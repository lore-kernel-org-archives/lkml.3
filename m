Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbbAPQWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:22:50 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36314 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbAPQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:22:49 -0500
Date: Fri, 16 Jan 2015 16:22:44 +0000
From: Will Deacon <will.deacon@arm.com>
To: Pratyush Anand <panand@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Long <dave.long@linaro.org>, William Cohen <wcohen@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Query: ARM64: Behavior of el1_dbg exception while executing
 el0_dbg
Message-ID: <20150116162244.GA7091@arm.com>
References: <20150108162312.GO11583@arm.com>
 <54AEBE45.9080203@redhat.com>
 <20150109154635.GG11258@arm.com>
 <54B00C39.1070809@redhat.com>
 <20150112173005.GK13360@arm.com>
 <54B4BF4C.2030009@redhat.com>
 <20150113155221.GG16524@e104818-lin.cambridge.arm.com>
 <54B55B95.1070402@redhat.com>
 <54B7EF3C.8060909@redhat.com>
 <54B8FD49.2060503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B8FD49.2060503@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:00:09PM +0000, Pratyush Anand wrote:
> On Thursday 15 January 2015 10:17 PM, Pratyush Anand wrote:
> > On Tuesday 13 January 2015 11:23 PM, Pratyush Anand wrote:
> >> I will still try to find some way to capture enable_dbg macro path.H
> >
> > I did instrumented debug tap points at all the location from where
> > enable_debug macro is called(see attached debug patch). But, I do not
> > see that, execution reaches to any of those tap points between el0_dbg
> > and el1_dbg, and tap points debug log also confirms that el1_dbg is
> > raised before el0_dbg is returned.
> 
> Probably we all missed this, ARMv8 specs is very clear about it. In 
> section "D2.1 About debug exceptions" it says:
> 
> Software Breakpoint Instruction exceptions cannot be masked. The PE 
> takes Software Breakpoint Instruction exceptions regardless of both of 
> the following:
> • The current Exception level.
> • The current Security state.

Ah, of course, I completely forgot you were using software breakpoints!

> So, reception of el1_dbg while executing el0_dbg seems perfectly normal 
> to me. If you agree then I am back with the original query which I asked 
> in the beginning of the 
> thread,(http://permalink.gmane.org/gmane.linux.ports.arm.kernel/383672) 
> ie how can instruction_pointer be wrong when second el1_dbg is called 
> recursively(as follows).
> 
> [1]-> el0_dbg (After executing BRK instruction by user)
> [2]	-> el1_dbg (when uprobe break handler at [1] executes BRK instruction)
> 		(At the end of this ELR_EL1 is programmed with fffffdfffc000004)
> [3]		-> el1_dbg (when kprobe break handler at [2] enables single stepping)
> 		(Here ELR_EL1 was found fffffe0000092470).So When this el1_dbg was 
> received, then regs->pc  values are not same what was programmed in 
> ELR_EL1 at the return of [2].

Perhaps you're not removing the BRK instruction properly, and so you try to
single-step a trapping instruction and end up stepping into the exception?

Will
