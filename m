Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaDVVJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:09:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36250 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453AbaDVUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@fb.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 129/133] lib/percpu_counter.c: fix bad percpu counter state during suspend
Date: Tue, 22 Apr 2014 13:14:27 -0700
Message-Id: <1398197671-12786-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 lib/percpu_counter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index ba6085d..8505ec4 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -166,7 +166,7 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	struct percpu_counter *fbc;
 
 	compute_batch_value();
-	if (action != CPU_DEAD)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	cpu = (unsigned long)hcpu;
-- 
1.9.1

