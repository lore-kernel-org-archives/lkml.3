Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaBYIx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:53:27 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:17175 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaBYIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:53:25 -0500
Message-ID: <530C5977.4090402@huawei.com>
Date: Tue, 25 Feb 2014 16:51:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [cgroup/task_lock] INFO: suspicious RCU usage.
References: <20140221021622.GB13515@localhost> <20140221154025.GB460@htj.dyndns.org>
In-Reply-To: <20140221154025.GB460@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/21 23:40, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 21, 2014 at 10:16:22AM +0800, Fengguang Wu wrote:
>> commit fb47fea7a59cf3d6387c566084a6684b5005af83
>> Author:     Tejun Heo <tj@kernel.org>
>> AuthorDate: Thu Feb 13 15:16:35 2014 -0500
>> Commit:     Tejun Heo <tj@kernel.org>
>> CommitDate: Thu Feb 13 15:16:35 2014 -0500
>>
>>     cgroup: drop task_lock() protection around task->cgroups
>>     
>>     For optimization, task_lock() is additionally used to protect
>>     task->cgroups.  The optimization is pretty dubious as either
>>     css_set_rwsem is grabbed anyway or PF_EXITING already protects
>>     task->cgroups.  It adds only overhead and confusion at this point.
>>     Let's drop task_[un]lock() and update comments accordingly.
>>     
>>     Signed-off-by: Tejun Heo <tj@kernel.org>
>>
>> [main] Setsockopt(1 2b 80d1000 4) on fd 223 [17:2:768]
>> [   27.030764] 
>> [   27.031119] ===============================
>> [   27.031833] [ INFO: suspicious RCU usage. ]
>> [   27.032536] 3.14.0-rc3-02458-g837caba #2 Not tainted
>> [   27.033378] -------------------------------
>> [   27.044237] include/linux/cgroup.h:697 suspicious rcu_dereference_check() usage!
>> [   27.045795] 
>> [   27.045795] other info that might help us debug this:
>> [   27.045795] 
>> [   27.047114] 
>> [   27.047114] rcu_scheduler_active = 1, debug_locks = 0
>> [main] Setsockopt(1 c 80d1000 4) on fd 225 [39:5:0]
>> [   27.048751] 2 locks held by trinity-c0/4479:
>> [   27.049478]  #0:  (callback_mutex){+.+...}, at: [<81118395>] cpuset_cpus_allowed+0x1e/0x123
>> [   27.051132]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<8111839c>] cpuset_cpus_allowed+0x25/0x123
>> [   27.052788] 
>> [   27.052788] stack backtrace:
>> [   27.053528] CPU: 0 PID: 4479 Comm: trinity-c0 Not tainted 3.14.0-rc3-02458-g837caba #2
>> [   27.064971]  00000000 00000000
>>  919eff28 81877cc3[main] Setsockopt(1 7 80d1000 4) on fd 226 [1:5:1]
> 
> So, this is from removing task_lock from task_css_set_check() and
> adding rcu_read_lock() in cpuset_cpus_allowed() should fix it.

Yeah, rcu_read_lock() should be sufficient.

> I'm
> not sure how much of task_lock() locking we currently have in cpuset
> is actually necessary tho.  Shouldn't we be able to do most with just
> callback_mutex, if not cpuset_mutex?  Li, any ideas?
> 

task_lock() is also used to protect task->mems_allowed. I'll see if we
can get rid of most (if not all) task_lock() lockings in cpuset.

