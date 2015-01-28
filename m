Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbbA1B2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836AbbA1B2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Kordik <kordikmarek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.18 19/61] PCI: Add pci_claim_bridge_resource() to clip window if necessary
Date: Tue, 27 Jan 2015 17:26:31 -0800
Message-Id: <20150128012639.108236053@linuxfoundation.org>
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

commit 8505e729a2f6eb0803ff943a15f133dd10afff3a upstream.

Add pci_claim_bridge_resource() to claim a PCI-PCI bridge window.  This is
like regular pci_claim_resource(), except that if we fail to claim the
window, we check to see if we can reduce the size of the window and try
again.

This is for scenarios like this:

  pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
  pci 0000:00:01.0:   bridge window [mem 0xbdf00000-0xddefffff 64bit pref]
  pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xcfffffff pref]

The 00:01.0 window is illegal: it starts before the host bridge window, so
we have to assume the [0xbdf00000-0xbfffffff] region is inaccessible.  We
can make it legal by clipping it to [mem 0xc0000000-0xddefffff 64bit pref].

Previously we discarded the 00:01.0 window and tried to reassign that part
of the hierarchy from scratch.  That is a problem because Linux doesn't
always assign things optimally.  For example, in this case, BIOS put the
01:00.0 device in a prefetchable window below 4GB, but after 5b28541552ef,
Linux puts the prefetchable window above 4GB where the 32-bit 01:00.0
device can't use it.

Clipping the 00:01.0 window is less intrusive than completely reassigning
things and is sufficient to let us use most of the BIOS configuration.  Of
course, it's possible that devices below 00:01.0 will no longer fit.  If
that's the case, we'll have to reassign things.  But that's a separate
problem.

[bhelgaas: changelog, split into separate patch]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-bus.c |   35 +++++++++++++++++++++++++++++++++++
 include/linux/pci.h     |    1 +
 2 files changed, 36 insertions(+)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -646,6 +646,41 @@ void pci_setup_bridge(struct pci_bus *bu
 	__pci_setup_bridge(bus, type);
 }
 
+
+int pci_claim_bridge_resource(struct pci_dev *bridge, int i)
+{
+	if (i < PCI_BRIDGE_RESOURCES || i > PCI_BRIDGE_RESOURCE_END)
+		return 0;
+
+	if (pci_claim_resource(bridge, i) == 0)
+		return 0;	/* claimed the window */
+
+	if ((bridge->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+		return 0;
+
+	if (!pci_bus_clip_resource(bridge, i))
+		return -EINVAL;	/* clipping didn't change anything */
+
+	switch (i - PCI_BRIDGE_RESOURCES) {
+	case 0:
+		pci_setup_bridge_io(bridge);
+		break;
+	case 1:
+		pci_setup_bridge_mmio(bridge);
+		break;
+	case 2:
+		pci_setup_bridge_mmio_pref(bridge);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (pci_claim_resource(bridge, i) == 0)
+		return 0;	/* claimed a smaller window */
+
+	return -EINVAL;
+}
+
 /* Check whether the bridge supports optional I/O and
    prefetchable memory ranges. If not, the respective
    base/limit registers must be read-only and read as 0. */
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1062,6 +1062,7 @@ resource_size_t pcibios_retrieve_fw_addr
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
+int pci_claim_bridge_resource(struct pci_dev *bridge, int i);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pci_assign_unassigned_bus_resources(struct pci_bus *bus);


