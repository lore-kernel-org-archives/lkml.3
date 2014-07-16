Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaGPT0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:26:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaGPT0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:26:33 -0400
Date: Wed, 16 Jul 2014 12:24:31 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-4badad352a6bb202ec68afa7a574c0bb961e5ebc@git.kernel.org>
Cc: mingo@kernel.org, catalin.marinas@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, cmetcalf@tilera.com, jason.low2@hp.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, dave.anglin@bell.net,
        James.Bottomley@hansenpartnership.com, will.deacon@arm.com,
        waiman.long@hp.com, james.hogan@imgtec.com, mpatocka@redhat.com,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, vgupta@synopsys.com, jejb@parisc-linux.org
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        catalin.marinas@arm.com, peterz@infradead.org, cmetcalf@tilera.com,
        jason.low2@hp.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        davidlohr@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        dave.anglin@bell.net, James.Bottomley@hansenpartnership.com,
        will.deacon@arm.com, waiman.long@hp.com, james.hogan@imgtec.com,
        mpatocka@redhat.com, davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        vgupta@synopsys.com, benh@kernel.crashing.org, jejb@parisc-linux.org
In-Reply-To: <20140606175316.GV13930@laptop.programming.kicks-ass.net>
References: <20140606175316.GV13930@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] locking/mutex:
  Disable optimistic spinning on some architectures
Git-Commit-ID: 4badad352a6bb202ec68afa7a574c0bb961e5ebc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4badad352a6bb202ec68afa7a574c0bb961e5ebc
Gitweb:     http://git.kernel.org/tip/4badad352a6bb202ec68afa7a574c0bb961e5ebc
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 6 Jun 2014 19:53:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 14:57:07 +0200

locking/mutex: Disable optimistic spinning on some architectures

The optimistic spin code assumes regular stores and cmpxchg() play nice;
this is found to not be true for at least: parisc, sparc32, tile32,
metag-lock1, arc-!llsc and hexagon.

There is further wreckage, but this in particular seemed easy to
trigger, so blacklist this.

Opt in for known good archs.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: stable@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org
Link: http://lkml.kernel.org/r/20140606175316.GV13930@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/Kconfig     | 1 +
 arch/arm64/Kconfig   | 1 +
 arch/powerpc/Kconfig | 1 +
 arch/sparc/Kconfig   | 1 +
 arch/x86/Kconfig     | 1 +
 kernel/Kconfig.locks | 5 ++++-
 6 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 245058b..88acf8b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -6,6 +6,7 @@ config ARM
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_MIGHT_HAVE_PC_PARPORT
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_WANT_IPC_PARSE_VERSION
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a474de34..839f48c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -4,6 +4,7 @@ config ARM64
 	select ARCH_HAS_OPP
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index fefe7c8..80b94b0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -145,6 +145,7 @@ config PPC
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select ARCH_USE_CMPXCHG_LOCKREF if PPC64
 	select HAVE_ARCH_AUDITSYSCALL
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 29f2e98..407c87d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -78,6 +78,7 @@ config SPARC64
 	select HAVE_C_RECORDMCOUNT
 	select NO_BOOTMEM
 	select HAVE_ARCH_AUDITSYSCALL
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..d24887b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -131,6 +131,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 35536d9..8190794 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -220,9 +220,12 @@ config INLINE_WRITE_UNLOCK_IRQRESTORE
 
 endif
 
+config ARCH_SUPPORTS_ATOMIC_RMW
+	bool
+
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
-	depends on SMP && !DEBUG_MUTEXES
+	depends on SMP && !DEBUG_MUTEXES && ARCH_SUPPORTS_ATOMIC_RMW
 
 config ARCH_USE_QUEUE_RWLOCK
 	bool
