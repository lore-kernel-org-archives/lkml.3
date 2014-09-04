Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaIDO3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:29:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:22614 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbaIDO1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,466,1406617200"; 
   d="scan'208";a="597927973"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Benjamin Romer <benjamin.romer@unisys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 12/12] wil6210: use seq_hex_dump() to dump buffers
Date: Thu,  4 Sep 2014 17:26:59 +0300
Message-Id: <1409840819-18976-13-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently introduced seq_hex_dump() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 32 +++++++-----------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index b1c6a72..9b28edd 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -131,6 +131,12 @@ static const struct file_operations fops_vring = {
 	.llseek		= seq_lseek,
 };
 
+static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
+			    const char *prefix)
+{
+	seq_hex_dump(s, prefix, DUMP_PREFIX_NONE, 16, 1, p, len, false);
+}
+
 static void wil_print_ring(struct seq_file *s, const char *prefix,
 			   void __iomem *off)
 {
@@ -186,8 +192,6 @@ static void wil_print_ring(struct seq_file *s, const char *prefix,
 				   le16_to_cpu(hdr.seq), len,
 				   le16_to_cpu(hdr.type), hdr.flags);
 			if (len <= MAX_MBOXITEM_SIZE) {
-				int n = 0;
-				char printbuf[16 * 3 + 2];
 				unsigned char databuf[MAX_MBOXITEM_SIZE];
 				void __iomem *src = wmi_buffer(wil, d.addr) +
 					sizeof(struct wil6210_mbox_hdr);
@@ -197,15 +201,7 @@ static void wil_print_ring(struct seq_file *s, const char *prefix,
 				 * reading header
 				 */
 				wil_memcpy_fromio_32(databuf, src, len);
-				while (n < len) {
-					int l = min(len - n, 16);
-					hex_dump_to_buffer(databuf + n, l,
-							   16, 1, printbuf,
-							   sizeof(printbuf),
-							   false);
-					seq_printf(s, "      : %s\n", printbuf);
-					n += l;
-				}
+				wil_seq_hexdump(s, databuf, len, "      : ");
 			}
 		} else {
 			seq_printf(s, "\n");
@@ -620,20 +616,6 @@ static const struct file_operations fops_wmi = {
 	.open  = simple_open,
 };
 
-static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
-			    const char *prefix)
-{
-	char printbuf[16 * 3 + 2];
-	int i = 0;
-	while (i < len) {
-		int l = min(len - i, 16);
-		hex_dump_to_buffer(p + i, l, 16, 1, printbuf,
-				   sizeof(printbuf), false);
-		seq_printf(s, "%s%s\n", prefix, printbuf);
-		i += l;
-	}
-}
-
 static void wil_seq_print_skb(struct seq_file *s, struct sk_buff *skb)
 {
 	int i = 0;
-- 
2.1.0

