Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab3AaW24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:28:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab3AaW2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:28:48 -0500
Date: Thu, 31 Jan 2013 14:28:37 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-e6ebf5deaaaa33b661f0db86380c232b162bd68c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1356075872-3054-5-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-5-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/common.c:
  load ucode in 64 bit or show loading ucode info in 32 bit on AP
Git-Commit-ID: e6ebf5deaaaa33b661f0db86380c232b162bd68c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:28:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6ebf5deaaaa33b661f0db86380c232b162bd68c
Gitweb:     http://git.kernel.org/tip/e6ebf5deaaaa33b661f0db86380c232b162bd68c
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Dec 2012 23:44:24 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:19:06 -0800

x86/common.c: load ucode in 64 bit or show loading ucode info in 32 bit on AP

In 64 bit, load ucode on AP in cpu_init().

In 32 bit, show ucode loading info on AP in cpu_init(). Microcode has been
loaded earlier before paging. Now it is safe to show the loading microcode
info on this AP.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1356075872-3054-5-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d7fd246..d814772 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1220,6 +1220,12 @@ void __cpuinit cpu_init(void)
 	int cpu;
 	int i;
 
+	/*
+	 * Load microcode on this cpu if a valid microcode is available.
+	 * This is early microcode loading procedure.
+	 */
+	load_ucode_ap();
+
 	cpu = stack_smp_processor_id();
 	t = &per_cpu(init_tss, cpu);
 	oist = &per_cpu(orig_ist, cpu);
@@ -1311,6 +1317,8 @@ void __cpuinit cpu_init(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
+	show_ucode_info_early();
+
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
 		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
 		for (;;)
