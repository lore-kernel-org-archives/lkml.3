Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698Ab3GSFmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:42:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965622Ab3GSF0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 25/72] parisc: fix LMMIO mismatch between PAT length and MASK register
Date: Thu, 18 Jul 2013 22:25:42 -0700
Message-Id: <20130719052601.582270625@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit dac76f1be5beaea4af9afe85fb475c73de0b8731 upstream.

The LMMIO length reported by PAT and the length given by the LBA MASK
register are not consistent. This leads e.g. to a not-working ATI FireGL
card with the radeon DRM driver since the memory can't be mapped.

Fix this by correctly adjusting the resource sizes.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/parisc/lba_pci.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -613,6 +613,54 @@ truncate_pat_collision(struct resource *
 	return 0;	/* truncation successful */
 }
 
+/*
+ * extend_lmmio_len: extend lmmio range to maximum length
+ *
+ * This is needed at least on C8000 systems to get the ATI FireGL card
+ * working. On other systems we will currently not extend the lmmio space.
+ */
+static unsigned long
+extend_lmmio_len(unsigned long start, unsigned long end, unsigned long lba_len)
+{
+	struct resource *tmp;
+
+	pr_debug("LMMIO mismatch: PAT length = 0x%lx, MASK register = 0x%lx\n",
+		end - start, lba_len);
+
+	lba_len = min(lba_len+1, 256UL*1024*1024); /* limit to 256 MB */
+
+	pr_debug("LBA: lmmio_space [0x%lx-0x%lx] - original\n", start, end);
+
+	if (boot_cpu_data.cpu_type < mako) {
+		pr_info("LBA: Not a C8000 system - not extending LMMIO range.\n");
+		return end;
+	}
+
+	end += lba_len;
+	if (end < start) /* fix overflow */
+		end = -1ULL;
+
+	pr_debug("LBA: lmmio_space [0x%lx-0x%lx] - current\n", start, end);
+
+	/* first overlap */
+	for (tmp = iomem_resource.child; tmp; tmp = tmp->sibling) {
+		pr_debug("LBA: testing %pR\n", tmp);
+		if (tmp->start == start)
+			continue; /* ignore ourself */
+		if (tmp->end < start)
+			continue;
+		if (tmp->start > end)
+			continue;
+		if (end >= tmp->start)
+			end = tmp->start - 1;
+	}
+
+	pr_info("LBA: lmmio_space [0x%lx-0x%lx] - new\n", start, end);
+
+	/* return new end */
+	return end;
+}
+
 #else
 #define truncate_pat_collision(r,n)  (0)
 #endif
@@ -994,6 +1042,14 @@ lba_pat_resources(struct parisc_device *
 		case PAT_LMMIO:
 			/* used to fix up pre-initialized MEM BARs */
 			if (!lba_dev->hba.lmmio_space.flags) {
+				unsigned long lba_len;
+
+				lba_len = ~READ_REG32(lba_dev->hba.base_addr
+						+ LBA_LMMIO_MASK);
+				if ((p->end - p->start) != lba_len)
+					p->end = extend_lmmio_len(p->start,
+						p->end, lba_len);
+
 				sprintf(lba_dev->hba.lmmio_name,
 						"PCI%02x LMMIO",
 						(int)lba_dev->hba.bus_num.start);


