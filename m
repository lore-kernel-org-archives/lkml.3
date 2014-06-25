Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaFYB4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:56:51 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:51318 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaFYB4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:56:50 -0400
Message-ID: <53AA2C4F.30808@huawei.com>
Date: Wed, 25 Jun 2014 09:56:31 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
References: <53994943.60703@huawei.com> <539949A1.90301@huawei.com> <20140620193521.GB28324@mtj.dyndns.org> <53A8D2B8.4080107@huawei.com> <20140624210119.GC14909@htj.dyndns.org>
In-Reply-To: <20140624210119.GC14909@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53AA2C53.00A6,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: f01f84052cc1bb9fda976dd61b5c00ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/25 5:01, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Jun 24, 2014 at 09:22:00AM +0800, Li Zefan wrote:
>>> Ah, right.  Gees, I'm really hating the fact that we have ->mount but
>>> not ->umount.  However, can't we make it a bit simpler by just
>>> introducing a mutex protecting looking up and refing up an existing
>>> root and a sb going away?  The only problem is that the refcnt being
>>> killed isn't atomic w.r.t. new live ref coming up, right?  Why not
>>> just add a mutex around them so that they can't race?
>>
>> Well, kill_sb() is called with sb->s_umount held, while kernfs_mount()
>> returned with sb->s_umount held, so adding a mutex will lead to ABBA
>> deadlock.
> 
> Hmmm?  Why does that matter?  The only region in cgroup_mount() which
> needs to be put inside such mutex would be root lookup, no?
> 

unfortunately that won't help. I think what you suggest is:

cgroup_mount()
{
	mutex_lock();
	lookup_cgroup_root();
	mutex_unlock();
	kernfs_mount();
}

cgroup_kill_sb()
{
	mutex_lock();
	percpu_ref_kill();
	mutex_Unlock();
	kernfs_kill_sb();
}

See, we may still be destroying the superblock after we've succeeded
in getting the refcnt of cgroup root.

