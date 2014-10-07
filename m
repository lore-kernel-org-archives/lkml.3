Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaJGXUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:20:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaJGXUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.14 24/37] drbd: fix regression out of mem, failed to invoke fence-peer helper
Date: Tue,  7 Oct 2014 16:19:41 -0700
Message-Id: <20141007231827.805724214@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars Ellenberg <lars.ellenberg@linbit.com>

commit bbc1c5e8ad6dfebf9d13b8a4ccdf66c92913eac9 upstream.

Since linux kernel 3.13, kthread_run() internally uses
wait_for_completion_killable().  We sometimes may use kthread_run()
while we still have a signal pending, which we used to kick our threads
out of potentially blocking network functions, causing kthread_run() to
mistake that as a new fatal signal and fail.

Fix: flush_signals() before kthread_run().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/drbd/drbd_nl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -525,6 +525,12 @@ void conn_try_outdate_peer_async(struct
 	struct task_struct *opa;
 
 	kref_get(&tconn->kref);
+	/* We may just have force_sig()'ed this thread
+	 * to get it out of some blocking network function.
+	 * Clear signals; otherwise kthread_run(), which internally uses
+	 * wait_on_completion_killable(), will mistake our pending signal
+	 * for a new fatal signal and fail. */
+	flush_signals(current);
 	opa = kthread_run(_try_outdate_peer_async, tconn, "drbd_async_h");
 	if (IS_ERR(opa)) {
 		conn_err(tconn, "out of mem, failed to invoke fence-peer helper\n");


