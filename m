Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaL2Lus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:50:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:57218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaL2Luq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:50:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="654419602"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/4] hexdump: fix ascii column for the tail of a dump
Date: Mon, 29 Dec 2014 13:50:52 +0200
Message-Id: <1419853854-5602-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation we have floating ascii column in the tail of the
dump.

For example, for row size equal to 16 the ascii column as in following table

group size \ length	8	12	16
	1		50	50	50
	2		22	32	42
	4		20	29	38
	8		19	-	36

This patch makes it the same independently of amount of bytes dumped.

The change is safe since all current users, which use ASCII part of the dump,
rely on the group size equal to 1. The patch doesn't change behaviour for such
group size (see the table above).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/hexdump.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/hexdump.c b/lib/hexdump.c
index 270773b..a61cb6b 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -126,7 +126,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%16.16llx", j ? " " : "",
 					(unsigned long long)*(ptr8 + j));
-		ascii_column = 17 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 8 + 2;
 		break;
 	}
 
@@ -137,7 +137,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%8.8x", j ? " " : "", *(ptr4 + j));
-		ascii_column = 9 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 4 + 2;
 		break;
 	}
 
@@ -148,7 +148,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%4.4x", j ? " " : "", *(ptr2 + j));
-		ascii_column = 5 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 2 + 2;
 		break;
 	}
 
-- 
2.1.3

