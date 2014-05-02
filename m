Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaEBPOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:14:48 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:34819 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaEBPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:14:46 -0400
X-Greylist: delayed 1088 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2014 11:14:46 EDT
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Manfred Schlaegl <manfred.schlaegl@gmx.at>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] tty: Fix lockless tty buffer race
Date: Fri,  2 May 2014 10:56:12 -0400
Message-Id: <1399042572-6533-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1399042572-6533-1-git-send-email-peter@hurleysoftware.com>
References: <1399042572-6533-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: <stable@vger.kernel.org> # 3.12.x+
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 8ebd9f8..cf78d19 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -258,7 +258,11 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size,
 			n->flags = flags;
 			buf->tail = n;
 			b->commit = b->used;
-			smp_mb();
+			/* paired w/ barrier in flush_to_ldisc(); ensures the
+			 * latest commit value can be read before the head is
+			 * advanced to the next buffer
+			 */
+			smp_wmb();
 			b->next = n;
 		} else if (change)
 			size = 0;
@@ -444,17 +448,24 @@ static void flush_to_ldisc(struct work_struct *work)
 
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
1.8.1.2

