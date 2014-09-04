Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaIDO1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:27:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:61391 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaIDO1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:27:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,466,1406617200"; 
   d="scan'208";a="586257619"
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
Subject: [PATCH v4 03/12] hexdump: do few calculations ahead
Date: Thu,  4 Sep 2014 17:26:50 +0300
Message-Id: <1409840819-18976-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of doing calculations in each case of different groupsize let's do them
beforehand. While here, change the switch by if-else-if construction.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/hexdump.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/lib/hexdump.c b/lib/hexdump.c
index 4677070..b82418f 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -87,6 +87,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			bool ascii)
 {
 	const u8 *ptr = buf;
+	int ngroups;
 	u8 ch;
 	int j, lx = 0;
 	int ascii_column;
@@ -98,45 +99,33 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 		goto nil;
 	if (len > rowsize)		/* limit to one line at a time */
 		len = rowsize;
+	if (!is_power_of_2(groupsize) || groupsize > 8)
+		groupsize = 1;
 	if ((len % groupsize) != 0)	/* no mixed size output */
 		groupsize = 1;
 
-	switch (groupsize) {
-	case 8: {
+	ngroups = len / groupsize;
+	ascii_column = rowsize * 2 + rowsize / groupsize + 1;
+	if (groupsize == 8) {
 		const u64 *ptr8 = buf;
-		int ngroups = len / groupsize;
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%16.16llx", j ? " " : "",
 					(unsigned long long)*(ptr8 + j));
-		ascii_column = rowsize * 2 + rowsize / 8 + 2;
-		break;
-	}
-
-	case 4: {
+	} else if (groupsize == 4) {
 		const u32 *ptr4 = buf;
-		int ngroups = len / groupsize;
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%8.8x", j ? " " : "", *(ptr4 + j));
-		ascii_column = rowsize * 2 + rowsize / 4 + 2;
-		break;
-	}
-
-	case 2: {
+	} else if (groupsize == 2) {
 		const u16 *ptr2 = buf;
-		int ngroups = len / groupsize;
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%4.4x", j ? " " : "", *(ptr2 + j));
-		ascii_column = rowsize * 2 + rowsize / 2 + 2;
-		break;
-	}
-
-	default:
+	} else {
 		for (j = 0; (j < len) && (lx + 3) <= linebuflen; j++) {
 			ch = ptr[j];
 			linebuf[lx++] = hex_asc_hi(ch);
@@ -145,14 +134,11 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 		}
 		if (j)
 			lx--;
-
-		ascii_column = 3 * rowsize + 2;
-		break;
 	}
 	if (!ascii)
 		goto nil;
 
-	while (lx < (linebuflen - 1) && lx < (ascii_column - 1))
+	while (lx < (linebuflen - 1) && lx < ascii_column)
 		linebuf[lx++] = ' ';
 	for (j = 0; (j < len) && (lx + 2) < linebuflen; j++) {
 		ch = ptr[j];
-- 
2.1.0

