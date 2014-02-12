Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaBLCRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:17:03 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:58801 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaBLCRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:17:01 -0500
Message-ID: <52FAD958.6020505@huawei.com>
Date: Wed, 12 Feb 2014 10:15:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: protect modifications to
 cgroup_idr with cgroup_mutex
References: <52F9D9DA.7040108@huawei.com> <20140211154105.GC24490@htj.dyndns.org> <20140211162625.GP11946@dhcp22.suse.cz>
In-Reply-To: <20140211162625.GP11946@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/12 0:26, Michal Hocko wrote:
> On Tue 11-02-14 10:41:05, Tejun Heo wrote:
> [...]
>> @@ -4254,12 +4256,12 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>>  
>>  	return 0;
>>  
>> -err_unlock:
>> -	mutex_unlock(&cgroup_mutex);
>> -	/* Release the reference count that we took on the superblock */
>> -	deactivate_super(sb);
>>  err_free_id:
>>  	idr_remove(&root->cgroup_idr, cgrp->id);
>> +	/* Release the reference count that we took on the superblock */
>> +	deactivate_super(sb);
>> +err_unlock:
>> +	mutex_unlock(&cgroup_mutex);
>>  err_free_name:
>>  	kfree(rcu_dereference_raw(cgrp->name));
>>  err_free_cgrp:
> 
> Do I have to change deactivate_super vs. mutex_unlock ordering in my
> backport for 3.12 as well?
> 

Your change is wrong that you shouldn't drop sb refcnt in err_unlock path.

But you made me think if it's OK to hold cgroup_mutex while calling deactivate_super(),
and the answer is NO! deactive_super() may call cgroup_kill_sb() which will
acquire cgroup_mutex.

I'll update the patch.

Thank Tejun we won't be entangled with vfs internal anymore after coverting
to kernfs.

