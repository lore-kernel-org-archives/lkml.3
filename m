Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934855AbaJ2Rhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:37:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44713 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934565AbaJ2Rhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:37:50 -0400
Date: Wed, 29 Oct 2014 13:37:45 -0400 (EDT)
Message-Id: <20141029.133745.352978224935750457.davem@davemloft.net>
To: peterz@infradead.org
Cc: fengguang.wu@intel.com, lkp@01.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH] netdev: Fix sleeping inside wait event
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141029161657.GF3337@twins.programming.kicks-ass.net>
References: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
	<20141029161657.GF3337@twins.programming.kicks-ass.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Oct 2014 10:37:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 29 Oct 2014 17:16:57 +0100

> On Tue, Oct 28, 2014 at 10:25:41PM +0800, Fengguang Wu wrote:
>> [  122.247299] ------------[ cut here ]------------
>> [  122.247328] WARNING: CPU: 0 PID: 61 at kernel/sched/core.c:7312 __might_sleep+0x50/0x249()
>> [  122.247334] do not call blocking ops when !TASK_RUNNING; state=2 set at [<c106ffd9>] prepare_to_wait+0x3c/0x5f
>> [  122.247339] Modules linked in:
>> [  122.247349] CPU: 0 PID: 61 Comm: kworker/u2:1 Not tainted 3.18.0-rc2-00037-g24574709 #136
>> [  122.247350] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> [  122.247368] Workqueue: netns cleanup_net
>> [  122.247377]  c1071d83 d2b83dd8 d2b83dac c15887b1 d2b83dc8 c104c4c6 00001c90 c1068ebf
>> [  122.247383]  00000000 c17b67e3 0000026d d2b83de0 c104c508 00000009 d2b83dd8 c17b5d4b
>> [  122.247388]  d2b83df4 d2b83e0c c1068ebf c17b5cec 00001c90 c17b5d4b 00000002 c106ffd9
>> [  122.247389] Call Trace:
>> [  122.247393]  [<c1071d83>] ? down_trylock+0x23/0x2c
>> [  122.247402]  [<c15887b1>] dump_stack+0x16/0x18
>> [  122.247413]  [<c104c4c6>] warn_slowpath_common+0x66/0x7d
>> [  122.247416]  [<c1068ebf>] ? __might_sleep+0x50/0x249
>> [  122.247419]  [<c104c508>] warn_slowpath_fmt+0x2b/0x2f
>> [  122.247422]  [<c1068ebf>] __might_sleep+0x50/0x249
>> [  122.247424]  [<c106ffd9>] ? prepare_to_wait+0x3c/0x5f
>> [  122.247426]  [<c106ffd9>] ? prepare_to_wait+0x3c/0x5f
>> [  122.247432]  [<c158c364>] mutex_lock_nested+0x23/0x347
>> [  122.247436]  [<c1075105>] ? trace_hardirqs_on+0xb/0xd
>> [  122.247439]  [<c158eb0c>] ? _raw_spin_unlock_irqrestore+0x66/0x78
>> [  122.247445]  [<c1570e10>] rtnl_lock+0x14/0x16
>> [  122.247449]  [<c156516b>] default_device_exit_batch+0x54/0xf3
>> [  122.247452]  [<c1570e1f>] ? rtnl_unlock+0xd/0xf
>> [  122.247454]  [<c1070233>] ? __wake_up_sync+0x12/0x12
>> [  122.247461]  [<c155e35d>] ops_exit_list+0x20/0x40
>> [  122.247464]  [<c155ec96>] cleanup_net+0xbe/0x140
>> [  122.247473]  [<c105ffe4>] process_one_work+0x29e/0x643
>> [  122.247479]  [<c1061215>] worker_thread+0x23a/0x311
>> [  122.247482]  [<c1060fdb>] ? rescuer_thread+0x204/0x204
>> [  122.247486]  [<c10648cc>] kthread+0xbe/0xc3
>> [  122.247490]  [<c158f4c0>] ret_from_kernel_thread+0x20/0x30
>> [  122.247492]  [<c106480e>] ? kthread_stop+0x364/0x364
>> [  122.247495] ---[ end trace 2073c37ae3c8b3b4 ]---
> 
> Ah, more of that. Thanks!
> 
> Dave, this relies on bits currently in tip/sched/core, if you're ok I'll
> merge it through that tree.

Yep, no problem:

Acked-by: David S. Miller <davem@davemloft.net>
