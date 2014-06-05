Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaFER6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:58:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaFER6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:58:30 -0400
Date: Thu, 5 Jun 2014 10:58:12 -0700
From: tip-bot for Igor Mammedov <tipbot@zytor.com>
Message-ID: <tip-89f898c1e195fa6235c869bb457e500b7b3ac49d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        imammedo@redhat.com, tglx@linutronix.de, toshi.kani@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        imammedo@redhat.com, tglx@linutronix.de, toshi.kani@hp.com
In-Reply-To: <1401975765-22328-2-git-send-email-imammedo@redhat.com>
References: <1401975765-22328-2-git-send-email-imammedo@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix list/memory corruption on CPU hotplug
Git-Commit-ID: 89f898c1e195fa6235c869bb457e500b7b3ac49d
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

Commit-ID:  89f898c1e195fa6235c869bb457e500b7b3ac49d
Gitweb:     http://git.kernel.org/tip/89f898c1e195fa6235c869bb457e500b7b3ac49d
Author:     Igor Mammedov <imammedo@redhat.com>
AuthorDate: Thu, 5 Jun 2014 15:42:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 16:33:07 +0200

x86: Fix list/memory corruption on CPU hotplug

currently if AP wake up is failed, master CPU marks AP as not
present in do_boot_cpu() by calling set_cpu_present(cpu, false).
That leads to following list corruption on the next physical CPU
hotplug:

[  418.107336] WARNING: CPU: 1 PID: 45 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
[  418.115268] list_add corruption. prev->next should be next (ffff88003dc57600), but was ffff88003e20c3a0. (prev=ffff88003e20c3a0).
[  418.123693] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT ipt_REJECT cfg80211 xt_conntrack rfkill ee
[  418.138979] CPU: 1 PID: 45 Comm: kworker/u10:1 Not tainted 3.14.0-rc6+ #387
[  418.149989] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[  418.165750] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  418.166433]  0000000000000021 ffff880038ca7988 ffffffff8159b22d 0000000000000021
[  418.176460]  ffff880038ca79d8 ffff880038ca79c8 ffffffff8106942c ffff880038ca79e8
[  418.177453]  ffff88003e20c3a0 ffff88003dc57600 ffff88003e20c3a0 00000000ffffffea
[  418.178445] Call Trace:
[  418.185811]  [<ffffffff8159b22d>] dump_stack+0x49/0x5c
[  418.186440]  [<ffffffff8106942c>] warn_slowpath_common+0x8c/0xc0
[  418.187192]  [<ffffffff81069516>] warn_slowpath_fmt+0x46/0x50
[  418.191231]  [<ffffffff8136ef51>] ? acpi_ns_get_node+0xb7/0xc7
[  418.193889]  [<ffffffff812f796e>] __list_add+0xbe/0xd0
[  418.196649]  [<ffffffff812e2aa9>] kobject_add_internal+0x79/0x200
[  418.208610]  [<ffffffff812e2e18>] kobject_add_varg+0x38/0x60
[  418.213831]  [<ffffffff812e2ef4>] kobject_add+0x44/0x70
[  418.229961]  [<ffffffff813e2c60>] device_add+0xd0/0x550
[  418.234991]  [<ffffffff813f0e95>] ? pm_runtime_init+0xe5/0xf0
[  418.250226]  [<ffffffff813e32be>] device_register+0x1e/0x30
[  418.255296]  [<ffffffff813e82a3>] register_cpu+0xe3/0x130
[  418.266539]  [<ffffffff81592be5>] arch_register_cpu+0x65/0x150
[  418.285845]  [<ffffffff81355c0d>] acpi_processor_hotadd_init+0x5a/0x9b
...
Which is caused by the fact that generic_processor_info() allocates
logical CPU id by calling:

 cpu = cpumask_next_zero(-1, cpu_present_mask);

which returns id of previously failed to wake up CPU, since its
bit is cleared by do_boot_cpu() and as result register_cpu()
tries to register another CPU with the same id as already
present but failed to be onlined CPU.

Taking in account that AP will not do anything if master CPU
failed to wake it up, there is no reason to mark that AP as not
present and break next cpu hotplug attempts. As a side effect of
not marking AP as not present, user would be allowed to online
it again later.

Also fix memory corruption in acpi_unmap_lsapic()

if during CPU hotplug master CPU failed to wake up AP
it set percpu x86_cpu_to_apicid to BAD_APICID=0xFFFF for AP.

However following attempt to unplug that CPU will lead to
out of bound write access to __apicid_to_node[] which is
32768 items long on x86_64 kernel.

So with above fix of cpu_present_mask make sure that a present
CPU has a valid APIC ID by not setting x86_cpu_to_apicid
to BAD_APICID in do_boot_cpu() on failure and allow
acpi_processor_remove()->acpi_unmap_lsapic() cleanly remove CPU.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1401975765-22328-2-git-send-email-imammedo@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3482693..2988f69 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -859,9 +859,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 
 		/* was set by cpu_init() */
 		cpumask_clear_cpu(cpu, cpu_initialized_mask);
-
-		set_cpu_present(cpu, false);
-		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
 
 	/* mark "stuck" area as not stuck */
