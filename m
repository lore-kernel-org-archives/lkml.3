Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbbAUXcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:32:22 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61854 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbbAUXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:32:13 -0500
MIME-Version: 1.0
In-Reply-To: <20150120230458.GM26493@n2100.arm.linux.org.uk>
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
Date: Wed, 21 Jan 2015 15:32:12 -0800
X-Google-Sender-Auth: 8YH2FZadOxOWy-raAMj_sZttmAY
Message-ID: <CAGXu5jKzif=vp6gn5ZtrTx-JTN367qFphobnt9s=awbaafwoUw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: entry-common: fix forgotten set of thread_info->syscall
From: Kees Cook <keescook@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Roman Peniaev <r.peniaev@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 3:04 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jan 20, 2015 at 10:45:19PM +0000, Russell King - ARM Linux wrote:
>> Well, the whole question is this: is restarting a system call like
>> usleep() really a separate system call, or is it a kernel implementation
>> detail?
>>
>> If you wanted seccomp to see this, what would be the use case?  Why
>> would seccomp want to block this syscall?  Does it make sense for
>> seccomp to block this syscall when it doesn't block something like
>> usleep() and then have usleep() fail just because the thread received
>> a signal?
>>
>> I personally regard the whole restart system call thing as a purely
>> kernel internal thing which should not be exposed to userland.  If
>> we decide that it should be exposed to userland, then it becomes part
>> of the user ABI, and it /could/ become difficult if we needed to
>> change it in future - and I'd rather not get into the "oh shit, we
>> can't change it because that would break app X" crap.
>
> Here's a scenario where it could become a problem:
>
> Let's say that we want to use seccomp to secure some code which issues
> system calls.  We determine that the app uses system calls which don't
> result in the restart system call being issued, so we decide to ask
> seccomp to block the restart system call.  Some of these system calls
> that the app was using are restartable system calls.
>
> When these system calls are restarted, what we see via ptrace etc is
> that the system call simply gets re-issued as its own system call.
>
> In a future kernel version, we decide that we could really do with one
> of those system calls using the restart block feature, so we arrange
> for it to set up the restart block, and return -ERESTART_BLOCK.  That's
> fine for most applications, but this app now breaks.
>
> The side effect of that breakage is that we have to revert that kernel
> change - because we've broken userland, and that's simply not allowed.
>
> Now look at the alternative: we don't make the restart syscall visible.
> This means that we hide that detail, and we actually reflect the
> behaviour that we've had for the other system call restart mechanisms,
> and we don't have to fear userspace breakage as a result of switching
> from one restart mechanism to another.
>
> I am very much of the opinion that we should be trying to limit the
> exposure of inappropriate kernel internal details to userland, because
> userland has a habbit of becoming reliant on them, and when it does,
> it makes kernel maintanence unnecessarily harder.

I totally agree with you. :) My question here is more about what we
should do with what we currently have since we have some unexpected
combinations.

There is already an __NR_restart_syscall syscall and it seems like
it's already part of the userspace ABI:
 - it is possible to call it from userspace directly
 - seccomp "sees" it
 - ptrace doesn't see it

Native ARM64 hides the restart from both seccomp and ptrace, and this
seems like the right idea, except that restart_syscall is still
callable from userspace. I don't think there's a way to make that
vanish, which means we'll always have an exposed syscall. If anything
goes wrong with it (which we've been quite close to recently[1]),
there would be no way to have seccomp filter it.

So, at the least, I'd like arm64 to NOT hide restart_syscall from
seccomp, and at best I'd like both arm and arm64 to (somehow) entirely
remove restart_syscall from the userspace ABI so it wouldn't need to
be filtered, and wouldn't become a weird ABI hiccup as you've
described.

I fail to imagine a way to remove restart_syscall from userspace, so
I'm left with wanting parity of behavior between ARM and ARM64 (and
x86). What's the right way forward?

-Kees

[1] https://git.kernel.org/linus/849151dd5481bc8acb1d287a299b5d6a4ca9f1c3

-- 
Kees Cook
Chrome OS Security
