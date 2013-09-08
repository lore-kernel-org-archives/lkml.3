Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3IHQGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:06:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab3IHQGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 12:06:19 -0400
Date: Sun, 8 Sep 2013 18:00:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: =?utf-8?B?6rmA7J2A6riw?= <eunki_kim@samsung.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: CGROUP =?utf-8?B?6rSA66CoIOusuOydmA==?=
Message-ID: <20130908160007.GA31903@redhat.com>
References: <1286806.131871377667197297.JavaMail.weblogic@epv6ml01> <20130828134000.GA9295@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130828134000.GA9295@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Sorry for delay, vacation.

On 08/28, Tejun Heo wrote:
>
> Hey, oleg.
>
> Eunki is reporting a stall in the following loop in
> kernel/cgroup.c::cgroup_attach_task()
>
> On Wed, Aug 28, 2013 at 05:19:57AM +0000, 김은기 wrote:
> >
> >      ---------------------------------------------------------------------------
> >         rcu_read_lock();
> >         do {
> >                 struct task_and_cgroup ent;
> >
> >                 /* @tsk either already exited or can't exit until the end */
> >                 if (tsk->flags & PF_EXITING)
> >                         continue;
> >
> >                 /* as per above, nr_threads may decrease, but not increase. */
> >                 BUG_ON(i >= group_size);
> >                 ent.task = tsk;
> >                 ent.cgrp = task_cgroup_from_root(tsk, root);
> >                 /* nothing to do if this task is already in the cgroup */
> >                 if (ent.cgrp == cgrp)
> >                         continue;
> >                 /*
> >                  * saying GFP_ATOMIC has no effect here because we did prealloc
> >                  * earlier, but it's good form to communicate our expectations.
> >                  */
> >                 retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
> >                 BUG_ON(retval != 0);
> >                 i++;
> >
> >                 if (!threadgroup)
> >                         break;
> >         } while_each_thread(leader, tsk);
> > ---------------------------------------------------------------------------------------------
>
> where the iteration goes like
>
>   leader -> Task1 -> Task2 -> Task3  -> Task1
>
> ie. leader seems RCU unlinked.  Looking at the users of
> while_each_thread(), I'm confused about its locking requirements.

In short: it is broken. This was already discussed several times but
every time I was distracted.

I already have the patches somewhere (probably not 100% finished),
will try to return to this problem soon.

Oleg.

