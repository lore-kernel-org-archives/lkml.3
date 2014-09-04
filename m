Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaIDO1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:27:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:21849 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaIDO1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,466,1406617200"; 
   d="scan'208";a="594560747"
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
Subject: [PATCH v4 11/12] kmemleak: use seq_hex_dump() to dump buffers
Date: Thu,  4 Sep 2014 17:26:58 +0300
Message-Id: <1409840819-18976-12-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently introduced seq_hex_dump() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 mm/kmemleak.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 3cda50c..bc14fdc 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -291,23 +291,14 @@ static void hex_dump_object(struct seq_file *seq,
 			    struct kmemleak_object *object)
 {
 	const u8 *ptr = (const u8 *)object->pointer;
-	int i, len, remaining;
-	unsigned char linebuf[HEX_ROW_SIZE * 5];
+	size_t len;
 
 	/* limit the number of lines to HEX_MAX_LINES */
-	remaining = len =
-		min(object->size, (size_t)(HEX_MAX_LINES * HEX_ROW_SIZE));
-
-	seq_printf(seq, "  hex dump (first %d bytes):\n", len);
-	for (i = 0; i < len; i += HEX_ROW_SIZE) {
-		int linelen = min(remaining, HEX_ROW_SIZE);
-
-		remaining -= HEX_ROW_SIZE;
-		hex_dump_to_buffer(ptr + i, linelen, HEX_ROW_SIZE,
-				   HEX_GROUP_SIZE, linebuf, sizeof(linebuf),
-				   HEX_ASCII);
-		seq_printf(seq, "    %s\n", linebuf);
-	}
+	len = min(object->size, (size_t)(HEX_MAX_LINES * HEX_ROW_SIZE));
+
+	seq_printf(seq, "  hex dump (first %zu bytes):\n", len);
+	seq_hex_dump(seq, "    ", DUMP_PREFIX_NONE, HEX_ROW_SIZE,
+		     HEX_GROUP_SIZE, ptr, len, HEX_ASCII);
 }
 
 /*
-- 
2.1.0

