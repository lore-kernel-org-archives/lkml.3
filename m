Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaJNVvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:51:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:29469 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaJNVvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:51:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,719,1406617200"; 
   d="scan'208";a="589012460"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/deflate: Replace UNALIGNED_OK w/ HAVE_EFFICIENT_UNALIGNED_ACCESS
Date: Tue, 14 Oct 2014 14:51:43 -0700
Message-Id: <1413323503-26033-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zlib implements a byte-by-byte and a word-by-word longest_match() string
comparision function. This implementation defaults to the slower byte-by-byte
version unless the preprocessor macro UNALIGNED_OK is defined.
Currently, nothing is hooked up to define this macro, but we do have
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS, which serves the same purpose.

The exact performance improvement of the word-by-word implementation is data
dependant, but on x86 it is typically in the range of a 5-10% cycle reduction.

The code is already there, might as well use it ...

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 lib/zlib_deflate/deflate.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/lib/zlib_deflate/deflate.c b/lib/zlib_deflate/deflate.c
index d20ef45..4920e51 100644
--- a/lib/zlib_deflate/deflate.c
+++ b/lib/zlib_deflate/deflate.c
@@ -570,9 +570,9 @@ static uInt longest_match(
     Pos *prev = s->prev;
     uInt wmask = s->w_mask;
 
-#ifdef UNALIGNED_OK
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
     /* Compare two bytes at a time. Note: this is not always beneficial.
-     * Try with and without -DUNALIGNED_OK to check.
+     * Try with and without -DCONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to check.
      */
     register Byte *strend = s->window + s->strstart + MAX_MATCH - 1;
     register ush scan_start = *(ush*)scan;
@@ -606,9 +606,10 @@ static uInt longest_match(
         /* Skip to next match if the match length cannot increase
          * or if the match length is less than 2:
          */
-#if (defined(UNALIGNED_OK) && MAX_MATCH == 258)
+#if (defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && MAX_MATCH == 258)
         /* This code assumes sizeof(unsigned short) == 2. Do not use
-         * UNALIGNED_OK if your compiler uses a different size.
+	 * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS if your compiler uses a
+	 * different size.
          */
         if (*(ush*)(match+best_len-1) != scan_end ||
             *(ush*)match != scan_start) continue;
@@ -639,7 +640,7 @@ static uInt longest_match(
         len = (MAX_MATCH - 1) - (int)(strend-scan);
         scan = strend - (MAX_MATCH-1);
 
-#else /* UNALIGNED_OK */
+#else /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
 
         if (match[best_len]   != scan_end  ||
             match[best_len-1] != scan_end1 ||
@@ -670,13 +671,13 @@ static uInt longest_match(
         len = MAX_MATCH - (int)(strend - scan);
         scan = strend - MAX_MATCH;
 
-#endif /* UNALIGNED_OK */
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
 
         if (len > best_len) {
             s->match_start = cur_match;
             best_len = len;
             if (len >= nice_match) break;
-#ifdef UNALIGNED_OK
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
             scan_end = *(ush*)(scan+best_len-1);
 #else
             scan_end1  = scan[best_len-1];
-- 
1.7.1

