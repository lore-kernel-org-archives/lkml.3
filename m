Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBJKgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:36:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:46297 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbaBJKgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:36:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,817,1384329600"; 
   d="scan'208";a="472686267"
Date: Mon, 10 Feb 2014 12:43:13 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Bin Gao <bin.gao@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v4 1/2] x86, tsc: Fallback to normal calibration if fast
 MSR calibration fails
Message-ID: <20140210104313.GX18029@intel.com>
References: <1392027794-8643-1-git-send-email-mika.westerberg@linux.intel.com>
 <alpine.DEB.2.02.1402101131330.21991@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402101131330.21991@ionos.tec.linutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:32:23AM +0100, Thomas Gleixner wrote:
> On Mon, 10 Feb 2014, Mika Westerberg wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > If we cannot calibrate TSC via MSR based calibration
> > try_msr_calibrate_tsc() stores zero to fast_calibrate and returns that to
> > the caller. This value gets then propagated further to clockevents code
> > resulting division by zero oops like the one below:
> > 
> >  divide error: 0000 [#1] PREEMPT SMP
> >  Modules linked in:
> >  CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0+ #47
> >  task: ffff880075508000 ti: ffff880075506000 task.ti: ffff880075506000
> >  RIP: 0010:[<ffffffff810aec14>]  [<ffffffff810aec14>] clockevents_config.part.3+0x24/0xa0
> >  RSP: 0000:ffff880075507e58  EFLAGS: 00010246
> >  RAX: ffffffffffffffff RBX: ffff880079c0cd80 RCX: 0000000000000000
> >  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffffffffff
> >  RBP: ffff880075507e70 R08: 0000000000000001 R09: 00000000000000be
> >  R10: 00000000000000bd R11: 0000000000000003 R12: 000000000000b008
> >  R13: 0000000000000008 R14: 000000000000b010 R15: 0000000000000000
> >  FS:  0000000000000000(0000) GS:ffff880079c00000(0000) knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >  CR2: ffff880079fff000 CR3: 0000000001c0b000 CR4: 00000000001006f0
> >  Stack:
> >   ffff880079c0cd80 000000000000b008 0000000000000008 ffff880075507e88
> >   ffffffff810aecb0 ffff880079c0cd80 ffff880075507e98 ffffffff81030168
> >   ffff880075507ed8 ffffffff81d1104f 00000000000000c3 0000000000000000
> >  Call Trace:
> >   [<ffffffff810aecb0>] clockevents_config_and_register+0x20/0x30
> >   [<ffffffff81030168>] setup_APIC_timer+0xc8/0xd0
> >   [<ffffffff81d1104f>] setup_boot_APIC_clock+0x4cc/0x4d8
> >   [<ffffffff81d0f5de>] native_smp_prepare_cpus+0x3dd/0x3f0
> >   [<ffffffff81d02ee9>] kernel_init_freeable+0xc3/0x205
> >   [<ffffffff8177c910>] ? rest_init+0x90/0x90
> >   [<ffffffff8177c91e>] kernel_init+0xe/0x120
> >   [<ffffffff8178deec>] ret_from_fork+0x7c/0xb0
> >   [<ffffffff8177c910>] ? rest_init+0x90/0x90
> > 
> > Prevent this from happening by:
> >  1) Modifying try_msr_calibrate_tsc() to return calibration value or zero
> >     if it fails.
> >  2) Check this return value in native_calibrate_tsc() and in case of zero
> >     fallback to use normal non-MSR based calibration.
> > 
> > Reported-and-tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> > Thomas, I hope you don't mind that I added your SoB to the patch. It is
> > after all from you.
> 
> You just missed to add your own SOB which tells us that you conveyed
> the patch.

Ah, right. Here it is,

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Is that enough or do you want me to resend this patch? Thanks.
