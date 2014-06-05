Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaFEQbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:31:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50303 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaFEQbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:31:48 -0400
Message-ID: <53909B50.50407@zytor.com>
Date: Thu, 05 Jun 2014 09:31:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>
CC: Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
References: <20140604224920.GB4126@pd.tnic> <538FB775.8070405@amacapital.net> <20140605071805.GA16647@pd.tnic> <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com> <20140605090206.GA16642@pd.tnic> <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com> <20140605155307.GD16642@pd.tnic> <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com> <20140605160842.GE16642@pd.tnic> <CALCETrUors-39hUxS9Bg-dh+DzMcmPOs=6t998sbCVjqXYgyug@mail.gmail.com> <20140605161834.GF16642@pd.tnic>
In-Reply-To: <20140605161834.GF16642@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 09:18 AM, Borislav Petkov wrote:
> On Thu, Jun 05, 2014 at 09:14:51AM -0700, Andy Lutomirski wrote:
>> Is this NMI pstore thing done from any context that's supposed to be
>> recoverable? It's always safe to use the FPU and then panic :)
> 
> Right :)
> 
>> Anyway, if we're just talking about EFI, there's an easier solution:
>> just preallocate a per-cpu FPU context for EFI and make the whole mess
>> be local to the EFI code.  For crypto, that's not so good.
> 
> This is probably something for Matt to decide but it sounds doable. If
> I'd have to guess, sooner or later we will need to do proper FPU context
> handling for EFI as I don't see anything stopping it from using FPU
> insns. At least we won't. :-)
> 

The bottom line is that we can't call EFI from a context where we can't
use the FPU.  Or specifically, we can't then resume execution.  If all
we're doing is stashing away some data before dying, well, then, by all
means - but we need to make sure that is what actually happens.

As far adding additional xstate save areas, the current size of the
xstate is about ~2.5K for AVX-512 enabled processors, and we need one
per thread.  If we make that two copies, then
kernel_fpu_begin()..._end() would no longer have to disable preemption,
but it wouldn't resolve the conflict about using the FPU from IRQ
context when inside kernel_fpu_begin().._end().

To support the FPU in IRQ context we end up having to create a percpu
FPU state stack, and it becomes then a matter of how deep that stack
would have to be.

	-hpa

