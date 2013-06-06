Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab3FFK1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:27:17 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:33410 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab3FFK1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:27:14 -0400
Message-ID: <51B063E6.30107@huawei.com>
Date: Thu, 6 Jun 2013 18:26:46 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v2 08/10] cpuset: allow to keep tasks in empty cpusets
References: <51AF0183.8070602@huawei.com> <51AF020B.3030701@huawei.com> <20130605205146.GI10693@mtj.dyndns.org>
In-Reply-To: <20130605205146.GI10693@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/6 4:51, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Jun 05, 2013 at 05:16:59PM +0800, Li Zefan wrote:
>> @@ -2092,11 +2183,13 @@ static void cpuset_propagate_hotplug_workfn(struct work_struct *work)
>>  	mutex_unlock(&cpuset_mutex);
>>  
>>  	/*
>> -	 * If @cs became empty, move tasks to the nearest ancestor with
>> -	 * execution resources.  This is full cgroup operation which will
>> +	 * If sane_behavior flag is set, we'll keep tasks in empty cpusets.
>> +	 *
>> +	 * Otherwise move tasks to the nearest ancestor with execution
>> +	 *  resources.  This is full cgroup operation which will
>>  	 * also call back into cpuset.  Should be done outside any lock.
>>  	 */
>> -	if (is_empty)
>> +	if (!sane && is_empty)
>>  		remove_tasks_in_empty_cpuset(cs);
>>  
>>  	/* the following may free @cs, should be the last operation */
>> @@ -2171,6 +2264,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>>  		cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
>>  		mutex_unlock(&callback_mutex);
>>  		/* we don't mess with cpumasks of tasks in top_cpuset */
>> +		update_tasks_cpumask_hier(&top_cpuset, false, NULL);
>>  	}
> 
> I'm a little confused by the order of operation.  We now have two
> different hierarchical walks for hotplug propagation, right?  I
> suppose the above one is added because we now also need to update the
> mask when cpus are being brought online?
> 

The first one will only update tasks in empty cpusets (no matter online or
offline), and the second one will only update tasks in non-empty cpusets
(only when offline).

> I wonder whether it'd be possible to merge the two paths.  My
> suspicion is that we probably don't need propagate_hotplug_work
> anymore now that we can drop RCU read lock while doing the pre-order
> walk.  What do you think?
> 

It indeed can be confusing. I'll see if we can make the code clearer.

