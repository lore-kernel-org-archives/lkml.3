Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaJCF3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:29:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaJCF3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:29:39 -0400
Date: Thu, 2 Oct 2014 22:28:49 -0700
From: tip-bot for Wei Huang <tipbot@zytor.com>
Message-ID: <tip-cc6cd47e7395bc05c5077009808b820633eb3f18@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, acme@kernel.org, wei@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, wei@redhat.com,
        acme@kernel.org
In-Reply-To: <1411617314-24659-1-git-send-email-wei@redhat.com>
References: <1411617314-24659-1-git-send-email-wei@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Tone down kernel messages when the PMU check fails in a virtual environment
Git-Commit-ID: cc6cd47e7395bc05c5077009808b820633eb3f18
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

Commit-ID:  cc6cd47e7395bc05c5077009808b820633eb3f18
Gitweb:     http://git.kernel.org/tip/cc6cd47e7395bc05c5077009808b820633eb3f18
Author:     Wei Huang <wei@redhat.com>
AuthorDate: Wed, 24 Sep 2014 22:55:14 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 06:04:41 +0200

perf/x86: Tone down kernel messages when the PMU check fails in a virtual environment

PMU checking can fail due to various reasons. On native machine, this
is mostly caused by faulty hardware and it is reasonable to use
KERN_ERR in reporting. However, when kernel is running on virtualized
environment, this checking can fail if virtual PMU is not supported
(e.g. KVM on AMD host). It is annoying to see an error message on
splash screen, even though we know such failure is benign on
virtualized environment.

This patch checks if the kernel is running in a virtualized environment.
If so, it will use KERN_INFO in reporting, which reduces the syslog
priority of them. This patch was tested successfully on KVM.

Signed-off-by: Wei Huang <wei@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1411617314-24659-1-git-send-email-wei@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 918d75f..16c7302 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -243,7 +243,8 @@ static bool check_hw_exists(void)
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
-	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
+	printk(boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR
+	       "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
 
 	return false;
 }
