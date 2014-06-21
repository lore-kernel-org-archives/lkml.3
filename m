Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbaFUCaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:30:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22187 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991AbaFUCa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:30:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>, Jan Beulich <JBeulich@suse.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] initrd: Fix lz4 decompress with initrd
Date: Fri, 20 Jun 2014 19:30:09 -0700
Message-Id: <1403317809-4036-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During testing initrd (>2G) support, find decompress/lz4 does
not work with initrd at all.

decompress_* should support:
1. inbuf[]/outbuf[] for kernel preboot.
2. inbuf[]/flush() for initramfs
3. fill()/flush() for initrd.

in the unlz4 does not handle case 3, as input len is passed
as 0, and it failed in first try.

Fix that add one extra if (fill) checking, and get out if
EOF from the fill().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 lib/decompress_unlz4.c |   65 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 22 deletions(-)

Index: linux-2.6/lib/decompress_unlz4.c
===================================================================
--- linux-2.6.orig/lib/decompress_unlz4.c
+++ linux-2.6/lib/decompress_unlz4.c
@@ -83,13 +83,20 @@ STATIC inline int INIT unlz4(u8 *input,
 	if (posp)
 		*posp = 0;
 
-	if (fill)
-		fill(inp, 4);
+	if (fill) {
+		size = fill(inp, 4);
+		if (size < 4) {
+			error("data corrupted");
+			goto exit_2;
+		}
+	}
 
 	chunksize = get_unaligned_le32(inp);
 	if (chunksize == ARCHIVE_MAGICNUMBER) {
-		inp += 4;
-		size -= 4;
+		if (!fill) {
+			inp += 4;
+			size -= 4;
+		}
 	} else {
 		error("invalid header");
 		goto exit_2;
@@ -100,29 +107,44 @@ STATIC inline int INIT unlz4(u8 *input,
 
 	for (;;) {
 
-		if (fill)
-			fill(inp, 4);
+		if (fill) {
+			size = fill(inp, 4);
+			if (size == 0)
+				break;
+			if (size < 4) {
+				error("data corrupted");
+				goto exit_2;
+			}
+		}
 
 		chunksize = get_unaligned_le32(inp);
 		if (chunksize == ARCHIVE_MAGICNUMBER) {
-			inp += 4;
-			size -= 4;
+			if (!fill) {
+				inp += 4;
+				size -= 4;
+			}
 			if (posp)
 				*posp += 4;
 			continue;
 		}
-		inp += 4;
-		size -= 4;
+
 
 		if (posp)
 			*posp += 4;
 
-		if (fill) {
+		if (!fill) {
+			inp += 4;
+			size -= 4;
+		} else {
 			if (chunksize > lz4_compressbound(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
 				goto exit_2;
 			}
-			fill(inp, chunksize);
+			size = fill(inp, chunksize);
+			if (size < chunksize) {
+				error("data corrupted");
+				goto exit_2;
+			}
 		}
 #ifdef PREBOOT
 		if (out_len >= uncomp_chunksize) {
@@ -149,18 +171,17 @@ STATIC inline int INIT unlz4(u8 *input,
 		if (posp)
 			*posp += chunksize;
 
-		size -= chunksize;
+		if (!fill) {
+			size -= chunksize;
 
-		if (size == 0)
-			break;
-		else if (size < 0) {
-			error("data corrupted");
-			goto exit_2;
+			if (size == 0)
+				break;
+			else if (size < 0) {
+				error("data corrupted");
+				goto exit_2;
+			}
+			inp += chunksize;
 		}
-
-		inp += chunksize;
-		if (fill)
-			inp = inp_start;
 	}
 
 	ret = 0;
