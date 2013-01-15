Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3AORxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:53:05 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:48979 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3AORxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130115034006.GA3854@home.goodmis.org>
References: <1357914810-20656-1-git-send-email-alcooperx@gmail.com>
	<50F0454D.5060109@gmail.com>
	<20130115034006.GA3854@home.goodmis.org>
Date: Tue, 15 Jan 2013 12:53:00 -0500
Message-ID: <CAOGqxeUSAikiRpVY=Lsu71DzBU6Mmt7C319NqLOv1WscESq=tw@mail.gmail.com>
Subject: Re: [PATCH] mips: function tracer: Fix broken function tracing
From: Alan Cooper <alcooperx@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney.cavm@gmail.com>, ralf@linux-mips.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:40 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
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
>         bl      _mcount
>         addiu   sp,sp,-8
>
> And you convert that to:
>
>         nop
>         nop
>
> Now if you convert that back to:
>
>         bl      ftrace_caller
>         addiu   sp,sp,-8
>
> then you can have an issue if the task was preempted after that first
> nop. Because stop_machine() doesn't wait for tasks to exit kernel space.
> If you have a CONFIG_PREEMPT kernel, a task can be sleeping anywhere.
> Thus you have a task execute the first nop, get preempted. You update
> the code to be:
>
>         bl      ftrace_caller
>         addiu   sp,sp,-8
>
> When that task gets scheduled back in, it will act like it just
> executed:
>
>         nop
>         addiu   sp,sp,-8
>
> Which is the problem you're trying to solve in the first place.
>
> Now that said, There's no reason we need that addiu sp,sp,-8 there.
> That's just what the mips defined mcount requires. But as you can see
> above, with dynamic ftrace, the defined mcount is only called at boot
> up, and never again. That means at boot up you can convert to:
>
>         nop
>         nop
>
> and then when you enable tracing just convert it to:
>
>         bl      ftrace_caller
>         nop
>
> There's nothing that states what the ftrace caller must be. We can have
> it do a proper stack update. That is, only at boot up do we need to
> handle the defined mcount. After that, those instructions are just place
> holders for our own algorithms. If the addiu was needed for the defined
> mcount, there's no reason to keep it for our own ftrace_caller.
>
> Would that work?
>
> -- Steve
>
