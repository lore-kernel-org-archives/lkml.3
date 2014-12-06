Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaLFKbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 05:31:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:2595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaLFKbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 05:31:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="494656146"
From: Robert Jarzmik <robert.jarzmik@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Berthier\, Emmanuel" <emmanuel.berthier@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, "Jarzmik\, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
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
	<65CD3FC07F3BF942ABE211646D72D770356ED34A@IRSMSX110.ger.corp.intel.com>
	<CALCETrWr=6BnQ7r4KYDVJzeNPO-pxk9wRmkkLy+mM1T_85Y=jw@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 06 Dec 2014 11:31:19 +0100
In-Reply-To: <CALCETrWr=6BnQ7r4KYDVJzeNPO-pxk9wRmkkLy+mM1T_85Y=jw@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 4 Dec 2014 10:09:53 -0800")
Message-ID: <87fvctnk7c.fsf@intel.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> I don't really care about the number of instructions.
Right, a couple of test/jz/jnz is negligible in the exception path, that's what
I also think.

>  But there are still all the nasty cases:
>
>  - Context switch during exception processing (both in the C handler
> and in the retint code).
>  - PMI during exception processing.
>  - Exception while perf is poking at LBR msrs.

Yes.
Wasn't that what Thomas's suggestion on the per-cpu variable was solving ?
Ie:
        DEFINE_PER_CPU(unsigned long, lbr_dump_state) = LBR_OOPS_DISABLED;
        ...

We would have a "LBR resource" variable to track who owns the LBR :
 - nobody : LBR_UNCLAIMED
 - the exception handler : LBR_EXCEPTION_DEBUG_USAGE
   - activated with a runtime variable or config
   - impossible to activate if perf has hold of it
 - the perf code : LBR_PERF_USAGE
   - activated through perf infrastructure
   - impossible to activated if exception handler has hold of it

Now this solves the perf/exception concurrency on the LBR registers. If there is
a rescheduling during the exception, or a PMI, can that have an impact ?
 - case 1: nobody is handling LBR
   => no impact, expception handlers won't touch LBR
 - case 2: perf is handling LBR
   => no imppact, exception handler won't touch LBR

 - case 3: exception handlers are handling LBR

   - case 3a: simple user exception
       -> exception entry
       -> is kernel exception == false => bypass LBR handling
       -> exception handling

   - case 3b: simple kernel exception
       -> exception entry
       -> test lbr_dump_state == EXCEPTION_OWNED => true => STOP LBR
       -> no reschedule, no PMI
       -> exception handling
       -> test lbr_dump_state == EXCEPTION_OWNED => true => START LBR

   - case 3c: kernel exception with PMI
       -> exception entry
       -> test lbr_dump_state == EXCEPTION_OWNED => true => STOP LBR
       -> PMI
          can't touch LBR, as lbr_dump_state == EXCEPTION_OWNED
       -> exception handling
       -> test lbr_dump_state == EXCEPTION_OWNED => true => START LBR

   - case 3d: kernel exception with a reschedule inside
       -> exception entry
       -> test lbr_dump_state == EXCEPTION_OWNED => true => STOP LBR
       -> exception handling
       -> context_switch()
          -> perf cannot touch LBR, nobody can
       -> test lbr_dump_state == EXCEPTION_OWNED => true => START LBR

I might be very wrong in the description as I'm not that sharp on x86, but is
there a flaw in the above cases ?

If not, a couple of tests and Thomas's per-cpu variable can solve the issue,
while keeping the exception handler code simple as Emmanual has proposed (given
the additionnal test inclusion - which will be designed to not pollute the LBR),
and having a small impact on perf to solve the resource acquire issue.

Cheers.

--
Robert
