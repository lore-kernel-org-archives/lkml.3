Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaD1Bbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42879 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Laszlo Ersek" <lersek@redhat.com>,
        "Jens Axboe" <axboe@fb.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.988045123@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 84/94] lib/percpu_counter.c: fix bad percpu counter
 state during suspend
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit e39435ce68bb4685288f78b1a7e24311f7ef939f upstream.

I got a bug report yesterday from Laszlo Ersek in which he states that
his kvm instance fails to suspend.  Laszlo bisected it down to this
commit 1cf7e9c68fe8 ("virtio_blk: blk-mq support") where virtio-blk is
converted to use the blk-mq infrastructure.

After digging a bit, it became clear that the issue was with the queue
drain.  blk-mq tracks queue usage in a percpu counter, which is
incremented on request alloc and decremented when the request is freed.
The initial hunt was for an inconsistency in blk-mq, but everything
seemed fine.  In fact, the counter only returned crazy values when
suspend was in progress.

When a CPU is unplugged, the percpu counters merges that CPU state with
the general state.  blk-mq takes care to register a hotcpu notifier with
the appropriate priority, so we know it runs after the percpu counter
notifier.  However, the percpu counter notifier only merges the state
when the CPU is fully gone.  This leaves a state transition where the
CPU going away is no longer in the online mask, yet it still holds
private values.  This means that in this state, percpu_counter_sum()
returns invalid results, and the suspend then hangs waiting for
abs(dead-cpu-value) requests to complete which of course will never
happen.

Fix this by clearing the state earlier, so we never have a case where
the CPU isn't in online mask but still holds private state.  This bug
has been there since forever, I guess we don't have a lot of users where
percpu counters needs to be reliable during the suspend cycle.

Signed-off-by: Jens Axboe <axboe@fb.com>
Reported-by: Laszlo Ersek <lersek@redhat.com>
Tested-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/percpu_counter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -166,7 +166,7 @@ static int __cpuinit percpu_counter_hotc
 	struct percpu_counter *fbc;
 
 	compute_batch_value();
-	if (action != CPU_DEAD)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	cpu = (unsigned long)hcpu;

