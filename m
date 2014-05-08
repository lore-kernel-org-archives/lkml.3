Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaEHA6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 20:58:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27734 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaEHA56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 20:57:58 -0400
Message-ID: <536AD685.5060508@oracle.com>
Date: Wed, 07 May 2014 20:57:41 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: gpf in global_dirty_limits
References: <536A6670.5070107@oracle.com> <20140507150252.243bb40c69b973f534d29e25@linux-foundation.org>
In-Reply-To: <20140507150252.243bb40c69b973f534d29e25@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 06:02 PM, Andrew Morton wrote:
> On Wed, 07 May 2014 12:59:28 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel I've stumbled on the following spew:
>>
>> [ 1139.410483] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> [ 1139.413202] Dumping ftrace buffer:
>> [ 1139.414152]    (ftrace buffer empty)
>> [ 1139.415069] Modules linked in:
>> [ 1139.415846] CPU: 10 PID: 39777 Comm: kworker/u115:2 Tainted: G        W     3.15.0-rc4-next-20140506-sasha-00021-gc164334-dirty #447
>> [ 1139.418931] Workqueue: writeback bdi_writeback_workfn (flush-7:10)
>> [ 1139.420320] task: ffff880285848000 ti: ffff880282dbc000 task.ti: ffff880282dbc000
>> [ 1139.420320] RIP: global_dirty_limits (include/trace/events/writeback.h:308 mm/page-writeback.c:309)
>> [ 1139.420320] RSP: 0018:ffff880282dbdc28  EFLAGS: 00010282
>> [ 1139.420320] RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000088034 RCX: 0000000000000001
>> [ 1139.420320] RDX: 0000000000110068 RSI: 0000000000088034 RDI: 6b6b6b6b6b6b6b6b
>> [ 1139.420320] RBP: ffff880282dbdc48 R08: 00000000000abad6 R09: ffff880285848cf0
>> [ 1139.420320] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000110068
>> [ 1139.420320] R13: ffff8805bc5932a8 R14: ffff880282dbdc60 R15: 0000000000001cc0
>> [ 1139.420320] FS:  0000000000000000(0000) GS:ffff880292c00000(0000) knlGS:0000000000000000
>> [ 1139.420320] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [ 1139.420320] CR2: 0000000000000001 CR3: 0000000025e2d000 CR4: 00000000000006a0
>> [ 1139.438692] Stack:
>> [ 1139.438692]  ffff8804e3ed0278 ffff8804e3ed0570 0000000000000000 ffff8804e3ed06c8
>> [ 1139.438692]  ffff880282dbdc78 ffffffffa1342180 0000000000088034 0000000000110068
>> [ 1139.438692]  0000000000000000 ffff8804e3ed0570 ffff880282dbdd38 ffffffffa1346f3a
>> [ 1139.438692] Call Trace:
>> [ 1139.438692] over_bground_thresh (arch/x86/include/asm/atomic64_64.h:21 include/asm-generic/atomic-long.h:31 include/linux/vmstat.h:122 fs/fs-writeback.c:772)
>> [ 1139.438692] bdi_writeback_workfn (fs/fs-writeback.c:934 fs/fs-writeback.c:1014 fs/fs-writeback.c:1043)
>> [ 1139.438692] process_one_work (kernel/workqueue.c:2227 include/linux/jump_label.h:105 include/trace/events/workqueue.h:111 kernel/workqueue.c:2232)
>> [ 1139.438692] ? process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2220)
>> [ 1139.438692] worker_thread (kernel/workqueue.c:2354)
>> [ 1139.438692] ? rescuer_thread (kernel/workqueue.c:2303)
>> [ 1139.438692] kthread (kernel/kthread.c:210)
>> [ 1139.438692] ? kthread_create_on_node (kernel/kthread.c:176)
>> [ 1139.438692] ret_from_fork (arch/x86/kernel/entry_64.S:553)
>> [ 1139.438692] ? kthread_create_on_node (kernel/kthread.c:176)
>> [ 1139.438692] Code: 25 a0 da 00 00 0f 84 82 00 00 00 66 90 eb 2e 66 0f 1f 44 00 00 49 8b 45 00 0f 1f 40 00 49 8b 7d 08 4c 89 e2 49 83 c5 10 48 89 de <ff> d0 49 8b 45 00 48 85 c0 75 e7 eb c5 0f 1f 44 00 00 eb 53 66
>> [ 1139.438692] RIP global_dirty_limits (include/trace/events/writeback.h:308 mm/page-writeback.c:309)
>> [ 1139.438692]  RSP <ffff880282dbdc28>
> 
> Did this die somewhere within trace_global_dirty_state()?
> 

This turns out to be an issue with tracing and not mm/, sorry for the noise.


Thanks,
Sasha
