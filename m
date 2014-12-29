Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaL2LvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:51:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:47817 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbaL2Lus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:50:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="434568346"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/4] hexdump: do few calculations ahead
Date: Mon, 29 Dec 2014 13:50:53 +0200
Message-Id: <1419853854-5602-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
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
index a61cb6b..4af53f7 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -103,6 +103,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			bool ascii)
 {
 	const u8 *ptr = buf;
+	int ngroups;
 	u8 ch;
 	int j, lx = 0;
 	int ascii_column;
@@ -114,45 +115,33 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
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
@@ -161,14 +150,11 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
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
2.1.3

