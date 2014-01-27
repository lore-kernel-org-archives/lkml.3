Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaA0KNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:13:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:12469 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaA0KND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:13:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,728,1384329600"; 
   d="scan'208";a="473004502"
Date: Mon, 27 Jan 2014 12:20:02 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Bin Gao <bin.gao@intel.com>
Subject: Re: [PATCH v2] x86, tsc: Add missing Baytrail frequency to the table
Message-ID: <20140127102002.GT18029@intel.com>
References: <20140123150912.7ee822a0@alan.etchedpixels.co.uk>
 <1390553196-15346-1-git-send-email-mika.westerberg@linux.intel.com>
 <4460FA1017EA3844B646E90DA4E984057D5A4E9F@ORSMSX103.amr.corp.intel.com>
 <20140125090923.GA106810@bin.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125090923.GA106810@bin.fm.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 01:09:23AM -0800, Bin Gao wrote:
> > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c index a3acbac2ee72$
> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -655,10 +655,11 @@ unsigned long native_calibrate_tsc(void)
> >       local_irq_save(flags);
> >       i = try_msr_calibrate_tsc(&fast_calibrate);
> >       local_irq_restore(flags);
> > -     if (i >= 0) {
> > -             if (i == 0)
> > -                     pr_warn("Fast TSC calibration using MSR failed\n");
> > +     if (i > 0) {
> >               return fast_calibrate;
> > +     } else if (i == 0) {
> > +             pr_warn("Fast TSC calibration using MSR failed\n");
> > +             /* Continue with the normal calibration */
> >       }
> >
> >       local_irq_save(flags);
> 
> The original design is to avoid trying PIC because touching PIC on
> a non-PIC SoC will simply cause system hang. Returning 0 will cause
> kernel to mark TSC unstable(rating 0). Since PM timer and HPET are
> typically not available on non-PIC SoC, kernal falls back to jiffies
> as clock source. Developers will start looking into the TSC clibrating
> failure once they notice the jiffies clock source.
> 
> >[<ffffffff810aecb0>] clockevents_config_and_register+0x20/0x30
> >[<ffffffff81030168>] setup_APIC_timer+0xc8/0xd0
> >[<ffffffff81d1104f>] setup_boot_APIC_clock+0x4cc/0x4d8
> >[<ffffffff81d0f5de>] native_smp_prepare_cpus+0x3dd/0x3f0
> >[<ffffffff81d02ee9>] kernel_init_freeable+0xc3/0x205
> >[<ffffffff8177c910>] ? rest_init+0x90/0x90
> >[<ffffffff8177c91e>] kernel_init+0xe/0x120
> >[<ffffffff8178deec>] ret_from_fork+0x7c/0xb0
> >[<ffffffff8177c910>] ? rest_init+0x90/0x90
> 
> This is because kernel is trying to use tsc-deadline mode for lapic
> timer. I think the right fix is to unset X86_FEATURE_TSC_DEADLINE_TIMER
> when try_msr_calibrate_tsc() returns 0.

You are right, that works too:

[    0.000000] Resolved frequency ID: 0, frequency: 0 KHz
[    0.000000] tsc: Fast TSC calibration using MSR failed
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1833.334 MHz processor

If there are no objections, I can send a new version of the patch with this
fixed.
