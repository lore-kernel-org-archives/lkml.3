Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3LVQCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 11:02:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab3LVQCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 11:02:54 -0500
Date: Sun, 22 Dec 2013 17:03:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20131222160321.GA17510@redhat.com>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com> <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com> <20131217153611.GA18321@redhat.com> <20131217154004.GA21656@redhat.com> <20131220190157.GA1452@redhat.com> <20131220213348.GE7959@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220213348.GE7959@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Peter Zijlstra wrote:
>
> On Fri, Dec 20, 2013 at 08:01:57PM +0100, Oleg Nesterov wrote:
> > The only problem is that
> >
> > 	#define ASSIGN_CONST(l, r)      (*(typeof(r) *)&(l) = (r))
> >
> > obviously can't work in this case ;) We need something more clever.
>
> Hmm indeed, C++ has both the const_cast<>() thingy and the template
> system is powerful enough to actually implement const_cast<>() inside
> the language.
>
> But I cannot find anything useful for C. Your attempt to use the rvalue
> type to hopefully obtain a const-less lvalue type is clever, but does
> indeed fail where the rvalue is const too.

Yes.

We can probably do

	#define ASSIGN_CONST(l, r) ({				\
		typeof (l) const r__ = (r);			\
		memcpy((void *)&(l), &(r__), sizeof(l));	\
		(l);						\
	})

gcc can actually avoid a temporary if you do

		ASSIGN_CONST(tsk->pid, leader->pid);

but this doesn't look very nice and assumes __builtin_memcpy().


So, how about

	#define CONST_CAST(type, lval)	\
		(*({					\
			(void)((type *)0 == &(lval));	\
			(type *)&(lval);		\
		}))					\

?

de_thread/copy_process can do

	CONST_CAST(pid_t, tsk->pid) = leader->pid;

and if "type" is wrong we have a warning.

Oleg.

