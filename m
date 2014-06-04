Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaFDIlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:41:20 -0400
Received: from [119.145.14.66] ([119.145.14.66]:57945 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaFDIlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:41:16 -0400
Message-ID: <538EDB7C.2070405@huawei.com>
Date: Wed, 4 Jun 2014 16:40:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/3] cgroup: don't destroy the default root
References: <538D4956.5050205@huawei.com> <20140603125728.GA26210@htj.dyndns.org>
In-Reply-To: <20140603125728.GA26210@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/3 20:57, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Jun 03, 2014 at 12:04:38PM +0800, Li Zefan wrote:
>>  static void cgroup_get(struct cgroup *cgrp)
>>  {
>>  	WARN_ON_ONCE(cgroup_is_dead(cgrp));
>> -	css_get(&cgrp->self);
>> +	if (!(cgrp->self.flags & CSS_NO_REF))
>> +		css_get(&cgrp->self);
> 
> Hmmm?  The same condition is tested by css_get().  Why should it be
> tested again here?
> 

Oh, I completely ignored that.

>>  static void cgroup_put(struct cgroup *cgrp)
>>  {
>> -	css_put(&cgrp->self);
>> +	if (!(cgrp->self.flags & CSS_NO_REF))
>> +		css_put(&cgrp->self);
> 
> Ditto.
> 
>> @@ -1781,10 +1783,12 @@ static void cgroup_kill_sb(struct super_block *sb)
>>  	 * This prevents new mounts by disabling percpu_ref_tryget_live().
>>  	 * cgroup_mount() may wait for @root's release.
>>  	 */
>> -	if (css_has_online_children(&root->cgrp.self))
>> +	if (css_has_online_children(&root->cgrp.self)) {
>>  		cgroup_put(&root->cgrp);
>> -	else
>> -		percpu_ref_kill(&root->cgrp.self.refcnt);
>> +	} else {
>> +		if (root != &cgrp_dfl_root)
>> +			percpu_ref_kill(&root->cgrp.self.refcnt);
>> +	}
> 
> As conceptually percpu_ref_kill() just puts the base ref and the
> dfl_root's refcnt never reaches zero, it won't actually trigger.

Yes it will, just try mount && umount.

I think it's because cgroup_get() is a no-op for CSS_NO_REF, so it has
only the base ref, so percpu_ref_iill() will actually schedule the
call to css_release().

> Hmmm.... wouldn't the above leak a ref each time the default hierarchy
> is unmounted tho?  Shouldn't it be like the following?
> 

cgroup_get() is a no-op for root cgroup of the default root, so there's
no leak, but still better to call cgroup_put().

I'll send an updated patch.

> 	if (root == &cgrp_dfl_root || css_has_online_children(...))
> 		cgroup_put(&root->cgrp);
> 	else
> 		percpu_ref_kill(...);
> 
> Thanks.
> 

