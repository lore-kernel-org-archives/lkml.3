Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaIAR3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:29:48 -0400
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:46865 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498AbaIAR3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:29:47 -0400
Message-ID: <1409592574.2948.83.camel@linaro1.home>
Subject: Re: [PATCH v5 1/3] ARM: probes: check stack operation when decoding
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David A. Long" <dave.long@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pei Feiyue <peifeiyue@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 01 Sep 2014 18:29:34 +0100
In-Reply-To: <540128C5.6050101@huawei.com>
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>
		 <1409144552-12751-2-git-send-email-wangnan0@huawei.com>
		 <53FEFB93.2010009@hitachi.com>
		 <20140828102021.GC30401@n2100.arm.linux.org.uk>
		 <20140828102406.GH22580@arm.com> <1409302042.1247.27.camel@computer5.home>
	 <540128C5.6050101@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-08-30 at 09:28 +0800, Wang Nan wrote:
> On 2014/8/29 16:47, Jon Medhurst (Tixy) wrote:
> > On Thu, 2014-08-28 at 11:24 +0100, Will Deacon wrote:
> >> On Thu, Aug 28, 2014 at 11:20:21AM +0100, Russell King - ARM Linux wrote:
> >>> On Thu, Aug 28, 2014 at 06:51:15PM +0900, Masami Hiramatsu wrote:
> >>>> (2014/08/27 22:02), Wang Nan wrote:
> >>>>> This patch improves arm instruction decoder, allows it check whether an
> >>>>> instruction is a stack store operation. This information is important
> >>>>> for kprobe optimization.
> >>>>>
> >>>>> For normal str instruction, this patch add a series of _SP_STACK
> >>>>> register indicator in the decoder to test the base and offset register
> >>>>> in ldr <Rt>, [<Rn>, <Rm>] against sp.
> >>>>>
> >>>>> For stm instruction, it check sp register in instruction specific
> >>>>> decoder.
> >>>>
> >>>> OK, reviewed. but since I'm not so sure about arm32 ISA,
> >>>> I need help from ARM32 maintainer to ack this.
> >>>
> >>> What you actually need is an ack from the ARM kprobes people who
> >>> understand this code.  That would be much more meaningful than my
> >>> ack.  They're already on the Cc list.
> >>
> >> Tixy, can you take a look please?
> > 
> > I'll take an in depth look on Monday as I'm currently on holiday, so for
> > now just some brief and possibly not well thought out comments...
> > 
> > - If the intent is to not optimise stack push operations, then this
> > actually excludes the main use of kprobes which I believe is to insert
> > probes at the start of functions (there's even a specific jprobes API
> > for that) this is because functions usually start by saving registers on
> > the stack.
> 
> Agree. If the decoder can bring up more information, kprobeopt can dynamically
> compute the range of stack an instruction require, then adjust stack protection range.
> This need ARM decoder bring up more information. For example: for a "push {r4, r5}"
> instruction, decoder should report it is a stack store operation, require 8 bytes
> of stack, then when composing trampoline code, we can put registers at
> [sp, #-8]. Only instructions such as "str r0, [sp, r1]" should be prevented.
> 
> However, this need more improvement on decoder: all store operations should use
> a special decorer then. What do you think?

This doesn't work for the non-optimised kprobes case because, when a
probe is hit, we couldn't know what stack addresses to reserve until
we're several calls deep in the exception handler and possibly already
using those addresses. Anyway, perhaps we don't need to worry about
these instructions after all, more below...

> 
> > 
> > - Crowbarring in special case testing for stack operations looks a bit
> > inelegant and not a sustainable way of doing this, what about the next
> > special case we need? However, stack push operations _are_ a general
> > special cases for instruction emulation so perhaps that's OK, and leads
> > me to...
> > 
> > - The current 'unoptimised' kprobes implementation allows for pushing on
> > the stack (see __und_svc and the unused (?) jprobe_return) but this is
> > just aimed at stm instructions, not things like "str r0, [sp, -imm]!"
> > that might be used to simultaneously save a register and reserve an
> > arbitrary amount of stack space. Probing such instructions could lead to
> > the kprobes code trashing the kernel stack.
> 
> By a quick search I just find tow instructions matching "str.*\[sp,[^\]]*-[^4]",
> one in Ldiv0_64, another in Ldiv0, both are "str     lr, [sp, #-8]!". So I think
> such instructions are very special.

Yes, I built a multi_v7_defconfig kernel with GCC 4.9 and I too could
only find those occurrences of the problematic instructions, which come
human written assembler, so we probably aren't restricting any kprobes
users if we don't support probing of those types of str instructions.

That would just leave us to support stm instructions which push
registers onto the stack, and the optimised kprobes could take the same
approach as the unoptimised ones and just unconditionally reserve 64
bytes of stack on every probe (see __und_svc in entry-armv.S).

> Furthermore, I thought "unoptimised" kprobe use another stack, could you please
> explain how such probing trashing normal kernel stack?

No, unoptimised probes doesn't use another stack, they use the stack of
the current kernel task.

-- 
Tixy

