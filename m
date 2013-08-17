Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3HQTtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:49:35 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:41693 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3HQTs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:48:59 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org
Cc: x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, fenghua.yu@intel.com,
        bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 3/4] hotplug, x86: Disable ARCH_CPU_PROBE_RELEASE on x86
Date: Sat, 17 Aug 2013 13:46:58 -0600
Message-Id: <1376768819-28975-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d7c53c9e enabled ARCH_CPU_PROBE_RELEASE on x86 in order to
serialize CPU online/offline operations.  Although it is the config
option to enable CPU hotplug test interfaces, probe & release, it is
also the option to enable cpu_hotplug_driver_lock() as well.  Therefore,
this option had to be enabled on x86 with dummy arch_cpu_probe() and
arch_cpu_release().

Since then, lock_device_hotplug() was introduced to serialize CPU
online/offline & hotplug operations.  Therefore, this config option
is no longer required for the serialization.  This patch disables
this config option on x86 and revert the changes made by commit
d7c53c9e.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/Kconfig          |    4 ----
 arch/x86/kernel/smpboot.c |   21 ---------------------
 2 files changed, 25 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..c87e49a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -255,10 +255,6 @@ config ARCH_HWEIGHT_CFLAGS
 	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
 	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
 
-config ARCH_CPU_PROBE_RELEASE
-	def_bool y
-	depends on HOTPLUG_CPU
-
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index aecc98a..5b24a9d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -82,27 +82,6 @@
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-#ifdef CONFIG_HOTPLUG_CPU
-/*
- * We need this for trampoline_base protection from concurrent accesses when
- * off- and onlining cores wildly.
- */
-static DEFINE_MUTEX(x86_cpu_hotplug_driver_mutex);
-
-void cpu_hotplug_driver_lock(void)
-{
-	mutex_lock(&x86_cpu_hotplug_driver_mutex);
-}
-
-void cpu_hotplug_driver_unlock(void)
-{
-	mutex_unlock(&x86_cpu_hotplug_driver_mutex);
-}
-
-ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
-ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
-#endif
-
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
