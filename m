Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbaICKcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:32:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33478 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756011AbaICKcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:32:14 -0400
Date: Wed, 3 Sep 2014 11:30:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>, Wang Nan <wangnan0@huawei.com>,
        Russell King <linux@arm.linux.org.uk>,
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
Subject: Re: [PATCH v5 3/3] kprobes: arm: enable OPTPROBES for ARM 32
Message-ID: <20140903103044.GC32378@arm.com>
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>
 <1409144552-12751-4-git-send-email-wangnan0@huawei.com>
 <1409665784.2873.49.camel@linaro1.home>
 <5406EADC.8080009@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5406EADC.8080009@hitachi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 11:18:04AM +0100, Masami Hiramatsu wrote:
> (2014/09/02 22:49), Jon Medhurst (Tixy) wrote:
> > 1. On SMP systems it's very slow because of kprobe's use of stop_machine
> > for applying and removing probes, this forces the system to idle and
> > wait for the next scheduler tick for each probe change.
> 
> Hmm, agreed. It seems that arm32 limitation of self-modifying code on SMP.
> I'm not sure how we can handle it, but I guess;
>  - for some processors which have better coherent cache for SMP, we can
>    atomically replace the breakpoint code with original code.

Except that it's not an architected breakpoint instruction, as I mentioned
before. It's also not really a property of the cache.

>  - Even if we get an "undefined instruction" exception, its handler can
>    ask kprobes if the address is under modifying or not. And if it is,
>    we can just return from the exception to retry the execution.

It's not as simple as that -- you could potentially see an interleaving of
the two instructions. The architecture is even broader than that:

 Concurrent modification and execution of instructions can lead to the
 resulting instruction performing any behavior that can be achieved by
 executing any sequence of instructions that can be executed from the
 same Exception level,

There are additional guarantees for some instructions (like the architected
BKPT instruction).

Will
