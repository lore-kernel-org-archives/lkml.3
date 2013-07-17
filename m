Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab3GQWyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:54:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab3GQWx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:53:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Soeren Moch <smoch@web.de>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 101/145] [media] media: dmxdev: remove dvb_ringbuffer_flush() on writer side
Date: Wed, 17 Jul 2013 15:47:13 -0700
Message-Id: <1374101277-7915-102-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Soeren Moch <smoch@web.de>

commit 414abbd2cd4c2618895f02ed3a76ec6647281436 upstream.

In dvb_ringbuffer lock-less synchronizationof reader and writer threads is done
with separateread and write pointers. Sincedvb_ringbuffer_flush() modifies the
read pointer, this function must not be called from the writer thread.
This patch removes the dvb_ringbuffer_flush() calls in the dmxdev ringbuffer
write functions, this fixes Oopses "Unable to handle kernel paging request"
I could observe for the call chaindvb_demux_read ->dvb_dmxdev_buffer_read ->
dvb_ringbuffer_read_user -> __copy_to_user (the reader side of the ringbuffer).
The flush calls at the write side are not necessary anyway since ringbuffer_flush
is also called in dvb_dmxdev_buffer_read() when an error condition is set in the
ringbuffer.
This patch should also be applied to stable kernels.

Signed-off-by: Soeren Moch <smoch@web.de>
Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/dvb-core/dmxdev.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index d81dbb2..f847c9e 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -377,10 +377,8 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer, buffer2,
 					      buffer2_len);
 	}
-	if (ret < 0) {
-		dvb_ringbuffer_flush(&dmxdevfilter->buffer);
+	if (ret < 0)
 		dmxdevfilter->buffer.error = ret;
-	}
 	if (dmxdevfilter->params.sec.flags & DMX_ONESHOT)
 		dmxdevfilter->state = DMXDEV_STATE_DONE;
 	spin_unlock(&dmxdevfilter->dev->lock);
@@ -416,10 +414,8 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	ret = dvb_dmxdev_buffer_write(buffer, buffer1, buffer1_len);
 	if (ret == buffer1_len)
 		ret = dvb_dmxdev_buffer_write(buffer, buffer2, buffer2_len);
-	if (ret < 0) {
-		dvb_ringbuffer_flush(buffer);
+	if (ret < 0)
 		buffer->error = ret;
-	}
 	spin_unlock(&dmxdevfilter->dev->lock);
 	wake_up(&buffer->queue);
 	return 0;
-- 
1.8.1.2

