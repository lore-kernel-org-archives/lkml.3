Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3KZOVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:21:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847Ab3KZOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:21:46 -0500
Date: Tue, 26 Nov 2013 06:21:27 -0800
From: tip-bot for Jason Baron <tipbot@zytor.com>
Message-ID: <tip-b71d47c14fba6270c0b5a0d56639bf042017025b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbaron@akamai.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jbaron@akamai.com, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <705bbe0f70fb20759151642ba0176a6414ec9f7a.1385418410.git.jbaron@akamai.com>
References: <705bbe0f70fb20759151642ba0176a6414ec9f7a.1385418410.git.jbaron@akamai.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debug] powerpc: Clean up panic_timeout usage
Git-Commit-ID: b71d47c14fba6270c0b5a0d56639bf042017025b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 26 Nov 2013 06:21:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b71d47c14fba6270c0b5a0d56639bf042017025b
Gitweb:     http://git.kernel.org/tip/b71d47c14fba6270c0b5a0d56639bf042017025b
Author:     Jason Baron <jbaron@akamai.com>
AuthorDate: Mon, 25 Nov 2013 23:23:11 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 26 Nov 2013 12:12:28 +0100

powerpc: Clean up panic_timeout usage

Default CONFIG_PANIC_TIMEOUT to 180 seconds on powerpc. The
pSeries continue to set the timeout to 10 seconds at run-time.

Thus, there's a small window where we don't have the correct
value on pSeries, but if this is only run-time discoverable we
don't have a better option. In any case, if the user changes the
default setting of 180 seconds, we honor that user setting.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: benh@kernel.crashing.org
Cc: paulus@samba.org
Cc: ralf@linux-mips.org
Cc: mpe@ellerman.id.au
Cc: felipe.contreras@gmail.com
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/705bbe0f70fb20759151642ba0176a6414ec9f7a.1385418410.git.jbaron@akamai.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/Kconfig                   | 4 ++++
 arch/powerpc/include/asm/setup.h       | 1 +
 arch/powerpc/kernel/setup_32.c         | 3 ---
 arch/powerpc/kernel/setup_64.c         | 3 ---
 arch/powerpc/platforms/pseries/setup.c | 2 +-
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b44b52c..b2be8e8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -147,6 +147,10 @@ config EARLY_PRINTK
 	bool
 	default y
 
+config PANIC_TIMEOUT
+	int
+	default 180
+
 config COMPAT
 	bool
 	default y if PPC64
diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index 703a841..11ba86e 100644
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -26,6 +26,7 @@ extern void reloc_got2(unsigned long);
 void check_for_initrd(void);
 void do_init_bootmem(void);
 void setup_panic(void);
+#define ARCH_PANIC_TIMEOUT 180
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index b903dc5..2b0da27 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -296,9 +296,6 @@ void __init setup_arch(char **cmdline_p)
 	if (cpu_has_feature(CPU_FTR_UNIFIED_ID_CACHE))
 		ucache_bsize = icache_bsize = dcache_bsize;
 
-	/* reboot on panic */
-	panic_timeout = 180;
-
 	if (ppc_md.panic)
 		setup_panic();
 
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 4085aaa..856dd4e 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -588,9 +588,6 @@ void __init setup_arch(char **cmdline_p)
 	dcache_bsize = ppc64_caches.dline_size;
 	icache_bsize = ppc64_caches.iline_size;
 
-	/* reboot on panic */
-	panic_timeout = 180;
-
 	if (ppc_md.panic)
 		setup_panic();
 
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index c1f1908..6f76ae4 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -470,7 +470,7 @@ static long pseries_little_endian_exceptions(void)
 
 static void __init pSeries_setup_arch(void)
 {
-	panic_timeout = 10;
+	set_arch_panic_timeout(10, ARCH_PANIC_TIMEOUT);
 
 	/* Discover PIC type and setup ppc_md accordingly */
 	pseries_discover_pic();
