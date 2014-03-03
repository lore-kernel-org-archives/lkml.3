Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaCCWnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:43:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30691 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbaCCWnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:43:21 -0500
Message-ID: <5315057F.3030602@oracle.com>
Date: Mon, 03 Mar 2014 17:43:11 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com> <20140303223327.GB26523@mtj.dyndns.org>
In-Reply-To: <20140303223327.GB26523@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 05:33 PM, Tejun Heo wrote:
> On Sat, Mar 01, 2014 at 10:00:11PM -0500, Sasha Levin wrote:
>> rcu read lock should be held when calling and working with task_css_set.
>>
>> This patch also fixes a related lockdep warning.
>
> Hmmm... PF_EXITING should be visible at that point and cset can't
> change anymore.  We prolly need to update lockdep annotation rather
> than adding spurious rcu locking around it.  Against which branch is
> it?  Can you please post the lockdep warning?

I see it on -next.

[    0.370543] ===============================
[    0.371030] [ INFO: suspicious RCU usage. ]
[    0.371453] 3.14.0-rc4-next-20140303-sasha-00012-g35a2897-dirty #43 Not tainted
[    0.372223] -------------------------------
[    0.372627] include/linux/cgroup.h:692 suspicious rcu_dereference_check() usage!
[    0.373417]
[    0.373417] other info that might help us debug this:
[    0.373417]
[    0.374223]
[    0.374223] rcu_scheduler_active = 1, debug_locks = 1
[    0.374993] no locks held by swapper/0/0.
[    0.375422]
[    0.375422] stack backtrace:
[    0.375865] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc4-next-20140303-sasha-00012-g35a2897-dirty #43
[    0.376936]  0000000000000001 ffffffff85e01d58 ffffffff8446a933 0000000000000001
[    0.377753]  ffffffff85e2e4a0 ffffffff85e01d88 ffffffff811a6ddb 0000000000000000
[    0.380550]  ffff88052a2398a8 ffff88052a238000 0000000000000000 ffffffff85e01de8
[    0.381370] Call Trace:
[    0.381641]  [<ffffffff8446a933>] dump_stack+0x52/0x7f
[    0.382261]  [<ffffffff811a6ddb>] lockdep_rcu_suspicious+0x10b/0x120
[    0.382893]  [<ffffffff8120024d>] cgroup_exit+0x20d/0x250
[    0.383566]  [<ffffffff811dc075>] ? ktime_get_ts+0x145/0x1d0
[    0.384221]  [<ffffffff8113fd66>] copy_process+0x5d6/0x670
[    0.384850]  [<ffffffff8114049b>] do_fork+0x8b/0x2e0
[    0.385347]  [<ffffffff811a9c0d>] ? trace_hardirqs_on+0xd/0x10
[    0.386009]  [<ffffffff8446d47e>] ? mutex_unlock+0xe/0x10
[    0.386559]  [<ffffffff872a4117>] ? early_idt_handlers+0x117/0x120
[    0.387327]  [<ffffffff81140776>] kernel_thread+0x26/0x30
[    0.387947]  [<ffffffff844606a6>] rest_init+0x26/0x150
[    0.388491]  [<ffffffff872a538d>] start_kernel+0x3c0/0x3c7
[    0.389126]  [<ffffffff872a4dfb>] ? repair_env_string+0x5b/0x5b
[    0.389813]  [<ffffffff84468dcb>] ? memblock_reserve+0x49/0x4e
[    0.390019]  [<ffffffff872a43d9>] x86_64_start_reservations+0x2a/0x2c
[    0.390754]  [<ffffffff872a45ae>] x86_64_start_kernel+0x186/0x195


Thanks,
Sasha
