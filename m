Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3KKUfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:35:06 -0500
Received: from bband-dyn22.95-103-149.t-com.sk ([95.103.149.22]:10101 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961Ab3KKUe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:34:59 -0500
X-Greylist: delayed 1732 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Nov 2013 15:34:58 EST
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] TTY: tty_buffer, warn on leaks
Date: Mon, 11 Nov 2013 21:05:59 +0100
Message-Id: <1384200359-31356-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we leak something, warn about that. For that we need to account
the memory used also in the free_all method. It is handled elsewhere
correctly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_buffer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 5f08c39e76ab..20cb9492dbf8 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -115,21 +115,27 @@ void tty_buffer_free_all(struct tty_port *port)
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *p, *next;
 	struct llist_node *llist;
+	int zero = 0;
 
 	while ((p = buf->head) != NULL) {
 		buf->head = p->next;
+		atomic_sub(p->size, &buf->memory_used);
 		if (p->size > 0)
 			kfree(p);
 	}
 	llist = llist_del_all(&buf->free);
-	llist_for_each_entry_safe(p, next, llist, free)
+	llist_for_each_entry_safe(p, next, llist, free) {
+		atomic_sub(p->size, &buf->memory_used);
 		kfree(p);
+	}
+
 
 	tty_buffer_reset(&buf->sentinel, 0);
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
 
-	atomic_set(&buf->memory_used, 0);
+	atomic_xchg(&buf->memory_used, zero);
+	WARN_ON(zero != 0);
 }
 
 /**
-- 
1.8.4.2

