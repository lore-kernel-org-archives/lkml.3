Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaDWQxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:53:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61888 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756343AbaDWQw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:52:59 -0400
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        <stable@vger.kernel.org>, Victor Kamensky <victor.kamensky@linaro.org>
Subject: [PATCH] word-at-a-time: avoid undefined behaviour in zero_bytemask macro
Date: Wed, 23 Apr 2014 17:52:52 +0100
Message-Id: <1398271972-15177-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm-generic, big-endian version of zero_bytemask creates a mask of
bytes preceding the first zero-byte by left shifting ~0ul based on the
position of the first zero byte.

Unfortunately, if the first (top) byte is zero, the output of
prep_zero_mask has only the top bit set, resulting in undefined C
behaviour as we shift left by an amount equal to the width of the type.
As it happens, GCC doesn't manage to spot this through the call to fls(),
but the issue remains if architectures choose to implement their shift
instructions differently.

An example would be arch/arm/ (AArch32), where LSL Rd, Rn, #32 results
in Rd == 0x0, whilst on arch/arm64 (AArch64) LSL Xd, Xn, #64 results in
Xd == Xn.

Rather than check explicitly for the problematic shift, this patch adds
an extra shift by 1, replacing fls with __fls. Since zero_bytemask is
never called with a zero argument (has_zero() is used to check the data
first), we don't need to worry about calling __fls(0), which is
undefined.

Cc: <stable@vger.kernel.org>
Cc: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

Hi Linus,

Victor reported this with a big-endian arm64 system. This is the
cleanest, most efficient solution I could come up with, but it would be
helpful if you could please confirm my assumption that zero_bytemask(0)
is nonsensical.

Cheers,

Will

 include/asm-generic/word-at-a-time.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/word-at-a-time.h b/include/asm-generic/word-at-a-time.h
index d3909effd725..d96deb443f18 100644
--- a/include/asm-generic/word-at-a-time.h
+++ b/include/asm-generic/word-at-a-time.h
@@ -50,11 +50,7 @@ static inline bool has_zero(unsigned long val, unsigned long *data, const struct
 }
 
 #ifndef zero_bytemask
-#ifdef CONFIG_64BIT
-#define zero_bytemask(mask)	(~0ul << fls64(mask))
-#else
-#define zero_bytemask(mask)	(~0ul << fls(mask))
-#endif /* CONFIG_64BIT */
-#endif /* zero_bytemask */
+#define zero_bytemask(mask) (~0ul << __fls(mask) << 1)
+#endif
 
 #endif /* _ASM_WORD_AT_A_TIME_H */
-- 
1.9.2

