Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3JISU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab3JISU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:20:26 -0400
Date: Wed, 9 Oct 2013 18:54:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, anjana vk <anjanvk12@gmail.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        eunki_kim@samsung.com
Subject: cgroup_attach_task && while_each_thread (Was: cgroup attach task -
	slogging cpu)
Message-ID: <20131009165448.GA22437@redhat.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org> <20131008145833.GA15600@redhat.com> <5254EB2A.7090803@huawei.com> <20131009133047.GA12414@redhat.com> <20131009140551.GA15849@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009140551.GA15849@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And I am starting to think that this change should also fix the
while_each_thread() problems in this particular case.

In generak the code like

	rcu_read_lock();
	task = find_get_task(...);
	rcu_read_unlock();

	rcu_read_lock();
	t = task;
	do {
		...
	} while_each_thread (task, t);
	rcu_read_unlock();

is wrong even if while_each_thread() was correct (and we have a lot
of examples of this pattern). A GP can pass before the 2nd rcu-lock,
and we simply can't trust ->thread_group.next.

But I didn't notice that cgroup_attach_task(tsk, threadgroup) can only
be called with threadgroup == T when a) tsk is ->group_leader and b)
we hold threadgroup_lock() which blocks de_thread(). IOW, in this case
"tsk" can't be removed from ->thread_group list before other threads.

If next_thread() sees thread_group.next != leader, we know that the
that .next thread didn't do __unhash_process() yet, and since we
know that in this case "leader" didn't do this too we are safe.

In short: __unhash_process(leader) (in this) case can never change
->thread_group.next of another thread, because leader->thread_group
should be already list_empty().

On 10/09, Oleg Nesterov wrote:
>
> On 10/09, Oleg Nesterov wrote:
> >
> > On 10/09, Li Zefan wrote:
> > >
> > > Anjana, could you revise the patch and send it out with proper changelog
> > > and Signed-off-by? And please add "Cc: <stable@vger.kernel.org> # 3.9+"
> >
> > Yes, Anjana, please!
>
> Please note also that the PF_EXITING check has the same problem, it also
> needs "goto next".
>
> > > > check in the main loop. So Anjana was right (sorry again!), and we
> > > > should probably do
> > > >
> > > > 		ent.cgrp = task_cgroup_from_root(...);
> > > > 		if (ent.cgrp != cgrp) {
> > > > 			retval = flex_array_put(...);
> > > > 			...
> > > > 		}
> > > >
> > > > 		if (!threadgroup)
> > > > 			break;
> > > >
> > >
> > > Or
> > >
> > > do {
> > > 	...
> > > 	if (ent.cgrp == cgrp)
> > > 		goto next;
> >
> > Or this, agreed.
> >
> > > > Or I am wrong again?
> > >
> > > No, you are not! :)
> >
> > Thanks ;)
> >
> > Oleg.

