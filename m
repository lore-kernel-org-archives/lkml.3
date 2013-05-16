Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3EPIlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:41:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:24352 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab3EPIlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:41:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,683,1363158000"; 
   d="scan'208";a="303276886"
Subject: [PATCH] tty_buffer: avoid race due to tty_buffer_free_all() being
 misused
From: channing <chao.bi@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 May 2013 16:59:22 +0800
Message-ID: <1368694762.2911.16.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In tty_buffer.c, function tty_buffer_free_all() is used to remove
all buffers for a tty, although it's declared that it mustn't be called
when the tty is in use, it cannot guarantee that. we can observe some
device driver make use it by mistake, for example, while tty device is
releasing, the tty data forwarding is not stopped, then it might hit
the case that tty buffer is being used while tty_buffer_free_all()
free this tty buffer, and finally lead to random error at any places,
and it's not clear to debug.

Although device driver could do better, it's simpler and safer to
strengthen protection in the view of tty buffer, by adding a tty->buf.lock
in tty_buffer_free_all() to avoid it racing with ongoing tty buffer
operations.

Signed-off-by: channing <chao.bi@intel.com>
---
 drivers/tty/tty_buffer.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 9121c1f..c7c100d 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -32,7 +32,9 @@ void tty_buffer_free_all(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *thead;
+	unsigned long flags;
 
+	spin_lock_irqsave(&buf->lock, flags);
 	while ((thead = buf->head) != NULL) {
 		buf->head = thead->next;
 		kfree(thead);
@@ -43,6 +45,7 @@ void tty_buffer_free_all(struct tty_port *port)
 	}
 	buf->tail = NULL;
 	buf->memory_used = 0;
+	spin_unlock_irqrestore(&buf->lock, flags);
 }
 
 /**
-- 
1.7.1



