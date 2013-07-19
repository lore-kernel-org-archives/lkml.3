Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966019Ab3GSFoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:44:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965581Ab3GSF03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 17/72] drivers: hv: switch to use mb() instead of smp_mb()
Date: Thu, 18 Jul 2013 22:25:34 -0700
Message-Id: <20130719052601.042108041@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 35848f68b07df3f917cb13fc3c134718669f569b upstream.

Even if guest were compiled without SMP support, it could not assume that host
wasn't. So switch to use mb() instead of smp_mb() to force memory barriers for
UP guest.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/ring_buffer.c |   10 +++++-----
 drivers/hv/vmbus_drv.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

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
@@ -41,7 +41,7 @@ u32 hv_end_read(struct hv_ring_buffer_in
 	u32 write;
 
 	rbi->ring_buffer->interrupt_mask = 0;
-	smp_mb();
+	mb();
 
 	/*
 	 * Now check to see if the ring buffer is still empty.
@@ -71,7 +71,7 @@ u32 hv_end_read(struct hv_ring_buffer_in
 
 static bool hv_need_to_signal(u32 old_write, struct hv_ring_buffer_info *rbi)
 {
-	smp_mb();
+	mb();
 	if (rbi->ring_buffer->interrupt_mask)
 		return false;
 
@@ -442,7 +442,7 @@ int hv_ringbuffer_write(struct hv_ring_b
 					     sizeof(u64));
 
 	/* Issue a full memory barrier before updating the write index */
-	smp_mb();
+	mb();
 
 	/* Now, update the write location */
 	hv_set_next_write_location(outring_info, next_write_location);
@@ -549,7 +549,7 @@ int hv_ringbuffer_read(struct hv_ring_bu
 	/* Make sure all reads are done before we update the read index since */
 	/* the writer may start writing to the read area once the read index */
 	/*is updated */
-	smp_mb();
+	mb();
 
 	/* Update the read index */
 	hv_set_next_read_location(inring_info, next_read_location);
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -434,7 +434,7 @@ static void vmbus_on_msg_dpc(unsigned lo
 		 * will not deliver any more messages since there is
 		 * no empty slot
 		 */
-		smp_mb();
+		mb();
 
 		if (msg->header.message_flags.msg_pending) {
 			/*


