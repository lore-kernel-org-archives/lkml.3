Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3FJVSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:18:35 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33351 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3FJVSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:18:33 -0400
Date: Mon, 10 Jun 2013 14:18:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com, rostedt@goodmis.org
Subject: Re: Another RCU trace. (3.10-rc5)
Message-ID: <20130610211803.GR5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130610195145.GA26068@redhat.com>
 <20130610203355.GO5146@linux.vnet.ibm.com>
 <20130610210123.GA27154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610210123.GA27154@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061021-7606-0000-0000-00000C5930BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 05:01:23PM -0400, Dave Jones wrote:
> On Mon, Jun 10, 2013 at 01:33:55PM -0700, Paul E. McKenney wrote:
> 
>  > > I saw some of Steven's patches get merged on Friday, is there anything else
>  > > outstanding that didn't make it in yet that I could test ?
>  > > Or is this another new bug ?
>  > 
>  > I have three fixes queued up at:
>  > 
>  > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
>  > 
>  > Kind of hard to tell whether they are relevant given the interleaved
>  > stack traces, but can't hurt to try them out.
> 
> Here's another. Looks different.

I bet that commit d6284099 (trace: Allow idle-safe tracepoints to be
called from irq) from the above git archive fixes this one.  Just don't
ask how much I am willing to bet.  ;-)

								Thanx, Paul

> [ 2739.921649] ===============================
> [ 2739.923894] [ INFO: suspicious RCU usage. ]
> [ 2739.926144] 3.10.0-rc5+ #6 Not tainted
> [ 2739.928397] -------------------------------
> [ 2739.930670] include/linux/rcupdate.h:780 rcu_read_lock() used illegally while idle!
> [ 2739.933826] 
> other info that might help us debug this:
> 
> [ 2739.939663] 
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 0
> [ 2739.946345] RCU used illegally from extended quiescent state!
> [ 2739.949123] 2 locks held by trinity-child1/4385:
> [ 2739.951537]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff816ea16f>] __schedule+0xef/0x9c0
> [ 2739.955316]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff810a5625>] cpuacct_charge+0x5/0x1f0
> [ 2739.959101] 
> stack backtrace:
> [ 2739.962529] CPU: 1 PID: 4385 Comm: trinity-child1 Not tainted 3.10.0-rc5+ #6
> [ 2739.970870]  0000000000000000 ffff8802247e3cf8 ffffffff816e39db ffff8802247e3d28
> [ 2739.974556]  ffffffff810b5987 ffff880200f02568 000000000032585b ffff880200f02520
> [ 2739.978353]  0000000000000001 ffff8802247e3d60 ffffffff810a57a5 ffffffff810a5625
> [ 2739.982052] Call Trace:
> [ 2739.984098]  [<ffffffff816e39db>] dump_stack+0x19/0x1b
> [ 2739.986996]  [<ffffffff810b5987>] lockdep_rcu_suspicious+0xe7/0x120
> [ 2739.990080]  [<ffffffff810a57a5>] cpuacct_charge+0x185/0x1f0
> [ 2739.992971]  [<ffffffff810a5625>] ? cpuacct_charge+0x5/0x1f0
> [ 2739.994716]  [<ffffffff8109609c>] update_curr+0xec/0x250
> [ 2739.995873]  [<ffffffff810975c8>] put_prev_task_fair+0x228/0x480
> [ 2739.997036]  [<ffffffff816ea1e6>] __schedule+0x166/0x9c0
> [ 2739.998192]  [<ffffffff816eaf60>] ? __cond_resched_softirq+0x60/0x60
> [ 2739.999344]  [<ffffffff816eae94>] preempt_schedule+0x44/0x60
> [ 2740.000479]  [<ffffffff816eaf60>] ? __cond_resched_softirq+0x60/0x60
> [ 2740.001622]  [<ffffffff816ecf64>] ? retint_careful+0x12/0x2e
> [ 2740.002760]  [<ffffffff8110d73f>] ftrace_ops_control_func+0x10f/0x140
> [ 2740.003908]  [<ffffffff816f4a00>] ftrace_call+0x5/0x2f
> [ 2740.005046]  [<ffffffff816ecf5d>] ? retint_careful+0xb/0x2e
> [ 2740.006188]  [<ffffffff816eaf65>] ? schedule_user+0x5/0x70
> [ 2740.007325]  [<ffffffff816eaf65>] ? schedule_user+0x5/0x70
> [ 2740.008454]  [<ffffffff816ecf64>] ? retint_careful+0x12/0x2e
> [ 2757.542667] ------------[ cut here ]------------
> [ 2757.544693] WARNING: at kernel/context_tracking.c:55 user_enter+0xb5/0xd0()
> [ 2757.546644] Modules linked in: snd_seq_dummy fuse hidp bnep rfcomm ipt_ULOG can_raw nfnetlink can_bcm can decnet scsi_transport_iscsi pppoe pppox ppp_generic slhc af_rxrpc caif_socket caif bluetooth x25 phonet ipx p8023 p8022 rds nfc rfkill netrom af_key irda appletalk psnap crc_ccitt llc2 llc rose ax25 atm af_802154 nfsv3 nfs_acl nfs lockd sunrpc fscache coretemp hwmon kvm_intel kvm crc32c_intel ghash_clmulni_intel snd_hda_codec_realtek microcode pcspkr snd_hda_codec_hdmi usb_debug snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e snd_pcm ptp pps_core snd_page_alloc snd_timer snd soundcore xfs libcrc32c
> [ 2757.559111] CPU: 2 PID: 7910 Comm: kworker/u8:2 Not tainted 3.10.0-rc5+ #6
> [ 2757.564356]  ffffffff81a18e2d ffff880200db3ba8 ffffffff816e39db ffff880200db3be0
> [ 2757.566581]  ffffffff8104a1b1 0000000000000001 ffff880200db3fd8 00000000ffffffff
> [ 2757.568813]  ffff8802434cc240 ffff880244dd9160 ffff880200db3bf0 ffffffff8104a28a
> [ 2757.571053] Call Trace:
> [ 2757.572639]  [<ffffffff816e39db>] dump_stack+0x19/0x1b
> [ 2757.574545]  [<ffffffff8104a1b1>] warn_slowpath_common+0x61/0x80
> [ 2757.576548]  [<ffffffff8104a28a>] warn_slowpath_null+0x1a/0x20
> [ 2757.578526]  [<ffffffff811451f5>] user_enter+0xb5/0xd0
> [ 2757.580424]  [<ffffffff816eb0d5>] preempt_schedule_irq+0x85/0x90
> [ 2757.582424]  [<ffffffff816ed036>] retint_kernel+0x26/0x30
> [ 2757.584344]  [<ffffffff81199877>] ? deactivate_slab+0x627/0x740
> [ 2757.586330]  [<ffffffff816e2957>] ? __slab_alloc+0x457/0x507
> [ 2757.588279]  [<ffffffff816e295c>] ? __slab_alloc+0x45c/0x507
> [ 2757.590237]  [<ffffffff816f4a00>] ? ftrace_call+0x5/0x2f
> [ 2757.592145]  [<ffffffff8110890e>] ? __delayacct_tsk_init+0x1e/0x50
> [ 2757.594156]  [<ffffffff8110890e>] ? __delayacct_tsk_init+0x1e/0x50
> [ 2757.596166]  [<ffffffff8119cd97>] kmem_cache_alloc+0x257/0x320
> [ 2757.598129]  [<ffffffff8110890e>] ? __delayacct_tsk_init+0x1e/0x50
> [ 2757.600138]  [<ffffffff8110890e>] __delayacct_tsk_init+0x1e/0x50
> [ 2757.602127]  [<ffffffff81048425>] copy_process.part.28+0x805/0x15a0
> [ 2757.604144]  [<ffffffff8106a1b0>] ? usermodehelper_read_lock_wait+0xc0/0xc0
> [ 2757.606242]  [<ffffffff810492ab>] do_fork+0xbb/0x470
> [ 2757.608098]  [<ffffffff816f4a00>] ? ftrace_call+0x5/0x2f
> [ 2757.609994]  [<ffffffff8106a1b0>] ? usermodehelper_read_lock_wait+0xc0/0xc0
> [ 2757.612099]  [<ffffffff8106a1b0>] ? usermodehelper_read_lock_wait+0xc0/0xc0
> [ 2757.614196]  [<ffffffff81049686>] kernel_thread+0x26/0x30
> [ 2757.616104]  [<ffffffff8106a418>] wait_for_helper+0x68/0xa0
> [ 2757.618037]  [<ffffffff8108b910>] ? schedule_tail+0x30/0xb0
> [ 2757.619961]  [<ffffffff8106a3b0>] ? __call_usermodehelper+0x90/0x90
> [ 2757.621959]  [<ffffffff816f4d1c>] ret_from_fork+0x7c/0xb0
> [ 2757.623846]  [<ffffffff8106a3b0>] ? __call_usermodehelper+0x90/0x90
> [ 2757.625829] ---[ end trace 312da8c9d32e2f2c ]---
> 
> 

