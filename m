Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3JJTNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:13:41 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:11240 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3JJTNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:13:40 -0400
From: "Cowell, Matt (NSN - US/Arlington Heights)" <matt.cowell@nsn.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: [PATCH RT] rtmutex: fix deadlock in spin_trylock with PREEMPT_RT
Thread-Topic: [PATCH RT] rtmutex: fix deadlock in spin_trylock with
 PREEMPT_RT
Thread-Index: AQHOxc8If9XvINhEBkOiJxsxOfTY35nuTRrA
Date: Thu, 10 Oct 2013 19:11:45 +0000
Message-ID: <641D1EBAB8EAD046954CD69996C8FE00141CF5@USCHMBX003.nsn-intra.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.159.161.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 3193
X-purgate-ID: 151667::1381432377-00005753-87111876/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a deadlock condition with RT spin_locks that may use trylock in
hardirq context.  The main user of this is get_next_timer_interrupt, which
will deadlock if an IRQ preempts a timer wheel modification.

Since this is a trylock and if the wait_lock is already held it means that
some other user is either locking, about to wait for, or unlocking the
rtmutex, we should not wait and return failure anyway.  This likely also
reduces latency.

Detected by spinlock lockup debug:
   BUG: spinlock lockup suspected on CPU#1, ncp_nca_0_grp_5/133
    lock: 0xee02a000, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
   CPU: 1 PID: 133 Comm: ncp_nca_0_grp_5 Tainted: G           O 3.10.10-rt7 #53
   [<c041539c>] (unwind_backtrace+0x0/0xf8) from [<c0411914>] (show_stack+0x10/0x14)
   [<c0411914>] (show_stack+0x10/0x14) from [<c06059b0>] (do_raw_spin_lock+0x100/0x164)
   [<c06059b0>] (do_raw_spin_lock+0x100/0x164) from [<c07afbc0>] (rt_spin_trylock+0x14/0xc4)
   [<c07afbc0>] (rt_spin_trylock+0x14/0xc4) from [<c04310fc>] (get_next_timer_interrupt+0x54/0x2b8)
   [<c04310fc>] (get_next_timer_interrupt+0x54/0x2b8) from [<c0467c44>] (tick_nohz_stop_sched_tick+0x204/0x2e4)
   [<c0467c44>] (tick_nohz_stop_sched_tick+0x204/0x2e4) from [<c0468534>] (tick_nohz_irq_exit+0x98/0xb8)
   [<c0468534>] (tick_nohz_irq_exit+0x98/0xb8) from [<c042b2b8>] (irq_exit+0xc0/0x164)
   [<c042b2b8>] (irq_exit+0xc0/0x164) from [<c04137ec>] (handle_IPI+0x9c/0x124)
   [<c04137ec>] (handle_IPI+0x9c/0x124) from [<c04085b4>] (axxia_gic_handle_irq+0xac/0xec)
   [<c04085b4>] (axxia_gic_handle_irq+0xac/0xec) from [<c07b0ac4>] (__irq_svc+0x44/0x8c)
   Exception stack(0xed859df8 to 0xed859e40)
   9de0:                                                       ee02a000 00000000
   9e00: 00000000 00000001 ee02a000 ee02a000 ee02a000 ed858000 ee02a000 00000000
   9e20: ed858000 00000000 ed858000 ed859e40 c07af9a8 c0605914 60000013 ffffffff
   [<c07b0ac4>] (__irq_svc+0x44/0x8c) from [<c0605914>] (do_raw_spin_lock+0x64/0x164)
   [<c0605914>] (do_raw_spin_lock+0x64/0x164) from [<c07af9a8>] (rt_spin_lock_slowunlock+0xc/0x68)
   [<c07af9a8>] (rt_spin_lock_slowunlock+0xc/0x68) from [<c07adbb0>] (schedule_timeout+0x138/0x1fc)
   [<c07adbb0>] (schedule_timeout+0x138/0x1fc) from [<bf067f0c>] (ncp_nca_thread_notifier+0xd0/0x12c [ncp])
   [<bf067f0c>] (ncp_nca_thread_notifier+0xd0/0x12c [ncp]) from [<bf083cac>] (ncp_nca_thread+0x24/0x78 [ncp])
   [<bf083cac>] (ncp_nca_thread+0x24/0x78 [ncp]) from [<c04440ec>] (kthread+0x9c/0xa4)
   [<c04440ec>] (kthread+0x9c/0xa4) from [<c040ddb8>] (ret_from_fork+0x14/0x3c)
---
 kernel/rtmutex.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 5d76634..25ad02d 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1057,7 +1057,9 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 {
 	int ret = 0;
 
-	raw_spin_lock(&lock->wait_lock);
+	if (!raw_spin_trylock(&lock->wait_lock)) {
+		return 0;
+	}
 	init_lists(lock);
 
 	if (likely(rt_mutex_owner(lock) != current)) {
-- 
1.7.10.1

