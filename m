Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaLORFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:05:03 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:49372 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaLORE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:04:59 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
Date: Mon, 15 Dec 2014 22:34:58 +0530
X-Google-Sender-Auth: j25OXIfaLttg1BjJNrVltJkkuTg
Message-ID: <CAKZGPAN6Ct_+FY1khP4AMSJ1RgP0zKdJ2pkczjhe-Q5HxTzsrw@mail.gmail.com>
Subject: [RCU] kernel hangs in wait_rcu_gp during suspend path
From: Arun KS <arunks.linux@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the backtrace of the process hanging in wait_rcu_gp,

PID: 247    TASK: e16e7380  CPU: 4   COMMAND: "kworker/u16:5"
 #0 [<c09fead0>] (__schedule) from [<c09fcab0>]
 #1 [<c09fcab0>] (schedule_timeout) from [<c09fe050>]
 #2 [<c09fe050>] (wait_for_common) from [<c013b2b4>]
 #3 [<c013b2b4>] (wait_rcu_gp) from [<c0142f50>]
 #4 [<c0142f50>] (atomic_notifier_chain_unregister) from [<c06b2ab8>]
 #5 [<c06b2ab8>] (cpufreq_interactive_disable_sched_input) from [<c06b32a8>]
 #6 [<c06b32a8>] (cpufreq_governor_interactive) from [<c06abbf8>]
 #7 [<c06abbf8>] (__cpufreq_governor) from [<c06ae474>]
 #8 [<c06ae474>] (__cpufreq_remove_dev_finish) from [<c06ae8c0>]
 #9 [<c06ae8c0>] (cpufreq_cpu_callback) from [<c0a0185c>]
#10 [<c0a0185c>] (notifier_call_chain) from [<c0121888>]
#11 [<c0121888>] (__cpu_notify) from [<c0121a04>]
#12 [<c0121a04>] (cpu_notify_nofail) from [<c09ee7f0>]
#13 [<c09ee7f0>] (_cpu_down) from [<c0121b70>]
#14 [<c0121b70>] (disable_nonboot_cpus) from [<c016788c>]
#15 [<c016788c>] (suspend_devices_and_enter) from [<c0167bcc>]
#16 [<c0167bcc>] (pm_suspend) from [<c0167d94>]
#17 [<c0167d94>] (try_to_suspend) from [<c0138460>]
#18 [<c0138460>] (process_one_work) from [<c0138b18>]
#19 [<c0138b18>] (worker_thread) from [<c013dc58>]
#20 [<c013dc58>] (kthread) from [<c01061b8>]

Will this patch helps here,
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1d74d14e98a6be740a6f12456c7d9ad47be9c9c

I couldn't really understand why it got struck in  synchronize_rcu().
Please give some pointers to debug this further.

Below are the configs enable related to RCU.

CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y

Kernel version is 3.10.28
Architecture is ARM

Thanks,
Arun
