Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3FZIYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:24:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:30447 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab3FZIYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:24:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="359769032"
Subject: [PATCH] TTY: fix memory leakage in tty_buffer_find()
From: channing <chao.bi@intel.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jun 2013 16:43:01 +0800
Message-ID: <1372236181.2390.4.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In tty_buffer_find(), it scans all tty buffers in
free buffer queue, if it finds matched one,
tty->buf.free will point to matched one's next buffer,
so tty buffers that ahead of matched one are removed
from free queue, they will never be used but they
are not released, then memory leak happen.

This patch is to make tty_buffer_find() only extract
the matched tty buffer, and keep others left inside
free queue, so that they could be found and used next
time.

Signed-off-by: Chao Bi <chao.bi@intel.com>
---
 drivers/tty/tty_buffer.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 9121c1f..d587742 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -178,10 +178,14 @@ void tty_buffer_flush(struct tty_struct *tty)
 static struct tty_buffer *tty_buffer_find(struct tty_port *port, size_t size)
 {
 	struct tty_buffer **tbh = &port->buf.free;
+	struct tty_buffer *prev = port->buf.free;
 	while ((*tbh) != NULL) {
 		struct tty_buffer *t = *tbh;
 		if (t->size >= size) {
-			*tbh = t->next;
+			if (prev == NULL)
+				*tbh = t->next;
+			else
+				prev->next = t->next;
 			t->next = NULL;
 			t->used = 0;
 			t->commit = 0;
@@ -189,6 +193,7 @@ static struct tty_buffer *tty_buffer_find(struct tty_port *port, size_t size)
 			port->buf.memory_used += t->size;
 			return t;
 		}
+		prev = t;
 		tbh = &((*tbh)->next);
 	}
 	/* Round the buffer size out */
-- 
1.7.1



