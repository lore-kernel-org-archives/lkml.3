Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbaCYRvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:51:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbaCYRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:51:46 -0400
Message-ID: <5331C20F.5010109@oracle.com>
Date: Tue, 25 Mar 2014 13:51:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
References: <20140303214040.GA15265@quack.suse.cz> <53166920.709@oracle.com> <20140305124536.GA32371@quack.suse.cz> <53189BF8.1010308@oracle.com> <531A7CFD.9030603@oracle.com> <20140310104350.GB28797@quack.suse.cz> <531DC89A.9010601@oracle.com> <53304451.7030800@oracle.com> <20140324214851.GB10057@quack.suse.cz> <5330D15E.2000702@oracle.com> <20140325173340.GB17292@quack.suse.cz>
In-Reply-To: <20140325173340.GB17292@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 01:33 PM, Jan Kara wrote:
> On Mon 24-03-14 20:44:14, Sasha Levin wrote:
>> On 03/24/2014 05:48 PM, Jan Kara wrote:
>>>>> [  339.948946] ** 4194304 ffff8805ac03ba38 [eventpoll] ffff8806ec051fe0
>>>>> [eventpoll] ffffffff84666040 ffff88056c73e7b0           (null)
>>>    OK, great. So finally we have something useful. We know we have problems
>>> with [eventpoll] dentry. That is actually a special filesystem not mounted
>>> anywhere - likely you get to that dentry through/proc/<pid>/fd/. Now
>>> eventpoll is interesting because it uses single anon inode for all
>>> eventpoll instances. And that inode should stay in place as long as
>>> eventpoll filesystem exists. So it's not clear how come that inode is
>>> freed. The basic check of handling of inode use count didn't find anything
>>> suspicious. But I can check in more detail and if I fail, we now have a
>>> pretty narrow area where to look...
>>
>> Seems like it's not specific to eventpoll, I saw the same error message with
>> "eventfd" and "perf_event".
>    Yup, all these use anon_inode_getfile() so it all points to the fact that
> for some reason we freed anon_inode_inode. But I don't see where the
> problem is. Can you maybe make 'anon_inode_inode' external to
> fs/anon_inodes.c and dump stack for all iput() calls to anon_inode_inode?
> There must be some suckers which don't belong there...

Okay, this is straightforward. It happened right after boot so we're lucky.

I'm also looking into that, but odds you'll spot the issue faster than me.


[  396.414556] CPU: 6 PID: 9838 Comm: trinity-c99 Tainted: G        W     3.14.0-rc7-next-20140325-sasha-00015-g142d039-dirty #275
[  396.415969]  0000000000000000 ffff88012554dd78 ffffffff844bd702 0000000000000001
[  396.417776]  ffff880bec133fc0 ffff88012554dda8 ffffffff8132db8e ffff8801ec065100
[  396.421972]  0000000000000000 ffff880bec133fc0 ffff8801ec065190 ffff88012554dde8
[  396.425483] Call Trace:
[  396.426543]  [<ffffffff844bd702>] dump_stack+0x4f/0x7c
[  396.428485]  [<ffffffff8132db8e>] iput+0x2e/0x1a0
[  396.429964]  [<ffffffff81327660>] dentry_kill+0x1b0/0x240
[  396.431414]  [<ffffffff813277fe>] dput+0x10e/0x130
[  396.433203]  [<ffffffff8130ffd7>] __fput+0x297/0x2e0
[  396.435423]  [<ffffffff8131006e>] ____fput+0xe/0x10
[  396.436233]  [<ffffffff811850ee>] task_work_run+0xae/0xf0
[  396.437842]  [<ffffffff8115e9c8>] do_exit+0x4a8/0xc80
[  396.439770]  [<ffffffff81b37003>] ? __this_cpu_preempt_check+0x13/0x20
[  396.442399]  [<ffffffff811c28f4>] ? trace_hardirqs_on_caller+0x1f4/0x290
[  396.444903]  [<ffffffff811c299d>] ? trace_hardirqs_on+0xd/0x10
[  396.446929]  [<ffffffff8115f274>] do_group_exit+0x84/0xd0
[  396.448845]  [<ffffffff8115f2d7>] SyS_exit_group+0x17/0x20
[  396.451430]  [<ffffffff84513258>] tracesys+0xe1/0xe6

[...]

[  396.896374] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  396.899164] Dumping ftrace buffer:
[  396.900236]    (ftrace buffer empty)
[  396.900236] Modules linked in:
[  396.900236] CPU: 2 PID: 9737 Comm: trinity-c2 Tainted: G        W     3.14.0-rc7-next-20140325-sasha-00015-g142d039-dirty #275
[  396.900236] task: ffff88012c790000 ti: ffff88012b992000 task.ti: ffff88012b992000
[  396.900236] RIP: 0010:[<ffffffff8133e85c>]  [<ffffffff8133e85c>] __mark_inode_dirty+0x10c/0x4a0
[  396.900236] RSP: 0018:ffff88012b993dd8  EFLAGS: 00010206
[  396.900236] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880bec133fc0 RCX: 0000000000000001
[  396.900236] RDX: ffff8800cb8f0000 RSI: 0000000000000007 RDI: ffff880bec133fc0
[  396.900236] RBP: ffff88012b993df8 R08: 000000005331c188 R09: 0000000000000000
[  396.900236] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000007
[  396.900236] R13: 0000000000000000 R14: ffff880bec790000 R15: ffff880bec133fc0
[  396.900236] FS:  00007f3eeb0ff700(0000) GS:ffff8800bec00000(0000) knlGS:0000000000000000
[  396.900236] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  396.900236] CR2: 00007f3eeb0c4504 CR3: 000000012b984000 CR4: 00000000000006a0
[  396.900236] DR0: 0000000000698000 DR1: 0000000000000000 DR2: 0000000000000000
[  396.900236] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000050602
[  396.900236] Stack:
[  396.900236]  ffff880bec133fc0 ffff88012b993ec8 0000000000000000 0000000000000180
[  396.900236]  ffff88012b993e28 ffffffff8133a8bb ffff88012b993e98 0000000000000041
[  396.900236]  ffff88012b993ec8 ffff88016c0e6cd8 ffff88012b993e98 ffffffff8132ead8
[  396.900236] Call Trace:
[  396.900236]  [<ffffffff8133a8bb>] simple_setattr+0x5b/0x70
[  396.900236]  [<ffffffff8132ead8>] notify_change+0x258/0x390
[  396.900236]  [<ffffffff8130b732>] ? chmod_common+0x72/0x150
[  396.900236]  [<ffffffff8130b774>] chmod_common+0xb4/0x150
[  396.900236]  [<ffffffff8132fc04>] ? __fget_light+0xe4/0x130
[  396.900236]  [<ffffffff8130cd02>] SyS_fchmod+0x62/0xa0
[  396.900236]  [<ffffffff84513258>] tracesys+0xe1/0xe6
[  396.900236] Code: 8b 45 00 0f 1f 40 00 49 8b 7d 08 44 89 e2 49 83 c5 10 48 89 de ff d0 49 8b 45 00 48 85 c0 75 e7 eb c5 0f 1f 44 00 00 49 8b 46 30 <48> 8b 40 10 48 85 c0 74 08 44 89 e6 48 89 df ff d0 66 66 66 66
[  396.939254] RIP  [<ffffffff8133e85c>] __mark_inode_dirty+0x10c/0x4a0
[  396.939254]  RSP <ffff88012b993dd8>


Thanks,
Sasha
