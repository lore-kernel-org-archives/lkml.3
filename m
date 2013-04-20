Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453Ab3DTBWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 21:22:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55430 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965307Ab3DTBWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 21:22:13 -0400
Message-ID: <5171EDC1.4070805@huawei.com>
Date: Sat, 20 Apr 2013 09:22:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 09/10] cpuset: allow to keep tasks in empty cpusets
References: <517137A7.4020605@huawei.com> <517138A4.3070209@huawei.com> <20130419205821.GA15543@mtj.dyndns.org>
In-Reply-To: <20130419205821.GA15543@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/20 4:58, Tejun Heo wrote:
> Hello,
> 
> On Fri, Apr 19, 2013 at 08:29:24PM +0800, Li Zefan wrote:
>> +static void update_tasks_cpumask_hier(struct cpuset *root_cs,
>> +				      bool update_root, struct ptr_heap *heap)
>> +{
>> +	struct cpuset *cp;
>> +	struct cgroup *pos_cgrp;
>> +
>> +	if (update_root)
>> +		update_tasks_cpumask(root_cs, heap);
>> +
>> +	rcu_read_lock();
>> +	cpuset_for_each_descendant_pre(cp, pos_cgrp, root_cs) {
>> +		/* skip the whole subtree if @cp have some CPU */
>> +		if (!cpumask_empty(cp->cpus_allowed)) {
>> +			pos_cgrp = cgroup_rightmost_descendant(pos_cgrp);
>> +			continue;
>> +		}
>> +
>> +		update_tasks_cpumask(cp, heap);
>> +	}
>> +	rcu_read_unlock();
> 
> I don't think we can call update_tasks_cpumask() under
> rcu_read_lock().  It calls into set_cpus_allowed_ptr() which may
> block, so you'll probably have to punt it to a work item like how

Oh, will fix.

> migration is being done.  Another approach would be converting cgroup
> to use SRCU instead, which would lessen pain on other places too.  The
> only problem there would be that srcu_read_lock() is a bit more
> expensive than rcu_read_lock().  I'm not sure whether that'd show up
> in some hot path or not.  Ideas?
> 

I guess we can live with rcu_read_lock() for now, and see if we can
change it to srcu when other significant changes are done in all
cgroup controllers. (hierarchy support in blkcg, etc..)

