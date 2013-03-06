Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3CFQCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:02:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23144 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3CFQCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:02:02 -0500
Message-ID: <5137687E.50701@oracle.com>
Date: Wed, 06 Mar 2013 11:02:06 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
CC: Dave Jones <davej@redhat.com>, Cgroups <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: cgroup: INFO: suspicious RCU usage. in cgroup_name
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel
I've stumbled on the following:

[  450.180599] ===============================
[  450.181392] [ INFO: suspicious RCU usage. ]
[  450.182101] 3.9.0-rc1-next-20130305-sasha-00048-g35e9ec5-dirty #1032 Tainted: G        W
[  450.183482] -------------------------------
[  450.184343] include/linux/cgroup.h:429 suspicious rcu_dereference_check() usage!
[  450.185575]
[  450.185575] other info that might help us debug this:
[  450.185575]
[  450.186961]
[  450.186961] rcu_scheduler_active = 1, debug_locks = 1
[  450.188001] 4 locks held by kworker/u:0/6:
[  450.188646]  #0:  (khelper){.+.+.+}, at: [<ffffffff8112ba98>] process_one_work+0x238/0x570
[  450.190186]  #1:  ((&sub_info->work)){+.+.+.}, at: [<ffffffff8112ba98>] process_one_work+0x238/0x570
[  450.191824]  #2:  (&(&p->alloc_lock)->rlock){+.+.-.}, at: [<ffffffff812036d3>] dump_header+0x43/0xe0
[  450.193366]  #3:  (cpuset_buffer_lock){+.+...}, at: [<ffffffff811a06d0>] cpuset_print_task_mems_allowed+0x60/0x150
[  450.195281]
[  450.195281] stack backtrace:
[  450.195987] Pid: 6, comm: kworker/u:0 Tainted: G        W    3.9.0-rc1-next-20130305-sasha-00048-g35e9ec5-dirty #1032
[  450.197678] Call Trace:
[  450.198086]  [<ffffffff811793b3>] lockdep_rcu_suspicious+0x113/0x130
[  450.199077]  [<ffffffff811a0757>] cpuset_print_task_mems_allowed+0xe7/0x150
[  450.200263]  [<ffffffff8120370c>] dump_header+0x7c/0xe0
[  450.201135]  [<ffffffff81203972>] oom_kill_process+0x82/0x370
[  450.202048]  [<ffffffff812040cb>] out_of_memory+0x1ab/0x200
[  450.202921]  [<ffffffff83d44e00>] ? _raw_write_unlock_irq+0x50/0x80
[  450.204068]  [<ffffffff8120ad1f>] __alloc_pages_slowpath+0x5bf/0x700
[  450.205075]  [<ffffffff8120b135>] __alloc_pages_nodemask+0x2d5/0x400
[  450.206067]  [<ffffffff811047c8>] dup_task_struct+0x68/0x1c0
[  450.206975]  [<ffffffff81105b19>] copy_process+0xe9/0xfd0
[  450.207798]  [<ffffffff8114dd25>] ? sched_clock_local+0x25/0x90
[  450.208679]  [<ffffffff81127c50>] ? call_helper+0x20/0x20
[  450.209496]  [<ffffffff81106e6b>] do_fork+0xbb/0x280
[  450.210384]  [<ffffffff811070b1>] kernel_thread+0x21/0x30
[  450.211323]  [<ffffffff81127a93>] __call_usermodehelper+0x33/0xa0
[  450.212260]  [<ffffffff8112bbc8>] process_one_work+0x368/0x570
[  450.213201]  [<ffffffff8112ba98>] ? process_one_work+0x238/0x570
[  450.214248]  [<ffffffff8112d735>] worker_thread+0x1f5/0x340
[  450.215159]  [<ffffffff8112d540>] ? manage_workers+0x160/0x160
[  450.216078]  [<ffffffff81135ec2>] kthread+0xe2/0xf0
[  450.216901]  [<ffffffff8117e34a>] ? __lock_release+0x1da/0x1f0
[  450.217824]  [<ffffffff81135de0>] ? __init_kthread_worker+0x70/0x70
[  450.218791]  [<ffffffff83d4ddbc>] ret_from_fork+0x7c/0xb0
[  450.219627]  [<ffffffff81135de0>] ? __init_kthread_worker+0x70/0x70
[  450.220780] kworker/u:0 cpuset=/ mems_allowed=0

The offending commit looks like "cgroup: fix cgroup_path() vs rename() race".


Thanks,
Sasha
