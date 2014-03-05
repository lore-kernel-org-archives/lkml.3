Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaCEA6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:58:24 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:38925 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaCEA6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:58:22 -0500
Message-ID: <53167662.5000801@huawei.com>
Date: Wed, 5 Mar 2014 08:57:06 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com> <20140303223327.GB26523@mtj.dyndns.org> <5315057F.3030602@oracle.com> <20140303224505.GE26523@mtj.dyndns.org> <53150989.70307@oracle.com> <53160B6D.8020501@oracle.com> <20140304194741.GA2204@htj.dyndns.org>
In-Reply-To: <20140304194741.GA2204@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/5 3:47, Tejun Heo wrote:
> On Tue, Mar 04, 2014 at 12:20:45PM -0500, Sasha Levin wrote:
>>> Hrm... there is a PF_EXITING check there already:
>>>
>>>     #define task_css_set_check(task, __c)            \
>>>         rcu_dereference_check((task)->cgroups,        \
>>>         lockdep_is_held(&cgroup_mutex) ||        \
>>>         lockdep_is_held(&css_set_rwsem) ||        \
>>>         ((task)->flags & PF_EXITING) || (__c))
>>>
>>> I see it's not happening on Linus's master so I'll run a bisection to figure out what broke it.
>>
>> Hi Tejun,
>>
>> It bisects down to your patch: "cgroup: drop task_lock() protection
>> around task->cgroups". I'll look into it later unless it's obvious
>> to you.
> 
> Hmmm... maybe I'm confused and PF_EXITING is not set there and
> task_lock was what held off the lockdep warning.  Confused....
> 

Because this cgroup_exit() is called in a failure path in copy_process().

