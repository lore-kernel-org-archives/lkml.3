Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab3JKNPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:15:33 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:52103 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3JKNPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:15:32 -0400
Message-ID: <5257F9E3.5030708@huawei.com>
Date: Fri, 11 Oct 2013 21:15:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, anjana vk <anjanvk12@gmail.com>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <eunki_kim@samsung.com>
Subject: Re: cgroup_attach_task && while_each_thread (Was: cgroup attach task
 - slogging cpu)
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org> <20131008145833.GA15600@redhat.com> <5254EB2A.7090803@huawei.com> <20131009133047.GA12414@redhat.com> <20131009140551.GA15849@redhat.com> <20131009165448.GA22437@redhat.com>
In-Reply-To: <20131009165448.GA22437@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/10 0:54, Oleg Nesterov wrote:
> And I am starting to think that this change should also fix the
> while_each_thread() problems in this particular case.
> 
> In generak the code like
> 
> 	rcu_read_lock();
> 	task = find_get_task(...);
> 	rcu_read_unlock();
> 
> 	rcu_read_lock();
> 	t = task;
> 	do {
> 		...
> 	} while_each_thread (task, t);
> 	rcu_read_unlock();
> 
> is wrong even if while_each_thread() was correct (and we have a lot
> of examples of this pattern). A GP can pass before the 2nd rcu-lock,
> and we simply can't trust ->thread_group.next.
> 
> But I didn't notice that cgroup_attach_task(tsk, threadgroup) can only
> be called with threadgroup == T when a) tsk is ->group_leader and b)
> we hold threadgroup_lock() which blocks de_thread(). IOW, in this case
> "tsk" can't be removed from ->thread_group list before other threads.
> 
> If next_thread() sees thread_group.next != leader, we know that the
> that .next thread didn't do __unhash_process() yet, and since we
> know that in this case "leader" didn't do this too we are safe.
> 
> In short: __unhash_process(leader) (in this) case can never change
> ->thread_group.next of another thread, because leader->thread_group
> should be already list_empty().
> 

If threadgroup == false, and if the tsk is existing or is already in
the targeted cgroup, we won't break the loop due to the bug but do
this:

  while_each_thread(task, t)

If @task isn't the leader, we might got stuck in the loop?

