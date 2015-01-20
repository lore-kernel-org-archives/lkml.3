Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbbATScA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:32:00 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35119 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbATSb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <20150119092002.GA32131@arm.com>
References: <CACZ9PQXW9G4Vw-dcPwkdVE=uoYmDYEQnJWDnnpup1LxC3s5QPg@mail.gmail.com>
	<CAGXu5jLO-YSaF8P9o3jcXP4VZCPYVshz73krnchYuv9pPGY6Sw@mail.gmail.com>
	<CACZ9PQVo0SF4Z-rdNk4e=yY17Xt9n5hAqm4ZRNLEw3jGYYcvtA@mail.gmail.com>
	<CAGXu5j+O6znN=7-gc3PqwqFA5MFRPLGBUzabOmQjWn_9WTjvpg@mail.gmail.com>
	<CACZ9PQUEprgKrpHazDULA5mf-OaoX=MAjEeWdspZTXT_+iUKWw@mail.gmail.com>
	<20150116155923.GK12302@n2100.arm.linux.org.uk>
	<CACZ9PQUVFtCQg6XjDbokEPy_R2fZcHiq6+EEUZnx4FVfpfZxJg@mail.gmail.com>
	<20150116161752.GL12302@n2100.arm.linux.org.uk>
	<CAGXu5j+XHFNyhaBndQr1Q2uthsFP9ZQGbaw5hofDmXyKXZ-H5g@mail.gmail.com>
	<CAGXu5j+9p1T29NoHnCNywd0T=H2mzWhCou5nSRfXZktEOC7_=A@mail.gmail.com>
	<20150119092002.GA32131@arm.com>
Date: Tue, 20 Jan 2015 10:31:57 -0800
X-Google-Sender-Auth: hy4Gf0sQwdA4GiuGceqBupzcJz4
Message-ID: <CAGXu5jJ8vphdjbqy7OojE=V70vLPs2impJ6i561JafrLYXxvbw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: entry-common: fix forgotten set of thread_info->syscall
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Roman Peniaev <r.peniaev@gmail.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 1:20 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Jan 16, 2015 at 11:54:45PM +0000, Kees Cook wrote:
>> On Fri, Jan 16, 2015 at 11:57 AM, Kees Cook <keescook@chromium.org> wrote:
>> > On Fri, Jan 16, 2015 at 8:17 AM, Russell King - ARM Linux
>> > <linux@arm.linux.org.uk> wrote:
>> >> On Sat, Jan 17, 2015 at 01:08:11AM +0900, Roman Peniaev wrote:
>> >>> On Sat, Jan 17, 2015 at 12:59 AM, Russell King - ARM Linux
>> >>> <linux@arm.linux.org.uk> wrote:
>> >>> > On Sat, Jan 17, 2015 at 12:57:02AM +0900, Roman Peniaev wrote:
>> >>> >> On Fri, Jan 16, 2015 at 7:54 AM, Kees Cook <keescook@chromium.org> wrote:
>> >>> >> > One interesting thing I noticed (which is unchanged by this series),
>> >>> >> > but pulling ARM_r7 during the seccomp ptrace event shows __NR_poll,
>> >>> >> > not __NR_restart_syscall, even though it was a __NR_restart_syscall
>> >>> >> > trap from seccomp. Is there a better place to see the actual syscall?
>> >>> >>
>> >>> >> As I understand we do not push new r7 to the stack, and ptrace uses the
>> >>> >> old value.
>> >>> >
>> >>> > And why should we push r7 to the stack?  ptrace should be using the
>> >>> > recorded system call number, rather than poking about on the stack
>> >>> > itself.
>> >>>
>> >>> Probably we should not, but the behaviour comparing arm to x86 is different.
>> >>
>> >> We definitely should not, because changing the stacked value changes the
>> >> value in r7 after the syscall has returned.  We have guaranteed that the
>> >> value will be preserved across syscalls for years, so we really should
>> >> not be changing that.
>> >
>> > Yeah, we can't mess with the registers. I was just asking for
>> > clarification on how this is visible to userspace.
>> >
>> >>
>> >>> Also there is no any way from userspace to figure out what syscall was
>> >>> restarted, if you do not trace each syscall enter and exit from the
>> >>> very beginning.
>> >>
>> >> Thinking about ptrace, that's been true for years.
>> >>
>> >> It really depends whether you consider the restart syscall a userspace
>> >> thing or a kernelspace thing.  When you consider that the vast majority
>> >> of syscall restarts are done internally in the kernel, and we just
>> >> re-issue the syscall, it immediately brings up the question "why is
>> >> the restart block method different?" and "should the restart block
>> >> method be visible to userspace?"
>> >>
>> >> IMHO, it is prudent not to expose kernel internals to userspace unless
>> >> there is a real reason to, otherwise they become part of the userspace
>> >> API.
>> >
>> > I couldn't agree more, but restart_syscall is already visible to
>> > userspace: it can be called directly, for example. And it's visible to
>> > tracers.
>> >
>> > Unfortunately, the difference here is the visibility during trace
>> > trap. On x86, it's exposed but on ARM, there's no way (that I can
>> > find) to query the "true" syscall, even though the true syscall is
>> > what triggers the tracer. The syscall number isn't provided by any
>> > element of the ptrace event system, nor through siginfo, and must be
>> > examined on a per-arch basis from registers.
>> >
>> > Seccomp does, however, provide a mechanism to pass arbitrary event
>> > data on a TRACE event, so poll vs restart_syscall can be distinguished
>> > that way.
>> >
>> > It seems even strace doesn't know how to find this information. For example:
>> >
>> > x86:
>> > poll([{fd=3, events=POLLIN}], 1, 4294967295
>> > ) = ? ERESTART_RESTARTBLOCK (Interrupted by signal)
>> > --- SIGSTOP {si_signo=SIGSTOP, si_code=SI_USER, si_pid=994, si_uid=1000} ---
>> > --- stopped by SIGSTOP ---
>> > --- SIGCONT {si_signo=SIGCONT, si_code=SI_USER, si_pid=994, si_uid=1000} ---
>> > restart_syscall(<... resuming interrupted call ...>
>> >
>> > ARM:
>> > poll([{fd=3, events=POLLIN}], 1, -1
>> > )    = ? ERESTART_RESTARTBLOCK (Interrupted by signal)
>> > --- SIGSTOP {si_signo=SIGSTOP, si_code=SI_USER, si_pid=20563, si_uid=0} ---
>> > --- stopped by SIGSTOP ---
>> > --- SIGCONT {si_signo=SIGCONT, si_code=SI_USER, si_pid=20563, si_uid=0} ---
>> > poll([{fd=3, events=POLLIN}], 1, -1
>> >
>> > Would it make sense to add REGSET_SYSTEM_CALL to ARM? (Though this
>> > begs the question, "Is restart_syscall visible during a trace on
>> > arm64?", which I'll have to go check...)
>>
>> So, some further testing:
>> - native arm64 presents "poll" again even to seccomp when
>> restart_syscall is triggered (both via regs[8] and
>> NT_ARM_SYSTEM_CALL).
>
> I'm fine either way for the native case, but we should stick with whetever
> we end up with. Being compatible with ARM is probably a good idea. Do you
> have a preference?

I actually prefer seccomp matching ptrace register visibility, so I'd
like to see restart_syscall everywhere. (It is a real entry point
after all.)

>> - compat mode on arm64 _does_ show syscall_restart (via ARM_r7).
>
> That sounds like a bug, then. Any chance you could look into a patch?

Well, actually, I think this is the _correct_ behavior, and native
arm64 and native arm are the broken pieces. If no one objects to
fixing this, I can work on sorting it out for ptrace, since it looks
like Roman has procfs handled.

Russell, given the rest of this thread, would you be okay exposing
"true" syscall to ARM? Perhaps we could implement NT_ARM_SYSTEM_CALL
on arm32?

-Kees

-- 
Kees Cook
Chrome OS Security
