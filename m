Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3FZFs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:48:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3FZFsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:48:24 -0400
Date: Wed, 26 Jun 2013 01:48:09 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130626054809.GA2862@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <1372177414.18733.211.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372177414.18733.211.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:23:34PM -0400, Steven Rostedt wrote:
 > On Tue, 2013-06-25 at 11:35 -0400, Dave Jones wrote:
 > > Took a lot longer to trigger this time. (13 hours of runtime).
 > > 
 > > This trace may still not be from the first lockup, as a flood of
 > > them happened at the same time. 
 > > 
 > > 
 > > # tracer: preemptirqsoff
 > > #
 > > # preemptirqsoff latency trace v1.1.5 on 3.10.0-rc7+
 > > # --------------------------------------------------------------------
 > > # latency: 389877255 us, #4/4, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
 > > #    -----------------
 > > #    | task: trinity-main-9252 (uid:1000 nice:19 policy:0 rt_prio:0)
 > > #    -----------------
 > > #  => started at: vprintk_emit
 > > #  => ended at:   vprintk_emit
 > > #
 > > #
 > > #                  _------=> CPU#            
 > > #                 / _-----=> irqs-off        
 > > #                | / _----=> need-resched    
 > > #                || / _---=> hardirq/softirq 
 > > #                ||| / _--=> preempt-depth   
 > > #                |||| /     delay             
 > > #  cmd     pid   ||||| time  |   caller      
 > > #     \   /      |||||  \    |   /           
 > > trinity--9252    1dNh1    0us!: console_unlock <-vprintk_emit
 > > trinity--9252    1dNh1 389877255us : console_unlock <-vprintk_emit
 > > trinity--9252    1dNh1 389877255us+: stop_critical_timings <-vprintk_emit
 > > trinity--9252    1dNh1 389877261us : <stack trace>
 > >  => console_unlock
 > >  => vprintk_emit
 > >  => printk
 > 
 > This is the same as the last one, with no new info to why it started the
 > tracing at console_unlock :-/
 > 
 > Now, what we can try to do as well, is to add a trigger to disable
 > tracing, which should (I need to check the code) stop tracing on printk.
 > To do so:
 > 
 > # echo printk:traceoff > /sys/kernel/debug/tracing/set_ftrace_filter
 > 
 > This will add a trigger to the printk function that when called, will
 > disable tracing. If it is hit before you get your trace, you can just
 > re-enable tracing with:
 > 
 > # echo 1 > /sys/kernel/debug/tracing/tracing_on
 > 
 > Hmm, no it needs a fix to make this work. I applied a patch below that
 > should do this correctly (and will put this into my 3.11 queue).
 > 
 > If you run the test again with this change and with the above filter, it
 > should stop the trace before overwriting the first dump, as it should
 > ignore the printk output.

More puzzling.  Rebooted the machine, restarted the test, and hit it pretty 
quickly.. Though different backtrace this time..

[ 1583.293902] BUG: soft lockup - CPU#1 stuck for 22s! [migration/1:28]
[ 1583.293905] BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:7]
[ 1583.293932] Modules linked in: tun hidp bnep nfnetlink rfcomm scsi_transport_iscsi ipt_ULOG can_raw af_rxrpc netrom nfc can_bcm can appletalk ipx p8023 af_key psnap irda p8022 rose caif_socket caif ax25 crc_ccitt llc2 af_802154 llc rds bluetooth phonet rfkill pppoe pppox atm ppp_generic slhc x25 coretemp hwmon kvm_intel kvm snd_hda_codec_realtek crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel microcode snd_hda_intel pcspkr snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e snd_pcm ptp pps_core snd_page_alloc snd_timer snd soundcore xfs libcrc32c
[ 1583.293932] irq event stamp: 108950
[ 1583.293937] hardirqs last  enabled at (108949): [<ffffffff816e9320>] restore_args+0x0/0x30
[ 1583.293940] hardirqs last disabled at (108950): [<ffffffff816f1dea>] apic_timer_interrupt+0x6a/0x80
[ 1583.293943] softirqs last  enabled at (108948): [<ffffffff810541d4>] __do_softirq+0x194/0x440
[ 1583.293945] softirqs last disabled at (108943): [<ffffffff8105463d>] irq_exit+0xcd/0xe0
[ 1583.293947] CPU: 0 PID: 7 Comm: migration/0 Not tainted 3.10.0-rc7+ #5
[ 1583.293948] task: ffff880244190000 ti: ffff88024418a000 task.ti: ffff88024418a000
[ 1583.293952] RIP: 0010:[<ffffffff810dd856>]  [<ffffffff810dd856>] stop_machine_cpu_stop+0x86/0x110
[ 1583.293953] RSP: 0018:ffff88024418bce8  EFLAGS: 00000293
[ 1583.293953] RAX: 0000000000000001 RBX: ffffffff816e9320 RCX: 0000000000000000
[ 1583.293954] RDX: ffff88024418bf00 RSI: ffffffff81084b2c RDI: ffff8801ecd51b88
[ 1583.293954] RBP: ffff88024418bd10 R08: 0000000000000001 R09: 0000000000000000
[ 1583.293955] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88024418bc58
[ 1583.293956] R13: ffff88024418bfd8 R14: ffff88024418a000 R15: 0000000000000046
[ 1583.293956] FS:  0000000000000000(0000) GS:ffff880245600000(0000) knlGS:0000000000000000
[ 1583.293957] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1583.293958] CR2: 0000000006ff0158 CR3: 00000001ea0df000 CR4: 00000000001407f0
[ 1583.293958] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1583.293959] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1583.293959] Stack:
[ 1583.293961]  ffff8802457cd880 ffff8801ecd51ac0 ffff8801ecd51b88 ffffffff810dd7d0
[ 1583.293963]  ffff88024418bfd8 ffff88024418bde0 ffffffff810dd6ed ffff88024418bfd8
[ 1583.293965]  ffff8802457cd8d0 000000000000017f ffff88024418bd48 00000007810b463e
[ 1583.293965] Call Trace:
[ 1583.293967]  [<ffffffff810dd7d0>] ? cpu_stopper_thread+0x180/0x180
[ 1583.293969]  [<ffffffff810dd6ed>] cpu_stopper_thread+0x9d/0x180
[ 1583.293971]  [<ffffffff816e86d5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[ 1583.293973]  [<ffffffff810b75b5>] ? trace_hardirqs_on_caller+0x115/0x1e0
[ 1583.293976]  [<ffffffff81084b2c>] smpboot_thread_fn+0x1ac/0x320
[ 1583.293978]  [<ffffffff81084980>] ? lg_global_unlock+0xe0/0xe0
[ 1583.293981]  [<ffffffff8107a88d>] kthread+0xed/0x100
[ 1583.293983]  [<ffffffff816e597f>] ? wait_for_completion+0xdf/0x110
[ 1583.293985]  [<ffffffff8107a7a0>] ? insert_kthread_work+0x80/0x80
[ 1583.293987]  [<ffffffff816f10dc>] ret_from_fork+0x7c/0xb0
[ 1583.293989]  [<ffffffff8107a7a0>] ? insert_kthread_work+0x80/0x80
[ 1583.294007] Code: f0 ff 4b 24 0f 94 c2 84 d2 44 89 e0 74 12 8b 43 20 8b 53 10 83 c0 01 89 53 24 89 43 20 44 89 e0 83 f8 04 74 20 f3 90 44 8b 63 20 <41> 39 c4 74 f0 41 83 fc 02 75 bf fa e8 49 66 fd ff eb c2 0f 1f 

Same trace for all 4 cpus occurred.

'trace' file contained this...

# tracer: preemptirqsoff
#
# preemptirqsoff latency trace v1.1.5 on 3.10.0-rc7+
# --------------------------------------------------------------------
# latency: 478 us, #4/4, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
#    -----------------
#    | task: sshd-405 (uid:1000 nice:0 policy:0 rt_prio:0)
#    -----------------
#  => started at: fget_light
#  => ended at:   fget_light
#
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /     delay             
#  cmd     pid   ||||| time  |   caller      
#     \   /      |||||  \    |   /           
    sshd-405     3...1    0us!: rcu_lockdep_current_cpu_online <-fget_light
    sshd-405     3...1  478us+: rcu_lockdep_current_cpu_online <-fget_light
    sshd-405     3...1  481us+: trace_preempt_on <-fget_light
    sshd-405     3...1  496us : <stack trace>
 => sub_preempt_count
 => rcu_lockdep_current_cpu_online
 => fget_light
 => do_select
 => core_sys_select
 => SyS_select
 => tracesys

which looks pretty unhelpful to me ?

	Dave

