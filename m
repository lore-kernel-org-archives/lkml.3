Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbbAPQSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:18:10 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45092 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736AbbAPQSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:18:07 -0500
Date: Fri, 16 Jan 2015 16:17:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>,
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
Message-ID: <20150116161752.GL12302@n2100.arm.linux.org.uk>
References: <1420986751-30364-1-git-send-email-r.peniaev@gmail.com>
 <1420986751-30364-2-git-send-email-r.peniaev@gmail.com>
 <20150112183955.GO13360@arm.com>
 <CACZ9PQXW9G4Vw-dcPwkdVE=uoYmDYEQnJWDnnpup1LxC3s5QPg@mail.gmail.com>
 <CAGXu5jLO-YSaF8P9o3jcXP4VZCPYVshz73krnchYuv9pPGY6Sw@mail.gmail.com>
 <CACZ9PQVo0SF4Z-rdNk4e=yY17Xt9n5hAqm4ZRNLEw3jGYYcvtA@mail.gmail.com>
 <CAGXu5j+O6znN=7-gc3PqwqFA5MFRPLGBUzabOmQjWn_9WTjvpg@mail.gmail.com>
 <CACZ9PQUEprgKrpHazDULA5mf-OaoX=MAjEeWdspZTXT_+iUKWw@mail.gmail.com>
 <20150116155923.GK12302@n2100.arm.linux.org.uk>
 <CACZ9PQUVFtCQg6XjDbokEPy_R2fZcHiq6+EEUZnx4FVfpfZxJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ9PQUVFtCQg6XjDbokEPy_R2fZcHiq6+EEUZnx4FVfpfZxJg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 01:08:11AM +0900, Roman Peniaev wrote:
> On Sat, Jan 17, 2015 at 12:59 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Sat, Jan 17, 2015 at 12:57:02AM +0900, Roman Peniaev wrote:
> >> On Fri, Jan 16, 2015 at 7:54 AM, Kees Cook <keescook@chromium.org> wrote:
> >> > One interesting thing I noticed (which is unchanged by this series),
> >> > but pulling ARM_r7 during the seccomp ptrace event shows __NR_poll,
> >> > not __NR_restart_syscall, even though it was a __NR_restart_syscall
> >> > trap from seccomp. Is there a better place to see the actual syscall?
> >>
> >> As I understand we do not push new r7 to the stack, and ptrace uses the
> >> old value.
> >
> > And why should we push r7 to the stack?  ptrace should be using the
> > recorded system call number, rather than poking about on the stack
> > itself.
> 
> Probably we should not, but the behaviour comparing arm to x86 is different.

We definitely should not, because changing the stacked value changes the
value in r7 after the syscall has returned.  We have guaranteed that the
value will be preserved across syscalls for years, so we really should
not be changing that.

> Also there is no any way from userspace to figure out what syscall was
> restarted, if you do not trace each syscall enter and exit from the
> very beginning.

Thinking about ptrace, that's been true for years.

It really depends whether you consider the restart syscall a userspace
thing or a kernelspace thing.  When you consider that the vast majority
of syscall restarts are done internally in the kernel, and we just
re-issue the syscall, it immediately brings up the question "why is
the restart block method different?" and "should the restart block
method be visible to userspace?"

IMHO, it is prudent not to expose kernel internals to userspace unless
there is a real reason to, otherwise they become part of the userspace
API.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
