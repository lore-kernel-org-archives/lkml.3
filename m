Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaCRQYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbaCRQYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:24:12 -0400
Date: Tue, 18 Mar 2014 17:23:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peng Tao <bergwolf@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Message-ID: <20140318162319.GB5669@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com> <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net> <CA+a=Yy567xtU0Osz+9-hTCNrzB65vE=ErYWTq880N+uEwG2DHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy567xtU0Osz+9-hTCNrzB65vE=ErYWTq880N+uEwG2DHA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18, Peng Tao wrote:
>
> On Tue, Mar 18, 2014 at 10:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Unless you cannot use ___wait() and really need to open-code the
> > wait_event() stuff.
> >
> Lustre's private l_wait_event() stuff takes care to (un)mask
> LUSTRE_FATAL_SIGS

Hmm. This is off-topic but after the quick grep LUSTRE_FATAL_SIGS/etc
looks suspicious.

Firtsly, cfs_block_sigs/cfs_block_sigsinv/etc are not exactly right,
they need set_current_blocked(). And you can read "old" lockless.

And note that cfs_block_sigsinv(0) (which should block all signals)
can't actually protect from SIGKILL (or in fact from another fatal
signal) or SIGSTOP if the caller is multithreaded. Or ptrace, or
freezer.

> and always wait in TASK_INTERRUPTIBLE state.

and it seems that __wstate passed to waitq_wait/waitq_timedwait is
simply ignored.

> It looks to me that we can at least wrap l_wait_event() on top of
> wait_event_interruptible/wait_event_timeout_interruptible.

l_wait_event looks really complicated ;) but perhaps you can rewrite
it on top of ___wait_event(), note that condition/cmd can do anything
you want.

Oleg.

