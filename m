Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaG3MQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:16:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36940 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbaG3MPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Vineet Gupta <vgupta@synopsys.com>, Jason Low <jason.low2@hp.com>,
        Waiman Long <waiman.long@hp.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        John David Anglin <dave.anglin@bell.net>,
        James Hogan <james.hogan@imgtec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 71/94] locking/mutex: Disable optimistic spinning on some architectures
Date: Wed, 30 Jul 2014 14:15:00 +0200
Message-Id: <91b2716ab0210733b2e26fbe9d490e9136b79672.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4badad352a6bb202ec68afa7a574c0bb961e5ebc upstream.

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/Kconfig     | 1 +
 arch/arm64/Kconfig   | 1 +
 arch/powerpc/Kconfig | 1 +
 arch/sparc/Kconfig   | 1 +
 arch/x86/Kconfig     | 1 +
 kernel/Kconfig.locks | 5 ++++-
 6 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e47fcd1e9645..99e1ce978cf9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -5,6 +5,7 @@ config ARM
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT if MMU
 	select CLONE_BACKWARDS
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c04454876bcb..fe70eaea0e28 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,6 +1,7 @@
 config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d5d026b6d237..2e0ddfadc0b9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -138,6 +138,7 @@ config PPC
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION if PPC32
 	select HAVE_DEBUG_STACKOVERFLOW
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 4e5683877b93..d60f34dbae89 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -75,6 +75,7 @@ config SPARC64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
 	select NO_BOOTMEM
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb2dfa61eabe..9dc1a24d41b8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -123,6 +123,7 @@ config X86
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac27a39..ecee67a00f5f 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -220,6 +220,9 @@ config INLINE_WRITE_UNLOCK_IRQRESTORE
 
 endif
 
+config ARCH_SUPPORTS_ATOMIC_RMW
+	bool
+
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
-	depends on SMP && !DEBUG_MUTEXES
+	depends on SMP && !DEBUG_MUTEXES && ARCH_SUPPORTS_ATOMIC_RMW
-- 
2.0.1

