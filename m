Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab3AORzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:55:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52967 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3AORzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:55:32 -0500
Message-ID: <50F59812.6040806@gmail.com>
Date: Tue, 15 Jan 2013 09:55:30 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Al Cooper <alcooperx@gmail.com>,
        ralf@linux-mips.org
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: function tracer: Fix broken function tracing
References: <y> <1357914810-20656-1-git-send-email-alcooperx@gmail.com> <50F0454D.5060109@gmail.com> <20130115034006.GA3854@home.goodmis.org>
In-Reply-To: <20130115034006.GA3854@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 07:40 PM, Steven Rostedt wrote:
> On Fri, Jan 11, 2013 at 09:01:01AM -0800, David Daney wrote:
>>
>> I thought all CPUs were in stop_machine() when the modifications
>> were done, so that there is no issue with multi-word instruction
>> patching.
>>
>> Am I wrong about this?
>>
>> So really I think you can do two NOP just as easily.
>
> The problem with double NOPs is that it can only work if there's no
> problem executing one nop and a non NOP. Which I think is an issue here.
>
>
> If you have something like:
>
> 	bl	_mcount
> 	addiu	sp,sp,-8
>
> And you convert that to:
>
> 	nop
> 	nop
>
> Now if you convert that back to:
>
> 	bl	ftrace_caller
> 	addiu	sp,sp,-8
>
> then you can have an issue if the task was preempted after that first
> nop. Because stop_machine() doesn't wait for tasks to exit kernel space.
> If you have a CONFIG_PREEMPT kernel, a task can be sleeping anywhere.
> Thus you have a task execute the first nop, get preempted. You update
> the code to be:

Thanks for the explanation Steven.  This is the part I was missing.


Given all of this, I think the most expedient course for the short term 
is to use the branch-likely-false trick.  Although the performance will 
probably not be great, I think it is probably race free.

In the longer term...

>
> 	bl	ftrace_caller
> 	addiu	sp,sp,-8
>
> When that task gets scheduled back in, it will act like it just
> executed:
>
> 	nop
> 	addiu	sp,sp,-8
>
> Which is the problem you're trying to solve in the first place.
>
> Now that said, There's no reason we need that addiu sp,sp,-8 there.
> That's just what the mips defined mcount requires. But as you can see
> above, with dynamic ftrace, the defined mcount is only called at boot
> up, and never again. That means at boot up you can convert to:
>
> 	nop
> 	nop
>
> and then when you enable tracing just convert it to:
>
> 	bl	ftrace_caller
> 	nop
>
> There's nothing that states what the ftrace caller must be. We can have
> it do a proper stack update. That is, only at boot up do we need to
> handle the defined mcount. After that, those instructions are just place
> holders for our own algorithms. If the addiu was needed for the defined
> mcount, there's no reason to keep it for our own ftrace_caller.
>
> Would that work?

... either do as you suggest and dynamically change the ABI of the 
target function.

Or add support to GCC for a better tracing ABI (as I already said we did 
for mips64).


Thanks,
David Daney


