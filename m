Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab3GWQnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab3GWQnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:43:11 -0400
Date: Tue, 23 Jul 2013 18:38:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ptrace(PTRACE_ATTACH)  [no intervering wait]
	ptrace(PTRACE_DETACH) may leave tracee stuck
Message-ID: <20130723163806.GA27905@redhat.com>
References: <1374573914.30532.68.camel@marge.simpson.net> <20130723155854.GA26211@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723155854.GA26211@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Oleg Nesterov wrote:
>
> On 07/23, Mike Galbraith wrote:
> >
> > I received a report that glibc:elf/pldd hangs occasionally, and indeed..
> >
> >   for i in `seq 1 1000`; do taskset -c 3 pldd $$ > /dev/null 2>&1; done
> >
> > ..will do so.  Rummage.....
> >
> > ptrace(PTRACE_DETACH) returns -ESRCH when the trap hasn't happened yet,
> > which happens because pldd doesn't wait() before ptrace(PTRACE_DETACH).
> >
> > pldd source:
> >
> [...snip...]
> >
> > Seems this usually works only because cycles expended between attach and
> > detach is usually enough to let trap happen so tracee can set its state
> > to TASK_TRACED as PTRACE_DETACH expects it to be.
> >
> > Is this expected behavior?
>
> Yes. PTRACE_ATTACH + PTRACE_DETACH is not correct without wait() in
> between, this is expected.
>
> PTRACE_DETACH like (almost) any other ptrace request needs the stopped
> tracee. Otherwise, say, ptrace_disable() or flush_ptrace_hw_breakpoint()
> are not safe.

I have found the source of pldd.c. It seems that it has another reason
for waitpid().

	/* Stop all threads since otherwise the list of loaded modules might
	   change while we are reading it. */

Yes, but without waitpid() we can't know if it was actually stopped.

OTOH, in this particular case pldd.c doesn't really need PTRACE_DETACH,
it can simply exit.

Oleg.

