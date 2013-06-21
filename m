Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945980Ab3FUUEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945935Ab3FUUEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:04:11 -0400
Date: Fri, 21 Jun 2013 21:59:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130621195949.GA15519@redhat.com>
References: <20130619164540.GB22483@redhat.com> <20130619175356.GA23673@redhat.com> <20130619181302.GE5146@linux.vnet.ibm.com> <20130620001212.GB12151@redhat.com> <20130620161652.GA4462@linux.vnet.ibm.com> <20130621151119.GA1596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621151119.GA1596@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Dave Jones wrote:
>
> On Thu, Jun 20, 2013 at 09:16:52AM -0700, Paul E. McKenney wrote:
>  > >  > >  > I've been hitting this a lot the last few days.
>  > >  > >  > This is the same machine that I was also seeing lockups during sync()
>  > >  > >
>  > >  > > On a whim, I reverted 971394f389992f8462c4e5ae0e3b49a10a9534a3
>  > >  > > (As I started seeing these just after that rcu merge).
>  > >  > >
>  > >  > > It's only been 30 minutes, but it seems stable again. Normally I would
>  > >  > > hit these within 5 minutes.
>  > >  > >
>  > >  > > I think this may be the same root cause for http://www.spinics.net/lists/kernel/msg1551503.html too.
>  > >  >
>  > > Dammit. Paul, you're off the hook (for now).
>  > > It just took longer to hit.
>  >
>  > Well, this commit could significantly increase CPU overhead, which might
>  > make the bug more likely to occur.  (Hey, I can rationalize -anything-!!!)
>
> I spent yesterday bisecting this (twice, on two systems in parallel to be sure).
> It came down to 8aac62706adaaf0fab02c4327761561c8bda9448
> Before I turned in last night, I pulled Linus current, and reverted that,

I hope you didn't pull some unrelated fix in between ;)

> and it's been fine during overnight stress testing.
>
> Oleg ?

I am puzzled. And I do not really understand

	hardirqs last  enabled at (2380318): [<ffffffff816ed220>] restore_args+0x0/0x30
	hardirqs last disabled at (2380319): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
	softirqs last  enabled at (196990): [<ffffffff810542d4>] __do_softirq+0x194/0x440 [19886.471395]
	softirqs last disabled at (197479): [<ffffffff8105473d>] irq_exit+0xcd/0xe0

below. how can they differ that much...

Dave, any chance you can reproduce the hang with the debugging patch at
the end? Just in case, the warnings themself do not mean a problem, just
to have a bit more info.

>  > > [19886.451044] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:12994]
>  > > [19886.452659] Modules linked in: bridge stp snd_seq_dummy fuse tun hidp rfcomm ipt_ULOG bnep nfnetlink can_raw ipx p8023 p8022 pppoe pppox ppp_generic slhc scsi_transport_iscsi can_bcm rds bluetooth can nfc
>  > > rfkill af_key af_802154 netrom irda af_rxrpc appletalk phonet psnap caif_socket caif x25 crc_ccitt llc2 llc rose ax25 atm coretemp hwmon kvm_intel kvm crc32c_intel ghash_clmulni_intel snd_hda_codec_realtek mi
>  > > crocode pcspkr snd_hda_codec_hdmi usb_debug snd_hda_intel snd_seq e1000e snd_hda_codec snd_hwdep ptp pps_core snd_seq_device snd_pcm snd_page_alloc snd_timer snd soundcore xfs libcrc32c
>  > > [19886.464209] irq event stamp: 2380319
>  > > [19886.465510] hardirqs last  enabled at (2380318): [<ffffffff816ed220>] restore_args+0x0/0x30
>  > > [19886.467446] hardirqs last disabled at (2380319): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
>  > > [19886.469464] softirqs last  enabled at (196990): [<ffffffff810542d4>] __do_softirq+0x194/0x440
>  > > [19886.471395] softirqs last disabled at (197479): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
>  > > [19886.473238] CPU: 0 PID: 12994 Comm: trinity-child0 Not tainted 3.10.0-rc6+ #17
>  > > [19886.477881] task: ffff8801a8222520 ti: ffff880228d98000 task.ti: ffff880228d98000
>  > > [19886.479712] RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
>  > > [19886.481706] RSP: 0018:ffff880244803f08  EFLAGS: 00000202
>  > > [19886.483298] RAX: ffff8801a8222520 RBX: ffffffff816ed220 RCX: 0000000000000002
>  > > [19886.485094] RDX: 00000000000045b0 RSI: ffff8801a8222ca0 RDI: ffff8801a8222520
>  > > [19886.486896] RBP: ffff880244803f70 R08: 0000000000000001 R09: 0000000000000000
>  > > [19886.488687] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244803e78
>  > > [19886.490507] R13: ffffffff816f5d2f R14: ffff880244803f70 R15: 0000000000000000
>  > > [19886.492325] FS:  00007f0bcf727740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
>  > > [19886.494184] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  > > [19886.495781] CR2: 0000000000000001 CR3: 00000001a56d0000 CR4: 00000000001407f0
>  > > [19886.497545] DR0: 00007f21e7713000 DR1: 0000000000000000 DR2: 0000000000000000
>  > > [19886.499304] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
>  > > [19886.501070] Stack:
>  > > [19886.502247]  0000000a00406040 00000001001ddcf4 ffff880228d99fd8 ffff880228d99fd8
>  > > [19886.504104]  ffff880228d99fd8 ffff8801a8222918 ffff880228d99fd8 ffff880200000000
>  > > [19886.505996]  ffff8801a8222520 0000000000000000 0000000000002e82 00000000162dccb4
>  > > [19886.507859] Call Trace:
>  > > [19886.509095]  <IRQ>
>  > > [19886.509334]  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
>  > > [19886.511879]  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
>  > > [19886.513586]  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
>  > > [19886.515243]  <EOI>
>  > > [19886.515482]  [<ffffffff812fe80d>] ? idr_find_slowpath+0x4d/0x150
>  > > [19886.518126]  [<ffffffff812a2cb9>] ipcget+0x89/0x380
>  > > [19886.519656]  [<ffffffff810b72dd>] ? trace_hardirqs_on_caller+0xfd/0x1c0
>  > > [19886.521409]  [<ffffffff812a43b6>] SyS_msgget+0x56/0x60
>  > > [19886.522971]  [<ffffffff812a39a0>] ? rcu_read_lock+0x80/0x80
>  > > [19886.524585]  [<ffffffff812a37e0>] ? sysvipc_msg_proc_show+0xd0/0xd0
>  > > [19886.526274]  [<ffffffff816f52d4>] tracesys+0xdd/0xe2
>  > > [19886.527804]  [<ffffffff8100ffff>] ? enable_step+0x3f/0x1d0
>  > > [19886.529397] Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74
>  > >
> ---end quoted text---


diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 10e5947..bbeb128 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -59,7 +59,9 @@ extern struct nsproxy init_nsproxy;
 
 static inline struct nsproxy *task_nsproxy(struct task_struct *tsk)
 {
-	return rcu_dereference(tsk->nsproxy);
+	struct nsproxy *ret = rcu_dereference(tsk->nsproxy);
+	WARN_ON(!ret);
+	return ret;
 }
 
 int copy_namespaces(unsigned long flags, struct task_struct *tsk);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 364ceab..77a20e9 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -220,6 +220,7 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 	rcu_assign_pointer(p->nsproxy, new);
 
 	if (ns && atomic_dec_and_test(&ns->count)) {
+		pr_info("YESTHISHAPPENS new=%p\n", new);
 		/*
 		 * wait for others to get what they want from this nsproxy.
 		 *
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 65bd3c9..917764e 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -9,6 +9,8 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
 	struct callback_head *head;
 
+	WARN_ON(task == current && !task->nsproxy);
+
 	do {
 		head = ACCESS_ONCE(task->task_works);
 		if (unlikely(head == &work_exited))

