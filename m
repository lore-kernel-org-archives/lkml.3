Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab3GZV2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:28:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999Ab3GZUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Soeren Moch <smoch@web.de>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 74/79] media: dmxdev: remove dvb_ringbuffer_flush() on writer side
Date: Fri, 26 Jul 2013 13:48:04 -0700
Message-Id: <20130726204730.580677076@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-core/dmxdev.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -377,10 +377,8 @@ static int dvb_dmxdev_section_callback(c
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
@@ -416,10 +414,8 @@ static int dvb_dmxdev_ts_callback(const
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


