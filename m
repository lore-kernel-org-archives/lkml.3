Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbbATWpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:45:40 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42200 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbATWpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:45:39 -0500
Date: Tue, 20 Jan 2015 22:45:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>, Roman Peniaev <r.peniaev@gmail.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: entry-common: fix forgotten set of
 thread_info->syscall
Message-ID: <20150120224518.GL26493@n2100.arm.linux.org.uk>
References: <CACZ9PQVo0SF4Z-rdNk4e=yY17Xt9n5hAqm4ZRNLEw3jGYYcvtA@mail.gmail.com>
 <CAGXu5j+O6znN=7-gc3PqwqFA5MFRPLGBUzabOmQjWn_9WTjvpg@mail.gmail.com>
 <CACZ9PQUEprgKrpHazDULA5mf-OaoX=MAjEeWdspZTXT_+iUKWw@mail.gmail.com>
 <20150116155923.GK12302@n2100.arm.linux.org.uk>
 <CACZ9PQUVFtCQg6XjDbokEPy_R2fZcHiq6+EEUZnx4FVfpfZxJg@mail.gmail.com>
 <20150116161752.GL12302@n2100.arm.linux.org.uk>
 <CAGXu5j+XHFNyhaBndQr1Q2uthsFP9ZQGbaw5hofDmXyKXZ-H5g@mail.gmail.com>
 <CAGXu5j+9p1T29NoHnCNywd0T=H2mzWhCou5nSRfXZktEOC7_=A@mail.gmail.com>
 <20150119092002.GA32131@arm.com>
 <CAGXu5jJ8vphdjbqy7OojE=V70vLPs2impJ6i561JafrLYXxvbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ8vphdjbqy7OojE=V70vLPs2impJ6i561JafrLYXxvbw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:31:57AM -0800, Kees Cook wrote:
> On Mon, Jan 19, 2015 at 1:20 AM, Will Deacon <will.deacon@arm.com> wrote:
> > I'm fine either way for the native case, but we should stick with whetever
> > we end up with. Being compatible with ARM is probably a good idea. Do you
> > have a preference?
> 
> I actually prefer seccomp matching ptrace register visibility, so I'd
> like to see restart_syscall everywhere. (It is a real entry point
> after all.)
> 
> >> - compat mode on arm64 _does_ show syscall_restart (via ARM_r7).
> >
> > That sounds like a bug, then. Any chance you could look into a patch?
> 
> Well, actually, I think this is the _correct_ behavior, and native
> arm64 and native arm are the broken pieces. If no one objects to
> fixing this, I can work on sorting it out for ptrace, since it looks
> like Roman has procfs handled.
> 
> Russell, given the rest of this thread, would you be okay exposing
> "true" syscall to ARM? Perhaps we could implement NT_ARM_SYSTEM_CALL
> on arm32?

Well, the whole question is this: is restarting a system call like
usleep() really a separate system call, or is it a kernel implementation
detail?

If you wanted seccomp to see this, what would be the use case?  Why
would seccomp want to block this syscall?  Does it make sense for
seccomp to block this syscall when it doesn't block something like
usleep() and then have usleep() fail just because the thread received
a signal?

I personally regard the whole restart system call thing as a purely
kernel internal thing which should not be exposed to userland.  If
we decide that it should be exposed to userland, then it becomes part
of the user ABI, and it /could/ become difficult if we needed to
change it in future - and I'd rather not get into the "oh shit, we
can't change it because that would break app X" crap.

Before we had the restart syscall, we used to just re-issue the
original syscall, so actually on ARM we preserved the older Linux
behaviour.

Can you put forward a strong argument justifying why the restart
system call should be exposed, other than "other architectures do" ?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
