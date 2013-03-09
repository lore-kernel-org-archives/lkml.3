Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab3CICPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 21:15:25 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:23193 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829Ab3CICPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 21:15:23 -0500
Message-ID: <513A9A67.60909@huawei.com>
Date: Sat, 9 Mar 2013 10:11:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <cgroups@vger.kernel.org>
Subject: Re: lockdep trace from prepare_bprm_creds
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org>
In-Reply-To: <20130307193820.GB3209@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/8 3:38, Tejun Heo wrote:
> Hello,
> 
> On Thu, Mar 07, 2013 at 08:12:42PM +0100, Oleg Nesterov wrote:
>> Well yes, I agree. I think that perfomance-wise threadgroup_change_begin()
>> in de_thread() is fine, and perhaps it is even more clean because we are
>> going to do the thread-group change. The scope of cred_guard_mutex is huge,
>> it doesn't look very nice in threadgroup_lock().
>>
>> But we should avoid the cgroup-specific hooks as much as possible, so I
>> like your patch more.
> 
> I don't really mind how it's done but while my approach seems to limit
> itself to cgroup proper, threadgroup locking is actually more invasive
> by meddling with cred_mutex.  As you said, yours is the cleaner and
> probably more permanent one here.
> 

Agreed.

Now we need that patch to be resent with SOB and proper changelog.

>>> +	if (threadgroup && !thread_group_leader(tsk)) {
>>> +		/*
>>> +		 * a race with de_thread from another thread's exec() may
>>> +		 * strip us of our leadership, if this happens, there is no
>>> +		 * choice but to throw this task away and try again; this
>>> +		 * is "double-double-toil-and-trouble-check locking".
>>> +		 */
>>> +		threadgroup_unlock(tsk);
>>> +		put_task_struct(tsk);
>>> +		goto retry_find_task;
>>> +	}
>>>
>>> +	ret = -ENODEV;
>>> +	if (cgroup_lock_live_group(cgrp)) {
>>> +		if (threadgroup)
>>> +			ret = cgroup_attach_proc(cgrp, tsk);
>>
>> Offtopic, but with or without this change I do not understand the
>> thread_group_leader/retry_find_task logic.
>>
>> Why do we actually need to restart? We do not really care if it is leader
>> or not, we only need to ensure we can safely use while_each_thread() to
>> find all !PF_EXITING threads.
> 
> If my memory serves me right (which BTW often fails), it's cgroup API
> thing.  cgroup wants to guarantee to the controllers that if multiple
> tasks are migrated together, they always constitute a threadgroup and
> the first one is the leader.  ISTR a controller callback which depends
> on the first one being the leader.
> 

It did serve you right this time. :)

