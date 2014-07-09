Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894AbaGIP2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:28:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:36855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbaGIP2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:28:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="570650796"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 4/5] parisc: use seq_hex_dump() to dump buffers
Date: Wed,  9 Jul 2014 18:24:29 +0300
Message-Id: <1404919470-26668-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently introduced seq_hex_dump() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/parisc/ccio-dma.c  | 14 +++-----------
 drivers/parisc/sba_iommu.c | 11 +++--------
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 8b490d7..9d353d2 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1101,20 +1101,12 @@ static const struct file_operations ccio_proc_info_fops = {
 
 static int ccio_proc_bitmap_info(struct seq_file *m, void *p)
 {
-	int len = 0;
 	struct ioc *ioc = ioc_list;
 
 	while (ioc != NULL) {
-		u32 *res_ptr = (u32 *)ioc->res_map;
-		int j;
-
-		for (j = 0; j < (ioc->res_size / sizeof(u32)); j++) {
-			if ((j & 7) == 0)
-				len += seq_puts(m, "\n   ");
-			len += seq_printf(m, "%08x", *res_ptr);
-			res_ptr++;
-		}
-		len += seq_puts(m, "\n\n");
+		seq_hex_dump(m, "   ", DUMP_PREFIX_NONE, 32, 4, ioc->res_map,
+			     ioc->res_size, false);
+		seq_putc(m, '\n');
 		ioc = ioc->next;
 		break; /* XXX - remove me */
 	}
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 1ff1b67..fbc4db9 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1857,15 +1857,10 @@ sba_proc_bitmap_info(struct seq_file *m, void *p)
 {
 	struct sba_device *sba_dev = sba_list;
 	struct ioc *ioc = &sba_dev->ioc[0];	/* FIXME: Multi-IOC support! */
-	unsigned int *res_ptr = (unsigned int *)ioc->res_map;
-	int i, len = 0;
 
-	for (i = 0; i < (ioc->res_size/sizeof(unsigned int)); ++i, ++res_ptr) {
-		if ((i & 7) == 0)
-			len += seq_printf(m, "\n   ");
-		len += seq_printf(m, " %08x", *res_ptr);
-	}
-	len += seq_printf(m, "\n");
+	seq_hex_dump(m, "   ", DUMP_PREFIX_NONE, 32, 4, ioc->res_map,
+		     ioc->res_size, false);
+	seq_printf(m, "\n");
 
 	return 0;
 }
-- 
2.0.1

