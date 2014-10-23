Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaJWSVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbaJWSVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:21:52 -0400
Date: Thu, 23 Oct 2014 20:18:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: introduce task_rcu_dereference?
Message-ID: <20141023181818.GB2740@redhat.com>
References: <1413962231.19914.130.camel@tkhai> <20141022213041.GA25467@redhat.com> <1414051845.19914.144.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414051845.19914.144.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Kirill Tkhai wrote:
>
> I'm agree generic helper is better. But probe_slab_address() has a sence
> if we know that SDBR is worse in our subject area.

And I still think it is worse.

> Less of code is
> easier to support :)

Sure, but ignoring the comments, SDBR needs the same code in
task_rcu_dereference() ? Except, of course

	-	probe_slab_address(&task->sighand, sighand);
	+	sighand = task->sighand;

or how do you think we can simplify it?


> probe_slab_address() it's not a trivial logic.

But it already has a user. And probably it can have more.

To me the usage of SDBR is not trivial (and confusing) in this case.
Once again, ignoring the CONFIG_DEBUG_PAGEALLOC problems it does not
help at all.

With or without SDBR rq->curr can be reused and we need to avoid this
race. The fact that with SDBR it can be reused only as another instance
of task_struct is absolutely immaterial imo.

Not to mention that SDBR still adds some overhead while probe_slab()
is free unless CONFIG_DEBUG_PAGEALLOC, but this option adds a large
slowdown anyway.


But again, I can't really work today, perhaps I missed something.
Perhaps you can show a better code which relies on SDBR?

Oleg.

