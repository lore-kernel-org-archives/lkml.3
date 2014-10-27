Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaJ0S50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaJ0S5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:24 -0400
Date: Mon, 27 Oct 2014 20:53:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 0/3] introduce task_rcu_dereference()
Message-ID: <20141027195339.GA11736@redhat.com>
References: <1413962231.19914.130.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413962231.19914.130.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, let me repeat once again, if you still prefer to avoid
probe_slab_address() and use SLAB_DESTROY_BY_RCU I won't argue.

I do not like SLAB_DESTROY_BY_RCU in this particular case. With
or without SDBR rq->curr can be reused and we need to avoid this
race. The fact that with SDBR it can be reused only as another
instance of task_struct is absolutely immaterial imo.

Not to mention that SDBR still adds some overhead while probe_slab()
is free unless CONFIG_DEBUG_PAGEALLOC, but this option adds a large
slowdown anyway.

However, my arguments against SDBR are not strictly technical, and
I think that this falls into "maintainer is always right" category.

So please tell me if you prefer v2 with SDBR. In this case 2/3 is
not needed, and 3/3 can simply read ->sighand. Otherwise the code
(and even the comments) will be the same.

Compared to the draft patch I sent before

	- update the comments

	- do not use ERR_PTR(), just return the task or NULL, so
	  kernel/sched/ doesn't need another helper.

	  This means that task_rcu_dereference() does retry itself.
	  We can add __task_rcu_dereference() if we have another
	  which do not need/want to retry.

Oleg.

 include/linux/sched.h   |    1 +
 include/linux/uaccess.h |   30 +++++++++++++++-------------
 kernel/exit.c           |   49 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/slub.c               |    6 +----
 4 files changed, 67 insertions(+), 19 deletions(-)

