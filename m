Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaIDO1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:27:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:22614 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbaIDO1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:27:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,466,1406617200"; 
   d="scan'208";a="475190080"
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
Subject: [PATCH v4 02/12] hexdump: fix ascii column for the tail of a dump
Date: Thu,  4 Sep 2014 17:26:49 +0300
Message-Id: <1409840819-18976-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
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
index 8499c81..4677070 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -110,7 +110,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%16.16llx", j ? " " : "",
 					(unsigned long long)*(ptr8 + j));
-		ascii_column = 17 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 8 + 2;
 		break;
 	}
 
@@ -121,7 +121,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%8.8x", j ? " " : "", *(ptr4 + j));
-		ascii_column = 9 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 4 + 2;
 		break;
 	}
 
@@ -132,7 +132,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%4.4x", j ? " " : "", *(ptr2 + j));
-		ascii_column = 5 * ngroups + 2;
+		ascii_column = rowsize * 2 + rowsize / 2 + 2;
 		break;
 	}
 
-- 
2.1.0

