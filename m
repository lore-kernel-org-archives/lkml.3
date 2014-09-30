Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaI3ROM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:14:12 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60907 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI3ROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140930081637.GA4456@dhcp22.suse.cz>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
	<20140930081637.GA4456@dhcp22.suse.cz>
Date: Tue, 30 Sep 2014 10:14:08 -0700
Message-ID: <CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
Subject: Re: Please backport commit 3812c8c8f39 to stable
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 1:16 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 29-09-14 20:43:46, Cong Wang wrote:
>> Hi, Johannes and Greg
>>
>>
>> Please consider to backport the following commit to stable kernels < 3.12.
>>
>> commit 3812c8c8f3953921ef18544110dafc3505c1ac62
>> Author: Johannes Weiner <hannes@cmpxchg.org>
>> Date:   Thu Sep 12 15:13:44 2013 -0700
>>
>>     mm: memcg: do not trap chargers with full callstack on OOM
>>
>> It should solve some soft lockup I observed on different machines
>> recently. For me myself, I only care about 3.10. :-p
>
> Could you be more specific about the soft lockup you are seeing?
>

Sure, almost same with the one in that changelog, this is why I
didn't provide it in my previous email. See the bottom of this email
for details.

Note, I am not entirely sure it is because OOM killer tried to kill
the one sleeping on inode mutex which caused the deadlock,
it may be because OOM killer failed to kill some frozen process
too as I saw many processes got frozen. If it is this case, we will
need my patch: https://lkml.org/lkml/2014/9/4/646.

But anyway, that commit definitely fixes some real soft lockups,
which could be a stable candidate although it is a large one.
I am willing to help if needed.

Thanks!

---------------------->

[8073927.905238] INFO: task mesos-slave:10041 blocked for more than 120 seconds.
[8073927.905241] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[8073927.905243] mesos-slave     D ffff88081bf46060     0 10041  10030
0x00000000
[8073927.905247]  ffff8808208bddb8 0000000000000082 ffff8808545e2e40
ffff8808208bdfd8
[8073927.905252]  ffff8808208bdfd8 0000000000012a00 ffff88081bf45c80
ffff88081bf45c80
[8073927.905255]  ffff880da4351f94 ffff880da4351f90 ffff880da4351f98
0000000000000000
[8073927.905258] Call Trace:
[8073927.905267]  [<ffffffff814a40a6>] schedule+0x69/0x6b
[8073927.905270]  [<ffffffff814a4484>] schedule_preempt_disabled+0xe/0x10
[8073927.905273]  [<ffffffff814a3287>] __mutex_lock_common.isra.9+0x148/0x1d6
[8073927.905278]  [<ffffffff811ec271>] ? security_inode_permission+0x1c/0x21
[8073927.905281]  [<ffffffff814a3401>] __mutex_lock_slowpath+0x13/0x15
[8073927.905284]  [<ffffffff814a3102>] mutex_lock+0x1f/0x2f
[8073927.905287]  [<ffffffff81134f3c>] vfs_unlink+0x44/0xb7
[8073927.905289]  [<ffffffff8113508b>] do_unlinkat+0xdc/0x17f
[8073927.905292]  [<ffffffff814a426d>] ? _cond_resched+0xe/0x1e
[8073927.905295]  [<ffffffff81058252>] ? task_work_run+0x82/0x94
[8073927.905300]  [<ffffffff81002811>] ? do_notify_resume+0x57/0x65
[8073927.905303]  [<ffffffff81135ca4>] SyS_unlink+0x16/0x18
[8073927.905307]  [<ffffffff814aba46>] system_call_fastpath+0x1a/0x1f


sysrq-t output:

[8821221.981672] mesos-slave     D ffff88081bf46060     0 10041  10030
0x00000000
[8821221.981674]  ffff8808208bddb8 0000000000000082 ffff8808545e2e40
ffff8808208bdfd8
[8821221.981677]  ffff8808208bdfd8 0000000000012a00 ffff88081bf45c80
ffff88081bf45c80
[8821221.981679]  ffff880da4351f94 ffff880da4351f90 ffff880da4351f98
0000000000000000
[8821221.981682] Call Trace:
[8821221.981685]  [<ffffffff814a40a6>] schedule+0x69/0x6b
[8821221.981687]  [<ffffffff814a4484>] schedule_preempt_disabled+0xe/0x10
[8821221.981690]  [<ffffffff814a3287>] __mutex_lock_common.isra.9+0x148/0x1d6
[8821221.981693]  [<ffffffff811ec271>] ? security_inode_permission+0x1c/0x21
[8821221.981696]  [<ffffffff814a3401>] __mutex_lock_slowpath+0x13/0x15
[8821221.981698]  [<ffffffff814a3102>] mutex_lock+0x1f/0x2f
[8821221.981701]  [<ffffffff81134f3c>] vfs_unlink+0x44/0xb7
[8821221.981703]  [<ffffffff8113508b>] do_unlinkat+0xdc/0x17f
[8821221.981705]  [<ffffffff814a426d>] ? _cond_resched+0xe/0x1e
[8821221.981707]  [<ffffffff81058252>] ? task_work_run+0x82/0x94
[8821221.981711]  [<ffffffff81002811>] ? do_notify_resume+0x57/0x65
[8821221.981714]  [<ffffffff81135ca4>] SyS_unlink+0x16/0x18
[8821221.981716]  [<ffffffff814aba46>] system_call_fastpath+0x1a/0x1f
[...]
[8821221.986069] python2.6       D ffff881054386060     0 41843  10049
0x00000004
[8821221.986071]  ffff8809677f5930 0000000000000082 ffff880eedf0ae40
ffff8809677f5fd8
[8821221.986074]  ffff8809677f5fd8 0000000000012a00 ffff881054385c80
000000030d5d1e86
[8821221.986077]  ffff88084ea73000 ffff88084ea73000 ffff88041ef49720
ffff88084ea73000
[8821221.986080] Call Trace:
[8821221.986082]  [<ffffffff814a40a6>] schedule+0x69/0x6b
[8821221.986085]  [<ffffffff814a2e24>] schedule_timeout+0xf3/0x129
[8821221.986087]  [<ffffffff810499ce>] ? __internal_add_timer+0xb6/0xb6
[8821221.986090]  [<ffffffff814a2eb8>]
schedule_timeout_uninterruptible+0x1e/0x20
[8821221.986092]  [<ffffffff811232d3>] __mem_cgroup_try_charge+0x3ea/0x8ff
[8821221.986095]  [<ffffffff81122d7a>] ? mem_cgroup_reclaim+0xb2/0xb2
[8821221.986097]  [<ffffffff81123c2a>] mem_cgroup_charge_common+0x35/0x5d
[8821221.986100]  [<ffffffff811250aa>] mem_cgroup_cache_charge+0x51/0x81
[8821221.986103]  [<ffffffff810e237d>] add_to_page_cache_locked+0x3b/0x104
[8821221.986106]  [<ffffffff810e245e>] add_to_page_cache_lru+0x18/0x39
[8821221.986110]  [<ffffffff810e278a>] grab_cache_page_write_begin+0x87/0xb7
[8821221.986113]  [<ffffffff81190c20>] ext4_write_begin+0xef/0x28b
[8821221.986116]  [<ffffffff810e1adc>] generic_file_buffered_write+0xfd/0x20c
[8821221.986119]  [<ffffffff8113c8fb>] ? update_time+0xa2/0xa9
[8821221.986122]  [<ffffffff810e3375>] __generic_file_aio_write+0x1c0/0x1f8
[8821221.986124]  [<ffffffff810e3408>] generic_file_aio_write+0x5b/0xa9
[8821221.986127]  [<ffffffff8118951f>] ext4_file_write+0x2e5/0x376
[8821221.986129]  [<ffffffff8100665c>] ? emulate_vsyscall+0x212/0x2f6
[8821221.986132]  [<ffffffff8149ae9f>] ? __bad_area_nosemaphore+0xb4/0x1bf
[8821221.986135]  [<ffffffff81128ee1>] do_sync_write+0x68/0x95
[8821221.986138]  [<ffffffff81129566>] vfs_write+0xb2/0x117
[8821221.986141]  [<ffffffff81129bb9>] SyS_write+0x46/0x74
[8821221.986144]  [<ffffffff814aba46>] system_call_fastpath+0x1a/0x1f
