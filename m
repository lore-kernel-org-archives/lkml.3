Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbbAWESE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 23:18:04 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:45065 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbAWESA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 23:18:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+CQxZo7ku6nj31UMHySVFo8My0Jd-GthF=tibe_Y2x0w@mail.gmail.com>
References: <CAGXu5j+O6znN=7-gc3PqwqFA5MFRPLGBUzabOmQjWn_9WTjvpg@mail.gmail.com>
	<CACZ9PQUEprgKrpHazDULA5mf-OaoX=MAjEeWdspZTXT_+iUKWw@mail.gmail.com>
	<20150116155923.GK12302@n2100.arm.linux.org.uk>
	<CACZ9PQUVFtCQg6XjDbokEPy_R2fZcHiq6+EEUZnx4FVfpfZxJg@mail.gmail.com>
	<20150116161752.GL12302@n2100.arm.linux.org.uk>
	<CAGXu5j+XHFNyhaBndQr1Q2uthsFP9ZQGbaw5hofDmXyKXZ-H5g@mail.gmail.com>
	<CAGXu5j+9p1T29NoHnCNywd0T=H2mzWhCou5nSRfXZktEOC7_=A@mail.gmail.com>
	<20150119092002.GA32131@arm.com>
	<CAGXu5jJ8vphdjbqy7OojE=V70vLPs2impJ6i561JafrLYXxvbw@mail.gmail.com>
	<20150120224518.GL26493@n2100.arm.linux.org.uk>
	<20150120230458.GM26493@n2100.arm.linux.org.uk>
	<CAGXu5jKzif=vp6gn5ZtrTx-JTN367qFphobnt9s=awbaafwoUw@mail.gmail.com>
	<CACZ9PQXd_UpnDjgdvG884OpVb_oH_VtZB4Ka9K2Ex6JM4zecyQ@mail.gmail.com>
	<CAGXu5j+CQxZo7ku6nj31UMHySVFo8My0Jd-GthF=tibe_Y2x0w@mail.gmail.com>
Date: Fri, 23 Jan 2015 13:17:58 +0900
Message-ID: <CACZ9PQU7T1cbqWsym1oDd0zYw9jCVc985==uMsMVLYw8hQHJzQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: entry-common: fix forgotten set of thread_info->syscall
From: Roman Peniaev <r.peniaev@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 3:07 AM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jan 21, 2015 at 5:24 PM, Roman Peniaev <r.peniaev@gmail.com> wrote:
>> On Thu, Jan 22, 2015 at 8:32 AM, Kees Cook <keescook@chromium.org> wrote:
>>> On Tue, Jan 20, 2015 at 3:04 PM, Russell King - ARM Linux
>>> <linux@arm.linux.org.uk> wrote:
[snip]
>>>
>>> Native ARM64 hides the restart from both seccomp and ptrace, and this
>>> seems like the right idea, except that restart_syscall is still
>>> callable from userspace. I don't think there's a way to make that
>>> vanish, which means we'll always have an exposed syscall. If anything
>>> goes wrong with it (which we've been quite close to recently[1]),
>>> there would be no way to have seccomp filter it.
>>>
>>> So, at the least, I'd like arm64 to NOT hide restart_syscall from
>>> seccomp, and at best I'd like both arm and arm64 to (somehow) entirely
>>> remove restart_syscall from the userspace ABI so it wouldn't need to
>>> be filtered, and wouldn't become a weird ABI hiccup as you've
>>> described.
>>>
>>> I fail to imagine a way to remove restart_syscall from userspace, so
>>> I'm left with wanting parity of behavior between ARM and ARM64 (and
>>> x86). What's the right way forward?
>>
>> My sufferings are an opposite of what seccompt expects: currently I do
>> not see any possible way (from userspace) to get syscall number which was
>> restarted, because at some given time userspace checks the procfs
>> syscall file and sees NR_restart there, without any chance to understand
>> what exactly was restarted (I am talking about some kind of debugging
>> tool which does dead-lock analysis of stuck tasks).
>>
>> I totally agree with Russell not to provide kernel guts to userspace,
>> but it is already done.  Too late.
>>
>> So probably there is a need to split syscall on two numbers:
>> real and effective.  Real number we have right now on x86.
>>
>> And this should be done for both ptrace and procfs syscall file.
>> (am I right that only for ARM we already have PTRACE_SET_SYSCALL?
>>  seems we can add also real/effective getter)
>
> ARM's syscall "get" is via PTRACE_GETREGSET with NT_PRSTATUS, reading ARM_r7:
>
> int syscall_get(pid_t tracee) {
>         struct iovec iov;
>         struct pt_regs;
>
>         iov.iov_base = &regs;
>         iov.iov_len = sizeof(regs);
>         if (ptrace(PTRACE_GETREGSET, tracee, NT_PRSTATUS, &iov) < 0) {
>                perror("PTRACE_GETREGSET, NT_PRSTATUS");
>                return -1;
>         }
>         return regs.ARM_r7;
> }
>
> ARM's syscall "set" is via PTRACE_SET_SYSCALL:
>
> int syscall_set(int syscall, pid_t tracee) {
>         return ptrace(PTRACE_SET_SYSCALL, tracee, NULL, syscall);
> }
>
> Landing in 3.19, ARM64 has get/set via PTRACE_[GS]ETREGSET with
> NT_ARM_SYSTEM_CALL:
>
> int syscall_get(pid_t tracee) {
>         struct iovec iov;
>         int syscall;
>
>         iov.iov_base = &syscall;
>         iov.iov_len = sizeof(syscall);
>         if (ptrace(PTRACE_GETREGSET, tracee,
>                   NT_ARM_SYSTEM_CALL, &iov) < 0) {
>                 perror("PTRACE_GETREGSET, NT_ARM_SYSTEM_CALL");
>                 return -1;
>         }
>         return syscall;
> }
>
> int syscall_set(int syscall, pid_t tracee) {
>         iov.iov_base = &syscall;
>         iov.iov_len = sizeof(syscall);
>         return ptrace(PTRACE_SETREGSET, tracee,
>                   NT_ARM_SYSTEM_CALL, &iov);
> }
>
> Prior to 3.19, ARM64 could use PTRACE_[GS]ETREGSET, NT_STATUS on
> struct user_pt_regs and regs[8].
>

Thanks.  I also came up with this possible way to retrieve effective
syscall.  But, as you showed, I still can get NR_restart (it is 32bit
userspace on ARM64, right?)

Also, this approach is definitely arch dependent (at least I have to
know the register for scnr, also [probably] I have to distinguish EABI
and OABI on ARM).

And also all this ptrace machinery is not as fast as reading from
procfs syscall file (no deal with signals, syscall restarts, etc).

But procfs syscall is not implemented on ARM and, even if it is,
NR_restart spoils me everything.

But still thanks.

--
Roman
