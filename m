Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaKSTGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:06:15 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34065 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbaKSTGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:06:14 -0500
Date: Wed, 19 Nov 2014 19:06:01 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 2/6] arm64: ptrace: allow tracer to skip a system call
Message-ID: <20141119190601.GM15985@arm.com>
References: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org>
 <1416273038-15590-3-git-send-email-takahiro.akashi@linaro.org>
 <20141118140425.GM18842@arm.com>
 <546C58DB.5080204@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546C58DB.5080204@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 08:46:19AM +0000, AKASHI Takahiro wrote:
> On 11/18/2014 11:04 PM, Will Deacon wrote:
> > On Tue, Nov 18, 2014 at 01:10:34AM +0000, AKASHI Takahiro wrote:
> >>
> >> +	if (((int)regs->syscallno == -1) && (orig_syscallno == -1)) {
> >> +		/*
> >> +		 * user-issued syscall(-1):
> >> +		 * RESTRICTION: We always return ENOSYS whatever value is
> >> +		 *   stored in x0 (a return value) at this point.
> >> +		 * Normally, with ptrace off, syscall(-1) returns -ENOSYS.
> >> +		 * With ptrace on, however, if a tracer didn't pay any
> >> +		 * attention to user-issued syscall(-1) and just let it go
> >> +		 * without a hack here, it would return a value in x0 as in
> >> +		 * other system call cases. This means that this system call
> >> +		 * might succeed and see any bogus return value.
> >> +		 * This should be definitely avoided.
> >> +		 */
> >> +		regs->regs[0] = -ENOSYS;
> >> +	}
> >
> > I'm still really uncomfortable with this, and it doesn't seem to match what
> > arch/arm/ does either.
> 
> Yeah, I know but
> as I mentioned before, syscall(-1) will be signaled on arm, and so we don't
> have to care about a return value :)

What does x86 do?

> > Doesn't it also prevent a tracer from skipping syscall(-1)?
> 
> Syscall(-1) will return -ENOSYS whether or not a syscallno is explicitly
> replaced with -1 by a tracer, and, in this sense, it is *skipped*.

Ok, but now userspace sees -ENOSYS for a skipped system call in that case,
whereas it would usually see whatever the trace put in x0, right?

Will
