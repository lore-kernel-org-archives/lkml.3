Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaKQXDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:03:03 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:26975 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaKQXDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:03:00 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nico@linaro.org>, Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dan McGee <dpmcgee@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] arm64/mm: Remove hack in mmap randomize layout
Date: Tue, 18 Nov 2014 00:02:19 +0100
Message-Id: <1416265339-8138-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 8a0a9bd4db63 ('random: make get_random_int() more
random'), get_random_int() returns a random value for each call,
so comment and hack introduced in mmap_rnd() as part of commit
1d18c47c735e ('arm64: MMU fault handling and page table management')
are incorrects.

Commit 1d18c47c735e seems to use the same hack introduced by
commit a5adc91a4b44 ('powerpc: Ensure random space between stack
and mmaps'), latter copied in commit 5a0efea09f42 ('sparc64: Sharpen
address space randomization calculations.').

But both architectures were cleaned up as part of commit
fa8cbaaf5a68 ('powerpc+sparc64/mm: Remove hack in mmap randomize
layout') as hack is no more needed since commit 8a0a9bd4db63.

So the present patch removes the comment and the hack around
get_random_int() on AArch64's mmap_rnd().

Cc: Dan McGee <dpmcgee@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Fixes: 1d18c47c735e ('arm64: MMU fault handling and page table management')
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 arch/arm64/mm/mmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 1d73662f00ff..54922d1275b8 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -47,22 +47,14 @@ static int mmap_is_legacy(void)
 	return sysctl_legacy_va_layout;
 }
 
-/*
- * Since get_random_int() returns the same value within a 1 jiffy window, we
- * will almost always get the same randomisation for the stack and mmap
- * region. This will mean the relative distance between stack and mmap will be
- * the same.
- *
- * To avoid this we can shift the randomness by 1 bit.
- */
 static unsigned long mmap_rnd(void)
 {
 	unsigned long rnd = 0;
 
 	if (current->flags & PF_RANDOMIZE)
-		rnd = (long)get_random_int() & (STACK_RND_MASK >> 1);
+		rnd = (long)get_random_int() & STACK_RND_MASK;
 
-	return rnd << (PAGE_SHIFT + 1);
+	return rnd << PAGE_SHIFT;
 }
 
 static unsigned long mmap_base(void)
-- 
1.9.3

