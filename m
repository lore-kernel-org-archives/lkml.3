Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbaEDQey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:34:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaEDPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 099/158] word-at-a-time: avoid undefined behaviour in zero_bytemask macro
Date: Sun,  4 May 2014 11:40:08 -0400
Message-Id: <20140504154043.402620153@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/word-at-a-time.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/include/asm-generic/word-at-a-time.h
+++ b/include/asm-generic/word-at-a-time.h
@@ -50,11 +50,7 @@ static inline bool has_zero(unsigned lon
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


