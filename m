Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaA1L5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 06:57:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:38684 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbaA1L5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 06:57:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,735,1384329600"; 
   d="scan'208";a="445758209"
Date: Tue, 28 Jan 2014 14:04:07 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Bin Gao <bin.gao@intel.com>
Subject: Re: [PATCH v2] x86, tsc: Add missing Baytrail frequency to the table
Message-ID: <20140128120407.GB18029@intel.com>
References: <20140123150912.7ee822a0@alan.etchedpixels.co.uk>
 <1390553196-15346-1-git-send-email-mika.westerberg@linux.intel.com>
 <4460FA1017EA3844B646E90DA4E984057D5A4E9F@ORSMSX103.amr.corp.intel.com>
 <20140125090923.GA106810@bin.fm.intel.com>
 <20140127102002.GT18029@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127102002.GT18029@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 12:20:02PM +0200, Mika Westerberg wrote:
> On Sat, Jan 25, 2014 at 01:09:23AM -0800, Bin Gao wrote:
> > > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c index a3acbac2ee72$
> > > --- a/arch/x86/kernel/tsc.c
> > > +++ b/arch/x86/kernel/tsc.c
> > > @@ -655,10 +655,11 @@ unsigned long native_calibrate_tsc(void)
> > >       local_irq_save(flags);
> > >       i = try_msr_calibrate_tsc(&fast_calibrate);
> > >       local_irq_restore(flags);
> > > -     if (i >= 0) {
> > > -             if (i == 0)
> > > -                     pr_warn("Fast TSC calibration using MSR failed\n");
> > > +     if (i > 0) {
> > >               return fast_calibrate;
> > > +     } else if (i == 0) {
> > > +             pr_warn("Fast TSC calibration using MSR failed\n");
> > > +             /* Continue with the normal calibration */
> > >       }
> > >
> > >       local_irq_save(flags);
> > 
> > The original design is to avoid trying PIC because touching PIC on
> > a non-PIC SoC will simply cause system hang. Returning 0 will cause
> > kernel to mark TSC unstable(rating 0). Since PM timer and HPET are
> > typically not available on non-PIC SoC, kernal falls back to jiffies
> > as clock source. Developers will start looking into the TSC clibrating
> > failure once they notice the jiffies clock source.
> > 
> > >[<ffffffff810aecb0>] clockevents_config_and_register+0x20/0x30
> > >[<ffffffff81030168>] setup_APIC_timer+0xc8/0xd0
> > >[<ffffffff81d1104f>] setup_boot_APIC_clock+0x4cc/0x4d8
> > >[<ffffffff81d0f5de>] native_smp_prepare_cpus+0x3dd/0x3f0
> > >[<ffffffff81d02ee9>] kernel_init_freeable+0xc3/0x205
> > >[<ffffffff8177c910>] ? rest_init+0x90/0x90
> > >[<ffffffff8177c91e>] kernel_init+0xe/0x120
> > >[<ffffffff8178deec>] ret_from_fork+0x7c/0xb0
> > >[<ffffffff8177c910>] ? rest_init+0x90/0x90
> > 
> > This is because kernel is trying to use tsc-deadline mode for lapic
> > timer. I think the right fix is to unset X86_FEATURE_TSC_DEADLINE_TIMER
> > when try_msr_calibrate_tsc() returns 0.
> 
> You are right, that works too:
> 
> [    0.000000] Resolved frequency ID: 0, frequency: 0 KHz
> [    0.000000] tsc: Fast TSC calibration using MSR failed
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 1833.334 MHz processor
> 
> If there are no objections, I can send a new version of the patch with this
> fixed.

Actually it does not work. I had the fallback path still in the patch when
I tried.

If I clear X86_FEATURE_TSC_DEADLINE_TIMER like you suggested, I get this:

[    0.093333] ------------[ cut here ]------------
[    0.096666] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/apic/apic.c:1397 setup_local_APIC+0x27c/0x330()
[    0.099999] Modules linked in:
[    0.103333] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0+ #115
[    0.106666]  0000000000000009 ffff880075507e40 ffffffff817953a1 0000000000000000
[    0.113333]  ffff880075507e78 ffffffff810473ed 0000000000000000 00000000000000f0
[    0.123333]  0000000000000000 00000000ffffffff 0000000000000001 ffff880075507e88
[    0.129999] Call Trace:
[    0.133333]  [<ffffffff817953a1>] dump_stack+0x4f/0x7b
[    0.136666]  [<ffffffff810473ed>] warn_slowpath_common+0x7d/0xa0
[    0.139999]  [<ffffffff810474ca>] warn_slowpath_null+0x1a/0x20
[    0.143333]  [<ffffffff8103102c>] setup_local_APIC+0x27c/0x330
[    0.146666]  [<ffffffff81d1053a>] native_smp_prepare_cpus+0x32e/0x3f0
[    0.149999]  [<ffffffff81d03ef0>] kernel_init_freeable+0xc3/0x205
[    0.153333]  [<ffffffff8178d100>] ? rest_init+0x90/0x90
[    0.156666]  [<ffffffff8178d10e>] kernel_init+0xe/0x120
[    0.159999]  [<ffffffff8179e4ec>] ret_from_fork+0x7c/0xb0
[    0.163333]  [<ffffffff8178d100>] ? rest_init+0x90/0x90
[    0.166666] ---[ end trace 0e1b24064a81bb0a ]---
[    0.173333] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.209999] smpboot: CPU0: Intel(R) Celeron(R) CPU  N2930  @ 1.83GHz (fam: 06, model: 37, stepping: 08)
[    0.216666] divide error: 0000 [#1] PREEMPT SMP 
[    0.216666] Modules linked in:
[    0.216666] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0+ #115
[    0.216666] task: ffff880075508000 ti: ffff880075506000 task.ti: ffff880075506000
[    0.216666] RIP: 0010:[<ffffffff810aebe4>]  [<ffffffff810aebe4>] clockevents_config.part.3+0x24/0xa0
[    0.216666] RSP: 0000:ffff880075507e58  EFLAGS: 00010246
[    0.216666] RAX: ffffffffffffffff RBX: ffff880079c0cd80 RCX: 0000000000000000
[    0.216666] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffffffffff
[    0.216666] RBP: ffff880075507e70 R08: 0000000000000001 R09: 00000000000000be
[    0.216666] R10: 00000000000000bd R11: 0000000000000003 R12: 000000000000b008
[    0.216666] R13: 0000000000000008 R14: 000000000000b010 R15: 0000000000000000
[    0.216666] FS:  0000000000000000(0000) GS:ffff880079c00000(0000) knlGS:0000000000000000
[    0.216666] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.216666] CR2: ffff880079fff000 CR3: 0000000001c0b000 CR4: 00000000001006f0
[    0.216666] Stack:
[    0.216666]  ffff880079c0cd80 000000000000b008 0000000000000008 ffff880075507e88
[    0.216666]  ffffffff810aec80 ffff880079c0cd80 ffff880075507e98 ffffffff81030168
[    0.216666]  ffff880075507ed8 ffffffff81d1205a 00000000000000c5 0000000000000000
[    0.216666] Call Trace:
[    0.216666]  [<ffffffff810aec80>] clockevents_config_and_register+0x20/0x30
[    0.216666]  [<ffffffff81030168>] setup_APIC_timer+0xc8/0xd0
[    0.216666]  [<ffffffff81d1205a>] setup_boot_APIC_clock+0x4cc/0x4d8
[    0.216666]  [<ffffffff81d105e9>] native_smp_prepare_cpus+0x3dd/0x3f0
[    0.216666]  [<ffffffff81d03ef0>] kernel_init_freeable+0xc3/0x205
[    0.216666]  [<ffffffff8178d100>] ? rest_init+0x90/0x90
[    0.216666]  [<ffffffff8178d10e>] kernel_init+0xe/0x120
[    0.216666]  [<ffffffff8179e4ec>] ret_from_fork+0x7c/0xb0
[    0.216666]  [<ffffffff8178d100>] ? rest_init+0x90/0x90
[    0.216666] Code: c3 66 0f 1f 44 00 00 0f 1f 44 00 00 55 31 d2 89 f1 48 89 e5 41 55 89 f6 41 54 41 b8 01 00 00 00 53 48 89 fb 48 8b 7f 70 48 89 f8 <48> f7 f6 48 85 c0 74 0b 48 3d 58 02 00 00 41 89 c0 77 51 4c 8d 
[    0.216666] RIP  [<ffffffff810aebe4>] clockevents_config.part.3+0x24/0xa0
[    0.216666]  RSP <ffff880075507e58>
[    0.219999] ---[ end trace 0e1b24064a81bb0b ]---

