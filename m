Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbaLBUMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:12:34 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:65352 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904AbaLBUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:12:31 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412022044410.16275@nanos>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411271609510.3961@nanos> <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com>
 <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EC658@IRSMSX110.ger.corp.intel.com>
 <CALCETrWxXm_Cvu+3dakCFX1GSN2KcaoxC+qbTr8Z7ha2CtEEXw@mail.gmail.com> <alpine.DEB.2.11.1412022044410.16275@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 2 Dec 2014 12:12:09 -0800
Message-ID: <CALCETrW1hsmUrrG9KzfAujFuGcF1g1b8m++hJkxSGxketobUHw@mail.gmail.com>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 11:56 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 2 Dec 2014, Andy Lutomirski wrote:
>> TBH, I'm wondering whether this is actually a good idea.  It might be
>> more valuable and less scary to try to make this work for BUG instead.
>> To get the most impact, it might be worth allocating a new exception
>> vector for BUG and using 'int 0xwhatever', and the prologue to that
>> could read out all the MSRs without any branches.
>
> BUG is pretty uninteresting. We usually know how we got there. Now
> where LBR might be useful is if you have stack corruption and branch
> into nirvana or access random crap via a few hoops. There the LBR data
> might help, because the corrupted stack does not tell anything.
>
> So yes, this is a corner case debugging scenario, but given the
> complexity of coordination with perf and the possible intrusiveness in
> the low level entry path, we really need to see a few real world
> examples where this helps, aside of the constructed case.
>

One option would be to treat this as the debugging feature that it is.

Don't change the exception entry code at all.  Instead add a run-time
switch that will ask perf to set up the LBR stuff appropriately and
will change the IDT entries to stubs that first use rdmsr to copy all
the LBRs to some per-cpu, per-vector area and then jump to the real
entry point.

Yes, performance will suck, and there will be some artifacts if the
exception nests inside itself before reporting the error (which can
happen for page faults, I think), but this isn't the end of the world
if it's an opt-in feature.

And the whole pile of rdmsrs can be generated at run-time to match the
running CPU.

--Andy

> Thanks,
>
>         tglx



-- 
Andy Lutomirski
AMA Capital Management, LLC
