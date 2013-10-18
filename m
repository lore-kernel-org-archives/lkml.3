Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3JRKCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:02:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37152 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab3JRKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:02:54 -0400
Date: Fri, 18 Oct 2013 11:02:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Jiang Liu (Gerry)" <jiang.liu@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jiang Liu <liuj97@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] arm64, jump label: optimize jump label
 implementation
Message-ID: <20131018100205.GC2858@mudshark.cambridge.arm.com>
References: <1381893492-7135-1-git-send-email-liuj97@gmail.com>
 <1381893492-7135-7-git-send-email-liuj97@gmail.com>
 <20131016114608.GH5403@mudshark.cambridge.arm.com>
 <525EC8D1.7000900@gmail.com>
 <20131017093944.GB18765@mudshark.cambridge.arm.com>
 <525FF6E0.7070000@gmail.com>
 <20131017112713.2638910f@gandalf.local.home>
 <5260AB8A.2060505@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5260AB8A.2060505@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Fri, Oct 18, 2013 at 04:31:22AM +0100, Jiang Liu (Gerry) wrote:
> On 2013/10/17 23:27, Steven Rostedt wrote:
> > On Thu, 17 Oct 2013 22:40:32 +0800
> > Jiang Liu <liuj97@gmail.com> wrote:
> >
> >
> >>>>> You could make the code more concise by limiting your patching ability to
> >>>>> branch immediates. Then a nop is simply a branch to the next instruction (I
> >>>>> doubt any modern CPUs will choke on this, whereas the architecture requires
> >>>>> a NOP to take time).
> >>>> I guess a NOP should be more effecient than a "B #4" on real CPUs:)
> >>>
> >>> Well, I was actually questioning that. A NOP *has* to take time (the
> >>> architecture prevents implementations from discaring it) whereas a static,
> >>> unconditional branch will likely be discarded early on by CPUs with even
> >>> simple branch prediction logic.
> >> I naively thought "NOP" is cheaper than a "B" :(
> >> Will use a "B #1" to replace "NOP".
> >>
> >
> > Really?? What's the purpose of a NOP then? It seems to me that an
> > architecture is broken if a NOP is slower than a static branch.

Cheers for making me double-check this: it turns out I was mixing up my
architecture and micro-architecture. The architecture actually states:

  `The timing effects of including a NOP instruction in a program are not
   guaranteed. It can increase execution time, leave it unchanged, or even
   reduce it. Therefore, NOP instructions are not suitable for timing loops.'

however I know of at least one micro-architecture where a NOP is actually
more expensive than some other instructions, hence my original concerns.

> 	I have discussed this with one of our chip design members.
> He thinks "NOP" should be better than "B #1" because jump instruction
> is one of the most complex instructions for microarchitecture, which
> may stall the pipeline. And NOP should be friendly enough for all
> microarchitectures. So I will keep the "NOP" version.

Fine by me, we can't please all micro-architectures and NOP probably makes
more sense. However, I would rather you rework your aarch64_insn_gen_nop
function to actually generate hint instructions (since NOP is a hint alias
in AArch64), where you specify the alias as a parameter.

In other news, the GCC guys have started pushing a patch to add the %c
output template to the AArch64 backend:

  http://gcc.gnu.org/ml/gcc-patches/2013-10/msg01314.html

Cheers, and sorry for the earlier confusion,

Will
