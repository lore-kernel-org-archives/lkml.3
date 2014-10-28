Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaJ1WKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:10:42 -0400
Received: from botnar.kaiser.cx ([176.28.20.183]:33057 "EHLO botnar.kaiser.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbaJ1WKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:10:41 -0400
X-Greylist: delayed 1166 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 18:10:40 EDT
Date: Tue, 28 Oct 2014 22:51:01 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] lirc: use kfifo_initialized() on lirc_buffer's fifo
Message-ID: <20141028215052.GA28171@husavik.kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use kfifo_initialized() to check if the fifo in lirc_buffer is
initialized or not. There's no need to have a dedicated fifo status
variable in lirc_buffer.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 include/media/lirc_dev.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 78f0637..05e7ad5 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -29,14 +29,13 @@ struct lirc_buffer {
 	/* Using chunks instead of bytes pretends to simplify boundary checking
 	 * And should allow for some performance fine tunning later */
 	struct kfifo fifo;
-	u8 fifo_initialized;
 };
 
 static inline void lirc_buffer_clear(struct lirc_buffer *buf)
 {
 	unsigned long flags;
 
-	if (buf->fifo_initialized) {
+	if (kfifo_initialized(&buf->fifo)) {
 		spin_lock_irqsave(&buf->fifo_lock, flags);
 		kfifo_reset(&buf->fifo);
 		spin_unlock_irqrestore(&buf->fifo_lock, flags);
@@ -56,17 +55,14 @@ static inline int lirc_buffer_init(struct lirc_buffer *buf,
 	buf->chunk_size = chunk_size;
 	buf->size = size;
 	ret = kfifo_alloc(&buf->fifo, size * chunk_size, GFP_KERNEL);
-	if (ret == 0)
-		buf->fifo_initialized = 1;
 
 	return ret;
 }
 
 static inline void lirc_buffer_free(struct lirc_buffer *buf)
 {
-	if (buf->fifo_initialized) {
+	if (kfifo_initialized(&buf->fifo)) {
 		kfifo_free(&buf->fifo);
-		buf->fifo_initialized = 0;
 	} else
 		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
 		     __func__);
-- 
1.7.10.4

