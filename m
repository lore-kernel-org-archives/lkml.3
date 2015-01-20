Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbbATXFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:05:16 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42233 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbbATXFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:05:14 -0500
Date: Tue, 20 Jan 2015 23:04:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
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
Subject: Re: [PATCH 1/2] ARM: entry-common: fix forgotten set of
 thread_info->syscall
Message-ID: <20150120230458.GM26493@n2100.arm.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120224518.GL26493@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:45:19PM +0000, Russell King - ARM Linux wrote:
> Well, the whole question is this: is restarting a system call like
> usleep() really a separate system call, or is it a kernel implementation
> detail?
> 
> If you wanted seccomp to see this, what would be the use case?  Why
> would seccomp want to block this syscall?  Does it make sense for
> seccomp to block this syscall when it doesn't block something like
> usleep() and then have usleep() fail just because the thread received
> a signal?
> 
> I personally regard the whole restart system call thing as a purely
> kernel internal thing which should not be exposed to userland.  If
> we decide that it should be exposed to userland, then it becomes part
> of the user ABI, and it /could/ become difficult if we needed to
> change it in future - and I'd rather not get into the "oh shit, we
> can't change it because that would break app X" crap.

Here's a scenario where it could become a problem:

Let's say that we want to use seccomp to secure some code which issues
system calls.  We determine that the app uses system calls which don't
result in the restart system call being issued, so we decide to ask
seccomp to block the restart system call.  Some of these system calls
that the app was using are restartable system calls.

When these system calls are restarted, what we see via ptrace etc is
that the system call simply gets re-issued as its own system call.

In a future kernel version, we decide that we could really do with one
of those system calls using the restart block feature, so we arrange
for it to set up the restart block, and return -ERESTART_BLOCK.  That's
fine for most applications, but this app now breaks.

The side effect of that breakage is that we have to revert that kernel
change - because we've broken userland, and that's simply not allowed.

Now look at the alternative: we don't make the restart syscall visible.
This means that we hide that detail, and we actually reflect the
behaviour that we've had for the other system call restart mechanisms,
and we don't have to fear userspace breakage as a result of switching
from one restart mechanism to another.

I am very much of the opinion that we should be trying to limit the
exposure of inappropriate kernel internal details to userland, because
userland has a habbit of becoming reliant on them, and when it does,
it makes kernel maintanence unnecessarily harder.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
