Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3ENKAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:00:20 -0400
Received: from mx10.gouders.net ([89.244.147.155]:48494 "EHLO mx10.gouders.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab3ENKAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:00:11 -0400
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2013 06:00:10 EDT
Authentication-Results: mx10.gouders.net; dkim=none reason="no signature";
	dkim-adsp=discard
From: Dirk Gouders <dirk@gouders.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH wq/for-3.10-fixes] workqueue: workqueue_congested() shouldn't translate WORK_CPU_UNBOUND into node number
In-Reply-To: <20130510182110.GB15502@mtj.dyndns.org> (Tejun Heo's message of
	"Fri, 10 May 2013 11:21:10 -0700")
References: <20130510182110.GB15502@mtj.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Tue, 14 May 2013 11:32:12 +0200
Message-ID: <gi38tp7vqb.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> From d3251859168b0b12841e1b90d6d768ab478dc23d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 10 May 2013 11:10:17 -0700
>
> df2d5ae499 ("workqueue: map an unbound workqueues to multiple per-node
> pool_workqueues") made unbound workqueues to map to multiple per-node
> pool_workqueues and accordingly updated workqueue_contested() so that,
> for unbound workqueues, it maps the specified @cpu to the NUMA node
> number to obtain the matching pool_workqueue to query the congested
> state.
>
> Before this change, workqueue_congested() ignored @cpu for unbound
> workqueues as there was only one pool_workqueue and some users
> (fscache) called it with WORK_CPU_UNBOUND.  After the commit, this
> causes the following oops as WORK_CPU_UNBOUND gets translated to
> garbage by cpu_to_node().

I probably also noticed this problem with 3.10.0-rc1-00087-g674825d when
I invoked init 0 (see attached oops).  I applied your patch and after
that the problem has gone.

Dirk

------------------------------------------------------------------------
May 14 11:08:20 karga kernel: BUG: unable to handle kernel paging request at ffff8803982ea070
May 14 11:08:20 karga kernel: IP: [<ffffffff8106bc62>] workqueue_congested+0x34/0x44
May 14 11:08:20 karga kernel: PGD 1ae6067 PUD 0 
May 14 11:08:20 karga kernel: Oops: 0000 [#1] SMP 
May 14 11:08:20 karga kernel: Modules linked in: bridge stp llc snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc snd_timer snd k8temp i2c_viapro atl1 mii floppy asus_atk0110
May 14 11:08:20 karga kernel: CPU: 1 PID: 2799 Comm: cachefilesd Tainted: G        W    3.10.0-rc1-00087-g674825d #1
May 14 11:08:20 karga kernel: Hardware name: System manufacturer System Product Name/M2V, BIOS 1803    05/11/2007
May 14 11:08:20 karga kernel: task: ffff88007c794780 ti: ffff88007c2be000 task.ti: ffff88007c2be000
May 14 11:08:20 karga kernel: RIP: 0010:[<ffffffff8106bc62>]  [<ffffffff8106bc62>] workqueue_congested+0x34/0x44
May 14 11:08:20 karga kernel: RSP: 0018:ffff88007c2bfd90  EFLAGS: 00010206
May 14 11:08:20 karga kernel: RAX: 00000000636f6c8e RBX: ffff88007c31c000 RCX: ffffffff815ab8a0
May 14 11:08:20 karga kernel: RDX: ffffffff8178a61d RSI: ffff88007cb33c00 RDI: 0000000000000020
May 14 11:08:20 karga kernel: RBP: ffff88007fd0f100 R08: ffffffff815ab8a0 R09: 0000000000000400
May 14 11:08:20 karga kernel: R10: ffffffff81a714c0 R11: ffffffff81a714c0 R12: ffff88007c31c000
May 14 11:08:20 karga kernel: R13: ffff88007c3df298 R14: ffff88007c2bfdc0 R15: ffff88007c9a02d0
May 14 11:08:20 karga kernel: FS:  00007f5f36536700(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
May 14 11:08:20 karga kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 14 11:08:20 karga kernel: CR2: ffff8803982ea070 CR3: 000000007b570000 CR4: 00000000000007e0
May 14 11:08:20 karga kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 14 11:08:20 karga kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 14 11:08:20 karga kernel: Stack:
May 14 11:08:20 karga kernel: ffffffff81164dd1 ffff88007c3df200 ffff88007c3df200 ffff88007c31c048
May 14 11:08:20 karga kernel: ffffffff81163cb4 ffff88007c9a02d0 ffff88007c31c048 ffff88007c31c048
May 14 11:08:20 karga kernel: ffffffff00000010 ffff88007c2bfe28 ffff88007c2bfde8 0000000000000296
May 14 11:08:20 karga kernel: Call Trace:
May 14 11:08:20 karga kernel: [<ffffffff81164dd1>] ? fscache_enqueue_object+0x28/0x7f
May 14 11:08:20 karga kernel: [<ffffffff81163cb4>] ? fscache_withdraw_cache+0x101/0x264
May 14 11:08:20 karga kernel: [<ffffffff8129c86e>] ? cachefiles_daemon_unbind+0x29/0x67
May 14 11:08:20 karga kernel: [<ffffffff8129d19f>] ? cachefiles_daemon_release+0x40/0x97
May 14 11:08:20 karga kernel: [<ffffffff811115e8>] ? __fput+0xe5/0x1ce
May 14 11:08:20 karga kernel: [<ffffffff81070b7a>] ? task_work_run+0x73/0x89
May 14 11:08:20 karga kernel: [<ffffffff8105bbbf>] ? do_exit+0x3b1/0x8f9
May 14 11:08:20 karga kernel: [<ffffffff81126783>] ? mntput_no_expire+0x13/0x11f
May 14 11:08:20 karga kernel: [<ffffffff8105c25c>] ? do_group_exit+0x66/0x98
May 14 11:08:20 karga kernel: [<ffffffff8105c29d>] ? SyS_exit_group+0xf/0xf
May 14 11:08:20 karga kernel: [<ffffffff8158fbd2>] ? system_call_fastpath+0x16/0x1b
May 14 11:08:20 karga kernel: Code: ff 75 11 48 8b 86 08 01 00 00 48 03 04 fd 90 1d 90 81 eb 1b 48 8b 14 fd 90 1d 90 81 48 c7 c0 90 e9 00 00 48 63 04 10 48 83 c0 22 <48> 8b 04 c6 48 8d 50 60 48 39 50 60 0f 95 c0 c3 53 48 89 fb 48 
May 14 11:08:20 karga kernel: RIP  [<ffffffff8106bc62>] workqueue_congested+0x34/0x44
May 14 11:08:20 karga kernel: RSP <ffff88007c2bfd90>
May 14 11:08:20 karga kernel: CR2: ffff8803982ea070
May 14 11:08:20 karga kernel: ---[ end trace df995ad9fe99c245 ]---
May 14 11:08:20 karga kernel: Fixing recursive fault but reboot is needed!
May 14 11:08:25 karga /etc/init.d/cachefilesd[3311]: start-stop-daemon: 1 process refused to stop
May 14 11:08:25 karga /etc/init.d/cachefilesd[3303]: ERROR: cachefilesd failed to stop
May 14 11:08:25 karga bluetoothd[2779]: Terminating
May 14 11:08:25 karga bluetoothd[2779]: Stopping SDP server
May 14 11:08:25 karga bluetoothd[2779]: Exit
May 14 11:08:26 karga sshd[2688]: Received signal 15; terminating.
May 14 11:08:26 karga kernel: device eth0 left promiscuous mode
May 14 11:08:26 karga kernel: br0: port 1(eth0) entered disabled state
May 14 11:09:20 karga kernel: INFO: rcu_sched self-detected stall on CPU { 0}  (t=15000 jiffies g=491 c=490 q=4827)
May 14 11:09:20 karga kernel: CPU: 0 PID: 1291 Comm: kworker/u4:6 Tainted: G      D W    3.10.0-rc1-00087-g674825d #1
May 14 11:09:20 karga kernel: Hardware name: System manufacturer System Product Name/M2V, BIOS 1803    05/11/2007
May 14 11:09:20 karga kernel: Workqueue: fscache_object fscache_object_work_func
May 14 11:09:20 karga kernel: ffffffff81585e4f 0000000000000025 ffffffff810b68ea 0000000000000001
May 14 11:09:20 karga kernel: 00000000000012db 0000000000000000 0000000000000000 ffff88007c954780
May 14 11:09:20 karga kernel: ffff88007c954780 0000000000000000 0000000000000000 ffff88007fc0d220
May 14 11:09:20 karga kernel: Call Trace:
May 14 11:09:20 karga kernel: <IRQ>  [<ffffffff81585e4f>] ? dump_stack+0xd/0x17
May 14 11:09:20 karga kernel: [<ffffffff810b68ea>] ? rcu_check_callbacks+0x1cb/0x5b2
May 14 11:09:20 karga kernel: [<ffffffff81093c7e>] ? tick_sched_do_timer+0x25/0x25
May 14 11:09:20 karga kernel: [<ffffffff81063fec>] ? update_process_times+0x31/0x5c
May 14 11:09:20 karga kernel: [<ffffffff810939e4>] ? tick_sched_handle+0x33/0x3e
May 14 11:09:20 karga kernel: [<ffffffff81093cae>] ? tick_sched_timer+0x30/0x4c
May 14 11:09:20 karga kernel: [<ffffffff810755e3>] ? __run_hrtimer+0xc7/0x18c
May 14 11:09:20 karga kernel: [<ffffffff81075dd6>] ? hrtimer_interrupt+0xe5/0x1cd
May 14 11:09:20 karga kernel: [<ffffffff81049b34>] ? smp_apic_timer_interrupt+0x7e/0x91
May 14 11:09:20 karga kernel: [<ffffffff8159078a>] ? apic_timer_interrupt+0x6a/0x70
May 14 11:09:20 karga kernel: <EOI>  [<ffffffff815897fe>] ? _raw_spin_lock+0x13/0x18
May 14 11:09:20 karga kernel: [<ffffffff81165733>] ? fscache_object_work_func+0x76c/0x7c5
May 14 11:09:20 karga kernel: [<ffffffff8106e2d4>] ? process_one_work+0x1eb/0x355
May 14 11:09:20 karga kernel: [<ffffffff8106e87a>] ? worker_thread+0x1c7/0x2bc
May 14 11:09:20 karga kernel: [<ffffffff8106e6b3>] ? rescuer_thread+0x250/0x250
May 14 11:09:20 karga kernel: [<ffffffff81072f42>] ? kthread+0xad/0xb5
May 14 11:09:20 karga kernel: [<ffffffff81072e95>] ? kthread_freezable_should_stop+0x40/0x40
May 14 11:09:20 karga kernel: [<ffffffff8158fb2c>] ? ret_from_fork+0x7c/0xb0
May 14 11:09:20 karga kernel: [<ffffffff81072e95>] ? kthread_freezable_should_stop+0x40/0x40
