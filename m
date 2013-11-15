Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3KOQhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:37:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56958 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053Ab3KOQhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:37:31 -0500
Date: Fri, 15 Nov 2013 16:37:18 +0000
From: Will Deacon <will.deacon@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
Message-ID: <20131115163718.GH19468@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
 <1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org>
 <20131108165639.GD15074@mudshark.cambridge.arm.com>
 <CA+b37P2Yt8Hb_fgtLfw56DO=ZGC0LxVkxJHftHdxa45HQTXJcQ@mail.gmail.com>
 <20131111112110.GD28302@mudshark.cambridge.arm.com>
 <CA+b37P1REzXJabkiNEc5Ji+n6p02PfuSdaPrb-k4P25kgfkLNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+b37P1REzXJabkiNEc5Ji+n6p02PfuSdaPrb-k4P25kgfkLNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:52:51AM +0000, Sandeepa Prabhu wrote:
> On 11 November 2013 16:51, Will Deacon <will.deacon@arm.com> wrote:
> > On Mon, Nov 11, 2013 at 05:35:37AM +0000, Sandeepa Prabhu wrote:
> >> On 8 November 2013 22:26, Will Deacon <will.deacon@arm.com> wrote:
> >> >> +#define MAX_INSN_SIZE                  2
> >> >
> >> > Why is this 2?
> >> Second entry is to hold NOP instruction, absence of it cause abort
> >> while instruction decode.
> >
> > Hmm, can you elaborate please? I'm not sure why you should get an abort
> > decoding kernel addresses.
> well, kprobes does not step from kernel address, but it prepares a
> allocated memory(executable),  copies the instruction and update the
> single step address (ELR) to enable stepping while ERET.
> So, don't we need NOP at next location after the instruction because
> next instruction will be in decode stage and might throw "undefined
> instruction" error?

You can't take speculative prefetch aborts like that, so unless you actually
go and *execute* garbage, you don't need that NOP. From the sounds of it, it's
not required, as long as you handle the step exception correctly.

> >> > NAK. Unmasking debug exceptions from within a debug exception is not safe.
> >> > I'd much rather we returned from handling this exception, then took whatever
> >> > other pending exception there was.
> >> well, kprobes needs recursive breakpoints to be handled, and I am not
> >> sure if this can be achieved other way than unmasking D-flag for a
> >> shorter duration where we can expect re-entry (I would check if this
> >> can be done without re-cursing)
> >> I want to understand why unmasking D-flag is unsafe here, kprobes make
> >> sure that recursion depth is only 2 (i.e. does not generate 3rd
> >> Breakpoint trap) and interrupts are kept masked while recursion/single
> >> stepping. Is it unsafe only if conflict with hardware breakpoint on
> >> same CPU?
> >
> > Is this recursion only to support setting kprobes on the kprobe
> > implementation? The problem is that the rest of the debug infrastructure is
> > not set up to deal with recursive exceptions, so allowing them can break
> > state machines maintained by code like hw_breakpoint.
> No, upon one kprobe hit for an address, the subsystem can call the
> user-defined handlers (pre- and -post) which can call same function
> again. Example, if we place kprobe on "printk" entry, and registered
> handler can invoke printk to print more info.

Hang on, I think I'm missing something here. If you run into a recursive
probe, you'll simply hit another BRK instruction, right? That should be
fine, since PSTATE.D doesn't mask software breakpoint exceptions. The
tricky part comes when you try to step over that guy, but you might be ok
if you clear PSTATE.D *only* while you step your single instruction that you
copied out to the buffer.

What do you think? I'd really like you to try testing something like:

  1. Place a hardware breakpoint in the kernel
  2. Place a kprobe on the same address
  3. Place a kprobe somewhere in the pre- hook for the kprobe placed in (2)

then check that (a) we manage to get through that lot without locking up and
(b) each probe/breakpoint is hit exactly once.

> This will make kprobe to trigger again and re-enter, so the kprobe
> subsystem need to handle the 2nd instance first, and then return back
> to previous execution. D-flag is enabled only the duration when the
> pre- and post- handler are called, so they they can recurse and handle
> single stepping, after that, D-flag is kept disabled.   I am yet to
> test the concurrency with hw_breakpoint, would update once I run these
> tests.

If you really want to support this, you need to do more than just clear the
D flag. Not only do you need to deal with hardware breakpoints, but also
things like scheduling... Assuming that the user-defined handlers can block,
then you run the risk of context-switching with the D-flag set, which
introduces a significant black-out period to kernel debugging. There are
also issues like returning to userspace with MDSCR_EL1.SS set because of a
context switch triggered by the pre- handler, resulting in a single-step
exception from userspace.

I reckon what I suggested above might work, but I'd like your input.

Will
