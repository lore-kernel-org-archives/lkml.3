Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaLDQCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:02:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:1976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbaLDQCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:02:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="493633375"
From: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
To: "'Andy Lutomirski'" <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] [LBR] Dump LBRs on Exception
Thread-Topic: [PATCH v2] [LBR] Dump LBRs on Exception
Thread-Index: AQHQClAp6CYIYedu6ESpcFdbEVpmDZx0+/cAgAAJTYCAAK9oAIAAcvIAgATcELCAAbVxAIAABnsAgAAERoCAAWYk4IAAIFGAgAD8k9A=
Date: Thu, 4 Dec 2014 16:01:03 +0000
Message-ID: <65CD3FC07F3BF942ABE211646D72D770356ED34A@IRSMSX110.ger.corp.intel.com>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411271609510.3961@nanos>
 <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com>
 <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EC658@IRSMSX110.ger.corp.intel.com>
 <CALCETrWxXm_Cvu+3dakCFX1GSN2KcaoxC+qbTr8Z7ha2CtEEXw@mail.gmail.com>
 <alpine.DEB.2.11.1412022044410.16275@nanos>
 <CALCETrW1hsmUrrG9KzfAujFuGcF1g1b8m++hJkxSGxketobUHw@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356ECDFD@IRSMSX110.ger.corp.intel.com>
 <CALCETrVk6XiFeAPKU4bM_ZFFSRmQQvDS=Ascs17qcRM3503ETQ@mail.gmail.com>
In-Reply-To: <CALCETrVk6XiFeAPKU4bM_ZFFSRmQQvDS=Ascs17qcRM3503ETQ@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB4G2RSl002817

> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Wednesday, December 3, 2014 8:30 PM
> To: Berthier, Emmanuel
> Cc: Thomas Gleixner; H. Peter Anvin; X86 ML; Jarzmik, Robert; LKML
> Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
> > The final patch will bypass the new code in case of UserSpace page fault, so
> performance impact will be very low.
> > LBRs copy takes much more time than LBR stop/start.
> >
> > The simple is the better:
> >
> > .macro STOP_LBR
> > #ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> >         testl $3,CS(%rsp)               /* Kernel Space? */
> >         jnz 1f
> >         testl $3, PER_CPU_VAR(lbr_dump_state) /* Disabled? */
> >         jnz 1f
> 
> But that just wasted two of your LBR slots.

No: false test does not generate Branch record, ex:

  Last Branch Records:
    to: [<ffffffff828122a0>] page_fault+0x0/0x90
  from: [<ffffffff823c0e06>] sysrq_handle_crash+0x16/0x20
    to: [<ffffffff823c0df0>] sysrq_handle_crash+0x0/0x20
  from: [<ffffffff823c156c>] __handle_sysrq+0x9c/0x170
    to: [<ffffffff823c1562>] __handle_sysrq+0x92/0x170

> >         push %rax
> >         push %rcx
> >         push %rdx
> >         movl $MSR_IA32_DEBUGCTLMSR, %ecx
> >         rdmsr
> >         and $~1, %eax   /* Disable LBR recording */
> >         wrmsr
> >         pop %rdx
> >         pop %rcx
> >         pop %rax
> 
> And the general problem with this approach (even ignoring the performance
> hit, and kernel faults on user addresses really do happen in real workloads) is
> that you're not saving and restoring MSR_IA32_DEBUGCTL. 
> It may be that
> the rest of your patch does whatever magic is needed to make this work, but
> from just this code it's not at all obvious that this is correct.

The algorithm is quite simple:
When I enter in Exception handler, I stop LBR recording, and dump its content later if needed.
When I leave Exception Handler, I restart LBR recording.
So, after the first exception, LBR in On.
In case of nested Exceptions and crash, you're right, LBR will probably not be relevant.
But your proposal does not solve this issue: If we save registers during 1rst exception, and then overwrite them during 2nd level,
we will lose relevant info if crash is due to the 1rst exception.

> Hence my suggestion for rdmsr -- if you're willing to enable this and take the
> performance hit, you can simplify it a lot and save some branch slots by
> unconditionally doing the rdmsrs if you've enabled the LBR tracing IDT entry.
> The simplification from using rdmsr isn't that the save code is simplified -- it's
> that there's no state change on exception entry, so you don't need to worry
> about restoring state correctly on the way out or during a context switch.
> And you can enable/disable the whole thing just by writing to the IDT, so
> there's no performance hit at all in the disabled case.

Concerning performances: if it's really matter, the better is to disable the CONFIG switch.
But if we enable it, it's for using it I guess, and in that case, bypassing UserSpace page faults is better.
You're proposal of "unconditionally doing the rdmsrs" is not good in that case.
The only small gain is when CONFIG is enable and feature is disabled by cmdline:
- with my proposal, we get 1 test and 1 jmp more (if I switch Kernel test with LBR state test): for an exception treatment, does it really matter?

We can mix our proposals: keep my STOP/START code, and replace the dynamic disabling test by IDT change.
I hope the code will stay readable.
Do we really want to save 2 instructions?

Thanks,

Emmanuel.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
