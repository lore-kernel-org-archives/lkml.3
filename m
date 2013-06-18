Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3FRFO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3FRFOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:14:55 -0400
From: Jason Wang <jasowang@redhat.com>
To: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] drivers: hv: switch to use mb() instead of smp_mb()
Date: Tue, 18 Jun 2013 13:04:23 +0800
Message-Id: <1371531863-12491-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if guest were compiled without SMP support, it could not assume that host
wasn't. So switch to use mb() instead of smp_mb() to force memory barriers for
UP guest.

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/ring_buffer.c |   10 +++++-----
 drivers/hv/vmbus_drv.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index d6fbb57..791f45d 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -32,7 +32,7 @@
 void hv_begin_read(struct hv_ring_buffer_info *rbi)
 {
 	rbi->ring_buffer->interrupt_mask = 1;
-	smp_mb();
+	mb();
 }
 
 u32 hv_end_read(struct hv_ring_buffer_info *rbi)
@@ -41,7 +41,7 @@ u32 hv_end_read(struct hv_ring_buffer_info *rbi)
 	u32 write;
 
 	rbi->ring_buffer->interrupt_mask = 0;
-	smp_mb();
+	mb();
 
 	/*
 	 * Now check to see if the ring buffer is still empty.
@@ -71,7 +71,7 @@ u32 hv_end_read(struct hv_ring_buffer_info *rbi)
 
 static bool hv_need_to_signal(u32 old_write, struct hv_ring_buffer_info *rbi)
 {
-	smp_mb();
+	mb();
 	if (rbi->ring_buffer->interrupt_mask)
 		return false;
 
@@ -442,7 +442,7 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 					     sizeof(u64));
 
 	/* Issue a full memory barrier before updating the write index */
-	smp_mb();
+	mb();
 
 	/* Now, update the write location */
 	hv_set_next_write_location(outring_info, next_write_location);
@@ -549,7 +549,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 	/* Make sure all reads are done before we update the read index since */
 	/* the writer may start writing to the read area once the read index */
 	/*is updated */
-	smp_mb();
+	mb();
 
 	/* Update the read index */
 	hv_set_next_read_location(inring_info, next_read_location);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index bf421e0..4004e54 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -434,7 +434,7 @@ static void vmbus_on_msg_dpc(unsigned long data)
 		 * will not deliver any more messages since there is
 		 * no empty slot
 		 */
-		smp_mb();
+		mb();
 
 		if (msg->header.message_flags.msg_pending) {
 			/*
-- 
1.7.1

