Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3K1L2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:28:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:46881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab3K1L2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:28:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,790,1378882800"; 
   d="scan'208";a="443642439"
From: "user.email" <andriy.shevchenko@linux.intel.com>
To: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dmaengine@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] lib/vsprintf.c: add %paD format specifier for dma_addr_t types
Date: Thu, 28 Nov 2013 13:28:04 +0200
Message-Id: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Add the %paD format specifier for printing a dma_addr_t type, since the
DMA address size on some platforms can vary based on build options,
regardless of the native integer type.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/printk-formats.txt |  7 +++++++
 lib/vsprintf.c                   | 15 ++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 445ad74..3344ca9 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -63,6 +63,13 @@ Physical addresses:
 	resource_size_t) which can vary based on build options, regardless of
 	the width of the CPU data path. Passed by reference.
 
+DMA addresses:
+
+	%paD	0x01234567 or 0x0123456789abcdef
+
+	For printing a dma_addr_t type which can vary based on build options,
+	regardless of the width of the CPU data path. Passed by reference.
+
 Raw buffer as a hex string:
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 10909c5..12ea69d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1219,6 +1219,7 @@ int kptr_restrict __read_mostly;
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
  * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
+ * - 'aD' For a dma_addr_t type (passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
  *
@@ -1354,10 +1355,18 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		break;
 	case 'a':
 		spec.flags |= SPECIAL | SMALL | ZEROPAD;
-		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
 		spec.base = 16;
-		return number(buf, end,
-			      (unsigned long long) *((phys_addr_t *)ptr), spec);
+		switch (fmt[1]) {
+		case 'D':
+			spec.field_width = sizeof(dma_addr_t) * 2 + 2;
+			return number(buf, end,
+				(unsigned long long)*((dma_addr_t *)ptr), spec);
+		default:
+			spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+			return number(buf, end,
+				(unsigned long long)*((phys_addr_t *)ptr), spec);
+		}
+		break;
 	case 'd':
 		return dentry_name(buf, end, ptr, spec, fmt);
 	case 'D':
-- 
1.8.4.4

