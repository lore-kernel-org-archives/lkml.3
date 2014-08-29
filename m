Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaH2Itl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:49:41 -0400
Received: from queue01b.mail.zen.net.uk ([212.23.3.242]:47561 "EHLO
	queue01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaH2Itj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:49:39 -0400
Message-ID: <1409302042.1247.27.camel@computer5.home>
Subject: Re: [PATCH v5 1/3] ARM: probes: check stack operation when decoding
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Wang Nan <wangnan0@huawei.com>, "David A. Long" <dave.long@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pei Feiyue <peifeiyue@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 29 Aug 2014 09:47:22 +0100
In-Reply-To: <20140828102406.GH22580@arm.com>
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>
	 <1409144552-12751-2-git-send-email-wangnan0@huawei.com>
	 <53FEFB93.2010009@hitachi.com>
	 <20140828102021.GC30401@n2100.arm.linux.org.uk>
	 <20140828102406.GH22580@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-28 at 11:24 +0100, Will Deacon wrote:
> On Thu, Aug 28, 2014 at 11:20:21AM +0100, Russell King - ARM Linux wrote:
> > On Thu, Aug 28, 2014 at 06:51:15PM +0900, Masami Hiramatsu wrote:
> > > (2014/08/27 22:02), Wang Nan wrote:
> > > > This patch improves arm instruction decoder, allows it check whether an
> > > > instruction is a stack store operation. This information is important
> > > > for kprobe optimization.
> > > > 
> > > > For normal str instruction, this patch add a series of _SP_STACK
> > > > register indicator in the decoder to test the base and offset register
> > > > in ldr <Rt>, [<Rn>, <Rm>] against sp.
> > > > 
> > > > For stm instruction, it check sp register in instruction specific
> > > > decoder.
> > > 
> > > OK, reviewed. but since I'm not so sure about arm32 ISA,
> > > I need help from ARM32 maintainer to ack this.
> > 
> > What you actually need is an ack from the ARM kprobes people who
> > understand this code.  That would be much more meaningful than my
> > ack.  They're already on the Cc list.
> 
> Tixy, can you take a look please?

I'll take an in depth look on Monday as I'm currently on holiday, so for
now just some brief and possibly not well thought out comments...

- If the intent is to not optimise stack push operations, then this
actually excludes the main use of kprobes which I believe is to insert
probes at the start of functions (there's even a specific jprobes API
for that) this is because functions usually start by saving registers on
the stack.

- Crowbarring in special case testing for stack operations looks a bit
inelegant and not a sustainable way of doing this, what about the next
special case we need? However, stack push operations _are_ a general
special cases for instruction emulation so perhaps that's OK, and leads
me to...

- The current 'unoptimised' kprobes implementation allows for pushing on
the stack (see __und_svc and the unused (?) jprobe_return) but this is
just aimed at stm instructions, not things like "str r0, [sp, -imm]!"
that might be used to simultaneously save a register and reserve an
arbitrary amount of stack space. Probing such instructions could lead to
the kprobes code trashing the kernel stack.

-- 
Tixy


