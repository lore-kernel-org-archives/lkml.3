Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaGFR2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:28:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51820 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaGFR2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:28:13 -0400
Message-ID: <53B98709.3090603@oracle.com>
Date: Sun, 06 Jul 2014 13:27:37 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: sched: spinlock recursion in sched_rr_get_interval
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

[10062.200152] BUG: spinlock recursion on CPU#11, trinity-c194/2414
[10062.201897]  lock: 0xffff88010cfd7740, .magic: dead4ead, .owner: trinity-c194/2414, .owner_cpu: -1
[10062.204432] CPU: 11 PID: 2414 Comm: trinity-c194 Not tainted 3.16.0-rc3-next-20140703-sasha-00024-g2ad7668-dirty #763
[10062.207517]  ffff88010cfd7740 ffff8803a429fe48 ffffffffaa4897e4 0000000000000000
[10062.209810]  ffff8803c35f0000 ffff8803a429fe68 ffffffffaa47df58 ffff88010cfd7740
[10062.210024]  ffffffffab845c77 ffff8803a429fe88 ffffffffaa47df83 ffff88010cfd7740
[10062.210024] Call Trace:
[10062.210024] dump_stack (lib/dump_stack.c:52)
[10062.210024] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminator 6))
[10062.210024] spin_bug (kernel/locking/spinlock_debug.c:76)
[10062.210024] do_raw_spin_lock (kernel/locking/spinlock_debug.c:84 kernel/locking/spinlock_debug.c:135)
[10062.210024] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[10062.210024] ? task_rq_lock (include/linux/sched.h:2885 kernel/sched/core.c:348)
[10062.210024] task_rq_lock (include/linux/sched.h:2885 kernel/sched/core.c:348)
[10062.210024] SyS_sched_rr_get_interval (kernel/sched/core.c:4429 kernel/sched/core.c:4407)
[10062.210024] ? tracesys (arch/x86/kernel/entry_64.S:531)
[10062.210024] tracesys (arch/x86/kernel/entry_64.S:542)


Thanks,
Sasha
