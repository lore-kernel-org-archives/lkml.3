Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaIDO2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:28:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:22599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbaIDO1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:27:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,466,1406617200"; 
   d="scan'208";a="475190083"
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
Subject: [PATCH v4 10/12] staging: unisys: use seq_hex_dump() to dump buffers
Date: Thu,  4 Sep 2014 17:26:57 +0300
Message-Id: <1409840819-18976-11-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently introduced seq_hex_dump() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../unisys/visorchannel/visorchannel_funcs.c       | 26 ++++------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/unisys/visorchannel/visorchannel_funcs.c b/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
index 947b23c..d8345a6 100644
--- a/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
+++ b/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
@@ -633,15 +633,11 @@ void
 visorchannel_dump_section(VISORCHANNEL *chan, char *s,
 			  int off, int len, struct seq_file *seq)
 {
-	char *buf, *tbuf, *fmtbuf;
-	int fmtbufsize = 0;
-	int i;
+	char *buf;
 	int errcode = 0;
 
-	fmtbufsize = 100 * COVQ(len, 16);
 	buf = kmalloc(len, GFP_KERNEL|__GFP_NORETRY);
-	fmtbuf = kmalloc(fmtbufsize, GFP_KERNEL|__GFP_NORETRY);
-	if (buf == NULL || fmtbuf == NULL)
+	if (buf == NULL)
 		goto Away;
 
 	errcode = visorchannel_read(chan, off, buf, len);
@@ -651,23 +647,9 @@ visorchannel_dump_section(VISORCHANNEL *chan, char *s,
 		goto Away;
 	}
 	seq_printf(seq, "channel %s:\n", s);
-	tbuf = buf;
-	while (len > 0) {
-		i = (len < 16) ? len : 16;
-		hex_dump_to_buffer(tbuf, i, 16, 1, fmtbuf, fmtbufsize, TRUE);
-		seq_printf(seq, "%s\n", fmtbuf);
-		tbuf += 16;
-		len -= 16;
-	}
+	seq_hex_dump(seq, "", DUMP_PREFIX_NONE, 16, 1, buf, len, true);
 
 Away:
-	if (buf != NULL) {
-		kfree(buf);
-		buf = NULL;
-	}
-	if (fmtbuf != NULL) {
-		kfree(fmtbuf);
-		fmtbuf = NULL;
-	}
+	kfree(buf);
 }
 EXPORT_SYMBOL_GPL(visorchannel_dump_section);
-- 
2.1.0

