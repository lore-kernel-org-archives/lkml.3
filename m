Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaKGM1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:27:50 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54504 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKGM1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:27:48 -0500
Date: Fri, 7 Nov 2014 12:27:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Message-ID: <20141107122734.GE18916@arm.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
 <1977974.l97vvy7Y8b@wuerfel>
 <20141107115551.GC18916@arm.com>
 <1678531.AUssrM9PAs@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1678531.AUssrM9PAs@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 12:03:00PM +0000, Arnd Bergmann wrote:
> On Friday 07 November 2014 11:55:51 Will Deacon wrote:
> > On Fri, Nov 07, 2014 at 09:30:53AM +0000, Arnd Bergmann wrote:
> > > On Friday 07 November 2014 16:47:23 AKASHI Takahiro wrote:
> > > > This patch adds a new generic ptrace request, PTRACE_SET_SYSCALL.
> > > > It can be used to change a system call number as follows:
> > > >     ret = ptrace(pid, PTRACE_SET_SYSCALL, null, new_syscall_no);
> > > > 'new_syscall_no' can be -1 to skip this system call, you need to modify
> > > > a register's value, in arch-specific way, as return value though.
> > > > 
> > > > Please note that we can't define PTRACE_SET_SYSCALL macro in
> > > > uapi/linux/ptrace.h partly because its value on arm, 23, is used as another
> > > > request on sparc.
> > > > 
> > > > This patch also contains an example of change on arch side, arm.
> > > > Only syscall_set_nr() is required to be defined in asm/syscall.h.
> > > > 
> > > > Currently only arm has this request, while arm64 would also have it
> > > > once my patch series of seccomp for arm64 is merged. It will also be
> > > > usable for most of other arches.
> > > > See the discussions in lak-ml:
> > > > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/300167.html
> > > > 
> > > > Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> > > > 
> > > 
> > > Can you describe why you are moving the implementation? Is this a feature
> > > that we want to have on all architectures in the future? As you say,
> > > only arm32 implements is at the moment.
> > 
> > We need this for arm64 and, since all architectures seem to have a mechanism
> > for setting a system call via ptrace, moving it to generic code should make
> > sense for new architectures too, no?
> 
> It makes a little more sense now, but I still don't understand why you
> need to set the system call number via ptrace. What is this used for,
> and why doesn't any other architecture have this?

I went through the same thought process back in August, and Akashi
eventually convinced me that this was the best thing to do:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/278692.html

It comes down to a debugger (which could be GDB, seccomp, tracer ...)
wanting to change the system call number. This is also used as a mechanism
to skip a system call by setting it to '-1' (yeah, it's gross, and the
interaction between all of these syscall hooks is horrible too).

If we update w8 directly instead, we run into a couple of issues:

  - Needing to restore the original w8 if the value is set to '-1' for
    skip, but continuing to return -ENOSYS for syscall(-1) when not on a
    tracer path

  - seccomp assumes that syscall_get_nr will return the version set by
    the most recent tracer, so then we need hacks in ptrace to route
    register writes to w8 to syscallno in pt_regs, but again, only in the
    case that we're tracing.

Akashi might be able to elaborate on other problems, since this was a
couple of months ago and I take every opportunity I can to avoid looking
at this part of the kernel.

Will
