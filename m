Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaC3QEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 12:04:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24747 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaC3QEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 12:04:42 -0400
Message-ID: <53384080.9020502@oracle.com>
Date: Sun, 30 Mar 2014 12:04:16 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>
CC: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
References: <5308E3AE.3040405@oracle.com>	<20140222205217.GC16272@mtj.dyndns.org>	<20140224120427.6394d5dd@linux.lan.towertech.it>	<5331FA9E.20506@oracle.com> <20140325233936.655a798e@linux.lan.towertech.it> <53321D04.2040102@oracle.com> <5337653D.6020002@oracle.com>
In-Reply-To: <5337653D.6020002@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2014 08:28 PM, Sasha Levin wrote:
> On 03/25/2014 08:19 PM, Sasha Levin wrote:
>> On 03/25/2014 06:39 PM, Alessandro Zummo wrote:
>>> On Tue, 25 Mar 2014 17:52:30 -0400
>>> Sasha Levin <sasha.levin@oracle.com> wrote:
>>>
>>>>>
>>>>>    Pretty interesting indeed. One option would be to remove
>>>>>    the sys files before acquiring the lock. But I wonder
>>>>>    if this could lead to other issues.
>>>>>
>>>>
>>>> Ping? Seems this thing got lost.
>>>
>>>   What if we move
>>>
>>>     rtc_sysfs_del_device(rtc);
>>>
>>>   before acquiring the lock?
>>
>> Trying it now, I'll leave it going for a week and see if it reproduces.
>
> Look good, thanks!

Or not...

Hit it again during overnight fuzzing:


[ 1288.605629] ======================================================
[ 1288.606622] [ INFO: possible circular locking dependency detected ]
[ 1288.607544] 3.14.0-rc8-next-20140328-sasha-00016-geb1c595-dirty #297 Tainted: G
   W
[ 1288.608861] -------------------------------------------------------
[ 1288.609719] trinity-c79/32073 is trying to acquire lock:
[ 1288.610463]  (&rtc->ops_lock){+.+.+.}, at: [<ffffffff9b3683a0>] rtc_read_time+0x30/0x
70
[ 1288.610490]
[ 1288.610490] but task is already holding lock:
[ 1288.610490]  (s_active#19){++++.+}, at: [<ffffffff99391264>] kernfs_seq_start+0x44/0x
a0
[ 1288.610490]
[ 1288.610490] which lock already depends on the new lock.
[ 1288.610490]
[ 1288.610490]
[ 1288.610490] the existing dependency chain (in reverse order) is:
[ 1288.610490]
-> #1 (s_active#19){++++.+}:
[ 1288.610490]        [<ffffffff991c5faa>] lock_acquire+0x19a/0x240
[ 1288.610490]        [<ffffffff9938f690>] __kernfs_remove+0x180/0x320
[ 1288.610490]        [<ffffffff993909dc>] kernfs_remove_by_name_ns+0x7c/0xb0
[ 1288.610490]        [<ffffffff993932e1>] remove_files.isra.1+0x51/0x80
[ 1288.610490]        [<ffffffff99393393>] sysfs_remove_group+0x83/0xb0
[ 1288.610490]        [<ffffffff993933fb>] sysfs_remove_groups+0x3b/0x60
[ 1288.610490]        [<ffffffff9a0caf62>] device_remove_groups+0x12/0x20
[ 1288.610490]        [<ffffffff9a0cafd8>] device_remove_attrs+0x68/0x80
[ 1288.610490]        [<ffffffff9a0cb147>] device_del+0x157/0x1c0
[ 1288.610490]        [<ffffffff9a0cb208>] device_unregister+0x58/0x70
[ 1288.610490]        [<ffffffff9b3677a3>] rtc_device_unregister+0x53/0x80
[ 1288.610490]        [<ffffffff9b36dcc3>] cmos_do_probe+0x3b3/0x400
[ 1288.610490]        [<ffffffff9f35ccf2>] cmos_platform_probe+0x44/0x4d
[ 1288.610490]        [<ffffffff9a0d0b02>] platform_drv_probe+0x32/0x90
[ 1288.610490]        [<ffffffff9a0cee45>] driver_probe_device+0x175/0x370
[ 1288.610490]        [<ffffffff9a0cf0c4>] __driver_attach+0x84/0xc0
[ 1288.610490]        [<ffffffff9a0cccd9>] bus_for_each_dev+0x69/0xb0
[ 1288.610490]        [<ffffffff9a0ce67e>] driver_attach+0x1e/0x20
[ 1288.610490]        [<ffffffff9a0ce2b8>] bus_add_driver+0x138/0x260
[ 1288.610490]        [<ffffffff9a0cf8a8>] driver_register+0x98/0xe0
[ 1288.610490]        [<ffffffff9a0d097a>] __platform_driver_register+0x4a/0x50
[ 1288.610490]        [<ffffffff9a0d09a4>] platform_driver_probe+0x24/0xc0
[ 1288.610490]        [<ffffffff9f35cc4b>] cmos_init+0x3c/0x74
[ 1288.610490]        [<ffffffff9900216a>] do_one_initcall+0xca/0x1d0
[ 1288.610490]        [<ffffffff9f2b7128>] kernel_init_freeable+0x1d5/0x26c
[ 1288.610490]        [<ffffffff9c49baae>] kernel_init+0xe/0x100
[ 1288.610490]        [<ffffffff9c50defc>] ret_from_fork+0x7c/0xb0
[ 1288.610490]
-> #0 (&rtc->ops_lock){+.+.+.}:
[ 1288.610490]        [<ffffffff991c4e24>] __lock_acquire+0x1804/0x2120
[ 1288.610490]        [<ffffffff991c5faa>] lock_acquire+0x19a/0x240
[ 1288.610490]        [<ffffffff9c4ff07f>] mutex_lock_interruptible_nested+0x6f/0x680
[ 1288.610490]        [<ffffffff9b3683a0>] rtc_read_time+0x30/0x70
[ 1288.610490]        [<ffffffff9b36a99a>] date_show+0x1a/0x50
[ 1288.610490]        [<ffffffff9a0c9f50>] dev_attr_show+0x20/0x60
[ 1288.610490]        [<ffffffff993923f8>] sysfs_kf_seq_show+0x98/0x110
[ 1288.610490]        [<ffffffff99390c16>] kernfs_seq_show+0x26/0x30
[ 1288.610490]        [<ffffffff9932ef8c>] seq_read+0x19c/0x3a0
[ 1288.610490]        [<ffffffff99391657>] kernfs_fop_read+0x47/0x160
[ 1288.610490]        [<ffffffff99306034>] vfs_read+0xb4/0x190
[ 1288.610490]        [<ffffffff993062c2>] SyS_read+0x52/0xc0
[ 1288.610490]        [<ffffffff9c50e1d8>] tracesys+0xe1/0xe6
[ 1288.610490]
[ 1288.610490] other info that might help us debug this:
[ 1288.610490]
[ 1288.610490]  Possible unsafe locking scenario:
[ 1288.610490]
[ 1288.610490]        CPU0                    CPU1
[ 1288.610490]        ----                    ----
[ 1288.610490]   lock(s_active#19);
[ 1288.610490]                                lock(&rtc->ops_lock);
[ 1288.610490]                                lock(s_active#19);
[ 1288.610490]   lock(&rtc->ops_lock);
[ 1288.610490]
[ 1288.610490]  *** DEADLOCK ***
[ 1288.610490]
[ 1288.610490] 4 locks held by trinity-c79/32073:
[ 1288.610490]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff99327fb4>] __fdget_pos+0x44/0x50
[ 1288.610490]  #1:  (&p->lock){+.+.+.}, at: [<ffffffff9932ee2d>] seq_read+0x3d/0x3a0
[ 1288.610490]  #2:  (&of->mutex){+.+.+.}, at: [<ffffffff9939125c>] kernfs_seq_start+0x3c/0xa0
[ 1288.610490]  #3:  (s_active#19){++++.+}, at: [<ffffffff99391264>] kernfs_seq_start+0x44/0xa0
[ 1288.610490]
[ 1288.610490] stack backtrace:
[ 1288.610490] CPU: 1 PID: 32073 Comm: trinity-c79 Tainted: G        W     3.14.0-rc8-next-20140328-sasha-00016-geb1c595-dirty #297
[ 1288.610490]  ffffffff9f9efb40 ffff88062c785ad8 ffffffff9c4b8507 0000000000000000
[ 1288.610490]  ffffffff9f9efb40 ffff88062c785b28 ffffffff9c4ab007 0000000000000004
[ 1288.610490]  ffff88062c785bb8 ffff88062c785b28 ffff88062c630d98 ffff88062c630dd0
[ 1288.610490] Call Trace:
[ 1288.610490]  [<ffffffff9c4b8507>] dump_stack+0x4f/0x7c
[ 1288.610490]  [<ffffffff9c4ab007>] print_circular_bug+0x1fb/0x20c
[ 1288.610490]  [<ffffffff991c4e24>] __lock_acquire+0x1804/0x2120
[ 1288.610490]  [<ffffffff990b9b84>] ? kvm_clock_read+0x24/0x40
[ 1288.610490]  [<ffffffff9907aab5>] ? sched_clock+0x15/0x20
[ 1288.610490]  [<ffffffff991c5faa>] lock_acquire+0x19a/0x240
[ 1288.610490]  [<ffffffff9b3683a0>] ? rtc_read_time+0x30/0x70
[ 1288.610490]  [<ffffffff9c4ff07f>] mutex_lock_interruptible_nested+0x6f/0x680
[ 1288.610490]  [<ffffffff9b3683a0>] ? rtc_read_time+0x30/0x70
[ 1288.610490]  [<ffffffff9c4aec22>] ? __slab_alloc+0x5c8/0x637
[ 1288.610490]  [<ffffffff9b3683a0>] ? rtc_read_time+0x30/0x70
[ 1288.610490]  [<ffffffff9b3683a0>] rtc_read_time+0x30/0x70
[ 1288.610490]  [<ffffffff9b36a99a>] date_show+0x1a/0x50
[ 1288.610490]  [<ffffffff9a0c9f50>] dev_attr_show+0x20/0x60
[ 1288.610490]  [<ffffffff993922a5>] ? sysfs_file_ops+0x35/0x80
[ 1288.610490]  [<ffffffff993923f8>] sysfs_kf_seq_show+0x98/0x110
[ 1288.610490]  [<ffffffff99390c16>] kernfs_seq_show+0x26/0x30
[ 1288.610490]  [<ffffffff9932ef8c>] seq_read+0x19c/0x3a0
[ 1288.610490]  [<ffffffff99391657>] kernfs_fop_read+0x47/0x160
[ 1288.610490]  [<ffffffff99306034>] vfs_read+0xb4/0x190
[ 1288.610490]  [<ffffffff993062c2>] SyS_read+0x52/0xc0
[ 1288.610490]  [<ffffffff9c50e1d8>] tracesys+0xe1/0xe6


Thanks,
Sasha
