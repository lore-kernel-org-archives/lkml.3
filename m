Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3LJTLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:11:15 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55534 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374Ab3LJTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:11:13 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 2/2] word-at-a-time: provide generic big-endian zero_bytemask implementation
Date: Tue, 10 Dec 2013 19:10:58 +0000
Message-Id: <1386702658-21430-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1386702658-21430-1-git-send-email-will.deacon@arm.com>
References: <1386702658-21430-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whilst architectures may be able to do better than this (which they can,
by simply defining their own macro), this is a generic stab at a
zero_bytemask implementation for the asm-generic, big-endian
word-at-a-time implementation.

On arm64, a clz instruction is used to implement the fls efficiently.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---

I'm happy to move this into the arch/ backends, but there's a strong
linkage between this and the generic word-at-a-time algorithm that could
easily break if they don't live together.

 include/asm-generic/word-at-a-time.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/asm-generic/word-at-a-time.h b/include/asm-generic/word-at-a-time.h
index 3f21f1b72e45..d3909effd725 100644
--- a/include/asm-generic/word-at-a-time.h
+++ b/include/asm-generic/word-at-a-time.h
@@ -49,4 +49,12 @@ static inline bool has_zero(unsigned long val, unsigned long *data, const struct
 	return (val + c->high_bits) & ~rhs;
 }
 
+#ifndef zero_bytemask
+#ifdef CONFIG_64BIT
+#define zero_bytemask(mask)	(~0ul << fls64(mask))
+#else
+#define zero_bytemask(mask)	(~0ul << fls(mask))
+#endif /* CONFIG_64BIT */
+#endif /* zero_bytemask */
+
 #endif /* _ASM_WORD_AT_A_TIME_H */
-- 
1.8.2.2

