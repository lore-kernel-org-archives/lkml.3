Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaLDQwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:52:16 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38780 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbaLDQwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:52:14 -0500
Date: Thu, 4 Dec 2014 17:52:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Chris Rorvick <chris@rorvick.com>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141204165203.GA3916@lerouge>
References: <547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
 <20141202205636.GQ25340@linux.vnet.ibm.com>
 <547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
 <CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
 <547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
 <CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
 <CAEUsAPYthwHxopuiBcGg4_nnBDDsS2jrTw4pDFiov38awsFodA@mail.gmail.com>
 <CA+55aFyBgyRS0zeE+LuHAvc=54v0de2KX=hRnr3imXwFFbftXw@mail.gmail.com>
 <54801ea9.0ca5e00a.3c72.08ce@mx.google.com>
 <CA+55aFzJ2uOxHC8y25oTzkURPcXo9r=5cvcCzSxgOSKnET5voQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzJ2uOxHC8y25oTzkURPcXo9r=5cvcCzSxgOSKnET5voQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 08:18:10AM -0800, Linus Torvalds wrote:
> On Thu, Dec 4, 2014 at 12:43 AM, Dâniel Fraga <fragabr@gmail.com> wrote:
> >
> >         Linus, today it's your lucky day, because I think I found the
> > real bad commit (if it isn't, then it's some very close to it). I
> > managed to narrow the bisect and here's the result:
> 
> Ok, that actually looks very reasonable, I had actually looked at it
> because of the whole "changes IPI" thing.
> 
> One more thing to try: does a revert fix it on current git?
> 
> It doesn't revert entirely cleanly, but close enough - attached a
> quick rough patch that may or may not work, but looks like a good
> revert.
> 
> Dave - this might be worth testing for you too, exactly because of
> that whole "it changes how we do IPI's". It was your bug report with
> TLB IPI's that made me look at that commit originally.

I think this is a different issue. What Daniel reported is:

Dec  4 06:03:41 tux kernel: [  737.180761]  [<ffffffff810637ca>] hrtimer_cancel+0x1a/0x30
Dec  4 06:03:41 tux kernel: [  737.180766]  [<ffffffff81097842>] tick_nohz_restart+0x12/0x80
Dec  4 06:03:41 tux kernel: [  737.180769]  [<ffffffff81097c4f>] __tick_nohz_full_check+0x9f/0xb0
Dec  4 06:03:41 tux kernel: [  737.180771]  [<ffffffff81097c69>] nohz_full_kick_work_func+0x9/0x10
Dec  4 06:03:41 tux kernel: [  737.180774]  [<ffffffff810aecd4>] irq_work_run_list+0x44/0x70
Dec  4 06:03:41 tux kernel: [  737.180777]  [<ffffffff81097730>] ? tick_sched_handle.isra.20+0x40/0x40
Dec  4 06:03:41 tux kernel: [  737.180779]  [<ffffffff810aed19>] __irq_work_run+0x19/0x30
Dec  4 06:03:41 tux kernel: [  737.180782]  [<ffffffff810aed98>] irq_work_run+0x18/0x40
Dec  4 06:03:41 tux kernel: [  737.180784]  [<ffffffff8104deb6>] update_process_times+0x56/0x70
Dec  4 06:03:41 tux kernel: [  737.180786]  [<ffffffff81097721>] tick_sched_handle.isra.20+0x31/0x40
Dec  4 06:03:42 tux kernel: [  737.180788]  [<ffffffff81097769>] tick_sched_timer+0x39/0x60
Dec  4 06:03:42 tux kernel: [  737.180790]  [<ffffffff810636a1>] __run_hrtimer.isra.33+0x41/0xd0
Dec  4 06:03:42 tux kernel: [  737.180792]  [<ffffffff81063a4f>] hrtimer_interrupt+0xef/0x250
Dec  4 06:03:42 tux kernel: [  737.180795]  [<ffffffff8102db65>] local_apic_timer_interrupt+0x35/0x60
Dec  4 06:03:42 tux kernel: [  737.180797]  [<ffffffff8102e12a>] smp_apic_timer_interrupt+0x3a/0x50
Dec  4 06:03:42 tux kernel: [  737.180799]  [<ffffffff81391a3a>] apic_timer_interrupt+0x6a/0x70

And this bug has been fixed upstream with:

     _ nohz: nohz full depends on irq work self IPI support
     _ x86: Tell irq work about self IPI support
     _ irq_work: Force raised irq work to run on irq work interrupt
     _ nohz: Move nohz full init call to tick init

These patches have been backported to stable as well.

I suspect Daniel rewinded far enough to fall on that old bug.

Daniel, did you see the above very stacktrace in latest upstream too? Or was it
a different one?
