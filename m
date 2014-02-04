Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935927AbaBDWzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:55:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbaBDVCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Jon Medhurst <tixy@linaro.org>, Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 004/104] lib/decompressors: fix "no limit" output buffer length
Date: Tue,  4 Feb 2014 13:01:07 -0800
Message-Id: <20140204210222.856933717@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/decompress_inflate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -48,7 +48,7 @@ STATIC int INIT gunzip(unsigned char *bu
 		out_len = 0x8000; /* 32 K */
 		out_buf = malloc(out_len);
 	} else {
-		out_len = 0x7fffffff; /* no limit */
+		out_len = ((size_t)~0) - (size_t)out_buf; /* no limit */
 	}
 	if (!out_buf) {
 		error("Out of memory while allocating output buffer");


