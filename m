Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaFXBWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 21:22:09 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11249 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaFXBWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 21:22:08 -0400
Message-ID: <53A8D2B8.4080107@huawei.com>
Date: Tue, 24 Jun 2014 09:22:00 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
References: <53994943.60703@huawei.com> <539949A1.90301@huawei.com> <20140620193521.GB28324@mtj.dyndns.org>
In-Reply-To: <20140620193521.GB28324@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/21 3:35, Tejun Heo wrote:
> Hello, Li.
> 
> Sorry about the long delay.
> 
> On Thu, Jun 12, 2014 at 02:33:05PM +0800, Li Zefan wrote:
>> We've converted cgroup to kernfs so cgroup won't be intertwined with
>> vfs objects and locking, but there are dark areas.
>>
>> Run two instances of this script concurrently:
>>
>>     for ((; ;))
>>     {
>>     	mount -t cgroup -o cpuacct xxx /cgroup
>>     	umount /cgroup
>>     }
>>
>> After a while, I saw two mount processes were stuck at retrying, because
>> they were waiting for a subsystem to become free, but the root associated
>> with this subsystem never got freed.
>>
>> This can happen, if thread A is in the process of killing superblock but
>> hasn't called percpu_ref_kill(), and at this time thread B is mounting
>> the same cgroup root and finds the root in the root list and performs
>> percpu_ref_try_get().
>>
>> To fix this, we increase the refcnt of the superblock instead of increasing
>> the percpu refcnt of cgroup root.
> 
> Ah, right.  Gees, I'm really hating the fact that we have ->mount but
> not ->umount.  However, can't we make it a bit simpler by just
> introducing a mutex protecting looking up and refing up an existing
> root and a sb going away?  The only problem is that the refcnt being
> killed isn't atomic w.r.t. new live ref coming up, right?  Why not
> just add a mutex around them so that they can't race?
> 

Well, kill_sb() is called with sb->s_umount held, while kernfs_mount()
returned with sb->s_umount held, so adding a mutex will lead to ABBA
deadlock.

