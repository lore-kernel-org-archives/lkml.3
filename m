Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaHYJDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:03:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:53376 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaHYJDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:03:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="581256940"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 4/5] parisc: use seq_hex_dump() to dump buffers
Date: Mon, 25 Aug 2014 12:03:14 +0300
Message-Id: <1408957395-404-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently introduced seq_hex_dump() helper.

In one case it changes the output from
	1111111122222222333333334444444455555555666666667777777788888888
to
	11111111 22222222 33333333 44444444 55555555 66666666 77777777 88888888

though it seems it prints same data (by meaning) in both cases. I decide to
choose to use the space divided one.

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
2.1.0

