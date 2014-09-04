Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaIDKlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:41:13 -0400
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:47622 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbaIDKlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:41:11 -0400
Message-ID: <1409827235.3008.46.camel@linaro1.home>
Subject: Re: [PATCH v5 3/3] kprobes: arm: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Wang Nan <wangnan0@huawei.com>, Russell King <linux@arm.linux.org.uk>,
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
Date: Thu, 04 Sep 2014 11:40:35 +0100
In-Reply-To: <20140903103044.GC32378@arm.com>
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>
	 <1409144552-12751-4-git-send-email-wangnan0@huawei.com>
	 <1409665784.2873.49.camel@linaro1.home> <5406EADC.8080009@hitachi.com>
	 <20140903103044.GC32378@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 11:30 +0100, Will Deacon wrote:
> On Wed, Sep 03, 2014 at 11:18:04AM +0100, Masami Hiramatsu wrote:
> > (2014/09/02 22:49), Jon Medhurst (Tixy) wrote:
> > > 1. On SMP systems it's very slow because of kprobe's use of stop_machine
> > > for applying and removing probes, this forces the system to idle and
> > > wait for the next scheduler tick for each probe change.
> > 
> > Hmm, agreed. It seems that arm32 limitation of self-modifying code on SMP.
> > I'm not sure how we can handle it, but I guess;
> >  - for some processors which have better coherent cache for SMP, we can
> >    atomically replace the breakpoint code with original code.
> 
> Except that it's not an architected breakpoint instruction, as I mentioned
> before. It's also not really a property of the cache.
> 
> >  - Even if we get an "undefined instruction" exception, its handler can
> >    ask kprobes if the address is under modifying or not. And if it is,
> >    we can just return from the exception to retry the execution.
> 
> It's not as simple as that -- you could potentially see an interleaving of
> the two instructions. The architecture is even broader than that:
> 
>  Concurrent modification and execution of instructions can lead to the
>  resulting instruction performing any behavior that can be achieved by
>  executing any sequence of instructions that can be executed from the
>  same Exception level,
> 
> There are additional guarantees for some instructions (like the architected
> BKPT instruction).

I should point out that the current implementation of kprobes doesn't
use stop_machine because it's trying to meet the above architecture
restrictions, and that arming kprobes (changing probed instruction to an
undefined instruction) isn't usually done under stop_machine, so other
CPUs could be executing the original instruction as it's being modified.

So, should we be making patch_text unconditionally use stop machine and
remove all direct use of __patch_text? (E.g. by jump labels.)

-- 
Tixy

