Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaJGEuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 00:50:52 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:56053 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaJGEuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:50:51 -0400
Message-ID: <54337127.40806@gmail.com>
Date: Mon, 06 Oct 2014 21:50:47 -0700
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>, David Daney <ddaney@caviumnetworks.com>
CC: Andy Lutomirski <luto@amacapital.net>, David Daney <ddaney.cavm@gmail.com>,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx>
In-Reply-To: <20141007004915.GF23797@brightrain.aerifal.cx>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 05:49 PM, Rich Felker wrote:
> On Mon, Oct 06, 2014 at 05:33:18PM -0700, David Daney wrote:
[...]

>> Why not?  It will emit any instructions we care to make it emit.  If
>> we want it to emit crypto instructions with patented algorithms,
>> then it will do that.  But we would still like to use a generic
>> kernel with generic FPU support.
>>
>> The most straight forward way (and the currently implemented way) of
>> doing this is to execute the instructions in question out-of-line
>> (on the userspace stack).
>>
>> The question here is:  What is the best way to get to a
>> non-executable stack.
>>
>> The consensus among MIPS developers is that we should continue using
> My experience has been that hardware and software developers focused
> on a particular hardware target are generally unqualified to make
> decisions that affect the design and operation of libc or the kernel.
> They are not experts in these areas. It was apparent early on in this
> thread, when you mentioned the idea that "not all threads would need
> fpu support", that you were thinking from a standpoint of custom
> low-level software and not a general purpose libc that cannot read the
> application author's mind.
Not at all, I was thinking of soft-float ABIs, as they never execute FP 
instructions, and are often used on systems with no FPU.  In fact many 
non-FPU systems never execute any hard-float code.  So those system 
should not suffer large performance regressions from any change made to 
support a non-executable stack.

We use GLibC on many soft-float only systems, and I would posit that 
GLibC is a general purpose libc.

>   It seems nobody had thought of the
> impossibility of doing lazy setup (inability to handle failure) and
> the necessity of always initializing this stuff at pthread_create
> time, either. Design issues like this should be run by experts in the
> libc area early on, not as an afterthought.

I bow down to the experts, as obviously I know nothing about:

1) The Linux kernel
2) The MIPS architecture.
3) Library design.
4) C libraries and their interaction with the kernel, linker and compiler.

>
>> the out-of-line execution trick, but do it somewhere other than in
>> stack memory.
> How do you answer Andy Lutomirski's question about what happens when a
> signal handler interrupts execution while the program counter is
> pointing at this "out-of-line execution" trampoline? This seems like a
> show-stopper for using anything other than the stack.
It would be nice to support, but not doing so would not be a regression 
from current behavior.

>
>> One way of doing this is to have the kernel magically generate
>> thread local memory regions.
>>
>> Another option is to have userspace manage the out-of-line execution areas.
>>
>> As is often the case, each approach has different pluses and minuses.
> Having the kernel magically do it would be better, but I'm doubtful
> that solution works anyway due to the above signal handler/nesting
> issue.

So the perfect is the enemy of the good?  No non-executable stack for 
you, MIPS.

> Rich
>

