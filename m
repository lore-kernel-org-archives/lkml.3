Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3H1NkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:40:06 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:40710 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3H1NkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:40:04 -0400
Date: Wed, 28 Aug 2013 09:40:00 -0400
From: Tejun Heo <tj@kernel.org>
To: =?utf-8?B?6rmA7J2A6riw?= <eunki_kim@samsung.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: CGROUP =?utf-8?B?6rSA66CoIOusuOydmA==?=
Message-ID: <20130828134000.GA9295@htj.dyndns.org>
References: <1286806.131871377667197297.JavaMail.weblogic@epv6ml01>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286806.131871377667197297.JavaMail.weblogic@epv6ml01>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, oleg.

Eunki is reporting a stall in the following loop in
kernel/cgroup.c::cgroup_attach_task()

On Wed, Aug 28, 2013 at 05:19:57AM +0000, 김은기 wrote:
> 
>      ---------------------------------------------------------------------------
>         rcu_read_lock();
>         do {
>                 struct task_and_cgroup ent;
> 
>                 /* @tsk either already exited or can't exit until the end */
>                 if (tsk->flags & PF_EXITING)
>                         continue;
> 
>                 /* as per above, nr_threads may decrease, but not increase. */
>                 BUG_ON(i >= group_size);
>                 ent.task = tsk;
>                 ent.cgrp = task_cgroup_from_root(tsk, root);
>                 /* nothing to do if this task is already in the cgroup */
>                 if (ent.cgrp == cgrp)
>                         continue;
>                 /*
>                  * saying GFP_ATOMIC has no effect here because we did prealloc
>                  * earlier, but it's good form to communicate our expectations.
>                  */
>                 retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
>                 BUG_ON(retval != 0);
>                 i++;
> 
>                 if (!threadgroup)
>                         break;
>         } while_each_thread(leader, tsk);
> ---------------------------------------------------------------------------------------------

where the iteration goes like

  leader -> Task1 -> Task2 -> Task3  -> Task1

ie. leader seems RCU unlinked.  Looking at the users of
while_each_thread(), I'm confused about its locking requirements.
Does it require tasklist_lock or is rcu read lock enough?  If there
are special requirements, it'd be great if it can be described in the
comment above the two macros.

Eunki, can you please post full stack dump from such lockups?  Where
is the function called from?  Is it from attach_task_by_pid() or other
places?  Apparently, we aren't holding threadgroup_lock from other
callsites so the leader isn't guaranteed to be / stay the leader.

Thanks.

-- 
tejun
