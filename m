Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3EVMtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:49:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3EVMtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:49:20 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=s9b0WtSLZS4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=_vU5-hpMSx0A:10 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=S7OzpgZLAAAA:8 a=cIOIUgNhb5GT7X1WlHAA:9 a=QEXdDO2ut3YA:10 a=x8gzFH9gYPwA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369226958.6828.175.camel@gandalf.local.home>
Subject: Re: rcu_read_lock() used illegally while idle!
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Date: Wed, 22 May 2013 08:49:18 -0400
In-Reply-To: <20130522093624.GZ3578@linux.vnet.ibm.com>
References: <20130521173100.GA2076@redhat.com>
	 <20130522093624.GZ3578@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 02:36 -0700, Paul E. McKenney wrote:
> On Tue, May 21, 2013 at 01:31:00PM -0400, Dave Jones wrote:
> > Back from vacation, and breaking stuff already :)
> > 
> > -rc2, plus some small local mods that shouldn't be a cause.
> 
> Hmmm...  I thought that ftrace already took care to let RCU know that
> the CPU should be considered non-idle before using RCU read-side critical
> sections.
> 
> Adding Steven and Frederic to CC for their insight.
> 
> 							Thanx, Paul
> 
> > [  839.278967] ===============================
> > [  839.279023] [ INFO: suspicious RCU usage. ]
> > [  839.279080] 3.10.0-rc2+ #1 Not tainted
> > [  839.279129] -------------------------------
> > [  839.279185] include/linux/rcupdate.h:771 rcu_read_lock() used illegally while idle!
> > [  839.279273] 
> > other info that might help us debug this:
> > 
> > [  839.279370] 
> > RCU used illegally from idle CPU!
> > rcu_scheduler_active = 1, debug_locks = 0
> > [  839.279497] RCU used illegally from extended quiescent state!
> > [  839.279566] 2 locks held by cc1/63645:
> > [  839.279614]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff816b39fd>] __schedule+0xed/0x9b0
> > [  839.279754]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8109d645>] cpuacct_charge+0x5/0x1f0
> > [  839.279895] 
> > stack backtrace:
> > [  839.279954] CPU: 1 PID: 63645 Comm: cc1 Not tainted 3.10.0-rc2+ #1 [loadavg: 40.57 27.55 13.39 25/277 64369]
> > [  839.280074] Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
> > [  839.280182]  0000000000000000 ffff88010f78fcf8 ffffffff816ae383 ffff88010f78fd28
> > [  839.280301]  ffffffff810b698d ffff88011c092548 000000000023d073 ffff88011c092500
> > [  839.280419]  0000000000000001 ffff88010f78fd60 ffffffff8109d7c5 ffffffff8109d645
> > [  839.280537] Call Trace:
> > [  839.280578]  [<ffffffff816ae383>] dump_stack+0x19/0x1b
> > [  839.280645]  [<ffffffff810b698d>] lockdep_rcu_suspicious+0xfd/0x130
> > [  839.280723]  [<ffffffff8109d7c5>] cpuacct_charge+0x185/0x1f0
> > [  839.280793]  [<ffffffff8109d645>] ? cpuacct_charge+0x5/0x1f0
> > [  839.280865]  [<ffffffff8108dffc>] update_curr+0xec/0x240
> > [  839.283157]  [<ffffffff8108f528>] put_prev_task_fair+0x228/0x480
> > [  839.285453]  [<ffffffff816b3a71>] __schedule+0x161/0x9b0
> > [  839.287753]  [<ffffffff816b4721>] preempt_schedule+0x51/0x80
> > [  839.290056]  [<ffffffff816b4800>] ? __cond_resched_softirq+0x60/0x60
> > [  839.292347]  [<ffffffff816b6824>] ? retint_careful+0x12/0x2e
> > [  839.294620]  [<ffffffff810ff3cc>] ftrace_ops_control_func+0x1dc/0x210
> > [  839.296880]  [<ffffffff816be280>] ftrace_call+0x5/0x2f
> > [  839.299107]  [<ffffffff816b681d>] ? retint_careful+0xb/0x2e
> > [  839.301319]  [<ffffffff816b4805>] ? schedule_user+0x5/0x70
> > [  839.303524]  [<ffffffff816b4805>] ? schedule_user+0x5/0x70
> > [  839.305709]  [<ffffffff816b6824>] ? retint_careful+0x12/0x2e
> > [  839.959586] ------------[ cut here ]------------

This looks to be the caused by the same issue that this patch fixes:

https://lkml.org/lkml/2013/5/10/537

The schedule_user() was traced, and the preempt_enable_no_trace() that
the function tracer does caused for a schedule to occur. As the
scheduler uses rcu, and it was called before schedule_user() could tell
the kernel that the context is changing from user to kernel.

-- Steve



> > [  839.962342] WARNING: at kernel/context_tracking.c:55 user_enter+0xb5/0xd0()
> > [  839.965471] Modules linked in: 8021q garp stp mrp rfcomm cmtp kernelcapi hidp fuse phonet af_key rose caif_socket af_rxrpc caif netrom llc2 bnep can_bcm can_raw can ipt_ULOG nfnetlink l2tp_ppp l2tp_netlink l2tp_core pppoe pppox ppp_generic slhc scsi_transport_iscsi ipx x25 p8023 appletalk psnap p8022 llc irda nfc crc_ccitt rds ax25 decnet af_802154 atm kvm_amd kvm microcode edac_core btusb bluetooth serio_raw pcspkr snd_hda_codec_realtek snd_hda_intel rfkill snd_hda_codec snd_pcm r8169 mii snd_page_alloc snd_timer snd soundcore sr_mod cdrom pata_atiixp radeon backlight drm_kms_helper ttm
> > [  839.983088] CPU: 1 PID: 275 Comm: jbd2/sda5-8 Not tainted 3.10.0-rc2+ #1 [loadavg: 40.57 27.55 13.39 41/277 64411]
> > [  839.986926] Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
> > [  839.990687]  ffffffff819ffcdc ffff88011cf6d6e8 ffffffff816ae383 ffff88011cf6d720
> > [  839.994267]  ffffffff81043280 0000000000000000 ffff88011cf6dfd8 00000000ffffffff
> > [  839.997861]  ffff88012a8046c0 ffff88012b1d7320 ffff88011cf6d730 ffffffff8104336a
> > [  840.001431] Call Trace:
> > [  840.004284]  [<ffffffff816ae383>] dump_stack+0x19/0x1b
> > [  840.007486]  [<ffffffff81043280>] warn_slowpath_common+0x70/0xa0
> > [  840.010807]  [<ffffffff8104336a>] warn_slowpath_null+0x1a/0x20
> > [  840.014079]  [<ffffffff8113acc5>] user_enter+0xb5/0xd0
> > [  840.017255]  [<ffffffff816b496d>] preempt_schedule_irq+0x7d/0x90
> > [  840.020548]  [<ffffffff816b68f6>] retint_kernel+0x26/0x30
> > [  840.023760]  [<ffffffff81190bf7>] ? deactivate_slab+0x627/0x740
> > [  840.027035]  [<ffffffff810b83fd>] ? trace_hardirqs_on+0xd/0x10
> > [  840.030303]  [<ffffffff816ac6ca>] ? __slab_alloc+0x433/0x4dd
> > [  840.033547]  [<ffffffff8126bc98>] ? ext4_ext_find_extent+0x438/0x520
> > [  840.036917]  [<ffffffff816be280>] ? ftrace_call+0x5/0x2f
> > [  840.040147]  [<ffffffff8126bc98>] ? ext4_ext_find_extent+0x438/0x520
> > [  840.043497]  [<ffffffff8126bc98>] ? ext4_ext_find_extent+0x438/0x520
> > [  840.046854]  [<ffffffff8126bc98>] ? ext4_ext_find_extent+0x438/0x520
> > [  840.050171]  [<ffffffff81192172>] __kmalloc+0x302/0x400
> > [  840.053339]  [<ffffffff8126bc98>] ext4_ext_find_extent+0x438/0x520
> > [  840.056660]  [<ffffffff812701ea>] ext4_ext_map_blocks+0x6a/0x12b0
> > [  840.059942]  [<ffffffff816be280>] ? ftrace_call+0x5/0x2f
> > [  840.063114]  [<ffffffff81243a4d>] ext4_map_blocks+0x23d/0x4a0
> > [  840.066325]  [<ffffffff81243e40>] ? _ext4_get_block+0x190/0x190
> > [  840.069563]  [<ffffffff81243d33>] _ext4_get_block+0x83/0x190
> > [  840.072754]  [<ffffffff81243e56>] ext4_get_block+0x16/0x20
> > [  840.075939]  [<ffffffff811e609f>] generic_block_bmap+0x3f/0x50
> > [  840.079189]  [<ffffffff811e6065>] ? generic_block_bmap+0x5/0x50
> > [  840.082433]  [<ffffffff81241610>] ? ext4_num_dirty_pages.isra.46+0x210/0x210
> > [  840.085817]  [<ffffffff81147302>] ? mapping_tagged+0x12/0x20
> > [  840.088981]  [<ffffffff8124169c>] ext4_bmap+0x8c/0xf0
> > [  840.092065]  [<ffffffff811cb021>] bmap+0x21/0x30
> > [  840.095078]  [<ffffffff8129b073>] jbd2_journal_bmap+0x33/0xb0
> > [  840.098238]  [<ffffffff8129b175>] jbd2_journal_next_log_block+0x85/0xa0
> > [  840.101479]  [<ffffffff81291728>] jbd2_journal_commit_transaction+0x8f8/0x25e0
> > [  840.104763]  [<ffffffff816be280>] ? ftrace_call+0x5/0x2f
> > [  840.107774]  [<ffffffff816b5b52>] ? _raw_spin_unlock_irqrestore+0x42/0x80
> > [  840.110983]  [<ffffffff81297f61>] kjournald2+0xe1/0x400
> > [  840.114003]  [<ffffffff81072d30>] ? wake_up_bit+0x40/0x40
> > [  840.117017]  [<ffffffff81297e80>] ? commit_timeout+0x10/0x10
> > [  840.120065]  [<ffffffff81071c3d>] kthread+0xed/0x100
> > [  840.123001]  [<ffffffff81071b50>] ? insert_kthread_work+0x80/0x80
> > [  840.126086]  [<ffffffff816be59c>] ret_from_fork+0x7c/0xb0
> > [  840.129092]  [<ffffffff81071b50>] ? insert_kthread_work+0x80/0x80
> > [  840.132199] ---[ end trace 407275e2f13d1407 ]---
> > 
> > 
> > 
> > $ grep RCU .config
> > # RCU Subsystem
> > CONFIG_TREE_PREEMPT_RCU=y
> > CONFIG_PREEMPT_RCU=y
> > CONFIG_RCU_STALL_COMMON=y
> > CONFIG_RCU_USER_QS=y
> > CONFIG_RCU_FANOUT=64
> > CONFIG_RCU_FANOUT_LEAF=16
> > # CONFIG_RCU_FANOUT_EXACT is not set
> > # CONFIG_RCU_FAST_NO_HZ is not set
> > # CONFIG_TREE_RCU_TRACE is not set
> > CONFIG_RCU_BOOST=y
> > CONFIG_RCU_BOOST_PRIO=1
> > CONFIG_RCU_BOOST_DELAY=500
> > CONFIG_RCU_NOCB_CPU=y
> > CONFIG_RCU_NOCB_CPU_ALL=y
> > CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> > # RCU Debugging
> > CONFIG_PROVE_RCU=y
> > # CONFIG_PROVE_RCU_REPEATEDLY is not set
> > CONFIG_PROVE_RCU_DELAY=y
> > CONFIG_SPARSE_RCU_POINTER=y
> > # CONFIG_RCU_TORTURE_TEST is not set
> > CONFIG_RCU_CPU_STALL_TIMEOUT=60
> > CONFIG_RCU_CPU_STALL_VERBOSE=y
> > CONFIG_RCU_CPU_STALL_INFO=y
> > # CONFIG_RCU_TRACE is not set
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 


