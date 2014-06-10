Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbaFJUR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:17:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaFJTv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Victor Kamensky <victor.kamensky@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 098/160] word-at-a-time: avoid undefined behaviour in zero_bytemask macro
Date: Tue, 10 Jun 2014 12:45:38 -0700
Message-Id: <1402429600-20477-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit ec6931b281797b69e6cf109f9cc94d5a2bf994e0 upstream.

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

Cc: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/asm-generic/word-at-a-time.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/word-at-a-time.h b/include/asm-generic/word-at-a-time.h
index d3909ef..d96deb4 100644
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
1.9.1

