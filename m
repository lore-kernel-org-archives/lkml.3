Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3DOPXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:23:43 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:49780 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751814Ab3DOPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:23:41 -0400
Date: Mon, 15 Apr 2013 16:23:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: Fix task tracing
Message-ID: <20130415152319.GF29528@arm.com>
References: <20130408153132.GQ17476@mudshark.cambridge.arm.com>
 <1365510814-21343-1-git-send-email-cov@codeaurora.org>
 <20130415101159.GA25095@localhost.cambridge.arm.com>
 <20130415104542.GE9827@mudshark.cambridge.arm.com>
 <20130415105840.GB29528@arm.com>
 <20130415114307.GC29528@arm.com>
 <516BFC00.5050700@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516BFC00.5050700@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 02:09:20PM +0100, Christopher Covington wrote:
> On 04/15/2013 07:43 AM, Catalin Marinas wrote:
> > On Mon, Apr 15, 2013 at 11:58:40AM +0100, Catalin Marinas wrote:
> >> On Mon, Apr 15, 2013 at 11:45:42AM +0100, Will Deacon wrote:
> >>> On Mon, Apr 15, 2013 at 11:11:59AM +0100, Catalin Marinas wrote:
> >>>> On Tue, Apr 09, 2013 at 01:33:34PM +0100, Christopher Covington wrote:
> >>>>> For accurate accounting pass contextidr_thread_switch the prev
> >>>>> task pointer, since cpu_switch_to has at that point changed the
> >>>>> the stack pointer.
> >>>>>
> >>>>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> >>>>> ---
> >>>>>  arch/arm64/kernel/process.c | 2 +-
> >>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> >>>>> index 0337cdb..a49b25a 100644
> >>>>> --- a/arch/arm64/kernel/process.c
> >>>>> +++ b/arch/arm64/kernel/process.c
> >>>>> @@ -315,7 +315,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
> >>>>>  	/* the actual thread switch */
> >>>>>  	last = cpu_switch_to(prev, next);
> >>>>>  
> >>>>> -	contextidr_thread_switch(next);
> >>>>> +	contextidr_thread_switch(prev);
> >>>>
> >>>> The original code was indeed wrong but using prev isn't any better. For
> >>>> a newly created thread, prev is probably 0 (if it's in a register,
> >>>> cpu_context has been zeroed by copy_thread()) or some random stack
> >>>> value.
> 
> <nit>
> I have to I disagree with the statement that using prev isn't _any_ better.
> Even if there are unhandled cases, from my observations, using prev is
> _measurably_ better. On the other hand, I agree that 100% accuracy is essential.
> </nit>

It is indeed better but we still miss the task creation (we only start
tracing once the task is scheduled out and scheduled back in.

> >>> Really? If prev is NULL in context_switch(...), the scheduler will implode,
> >>> and I can't see where else switch_to is called from.
> >>>
> >>> Which code path are you thinking of?
> >>
> >> copy_thread() zeros cpu_context which is used by cpu_switch_to() to load
> >> the next saved registers. The switch_to() function sets prev to last as
> >> returned by __switch_to(), so this is valid but in __switch_to() we
> >> don't have a valid prev (nor next) after cpu_switch_to() for newly
> >> created threads.
> > 
> > Correction - newly created threads return to ret_from_fork rather than
> > __switch_to(), which means that we miss the first
> > contextidr_thread_switch() call for a new thread. I would vote for
> > Christopher's original patch moving the call before cpu_switch_to(). The
> > alternative is to define finish_arch_switch() and add the call there. If
> > you are primarily tracing user space, it doesn't really matter whether
> > the stack was switched or not when we set the contextidr. For kernel
> > tracking, it could be a problem as we have the next task with the old
> > stack. But the same could be said about the prev task with the new
> > stack.
> 
> I'm fine with using either of my previous patches (or are there still cases
> where the second one is suspected to be wrong?) or rolling a new one using
> finish_arch_switch(). Let me know if you all would prefer for me to start on
> the latter.

The second patch is not wrong but insufficient since it doesn't cover
ret_from_fork. Will has a point that debuggers may use the contextidr
event to look into the state of the tread which would still have the old
stack with your first patch. But at least it is consistent with the
arch/arm implementation which uses notifiers.

So I would go with your first patch until we hear otherwise from the
debuggers people, in which case we would probably need to fix both
arch/arm and arch/arm64.

-- 
Catalin
