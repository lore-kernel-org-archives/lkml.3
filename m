Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaKJGhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:37:09 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48891 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKJGhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:37:04 -0500
Message-ID: <54605D08.1030008@linaro.org>
Date: Mon, 10 Nov 2014 15:36:56 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <1977974.l97vvy7Y8b@wuerfel> <20141107115551.GC18916@arm.com> <1678531.AUssrM9PAs@wuerfel> <20141107122734.GE18916@arm.com>
In-Reply-To: <20141107122734.GE18916@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 09:27 PM, Will Deacon wrote:
> On Fri, Nov 07, 2014 at 12:03:00PM +0000, Arnd Bergmann wrote:
>> On Friday 07 November 2014 11:55:51 Will Deacon wrote:
>>> On Fri, Nov 07, 2014 at 09:30:53AM +0000, Arnd Bergmann wrote:
>>>> On Friday 07 November 2014 16:47:23 AKASHI Takahiro wrote:
>>>>> This patch adds a new generic ptrace request, PTRACE_SET_SYSCALL.
>>>>> It can be used to change a system call number as follows:
>>>>>      ret = ptrace(pid, PTRACE_SET_SYSCALL, null, new_syscall_no);
>>>>> 'new_syscall_no' can be -1 to skip this system call, you need to modify
>>>>> a register's value, in arch-specific way, as return value though.
>>>>>
>>>>> Please note that we can't define PTRACE_SET_SYSCALL macro in
>>>>> uapi/linux/ptrace.h partly because its value on arm, 23, is used as another
>>>>> request on sparc.
>>>>>
>>>>> This patch also contains an example of change on arch side, arm.
>>>>> Only syscall_set_nr() is required to be defined in asm/syscall.h.
>>>>>
>>>>> Currently only arm has this request, while arm64 would also have it
>>>>> once my patch series of seccomp for arm64 is merged. It will also be
>>>>> usable for most of other arches.
>>>>> See the discussions in lak-ml:
>>>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/300167.html
>>>>>
>>>>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>>>>
>>>>
>>>> Can you describe why you are moving the implementation? Is this a feature
>>>> that we want to have on all architectures in the future? As you say,
>>>> only arm32 implements is at the moment.
>>>
>>> We need this for arm64 and, since all architectures seem to have a mechanism
>>> for setting a system call via ptrace, moving it to generic code should make
>>> sense for new architectures too, no?
>>
>> It makes a little more sense now, but I still don't understand why you
>> need to set the system call number via ptrace. What is this used for,
>> and why doesn't any other architecture have this?
>
> I went through the same thought process back in August, and Akashi
> eventually convinced me that this was the best thing to do:
>
>    http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/278692.html
>
> It comes down to a debugger (which could be GDB, seccomp, tracer ...)
> wanting to change the system call number. This is also used as a mechanism
> to skip a system call by setting it to '-1' (yeah, it's gross, and the
> interaction between all of these syscall hooks is horrible too).
>
> If we update w8 directly instead, we run into a couple of issues:
>
>    - Needing to restore the original w8 if the value is set to '-1' for
>      skip, but continuing to return -ENOSYS for syscall(-1) when not on a
>      tracer path

Yeah, this restriction still exists on my recent patch, v7.
(this is because arm64 uses the same register, x0, as the first argument
and a return value.)

>    - seccomp assumes that syscall_get_nr will return the version set by
>      the most recent tracer, so then we need hacks in ptrace to route
>      register writes to w8 to syscallno in pt_regs, but again, only in the
>      case that we're tracing.

The problem here is that, if we had a hack of replacinging syscallno with w8
in ptrace (ptrace_syscall_enter()), secure_computing() (actually, seccomp_phase2()
on v3.18-rc) would have no chance of seeing a modified syscall number because
the hack would be executed after secure_computing().
(Please note that a tracer simply modifies w8, not syscallno directly).

This eventually results in missing a special case of -1 (skipping this system call).
     http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/280846.html

That is why we needed to have a dedicated new interface.

-Takahiro AKASHI

> Akashi might be able to elaborate on other problems, since this was a
> couple of months ago and I take every opportunity I can to avoid looking
> at this part of the kernel.
>
> Will
>
