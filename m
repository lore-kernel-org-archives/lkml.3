Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaI2NPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:15:49 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:34975 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbaI2NPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:15:02 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, dave@stgolabs.net,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 3/4] locktorture: Cannot hold read and write lock
Date: Mon, 29 Sep 2014 06:14:25 -0700
Message-Id: <1411996466-11488-4-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
References: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... trigger an error if so.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/locktorture.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 9e9cd11..b05dc46 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -453,14 +453,19 @@ static int lock_torture_writer(void *arg)
 	do {
 		if ((torture_random(&rand) & 0xfffff) == 0)
 			schedule_timeout_uninterruptible(1);
+
 		cxt.cur_ops->writelock();
 		if (WARN_ON_ONCE(lock_is_write_held))
 			lwsp->n_lock_fail++;
 		lock_is_write_held = 1;
+		if (WARN_ON_ONCE(lock_is_read_held))
+			lwsp->n_lock_fail++; /* rare, but... */
+
 		lwsp->n_lock_acquired++;
 		cxt.cur_ops->write_delay(&rand);
 		lock_is_write_held = 0;
 		cxt.cur_ops->writeunlock();
+
 		stutter_wait("lock_torture_writer");
 	} while (!torture_must_stop());
 	torture_kthread_stopping("lock_torture_writer");
@@ -482,12 +487,17 @@ static int lock_torture_reader(void *arg)
 	do {
 		if ((torture_random(&rand) & 0xfffff) == 0)
 			schedule_timeout_uninterruptible(1);
+
 		cxt.cur_ops->readlock();
 		lock_is_read_held = 1;
+		if (WARN_ON_ONCE(lock_is_write_held))
+			lrsp->n_lock_fail++; /* rare, but... */
+
 		lrsp->n_lock_acquired++;
 		cxt.cur_ops->read_delay(&rand);
 		lock_is_read_held = 0;
 		cxt.cur_ops->readunlock();
+
 		stutter_wait("lock_torture_reader");
 	} while (!torture_must_stop());
 	torture_kthread_stopping("lock_torture_reader");
-- 
1.8.4.5

