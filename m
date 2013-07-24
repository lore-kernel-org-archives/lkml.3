Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3GXOQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:16:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45744 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab3GXOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Soeren Moch" <smoch@web.de>,
        "Sakari Ailus" <sakari.ailus@iki.fi>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.555105067@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [27/85] [media] media: dmxdev: remove dvb_ringbuffer_flush() on
 writer side
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/dvb-core/dmxdev.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -380,10 +380,8 @@ static int dvb_dmxdev_section_callback(c
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
@@ -419,10 +417,8 @@ static int dvb_dmxdev_ts_callback(const
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

