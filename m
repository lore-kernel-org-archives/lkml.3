Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbaHHUmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:42:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaHHUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:42:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, David Miller <davem@davemloft.net>,
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
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 145/259] locking/mutex: Disable optimistic spinning on some architectures
Date: Fri,  8 Aug 2014 13:39:28 -0700
Message-Id: <1407530482-4483-146-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/Kconfig     | 1 +
 arch/arm64/Kconfig   | 1 +
 arch/powerpc/Kconfig | 1 +
 arch/sparc/Kconfig   | 1 +
 arch/x86/Kconfig     | 1 +
 kernel/Kconfig.locks | 5 ++++-
 6 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 31e1f44..b3d400d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -6,6 +6,7 @@ config ARM
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_MIGHT_HAVE_PC_PARPORT
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT if MMU
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d4dd22..bf0ed5d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2,6 +2,7 @@ config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b44b52c..ab43fa3 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -139,6 +139,7 @@ config PPC
 	select OLD_SIGACTION if PPC32
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6c95f4d..94cd9c1 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -76,6 +76,7 @@ config SPARC64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
 	select NO_BOOTMEM
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9e31880..9562fc3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -125,6 +125,7 @@ config X86
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac..ecee67a 100644
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
1.9.1

