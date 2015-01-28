Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236AbbA1COP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:14:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759851AbbA1B2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Kordik <kordikmarek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.18 20/61] PCI: Add pci_bus_clip_resource() to clip to fit upstream window
Date: Tue, 27 Jan 2015 17:26:32 -0800
Message-Id: <20150128012639.212456542@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 0f7e7aee2f37119a32e6e8b63250922442528961 upstream.

Add pci_bus_clip_resource().  If a PCI-PCI bridge window overlaps an
upstream bridge window but is not completely contained by it, this clips
the downstream window so it fits inside the upstream one.

No functional change (this adds the function but no callers).

[bhelgaas: changelog, split into separate patch]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 73aef51a28f0..8fb16188cd82 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -228,6 +228,49 @@ int pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 }
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 
+/*
+ * The @idx resource of @dev should be a PCI-PCI bridge window.  If this
+ * resource fits inside a window of an upstream bridge, do nothing.  If it
+ * overlaps an upstream window but extends outside it, clip the resource so
+ * it fits completely inside.
+ */
+bool pci_bus_clip_resource(struct pci_dev *dev, int idx)
+{
+	struct pci_bus *bus = dev->bus;
+	struct resource *res = &dev->resource[idx];
+	struct resource orig_res = *res;
+	struct resource *r;
+	int i;
+
+	pci_bus_for_each_resource(bus, r, i) {
+		resource_size_t start, end;
+
+		if (!r)
+			continue;
+
+		if (resource_type(res) != resource_type(r))
+			continue;
+
+		start = max(r->start, res->start);
+		end = min(r->end, res->end);
+
+		if (start > end)
+			continue;	/* no overlap */
+
+		if (res->start == start && res->end == end)
+			return false;	/* no change */
+
+		res->start = start;
+		res->end = end;
+		dev_printk(KERN_DEBUG, &dev->dev, "%pR clipped to %pR\n",
+				 &orig_res, res);
+
+		return true;
+	}
+
+	return false;
+}
+
 void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
 
 /**
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 8aff29a804ff..d54632a1db43 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -208,6 +208,7 @@ void __pci_bus_size_bridges(struct pci_bus *bus,
 void __pci_bus_assign_resources(const struct pci_bus *bus,
 				struct list_head *realloc_head,
 				struct list_head *fail_head);
+bool pci_bus_clip_resource(struct pci_dev *dev, int idx);
 
 /**
  * pci_ari_enabled - query ARI forwarding status


