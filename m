Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaJUIGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:06:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:16623 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaJUIFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:05:42 -0400
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <nicolas.ferre@atmel.com>
CC: <linux-kernel@vger.kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 2/2] jffs2: fix buffer dump debug output
Date: Tue, 21 Oct 2014 10:05:00 +0200
Message-ID: <21ad981db8c65d3f00be3d9a254cae78cf40b96d.1413878259.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1413878259.git.cyrille.pitchen@atmel.com>
References: <cover.1413878259.git.cyrille.pitchen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes __jffs2_dbg_dump_buffer(): this function prints a message
claiming to dump len bytes. However, depending on the start offset, the former
code drops up to 31 (JFFS2_BUFDUMP_BYTES_PER_LINE - 1) bytes.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 fs/jffs2/debug.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/jffs2/debug.c b/fs/jffs2/debug.c
index 07bd5bc..1b515b2 100644
--- a/fs/jffs2/debug.c
+++ b/fs/jffs2/debug.c
@@ -736,30 +736,25 @@ void
 __jffs2_dbg_dump_buffer(unsigned char *buf, int len, uint32_t offs)
 {
 	int skip;
-	int i;
+	int i, pos;
 
 	printk(JFFS2_DBG_MSG_PREFIX " dump from offset %#08x to offset %#08x (%x bytes).\n",
 		offs, offs + len, len);
-	i = skip = offs % JFFS2_BUFDUMP_BYTES_PER_LINE;
+	i = skip = offs & (JFFS2_BUFDUMP_BYTES_PER_LINE - 1);
 	offs = offs & ~(JFFS2_BUFDUMP_BYTES_PER_LINE - 1);
 
-	if (skip != 0)
-		printk(JFFS2_DBG "%#08x: ", offs);
-
+	printk(JFFS2_DBG "%#08x: ", offs);
 	while (skip--)
 		printk("   ");
 
-	while (i < len) {
-		if ((i % JFFS2_BUFDUMP_BYTES_PER_LINE) == 0 && i != len -1) {
-			if (i != 0)
-				printk("\n");
+	for (pos = 0; pos < len; ++pos, ++i) {
+		if (i == JFFS2_BUFDUMP_BYTES_PER_LINE) {
 			offs += JFFS2_BUFDUMP_BYTES_PER_LINE;
-			printk(JFFS2_DBG "%0#8x: ", offs);
+			printk(JFFS2_DBG "\n%0#8x: ", offs);
+			i = 0;
 		}
 
-		printk("%02x ", buf[i]);
-
-		i += 1;
+		printk("%02x ", buf[pos]);
 	}
 
 	printk("\n");
-- 
1.8.2.2

