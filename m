Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaA0WGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:06:35 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33903 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaA0WGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:06:34 -0500
Message-ID: <52E6D866.604@amacapital.net>
Date: Mon, 27 Jan 2014 14:06:30 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com> <20140127002255.GA10323@ZenIV.linux.org.uk> <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com> <20140127074208.GB10323@ZenIV.linux.org.uk>
In-Reply-To: <20140127074208.GB10323@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 11:42 PM, Al Viro wrote:
> On Sun, Jan 26, 2014 at 08:32:09PM -0800, Linus Torvalds wrote:
>> On Sun, Jan 26, 2014 at 4:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>>
>>> Umm...  Can't uprobe_notify_resume() modify regs as well?
>>
>> Probably.
>>
>> .. and on the other hand, we should actually be able to use 'sysret'
>> for signal handling on x86-64, because while sysret destroys %rcx and
>> doesn't allow for returning to odd modes, for calling a signal handler
>> I don't think we really care..
> 
> I'm afraid we might:
> 
>  * When user can change the frames always force IRET. That is because
>  * it deals with uncanonical addresses better. SYSRET has trouble
>  * with them due to bugs in both AMD and Intel CPUs.
> 
> IIRC, that was about SYSRET with something unpleasant left in RCX, which
> comes from regs->ip, which is set to sa_handler by __setup_rt_frame().
> And we do not normalize or validate that - not in __setup_rt_frame() and
> not at sigaction(2) time.  Something about GPF triggered and buggering
> attacker-chosen memory area?  I don't remember details, but IIRC the
> conclusion had been "just don't go there"...
> 
> Note that we can manipulate regs->ip and regs->sp, regardless of validation
> at sigaction(2) or __setup_rt_frame() - just have the sucker ptraced, send
> it a signal and it'll stop on delivery.  Then tracer can use ptrace to modify
> registers and issue PTRACE_CONT with zero signal.  Voila - regs->[is]p
> set to arbitrary values, no signal handlers triggered...
> 

It's not just ip and sp -- cs matters here, too, I think.

(I may be the only one to have ever tried it, but it's possible to
far-call from 64-bit to 32-bit cs, and it works.  I've never tried
switching cs using ptrace, but someone may want that to work. too.)

That being said, the last time I benchmarked it, sysret was *way* faster
than iret.  So maybe the thing to do is to validate the registers on the
way out and, if they're appropriate for sysret, do the sysret.

I'm not quite sure how to express "I don't care about rcx" in pt_regs.
Maybe use the actual value that the CPU will stick in there (assuming
that anyone knows that this is).

--Andy
