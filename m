Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3BEXmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:42:53 -0500
Received: from mail.candelatech.com ([208.74.158.172]:39968 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3BEXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:42:51 -0500
Message-ID: <511198FA.9090107@candelatech.com>
Date: Tue, 05 Feb 2013 15:42:50 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Kernel splat in patched 3.7.6+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is with a patched 3.7.6+ kernel.  We see this after starting a
modified version of pktgen.  Any idea what this means, or what sorts
of extra debug to enable to get more info on this?

It's the first WARN_ON that hits...

	/*
	 * Idle task boosting is a nono in general. There is one
	 * exception, when PREEMPT_RT and NOHZ is active:
	 *
	 * The idle task calls get_next_timer_interrupt() and holds
	 * the timer wheel base->lock on the CPU and another CPU wants
	 * to access the timer (probably to cancel it). We can safely
	 * ignore the boosting request, as the idle CPU runs this code
	 * with interrupts disabled and will complete the lock
	 * protected section without being interrupted. So there is no
	 * real need to boost.
	 */
	if (unlikely(p == rq->idle)) {
		WARN_ON(p != rq->curr);
		WARN_ON(p->pi_blocked_on);
		goto out_unlock;
	}


WARNING: at /home/greearb/git/linux-3.7.dev.y/kernel/sched/core.c:3477 rt_mutex_setprio+0x4e/0x126()
Hardware name: X7DBU
Modules linked in: btrfs libcrc32c ufs qnx4 hfsplus hfs minix vfat msdos fat jfs xfs reiserfs nf_nat_ipv4 nf_nat macvlan wanlink(O) pktgen fuse nfsv3 nfs_acl 
nfsv4 auth_rpcgss nfs fscache lockd sunrpc w83793 w83627hf hwmon_vid be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi ib_iser 
rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi coretemp mperf kvm_intel iTCO_wdt kvm i5k_amb 
iTCO_vendor_support i5000_edac gpio_ich lpc_ich ioatdma edac_core microcode e1000e shpchp pcspkr dca i2c_i801 uinput ipv6 floppy radeon i2c_algo_bit hwmon 
drm_kms_helper ttm drm i2c_core [last unloaded: iptable_nat]
Pid: 10, comm: rcub/0 Tainted: G         C O 3.7.6+ #63
Call Trace:
  [<ffffffff81086b50>] warn_slowpath_common+0x80/0x98
  [<ffffffff81086b7d>] warn_slowpath_null+0x15/0x17
  [<ffffffff810ab7f7>] rt_mutex_setprio+0x4e/0x126
  [<ffffffff810cb64f>] __rt_mutex_adjust_prio+0x30/0x32
  [<ffffffff810cbcf2>] task_blocks_on_rt_mutex+0x148/0x1b5
  [<ffffffff81524431>] rt_mutex_slowlock+0xad/0x132
  [<ffffffff81524512>] rt_mutex_lock+0x28/0x2a
  [<ffffffff810ef900>] rcu_boost_kthread+0x131/0x17e
  [<ffffffff810ef7cf>] ? rcu_cpu_kthread+0x11f/0x11f
  [<ffffffff810ef7cf>] ? rcu_cpu_kthread+0x11f/0x11f
  [<ffffffff810a0084>] kthread+0xbf/0xc7
  [<ffffffff8109ffc5>] ? __init_kthread_worker+0x37/0x37
  [<ffffffff81529b3c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8109ffc5>] ? __init_kthread_worker+0x37/0x37
---[ end trace e207902a4ba9e32b ]---

After this, the system is sick..not sure if this is directly related or not.


INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-7): P0
	Tasks blocked on level-0 rcu_node (CPUs 0-7): P0
	(detected by 0, t=60002 jiffies)
sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU 0
Pid: 0, comm: swapper/0 Tainted: G        WC O 3.7.6+ #63 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff8101094e>]  [<ffffffff8101094e>] read_persistent_clock+0x21/0x21
RSP: 0018:ffff88012fc03d50  EFLAGS: 00000002
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81be8a48
RDX: ffff88012fc03d48 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff88012fc03d88 R08: 0000000000000040 R09: 0000000000000001
R10: ffff88012fc03ca8 R11: 0000000000000000 R12: 00000000001e842d
R13: 0000000000000000 R14: 000000000000ea62 R15: ffffffff81a2efc0
FS:  0000000000000000(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f860ce31300 CR3: 0000000001a0b000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a13410)
Stack:
  ffffffff812815d3 ffff88012fc03d68 0000000000000001 ffff88012fc0ec90
  0000000000000002 000000000000ea62 ffffffff81a2efc0 ffff88012fc03d98
  ffffffff8128157f ffff88012fc03db8 ffffffff81027c93 0000000000000040
Call Trace:
  <IRQ>
  [<ffffffff812815d3>] ? delay_tsc+0x31/0xde
  [<ffffffff8128157f>] __const_udelay+0x28/0x2a
  [<ffffffff81027c93>] arch_trigger_all_cpu_backtrace+0x61/0x76
  [<ffffffff810f1ec3>] rcu_check_callbacks+0x557/0x6a8
  [<ffffffff810add1b>] ? account_idle_time+0x32/0x5a
  [<ffffffff810ae0cb>] ? account_process_tick+0xff/0x15c
  [<ffffffff810c7787>] ? tick_nohz_handler+0xde/0xde
  [<ffffffff81092988>] update_process_times+0x3c/0x73
  [<ffffffff810c7805>] tick_sched_timer+0x7e/0xa8
  [<ffffffff810a3298>] __run_hrtimer+0x57/0xcc
  [<ffffffff810a3686>] hrtimer_interrupt+0xde/0x1df
  [<ffffffff81027852>] smp_apic_timer_interrupt+0x80/0x93
  [<ffffffff8152a69d>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff81010e2c>] ? mwait_idle+0x6e/0x8c
  [<ffffffff81010e1f>] ? mwait_idle+0x61/0x8c
  [<ffffffff81011134>] cpu_idle+0x63/0xb7
  [<ffffffff815077fa>] rest_init+0x7e/0x82
  [<ffffffff81ab8ccb>] start_kernel+0x375/0x382
  [<ffffffff81ab878b>] ? repair_env_string+0x58/0x58
  [<ffffffff81ab82dd>] x86_64_start_reservations+0xb8/0xbd
  [<ffffffff81ab83e3>] x86_64_start_kernel+0x101/0x110
Code: 75 f8 ff 15 f5 54 a0 00 c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 ff 15 d9 54 a0 00 48 c7 43 08 00 00 00 00 48 89 03 58 5b c9 c3 <55> 48 89 e5 0f 31 89 c1 
48 89 d0 48 c1 e0 20 89 c9 48 09 c8 c9
NMI backtrace for cpu 2
CPU 2
Pid: 0, comm: swapper/2 Tainted: G        WC O 3.7.6+ #63 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81010e2c>]  [<ffffffff81010e2c>] mwait_idle+0x6e/0x8c
RSP: 0018:ffff88012aac7ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81a9e418 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88012aac6000
RBP: ffff88012aac7ef8 R08: ffff88012aac7ee8 R09: ffff88012b004e00
R10: 0000000000000002 R11: ffff880124f74b00 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000002bf9b68 CR3: 0000000127732000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/2 (pid: 0, threadinfo ffff88012aac6000, task ffff88012aac8000)
Stack:
  ffff88012aac7f18 ffffffff81011134 ffff88012aac7f18 000000000000db50
  ffff88012aac7f48 ffffffff8151e572 0000000000000000 0000000200000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81011134>] cpu_idle+0x63/0xb7
  [<ffffffff8151e572>] start_secondary+0x1f7/0x1fe
Code: d2 65 48 8b 04 25 c8 c6 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 49 ff ff ff 85 c0 75 0b 31 c0 48 89 c1 fb 0f 01 c9 <eb> 07 fb 66 66 90 66 66 
90 e8 8e 75 27 00 e8 89 75 27 00 eb 07
NMI backtrace for cpu 4
CPU 4
Pid: 0, comm: swapper/4 Tainted: G        WC O 3.7.6+ #63 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81010e2c>]  [<ffffffff81010e2c>] mwait_idle+0x6e/0x8c
RSP: 0018:ffff88012aad3ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81a9e418 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88012aad2000
RBP: ffff88012aad3ef8 R08: ffff88012aad3ee8 R09: ffff88012b004e00
R10: 0000000000000004 R11: ffff88011d8a83c0 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f5ae403d000 CR3: 000000011e3cb000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/4 (pid: 0, threadinfo ffff88012aad2000, task ffff88012aacae60)
Stack:
  ffff88012aad3f18 ffffffff81011134 ffff88012aad3f18 000000000000db50
  ffff88012aad3f48 ffffffff8151e572 0000000000000000 0000000400000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81011134>] cpu_idle+0x63/0xb7
  [<ffffffff8151e572>] start_secondary+0x1f7/0x1fe
Code: d2 65 48 8b 04 25 c8 c6 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 49 ff ff ff 85 c0 75 0b 31 c0 48 89 c1 fb 0f 01 c9 <eb> 07 fb 66 66 90 66 66 
90 e8 8e 75 27 00 e8 89 75 27 00 eb 07
NMI backtrace for cpu 5
CPU 5
Pid: 0, comm: swapper/5 Tainted: G        WC O 3.7.6+ #63 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81010e2c>]  [<ffffffff81010e2c>] mwait_idle+0x6e/0x8c
RSP: 0018:ffff88012aad5ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81a9e418 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88012aad4000
RBP: ffff88012aad5ef8 R08: ffff88012aad5ee8 R09: ffff88012b004e60
R10: 0000000000000005 R11: ffff880124f74b00 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000003589268 CR3: 0000000127732000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/5 (pid: 0, threadinfo ffff88012aad4000, task ffff88012aacc590)
Stack:
  ffff88012aad5f18 ffffffff81011134 ffff88012aad5f18 000000000000db50
  ffff88012aad5f48 ffffffff8151e572 0000000000000000 0000000500000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81011134>] cpu_idle+0x63/0xb7
  [<ffffffff8151e572>] start_secondary+0x1f7/0x1fe
Code: d2 65 48 8b 04 25 c8 c6 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 49 ff ff ff 85 c0 75 0b 31 c0 48 89 c1 fb 0f 01 c9 <eb> 07 fb 66 66 90 66 66 
90 e8 8e 75 27 00 e8 89 75 27 00 eb 07
NMI backtrace for cpu 3
CPU 3
Pid: 0, comm: swapper/3 Tainted: G        WC O 3.7.6+ #63 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81010e2c>]  [<ffffffff81010e2c>] mwait_idle+0x6e/0x8c
RSP: 0018:ffff88012aad1ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81a9e418 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88012aad0000
RBP: ffff88012aad1ef8 R08: ffff88012aad1ee8 R09: ffff88012b004de0
R10: 0000000000000003 R11: ffff8801294c7440 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f860ce31a80 CR3: 00000000c2a95000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/3 (pid: 0, threadinfo ffff88012aad0000, task ffff88012aac9730)
Stack:
  ffff88012aad1f18 ffffffff81011134 ffff88012aad1f18 000000000000db50
  ffff88012aad1f48 ffffffff8151e572 0000000000000000 0000000300000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81011134>] cpu_idle+0x63/0xb7
  [<ffffffff8151e572>] start_secondary+0x1f7/0x1fe
Code: d2 65 48 8b 04 25 c8 c6 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 49 ff ff ff 85 c0 75 0b 31 c0 48 89 c1 fb 0f 01 c9 <eb> 07 fb 66 66 90 66 66 
90 e8 8e 75 27 00 e8 89 75 27 00 eb 07
NMI backtrace for cpu 7
CPU 7
Pid: 0, comm: swapper/7 Tainted: G        WC O 3.7.6+ #63 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81010e2c>]  [<ffffffff81010e2c>] mwait_idle+0x6e/0x8c
RSP: 0018:ffff88012aae9ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81a9e418 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88012aae8000
RBP: ffff88012aae9ef8 R08: ffff88012aae9ee8 R09: ffff88012b004e60
R10: 0000000000000007 R11: ffff880124f74b00 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fdc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f85e800c000 CR3: 0000000001a0b000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/7 (pid: 0, threadinfo ffff88012aae8000, task ffff88012aae0000)
Stack:
  ffff88012aae9f18 ffffffff81011134 ffff88012aae9f18 000000000000db50
  ffff88012aae9f48 ffffffff8151e572 0000000000000000 0000000700000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81011134>] cpu_idle+0x63/0xb7
  [<ffffffff8151e572>] start_secondary+0x1f7/0x1fe
Code: d2 65 48 8b 04 25 c8 c6 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 49 ff ff ff 85 c0 75 0b 31 c0 48 89 c1 fb 0f 01 c9 <eb> 07 fb 66 66 90 66 66 
90 e8 8e 75 27 00 e8 89 75 27 00 eb 07
NMI backtrace for cpu 1
CPU 1
Pid: 0, comm: swapper/1 Tainted: G        WC O 3.7.6+ #63 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81010e2c>]  [<ffffffff81010e2c>] mwait_idle+0x6e/0x8c
RSP: 0018:ffff88012aac5ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81a9e418 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88012aac4000
RBP: ffff88012aac5ef8 R08: ffff88012aac5ee8 R09: ffff88012b004de0
R10: 0000000000000001 R11: ffff880124f72940 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000002c1029c CR3: 0000000124f53000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/1 (pid: 0, threadinfo ffff88012aac4000, task ffff88012aabdcc0)
Stack:
  ffff88012aac5f18 ffffffff81011134 ffff88012aac5f18 000000000000db50
  ffff88012aac5f48 ffffffff8151e572 0000000000000000 0000000100000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81011134>] cpu_idle+0x63/0xb7
  [<ffffffff8151e572>] start_secondary+0x1f7/0x1fe
Code: d2 65 48 8b 04 25 c8 c6 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 49 ff ff ff 85 c0 75 0b 31 c0 48 89 c1 fb 0f 01 c9 <eb> 07 fb 66 66 90 66 66 
90 e8 8e 75 27 00 e8 89 75 27 00 eb 07
NMI backtrace for cpu 6
CPU 6
Pid: 0, comm: swapper/6 Tainted: G        WC O 3.7.6+ #63 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81010e2c>]  [<ffffffff81010e2c>] mwait_idle+0x6e/0x8c
RSP: 0018:ffff88012aad7ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff81a9e418 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88012aad6000
RBP: ffff88012aad7ef8 R08: ffff88012aad7ee8 R09: ffff88012b004e00
R10: 0000000000000006 R11: ffff880128a0b840 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f85fb7fd790 CR3: 000000011e316000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/6 (pid: 0, threadinfo ffff88012aad6000, task ffff88012aacdcc0)
Stack:
  ffff88012aad7f18 ffffffff81011134 ffff88012aad7f18 000000000000db50
  ffff88012aad7f48 ffffffff8151e572 0000000000000000 0000000600000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff81011134>] cpu_idle+0x63/0xb7
  [<ffffffff8151e572>] start_secondary+0x1f7/0x1fe
Code: d2 65 48 8b 04 25 c8 c6 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 49 ff ff ff 85 c0 75 0b 31 c0 48 89 c1 fb 0f 01 c9 <eb> 07 fb 66 66 90 66 66 
90 e8 8e 75 27 00 e8 89 75 27 00 eb 07
swapper/0       R  running task        0     0      0 0x00000008
  000000000000e860 ffffffff81b0e2d0 ffffffff81a01eb8 ffffffff810c7e77
  ffffffff81a01ed8 00000031d6980000 ffff880124f74b00 0000000000000000
  ffff88012b004e80 ffffffff81a01ec8 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff810c7e77>] ? __tick_nohz_idle_enter+0x113/0x331
  [<ffffffff81010e2c>] ? mwait_idle+0x6e/0x8c
  [<ffffffff81010e1f>] ? mwait_idle+0x61/0x8c
  [<ffffffff81011134>] ? cpu_idle+0x63/0xb7
  [<ffffffff815077fa>] ? rest_init+0x7e/0x82
  [<ffffffff81ab8ccb>] ? start_kernel+0x375/0x382
  [<ffffffff81ab878b>] ? repair_env_string+0x58/0x58
  [<ffffffff81ab82dd>] ? x86_64_start_reservations+0xb8/0xbd
  [<ffffffff81ab83e3>] ? x86_64_start_kernel+0x101/0x110
swapper/0       R  running task        0     0      0 0x00000008
  000000000000e860 ffffffff81b0e2d0 ffffffff81a01eb8 ffffffff810c7e77
  ffffffff81a01ed8 00000031d6980000 ffff880124f74b00 0000000000000000
  ffff88012b004e80 ffffffff81a01ec8 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff810c7e77>] ? __tick_nohz_idle_enter+0x113/0x331
  [<ffffffff81010e2c>] ? mwait_idle+0x6e/0x8c
  [<ffffffff81010e1f>] ? mwait_idle+0x61/0x8c
  [<ffffffff81011134>] ? cpu_idle+0x63/0xb7
  [<ffffffff815077fa>] ? rest_init+0x7e/0x82
  [<ffffffff81ab8ccb>] ? start_kernel+0x375/0x382
  [<ffffffff81ab878b>] ? repair_env_string+0x58/0x58
  [<ffffffff81ab82dd>] ? x86_64_start_reservations+0xb8/0xbd
  [<ffffffff81ab83e3>] ? x86_64_start_kernel+0x101/0x110


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

