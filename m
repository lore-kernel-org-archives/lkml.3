Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3I2Tdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:33:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3I2T3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Solomon Peachy <pizza@shaftnet.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 69/71] cw1200: Prevent a lock-related hang in the cw1200_spi driver
Date: Sun, 29 Sep 2013 12:28:21 -0700
Message-Id: <20130929192648.238118126@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Solomon Peachy <pizza@shaftnet.org>

commit 85ba8f529c57ac6e2fca9be0d9e17920a1afb2e8 upstream.

The cw1200_spi driver tries to mirror the cw1200_sdio driver's lock
API, which relies on sdio_claim_host/sdio_release_host to serialize
hardware operations across multiple threads.

Unfortunately the implementation was flawed, as it lacked a way to wake
up the lock requestor when there was contention, often resulting in a
hang.

This problem was uncovered while trying to fix the
spi-transfers-in-interrupt-context BUG() corrected in the previous
patch.  Many thanks to Dave Sizeburns for his assistance in fixing this.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/cw1200/cw1200_spi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -40,6 +40,7 @@ struct hwbus_priv {
 	struct cw1200_common	*core;
 	const struct cw1200_platform_data_spi *pdata;
 	spinlock_t		lock; /* Serialize all bus operations */
+	wait_queue_head_t       wq;
 	int claimed;
 };
 
@@ -197,8 +198,11 @@ static void cw1200_spi_lock(struct hwbus
 {
 	unsigned long flags;
 
+	DECLARE_WAITQUEUE(wait, current);
+
 	might_sleep();
 
+	add_wait_queue(&self->wq, &wait);
 	spin_lock_irqsave(&self->lock, flags);
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -211,6 +215,7 @@ static void cw1200_spi_lock(struct hwbus
 	set_current_state(TASK_RUNNING);
 	self->claimed = 1;
 	spin_unlock_irqrestore(&self->lock, flags);
+	remove_wait_queue(&self->wq, &wait);
 
 	return;
 }
@@ -222,6 +227,8 @@ static void cw1200_spi_unlock(struct hwb
 	spin_lock_irqsave(&self->lock, flags);
 	self->claimed = 0;
 	spin_unlock_irqrestore(&self->lock, flags);
+	wake_up(&self->wq);
+
 	return;
 }
 
@@ -400,6 +407,8 @@ static int cw1200_spi_probe(struct spi_d
 
 	spi_set_drvdata(func, self);
 
+	init_waitqueue_head(&self->wq);
+
 	status = cw1200_spi_irq_subscribe(self);
 
 	status = cw1200_core_probe(&cw1200_spi_hwbus_ops,


