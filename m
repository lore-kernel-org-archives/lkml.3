Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaF0Gcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:32:42 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:48465 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF0Gck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:32:40 -0400
Message-ID: <53AD1001.4090405@huawei.com>
Date: Fri, 27 Jun 2014 14:32:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
References: <53994943.60703@huawei.com> <539949A1.90301@huawei.com> <20140620193521.GB28324@mtj.dyndns.org> <53A8D2B8.4080107@huawei.com> <20140624210119.GC14909@htj.dyndns.org> <53AA2C4F.30808@huawei.com> <20140625150053.GE26883@htj.dyndns.org>
In-Reply-To: <20140625150053.GE26883@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.53AD1003.00A4,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: f01f84052cc1bb9fda976dd61b5c00ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/25 23:00, Tejun Heo wrote:
> Hey,
> 
> On Wed, Jun 25, 2014 at 09:56:31AM +0800, Li Zefan wrote:
>>> Hmmm?  Why does that matter?  The only region in cgroup_mount() which
>>> needs to be put inside such mutex would be root lookup, no?
>>
>> unfortunately that won't help. I think what you suggest is:
>>
>> cgroup_mount()
>> {
>> 	mutex_lock();
>> 	lookup_cgroup_root();
>> 	mutex_unlock();
>> 	kernfs_mount();
>> }
>>
>> cgroup_kill_sb()
>> {
>> 	mutex_lock();
>> 	percpu_ref_kill();
>> 	mutex_Unlock();
>> 	kernfs_kill_sb();
>> }
>>
>> See, we may still be destroying the superblock after we've succeeded
>> in getting the refcnt of cgroup root.
> 
> Sure, but now the decision to kill is synchronized so the other side
> can interlock with it.  e.g.
> 
> cgroup_mount()
> {
> 	mutex_lock();
> 	lookup_cgroup_root();
> 	if (root isn't killed yet)
> 		root->this_better_stay_alive++;
> 	mutex_unlock();
> 	kernfs_mount();
> }
> 
> cgroup_kill_sb()
> {
> 	mutex_lock();
> 	if (check whether root can be killed)
> 		percpu_ref_kill();
> 	mutex_unlock();
> 	if (the above condition was true)
> 		kernfs_kill_sb();
> }
> 

This looks nasty, and I don't think it's correct. If we skip the call
to kernfs_kill_sb(), kernfs_super_info won't be freed but super_block
will, so we will end up either leaking memory or accessing invalid
memory. There are other problems like returning with sb->s_umount still
held.

