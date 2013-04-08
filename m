Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab3DHPbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:31:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53998 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965002Ab3DHPby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:31:54 -0400
Date: Mon, 8 Apr 2013 16:31:32 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] arm64: Fix task tracing
Message-ID: <20130408153132.GQ17476@mudshark.cambridge.arm.com>
References: <1365012061-31660-1-git-send-email-cov@codeaurora.org>
 <20130403180443.GB21167@mudshark.cambridge.arm.com>
 <5162D750.9050706@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162D750.9050706@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 03:42:24PM +0100, Christopher Covington wrote:
> On 04/03/2013 02:04 PM, Will Deacon wrote:
> > Hi Christopher,
> > 
> > On Wed, Apr 03, 2013 at 07:01:01PM +0100, Christopher Covington wrote:
> >> For accurate accounting call contextidr_thread_switch before a
> >> task is scheduled, rather than after.
> >>
> >> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> >> ---
> >>  arch/arm64/kernel/process.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> >> index 0337cdb..c2cc249 100644
> >> --- a/arch/arm64/kernel/process.c
> >> +++ b/arch/arm64/kernel/process.c
> >> @@ -311,11 +311,11 @@ struct task_struct *__switch_to(struct task_struct *prev,
> >>  	fpsimd_thread_switch(next);
> >>  	tls_thread_switch(next);
> >>  	hw_breakpoint_thread_switch(next);
> >> +	contextidr_thread_switch(next);
> >>  
> >>  	/* the actual thread switch */
> >>  	last = cpu_switch_to(prev, next);
> >>  
> >> -	contextidr_thread_switch(next);
> >>  	return last;
> >>  }
> > 
> > Catalin and I wondered about this and decided to go with the current
> > approach in case a debugger, in response to the contextidr write, decided to
> > go off and mine information about the *new* task using the sp.
> 
> The problem with the existing implementation is that it doesn't seem to
> compensate for how cpu_switch_to changes the stack pointer. Consider the
> following sequence.
> 
> cpu_switch_to(prev=A, next=B)
> cpu_switch_to(prev=B, next=C)
> cpu_switch_to(prev=C, next=A)
> 
> After the third call, using A's stack, next will be B, and its thread ID will
> be written to CONTEXTIDR. An easy way to see this in a simulator is to just
> instrument the code with some printk's.

Yes, but moving the call still isn't the right thing to do if we can avoid
it. How about making that contextidr_thread_switch take prev instead of
next?

Will
