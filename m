Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaIXPDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:03:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaIXPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:03:10 -0400
Date: Wed, 24 Sep 2014 08:01:52 -0700
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-03bd4e1f7265548832a76e7919a81f3137c44fd1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, linn@hp.com, stable@vger.kernel.org,
        toshi.kani@hp.com, wanpeng.li@linux.intel.com, srostedt@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, tglx@linutronix.de, prarit@redhat.com,
        rientjes@google.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linn@hp.com, stable@vger.kernel.org,
        toshi.kani@hp.com, wanpeng.li@linux.intel.com,
        isimatu.yasuaki@jp.fujitsu.com, srostedt@redhat.com,
        tglx@linutronix.de, bp@suse.de, rientjes@google.com, prarit@redhat.com
In-Reply-To: <1411547885-48165-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1411547885-48165-1-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix unreleased llc_shared_mask bit during CPU hotplug
Git-Commit-ID: 03bd4e1f7265548832a76e7919a81f3137c44fd1
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

Commit-ID:  03bd4e1f7265548832a76e7919a81f3137c44fd1
Gitweb:     http://git.kernel.org/tip/03bd4e1f7265548832a76e7919a81f3137c44fd1
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Wed, 24 Sep 2014 16:38:05 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 15:13:20 +0200

sched: Fix unreleased llc_shared_mask bit during CPU hotplug

The following bug can be triggered by hot adding and removing a large number of
xen domain0's vcpus repeatedly:

	BUG: unable to handle kernel NULL pointer dereference at 0000000000000004 IP: [..] find_busiest_group
	PGD 5a9d5067 PUD 13067 PMD 0
	Oops: 0000 [#3] SMP
	[...]
	Call Trace:
	load_balance
	? _raw_spin_unlock_irqrestore
	idle_balance
	__schedule
	schedule
	schedule_timeout
	? lock_timer_base
	schedule_timeout_uninterruptible
	msleep
	lock_device_hotplug_sysfs
	online_store
	dev_attr_store
	sysfs_write_file
	vfs_write
	SyS_write
	system_call_fastpath

Last level cache shared mask is built during CPU up and the
build_sched_domain() routine takes advantage of it to setup
the sched domain CPU topology.

However, llc_shared_mask is not released during CPU disable,
which leads to an invalid sched domainCPU topology.

This patch fix it by releasing the llc_shared_mask correctly
during CPU disable.

Yasuaki also reported that this can happen on real hardware:

  https://lkml.org/lkml/2014/7/22/1018

His case is here:

	==
	Here is an example on my system.
	My system has 4 sockets and each socket has 15 cores and HT is
	enabled. In this case, each core of sockes is numbered as
	follows:

		 | CPU#
	Socket#0 | 0-14 , 60-74
	Socket#1 | 15-29, 75-89
	Socket#2 | 30-44, 90-104
	Socket#3 | 45-59, 105-119

	Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.

	It means that last level cache of Socket#2 is shared with
	CPU#30-44 and 90-104.

	When hot-removing socket#2 and #3, each core of sockets is
	numbered as follows:

		 | CPU#
	Socket#0 | 0-14 , 60-74
	Socket#1 | 15-29, 75-89

	But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30
	remains having 0x3fff80000001fffc0000000.

	After that, when hot-adding socket#2 and #3, each core of
	sockets is numbered as follows:

		 | CPU#
	Socket#0 | 0-14 , 60-74
	Socket#1 | 15-29, 75-89
	Socket#2 | 30-59
	Socket#3 | 90-119

	Then llc_shared_mask of CPU#30 becomes
	0x3fff8000fffffffc0000000. It means that last level cache of
	Socket#2 is shared with CPU#30-59 and 90-104. So the mask has
	the wrong value.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Tested-by: Linn Crosetto <linn@hp.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1411547885-48165-1-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d872e0..42a2dca 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1284,6 +1284,9 @@ static void remove_siblinginfo(int cpu)
 
 	for_each_cpu(sibling, cpu_sibling_mask(cpu))
 		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
+	for_each_cpu(sibling, cpu_llc_shared_mask(cpu))
+		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(sibling));
+	cpumask_clear(cpu_llc_shared_mask(cpu));
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
