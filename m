Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbaLBTil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:38:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:63308 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933669AbaLBT0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,502,1413270000"; 
   d="scan'208";a="631549875"
From: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] [LBR] Dump LBRs on Exception
Thread-Topic: [PATCH v2] [LBR] Dump LBRs on Exception
Thread-Index: AQHQClAp6CYIYedu6ESpcFdbEVpmDZx0+/cAgAAJTYCAAK9oAIAAcvIAgATcELA=
Date: Tue, 2 Dec 2014 19:09:40 +0000
Message-ID: <65CD3FC07F3BF942ABE211646D72D770356EC658@IRSMSX110.ger.corp.intel.com>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411271609510.3961@nanos>
 <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com>
 <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com>
In-Reply-To: <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB2JcmIe019525

> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Friday, November 28, 2014 4:15 PM
> To: Berthier, Emmanuel
> Cc: Thomas Gleixner; H. Peter Anvin; X86 ML; Jarzmik, Robert; LKML
> Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
> 
> On Fri, Nov 28, 2014 at 12:44 AM, Berthier, Emmanuel
> <emmanuel.berthier@intel.com> wrote:
> >  diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index df088bb..f39cded 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1035,6 +1035,46 @@ apicinterrupt IRQ_WORK_VECTOR \
> >         irq_work_interrupt smp_irq_work_interrupt  #endif
> >
> > +.macro STOP_LBR
> > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> > +       testl $3,CS+8(%rsp)             /* Kernel Space? */
> > +       jz 1f
> > +       testl $1, lbr_dump_on_exception
> 
> Is there a guarantee that, if lbr_dump_on_exception is true, then LBR is on?
> What happens if you schedule between stopping and resuming LBR?

Good point. The current assumption is to rely on the numerous exceptions to "re-arm" the LBR recording.
Even if we bypass UserSpace page faults, we can keep rely on kernel VMalloc page faults to re-arm the recording.

> > +       jz 1f
> > +       push %rax
> > +       push %rcx
> > +       push %rdx
> > +       movl $MSR_IA32_DEBUGCTLMSR, %ecx
> > +       rdmsr
> > +       and $~1, %eax                   /* Disable LBR recording */
> > +       wrmsr
> 
> wrmsr is rather slow.  Have you checked whether this is faster than just
> saving the LBR trace on exception entry?

The figures I have show that for common MSR, rdmsr and wrmsr have quite the same impact, around 100 cycles (greatly depends on the arch).
The cost of stop/start is: 2 rdmsr + 2 wrmsr = 4 msr
The cost of reading LBR is: 1 rdmsr for TOS + 2 rdmsr per record, and there are from 8 to 32 Records (Arch specific) = between 17 to 65 msr.
I've measured on Atom arch (8 records): LBR read versus stop/start: around x3 more time.
As the LBR size is arch dependent, it's not easy to implement the record reading in ASM without any branch, and this would generate maintenance dependency.
I prefer to let perf_event_lbr dealing with all that stuff.

Thx,

Emmanuel.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
