Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3AOFeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 00:34:17 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:50824 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3AOFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 00:34:16 -0500
Message-ID: <50F4EA14.5070708@huawei.com>
Date: Tue, 15 Jan 2013 13:33:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cpuset: lockdep spew on proc_cpuset_show
References: <50F4C32E.4020509@oracle.com>
In-Reply-To: <50F4C32E.4020509@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/15 10:47, Sasha Levin wrote:
> Hi Tejun,
> 
> I've stumbled on the following:
> 
> [   75.972016] ===============================
> [   75.977317] [ INFO: suspicious RCU usage. ]
> [   76.041031] 3.8.0-rc3-next-20130114-sasha-00016-ga107525-dirty #262 Tainted: G        W
> [   76.057535] -------------------------------
> [   76.063397] include/linux/cgroup.h:534 suspicious rcu_dereference_check() usage!
> [   76.076333]
> [   76.076333] other info that might help us debug this:
> [   76.076333]
> [   76.087091]
> [   76.087091] rcu_scheduler_active = 1, debug_locks = 1
> [   76.098682] 2 locks held by trinity/7514:
> [   76.104154]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff812b06aa>] seq_read+0x3a/0x3e0
> [   76.119533]  #1:  (cpuset_mutex){+.+...}, at: [<ffffffff811abae4>] proc_cpuset_show+0x84/0x190
> [   76.151167]
> [   76.151167] stack backtrace:
> [   76.156853] Pid: 7514, comm: trinity Tainted: G        W    3.8.0-rc3-next-20130114-sasha-00016-ga107525-dirty #262
> [   76.180547] Call Trace:
> [   76.183754]  [<ffffffff81182cab>] lockdep_rcu_suspicious+0x10b/0x120
> [   76.191885]  [<ffffffff811abb71>] proc_cpuset_show+0x111/0x190
> [   76.200572]  [<ffffffff812b0827>] seq_read+0x1b7/0x3e0
> [   76.206843]  [<ffffffff812b0670>] ? seq_lseek+0x110/0x110
> [   76.213562]  [<ffffffff8128b4fb>] do_loop_readv_writev+0x4b/0x90
> [   76.220961]  [<ffffffff8128b776>] do_readv_writev+0xf6/0x1d0
> [   76.227940]  [<ffffffff8128b8ee>] vfs_readv+0x3e/0x60
> [   76.235971]  [<ffffffff8128b960>] sys_readv+0x50/0xd0
> [   76.241945]  [<ffffffff83d33d18>] tracesys+0xe1/0xe6
> 
> This is the result of "cpuset: replace cgroup_mutex locking with cpuset internal locking"
> which remove the cgroup_lock() before calling task_subsys_state(), which now complains since
> one of the debug conditions in the rcu_dereference_check() there is cgroup_lock_is_held().
> 
> I'm not sure if this is an actual issue, but I do see that task_subsys_state() gets called
> from other places as well, so I think that possibly lockdep is right here and we do need
> to fix up locking there, but again, I'm not sure...
> 

I've prepared a fix.

