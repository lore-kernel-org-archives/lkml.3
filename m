Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFEQjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:39:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52511 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbaFEQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:39:38 -0400
Date: Thu, 5 Jun 2014 18:37:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
Message-ID: <20140605163711.GG16642@pd.tnic>
References: <20140605071805.GA16647@pd.tnic>
 <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com>
 <20140605090206.GA16642@pd.tnic>
 <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com>
 <20140605155307.GD16642@pd.tnic>
 <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com>
 <20140605160842.GE16642@pd.tnic>
 <CALCETrUors-39hUxS9Bg-dh+DzMcmPOs=6t998sbCVjqXYgyug@mail.gmail.com>
 <20140605161834.GF16642@pd.tnic>
 <53909B50.50407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53909B50.50407@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 09:31:12AM -0700, H. Peter Anvin wrote:
> The bottom line is that we can't call EFI from a context where we can't
> use the FPU.  Or specifically, we can't then resume execution.

Can't we allocate a save-state area, stash the state there and let EFI
scribble over it? When EFI returns, we scribble over it back assuming it
has done the saving/restoring on its own.

> If all we're doing is stashing away some data before dying, well,
> then, by all means - but we need to make sure that is what actually
> happens.

Yeah, who knows, we might return. I'm thinking of a #MC here which is
serious enough to real exception, we do some handling and issue the
error info into pstore and continue execution. Purely hypothetical
though.

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

... if it all makes sense at all, of course.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
