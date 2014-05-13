Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbaEMKNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:13:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703AbaEMKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 125/182] tty: Fix lockless tty buffer race
Date: Tue, 13 May 2014 11:27:57 +0200
Message-Id: <6ea8892c2e6f56e47a3a88af2065d87256a1831f.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 62a0d8d7c2b29f92850e4ee3c38e5dfd936e92b2 upstream.

Commit 6a20dbd6caa2358716136144bf524331d70b1e03,
"tty: Fix race condition between __tty_buffer_request_room and flush_to_ldisc"
correctly identifies an unsafe race condition between
__tty_buffer_request_room() and flush_to_ldisc(), where the consumer
flush_to_ldisc() prematurely advances the head before consuming the
last of the data committed. For example:

           CPU 0                     |            CPU 1
__tty_buffer_request_room            | flush_to_ldisc
  ...                                |   ...
                                     |   count = head->commit - head->read
  n = tty_buffer_alloc()             |
  b->commit = b->used                |
  b->next = n                        |
                                     |   if (!count)                /* T */
                                     |     if (head->next == NULL)  /* F */
                                     |     buf->head = head->next

In this case, buf->head has been advanced but head->commit may have
been updated with a new value.

Instead of reintroducing an unnecessary lock, fix the race locklessly.
Read the commit-next pair in the reverse order of writing, which guarantees
the commit value read is the latest value written if the head is
advancing.

Reported-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_buffer.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 2b52d807934e..4847fc57f3e2 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -248,7 +248,11 @@ int tty_buffer_request_room(struct tty_port *port, size_t size)
 		if ((n = tty_buffer_alloc(port, size)) != NULL) {
 			buf->tail = n;
 			b->commit = b->used;
-			smp_mb();
+			/* paired w/ barrier in flush_to_ldisc(); ensures the
+			 * latest commit value can be read before the head is
+			 * advanced to the next buffer
+			 */
+			smp_wmb();
 			b->next = n;
 		} else
 			size = left;
@@ -449,17 +453,24 @@ static void flush_to_ldisc(struct work_struct *work)
 
 	while (1) {
 		struct tty_buffer *head = buf->head;
+		struct tty_buffer *next;
 		int count;
 
 		/* Ldisc or user is trying to gain exclusive access */
 		if (atomic_read(&buf->priority))
 			break;
 
+		next = head->next;
+		/* paired w/ barrier in __tty_buffer_request_room();
+		 * ensures commit value read is not stale if the head
+		 * is advancing to the next buffer
+		 */
+		smp_rmb();
 		count = head->commit - head->read;
 		if (!count) {
-			if (head->next == NULL)
+			if (next == NULL)
 				break;
-			buf->head = head->next;
+			buf->head = next;
 			tty_buffer_free(port, head);
 			continue;
 		}
-- 
1.9.3

