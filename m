Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaBGLwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbaBGLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 205/233] lib/decompressors: fix "no limit" output buffer length
Date: Fri,  7 Feb 2014 11:47:04 +0000
Message-Id: <1391773652-25214-206-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Courbot <acourbot@nvidia.com>

commit 1431574a1c4c669a0c198e4763627837416e4443 upstream.

When decompressing into memory, the output buffer length is set to some
arbitrarily high value (0x7fffffff) to indicate the output is, virtually,
unlimited in size.

The problem with this is that some platforms have their physical memory at
high physical addresses (0x80000000 or more), and that the output buffer
address and its "unlimited" length cannot be added without overflowing.
An example of this can be found in inflate_fast():

/* next_out is the output buffer address */
out = strm->next_out - OFF;
/* avail_out is the output buffer size. end will overflow if the output
 * address is >= 0x80000104 */
end = out + (strm->avail_out - 257);

This has huge consequences on the performance of kernel decompression,
since the following exit condition of inflate_fast() will be always true:

} while (in < last && out < end);

Indeed, "end" has overflowed and is now always lower than "out".  As a
result, inflate_fast() will return after processing one single byte of
input data, and will thus need to be called an unreasonably high number of
times.  This probably went unnoticed because kernel decompression is fast
enough even with this issue.

Nonetheless, adjusting the output buffer length in such a way that the
above pointer arithmetic never overflows results in a kernel decompression
that is about 3 times faster on affected machines.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Tested-by: Jon Medhurst <tixy@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 lib/decompress_inflate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index 19ff89e..d619b28 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -48,7 +48,7 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
 		out_len = 0x8000; /* 32 K */
 		out_buf = malloc(out_len);
 	} else {
-		out_len = 0x7fffffff; /* no limit */
+		out_len = ((size_t)~0) - (size_t)out_buf; /* no limit */
 	}
 	if (!out_buf) {
 		error("Out of memory while allocating output buffer");
-- 
1.8.3.2

