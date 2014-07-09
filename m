Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaGITSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:18:37 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:52709 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaGITSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:18:35 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH] drbd: fix regression 'out of mem, failed to invoke fence-peer helper'
Date: Wed,  9 Jul 2014 21:18:32 +0200
Message-Id: <1404933512-5166-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404933512-5166-1-git-send-email-philipp.reisner@linbit.com>
References: <1404933512-5166-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Since linux kernel 3.13, kthread_run() internally uses
wait_for_completion_killable().  We sometimes may use kthread_run()
while we still have a signal pending, which we used to kick our threads
out of potentially blocking network functions, causing kthread_run() to
mistake that as a new fatal signal and fail.

Fix: flush_signals() before kthread_run().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 1b35c45..3f2e167 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -544,6 +544,12 @@ void conn_try_outdate_peer_async(struct drbd_connection *connection)
 	struct task_struct *opa;
 
 	kref_get(&connection->kref);
+	/* We may just have force_sig()'ed this thread
+	 * to get it out of some blocking network function.
+	 * Clear signals; otherwise kthread_run(), which internally uses
+	 * wait_on_completion_killable(), will mistake our pending signal
+	 * for a new fatal signal and fail. */
+	flush_signals(current);
 	opa = kthread_run(_try_outdate_peer_async, connection, "drbd_async_h");
 	if (IS_ERR(opa)) {
 		drbd_err(connection, "out of mem, failed to invoke fence-peer helper\n");
-- 
1.9.1

