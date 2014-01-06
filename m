Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbaAFXcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:32:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbaAFWkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Thompson <anthony.thompson@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 026/129] arm64: spinlock: retry trylock operation if strex fails on free lock
Date: Mon,  6 Jan 2014 14:37:35 -0800
Message-Id: <20140106223900.357217694@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 4ecf7ccb1973fd826456b6ab1e6dfafe9023c753 upstream.

An exclusive store instruction may fail for reasons other than lock
contention (e.g. a cache eviction during the critical section) so, in
line with other architectures using similar exclusive instructions
(alpha, mips, powerpc), retry the trylock operation if the lock appears
to be free but the strex reported failure.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Tony Thompson <anthony.thompson@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/spinlock.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/spinlock.h
+++ b/arch/arm64/include/asm/spinlock.h
@@ -59,9 +59,10 @@ static inline int arch_spin_trylock(arch
 	unsigned int tmp;
 
 	asm volatile(
-	"	ldaxr	%w0, %1\n"
+	"2:	ldaxr	%w0, %1\n"
 	"	cbnz	%w0, 1f\n"
 	"	stxr	%w0, %w2, %1\n"
+	"	cbnz	%w0, 2b\n"
 	"1:\n"
 	: "=&r" (tmp), "+Q" (lock->lock)
 	: "r" (1)


