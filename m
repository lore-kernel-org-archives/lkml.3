Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaLALgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:36:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbaLALgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:36:12 -0500
Date: Mon, 1 Dec 2014 13:35:57 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio_console: fix sparse warnings
Message-ID: <1417433749-17408-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CHECK drivers/char/virtio_console.c
drivers/char/virtio_console.c:687:36: warning: incorrect type in
	argument 1 (different address spaces)
drivers/char/virtio_console.c:687:36:    expected void [noderef]
	<asn:1>*to
drivers/char/virtio_console.c:687:36:    got char *out_buf
drivers/char/virtio_console.c:790:35: warning: incorrect type in
	argument 2 (different address spaces)
drivers/char/virtio_console.c:790:35:    expected char *out_buf
drivers/char/virtio_console.c:790:35:    got char [noderef]
	<asn:1>*ubuf

fill_readbuf is reused with both kernel and userspace pointers,
depending on value of to_user flag.

Tag address parameter as __user, and cast to/from regular pointer type
when we know it's safe.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/virtio_console.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 775c898..ccb5357 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -669,8 +669,8 @@ done:
  * Give out the data that's requested from the buffer that we have
  * queued up.
  */
-static ssize_t fill_readbuf(struct port *port, char *out_buf, size_t out_count,
-			    bool to_user)
+static ssize_t fill_readbuf(struct port *port, char __user *out_buf,
+			    size_t out_count, bool to_user)
 {
 	struct port_buffer *buf;
 	unsigned long flags;
@@ -688,7 +688,8 @@ static ssize_t fill_readbuf(struct port *port, char *out_buf, size_t out_count,
 		if (ret)
 			return -EFAULT;
 	} else {
-		memcpy(out_buf, buf->buf + buf->offset, out_count);
+		memcpy((__force char *)out_buf, buf->buf + buf->offset,
+		       out_count);
 	}
 
 	buf->offset += out_count;
@@ -1162,7 +1163,7 @@ static int get_chars(u32 vtermno, char *buf, int count)
 	/* If we don't have an input queue yet, we can't get input. */
 	BUG_ON(!port->in_vq);
 
-	return fill_readbuf(port, buf, count, false);
+	return fill_readbuf(port, (__force char __user *)buf, count, false);
 }
 
 static void resize_console(struct port *port)
-- 
MST
