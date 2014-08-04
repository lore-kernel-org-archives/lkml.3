Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaHDQv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:51:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56899 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbaHDQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:51:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John David Anglin" <dave.anglin@bell.net>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Paul McKenney" <paulmck@linux.vnet.ibm.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Waiman Long" <waiman.long@hp.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Davidlohr Bueso" <davidlohr@hp.com>,
        "Vineet Gupta" <vgupta@synopsys.com>,
        "Will Deacon" <will.deacon@arm.com>,
        "Chris Metcalf" <cmetcalf@tilera.com>,
        "David Miller" <davem@davemloft.net>,
        "James Hogan" <james.hogan@imgtec.com>,
        "James Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, "Jason Low" <jason.low2@hp.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.728427849@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 51/94] locking/mutex: Disable optimistic spinning on
 some architectures
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Drop arm64 change]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1,6 +1,7 @@
 config ARM
 	bool
 	default y
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select HAVE_DMA_API_DEBUG
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_MEMBLOCK
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -137,6 +137,7 @@ config PPC
 	select HAVE_BPF_JIT if (PPC64 && NET)
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config EARLY_PRINTK
 	bool
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -57,6 +57,7 @@ config SPARC64
 	select IRQ_PREFLOW_FASTEOI
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config ARCH_DEFCONFIG
 	string
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -75,6 +75,7 @@ config X86
 	select HAVE_BPF_JIT if (X86_64 && NET)
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -198,5 +198,9 @@ config INLINE_WRITE_UNLOCK_IRQ
 config INLINE_WRITE_UNLOCK_IRQRESTORE
 	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 
+config ARCH_SUPPORTS_ATOMIC_RMW
+	bool
+
 config MUTEX_SPIN_ON_OWNER
-	def_bool SMP && !DEBUG_MUTEXES
+	def_bool y
+	depends on SMP && !DEBUG_MUTEXES && ARCH_SUPPORTS_ATOMIC_RMW

