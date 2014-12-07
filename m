Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaLGSkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 13:40:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:25555 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbaLGSkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 13:40:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,534,1413270000"; 
   d="scan'208";a="620043303"
From: Robert Jarzmik <robert.jarzmik@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Robert Jarzmik <robert.jarzmik@intel.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Berthier\, Emmanuel" <emmanuel.berthier@intel.com>
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
	<87fvctnk7c.fsf@intel.com>
	<CALCETrXhfzd9Fkikvm5qj0LWgWtDzgdpY_0EC3ChwyyGZksTMw@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 07 Dec 2014 19:40:48 +0100
In-Reply-To: <CALCETrXhfzd9Fkikvm5qj0LWgWtDzgdpY_0EC3ChwyyGZksTMw@mail.gmail.com>
	(Andy Lutomirski's message of "Sat, 6 Dec 2014 07:07:25 -0800")
Message-ID: <87bnnfnw0f.fsf@intel.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Andy Lutomirski <luto@amacapital.net> writes:
> On Dec 6, 2014 2:31 AM, "Robert Jarzmik" <robert.jarzmik@intel.com> wrote:
>> We would have a "LBR resource" variable to track who owns the LBR :
>> - nobody : LBR_UNCLAIMED
>> - the exception handler : LBR_EXCEPTION_DEBUG_USAGE
>
> Which exception handler? There can be several on the stack.
All of them, ie. LBR is used by exception handlers, ie. perf cannot use it, just
as what Emmanuel's patch is doing I think. Or said differently LBR are reserved
for expeption handlers only, whichever have the implementation to use them.

>> - case 3d: kernel exception with a reschedule inside
>> -> exception entry
>> -> test lbr_dump_state == EXCEPTION_OWNED => true => STOP LBR
>> -> exception handling
>> -> context_switch()
>> -> perf cannot touch LBR, nobody can
>> -> test lbr_dump_state == EXCEPTION_OWNED => true => START LBR
>
> Careful. This is still the nested exception, and it just did the wrong thing.
Can you be more explicit about the "wrong" thing ? And would that wrong thing be
solved by a per-cpu reference counter ?

>> I might be very wrong in the description as I'm not that sharp on x86, but is
>> there a flaw in the above cases ?
>>
>> If not, a couple of tests and Thomas's per-cpu variable can solve the issue,
>> while keeping the exception handler code simple as Emmanual has proposed
> (given
>> the additionnal test inclusion - which will be designed to not pollute the
> LBR),
>> and having a small impact on perf to solve the resource acquire issue.
>
> On current kernels, percpu memory is vmalloced, so accessing it can fault, so
> you can't touch percpu memory at all from page_fault until the vmalloc fixup
> runs. Sorry :(
What about INIT_PER_CPU_VAR (as in gdt_page) ? Won't that be mapped all the time
without need for faulting in pages ?

> This is a problem with rdmsr, too.
You mean rdmsr can fault in a non-hypervisor environment ? Because that
definetely opens a new range of corner cases.

> It may be worth fixing that. In fact, it may be worth getting rid of lazy vmap
> entirely.
Your battle ? ;)

Anyway, would a static per-cpu variable (or variables, one about resources
usage, one reference counter) solve our cases (ie. 3d) ?

-- 
Robert
