Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaCDRU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:20:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25673 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaCDRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:20:56 -0500
Message-ID: <53160B6D.8020501@oracle.com>
Date: Tue, 04 Mar 2014 12:20:45 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com> <20140303223327.GB26523@mtj.dyndns.org> <5315057F.3030602@oracle.com> <20140303224505.GE26523@mtj.dyndns.org> <53150989.70307@oracle.com>
In-Reply-To: <53150989.70307@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 06:00 PM, Sasha Levin wrote:
> On 03/03/2014 05:45 PM, Tejun Heo wrote:
>> On Mon, Mar 03, 2014 at 05:43:11PM -0500, Sasha Levin wrote:
>>> On 03/03/2014 05:33 PM, Tejun Heo wrote:
>>>> On Sat, Mar 01, 2014 at 10:00:11PM -0500, Sasha Levin wrote:
>>>>> rcu read lock should be held when calling and working with task_css_set.
>>>>>
>>>>> This patch also fixes a related lockdep warning.
>>>>
>>>> Hmmm... PF_EXITING should be visible at that point and cset can't
>>>> change anymore.  We prolly need to update lockdep annotation rather
>>>> than adding spurious rcu locking around it.  Against which branch is
>>>> it?  Can you please post the lockdep warning?
>>>
>>> I see it on -next.
>>
>> I think the right thing to do is using task_css_set_check() with
>> PF_EXITING check and add comment explaining that cset can no longer
>> change.  Can you please write up a patch?
>
> Hrm... there is a PF_EXITING check there already:
>
>      #define task_css_set_check(task, __c)            \
>          rcu_dereference_check((task)->cgroups,        \
>          lockdep_is_held(&cgroup_mutex) ||        \
>          lockdep_is_held(&css_set_rwsem) ||        \
>          ((task)->flags & PF_EXITING) || (__c))
>
> I see it's not happening on Linus's master so I'll run a bisection to figure out what broke it.

Hi Tejun,

It bisects down to your patch: "cgroup: drop task_lock() protection around task->cgroups". I'll
look into it later unless it's obvious to you.


Thanks,
Sasha

