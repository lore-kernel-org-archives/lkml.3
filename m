Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbbASKL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:11:57 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37606 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbbASKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:11:56 -0500
Date: Mon, 19 Jan 2015 10:11:42 +0000
From: Will Deacon <will.deacon@arm.com>
To: Pratyush Anand <panand@redhat.com>
Cc: Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Long <dave.long@linaro.org>, William Cohen <wcohen@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Query: ARM64: Behavior of el1_dbg exception while executing
 el0_dbg
Message-ID: <20150119101142.GB32131@arm.com>
References: <20150109154635.GG11258@arm.com>
 <54B00C39.1070809@redhat.com>
 <20150112173005.GK13360@arm.com>
 <54B4BF4C.2030009@redhat.com>
 <20150113155221.GG16524@e104818-lin.cambridge.arm.com>
 <54B55B95.1070402@redhat.com>
 <54B7EF3C.8060909@redhat.com>
 <54B8FD49.2060503@redhat.com>
 <20150116162244.GA7091@arm.com>
 <54BC9FC0.2080207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BC9FC0.2080207@redhat.com>
Thread-Topic: Query: ARM64: Behavior of el1_dbg exception while executing
 el0_dbg
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 06:10:08AM +0000, Pratyush Anand wrote:
> On Friday 16 January 2015 09:52 PM, Will Deacon wrote:
> > Perhaps you're not removing the BRK instruction properly, and so you try to
> > single-step a trapping instruction and end up stepping into the exception?
> 
> No, probably that is not the scenario. One thing I agree, that even if 
> AARCH64 specs says that SW BRK exception can not be masked, current 
> kernel code is not ready to handle re-entrant software debug exception. 
> So, I will keep those part of uprobe code as non-kprobable, and then its 
> not so important to get into it for code development perspective.
> 
> However, it would be good to understand that what went wrong and caused 
> to receive an el1_inval. I still fail to pin point the reason of current 
> issue and its not single stepping a trapping instruction (BRK). Sorry, 
> but please have a relook at the sequence of events:

I think my general point still stands (the issue is likely in step 5),
but ok.

> 1. 1st instruction of uprobe_breakpoint_handler is:
> ffffffc00059a628:       a9bf7bfd        stp     x29, x30, [sp,#-16]!
> which is replaced by BRK64_OPCODE_KPROBES = 0xD4200080, when Kprobe is 
> instrumented.
> 
> 2. User instruction at address 0x4005d0 is replaced by 
> BRK64_OPCODE_UPROBES = 0xD4200100, when uprobe is instrumented.
> 
> 3. When application executes instruction at 0x4005d0,we receive el0_dbg.
> 
> 4. In el0_dbg handler we execute kernel code at address 
> ffffffc00059a628, so el1_dbg is raised. (I agree here that el0_dbg has 
> not been closed properly, which current entry.S code expects, so we will 
> need to fix it if we consensus to support re-entrant software debug 
> exception, how ever the issue which I see seems unrelated, so...)

Up to here, we seem to be doing fine.

> 5. Now in el1_dbg, we handle kprobe_breakpoint_handler, where we write 
> saved instruction (ie a9bf7bfd        stp     x29, x30, [sp,#-16]!) to 
> the kmalloc allocated address fffffdfffc000004. kprobe code does 
> flush_icache_range on this location. regs->pc is set to 
> fffffdfffc000004, so elr_el1 is programmed with fffffdfffc000004 during 
> kernel_exit. I have cross checked elr_el1 value just before eret is 
> executed in kernel_exit, and it is correct.

This is the step I'm concerned about. Can you verify that:

  - Replacing the instruction with a nop does/doesn't change behaviour?
  - 0xfffffdfffc000004 is mapped at the point of exception return?
  - Using __flush_icache_all instead of flush_icache_range makes no
    difference?

> So, here we are trying to single step a STP instruction and not BRK 
> instruction.
> 
> 6. Here I am expecting a single step exception, but I receive a el1_inv 
> with ESR_EL1(0x86000007) ie EC as "ESR_EL1_EC_IABT_EL1" and IFSC as 
> "Translation fault, third level". WHY????

That likely means that 0xfffffdfffc000004 isn't mapped. Looking at the
kprobes code, shouldn't it be using the modules area so that it can
guarantee an executable mapping? If so, that should be below PAGE_OFFSET
which isn't true in your case afaict.

Will
