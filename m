Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab3BFTxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:53:20 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:57835 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab3BFTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:22 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 73/77] posix-timers: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:45 -0800
Message-Id: <1360179649-22465-74-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/posix-timers.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 69185ae..e897f66 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -552,24 +552,22 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		return -EAGAIN;
 
 	spin_lock_init(&new_timer->it_lock);
- retry:
-	if (unlikely(!idr_pre_get(&posix_timers_id, GFP_KERNEL))) {
-		error = -EAGAIN;
-		goto out;
-	}
+
+	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&idr_lock);
-	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
+	error = idr_alloc(&posix_timers_id, new_timer, 0, 0, GFP_NOWAIT);
 	spin_unlock_irq(&idr_lock);
-	if (error) {
-		if (error == -EAGAIN)
-			goto retry;
+	idr_preload_end();
+	if (error < 0) {
 		/*
 		 * Weird looking, but we return EAGAIN if the IDR is
 		 * full (proper POSIX return value for this)
 		 */
-		error = -EAGAIN;
+		if (error == -ENOSPC)
+			error = -EAGAIN;
 		goto out;
 	}
+	new_timer_id = error;
 
 	it_id_set = IT_ID_SET;
 	new_timer->it_id = (timer_t) new_timer_id;
-- 
1.8.1

