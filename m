Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3KVTh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:37:56 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54697 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755657Ab3KVThy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:37:54 -0500
Date: Fri, 22 Nov 2013 19:37:13 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <anurag19aggarwal@gmail.com>
Cc: naveen.sel@samsung.com, "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        narendra.m1@samsung.com, nico@linaro.org,
        Anurag Aggarwal <a.anurag@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpgs@samsung.com, naveenkrishna.ch@gmail.com, rajat.suri@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        mohammad.a2@samsung.com
Subject: Re: [PATCH] ARM: unwinder: Handle Stackoverflow in unwind_exec_insn
Message-ID: <20131122193703.GA2286@e103592.cambridge.arm.com>
References: <1383731448-847-1-git-send-email-a.anurag@samsung.com>
 <20131108132119.GB2602@localhost.localdomain>
 <CAPoNrtuuHOB5d+vo-wGJ=5JQG=K0ZdaAv2Nyfxnit=WAWzXegg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPoNrtuuHOB5d+vo-wGJ=5JQG=K0ZdaAv2Nyfxnit=WAWzXegg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 12:28:57PM +0530, Anurag Aggarwal wrote:
> Thanks for your input Dave,
> 
> I think there is another way to avoid the stack overflow and reduce
> the number of checks also,
> 
> Stack overflow will cause a problem only when we are backtracking the
> last set of registers.
> i.e when the difference between current SP and top of stack is less
> than or equal to number of registers

Apologies, it looks like I failed to respond to this earlier...


Although that will usually be correct, there is no rule in the ABI to
guarantee it.

> we can create two unwind_exec_insn, one without checks and one with checks.
> 
> then we call the correct function from unwind_frame depending on the
> difference of SP and top of stack.
> 
> This will reduce the amount of checks every time we read a set of
> registers from stack

That sounds like it might duplicate a lot of code, to optimise based on
assumptions that may not always be true, for what really should not be a
hot path in the kernel.

If you can find a tidy way of doing it, it would be certainly worth
reviewing, but I still think it would be simpler just to do a simple
bounds check for every word read from the stack -- it should be
impossible for that to go wrong, even if some of the bounds checks
are not stictly required.

Cheers
---Dave
