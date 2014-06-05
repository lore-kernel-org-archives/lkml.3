Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaFEQfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:35:44 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:64458 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaFEQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <53909B50.50407@zytor.com>
References: <20140604224920.GB4126@pd.tnic> <538FB775.8070405@amacapital.net>
 <20140605071805.GA16647@pd.tnic> <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com>
 <20140605090206.GA16642@pd.tnic> <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com>
 <20140605155307.GD16642@pd.tnic> <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com>
 <20140605160842.GE16642@pd.tnic> <CALCETrUors-39hUxS9Bg-dh+DzMcmPOs=6t998sbCVjqXYgyug@mail.gmail.com>
 <20140605161834.GF16642@pd.tnic> <53909B50.50407@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 5 Jun 2014 09:35:21 -0700
Message-ID: <CALCETrVhN36asNbx40BTK8TU3eCLq36-hh-i1MKMw=iL=5_m0A@mail.gmail.com>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state in
 irq ctxt
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 9:31 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/05/2014 09:18 AM, Borislav Petkov wrote:
>> On Thu, Jun 05, 2014 at 09:14:51AM -0700, Andy Lutomirski wrote:
>>> Is this NMI pstore thing done from any context that's supposed to be
>>> recoverable? It's always safe to use the FPU and then panic :)
>>
>> Right :)
>>
>>> Anyway, if we're just talking about EFI, there's an easier solution:
>>> just preallocate a per-cpu FPU context for EFI and make the whole mess
>>> be local to the EFI code.  For crypto, that's not so good.
>>
>> This is probably something for Matt to decide but it sounds doable. If
>> I'd have to guess, sooner or later we will need to do proper FPU context
>> handling for EFI as I don't see anything stopping it from using FPU
>> insns. At least we won't. :-)
>>
>
> The bottom line is that we can't call EFI from a context where we can't
> use the FPU.  Or specifically, we can't then resume execution.  If all
> we're doing is stashing away some data before dying, well, then, by all
> means - but we need to make sure that is what actually happens.

I bet we have to be extra careful about EFI: I imagine that, if we
take an NMI or MCE while in EFI code, another call into EFI is a
terrible idea, which might be a good reason to have the EFI code track
its own context and prevent nesting.

>
> As far adding additional xstate save areas, the current size of the
> xstate is about ~2.5K for AVX-512 enabled processors, and we need one
> per thread.  If we make that two copies, then
> kernel_fpu_begin()..._end() would no longer have to disable preemption,
> but it wouldn't resolve the conflict about using the FPU from IRQ
> context when inside kernel_fpu_begin().._end().
>
> To support the FPU in IRQ context we end up having to create a percpu
> FPU state stack, and it becomes then a matter of how deep that stack
> would have to be.

I suppose it's a question of how valuable making a change like this
would be (two per-thread xstate areas plus a bunch per cpu, say).  I
doubt that the memory usage matters much, but writing and maintaining
it will be a mild PITA.  Maybe no worse than the current stuff.

What are the major users?  If it worked really well, we could enable
SSE for all kernel code, but at least all the crypto stuff would
benefit a lot.

--Andy
