Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaEBPSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:18:34 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:35026 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaEBPSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:18:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Manfred Schlaegl <manfred.schlaegl@gmx.at>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 1/2] Revert "tty: Fix race condition between __tty_buffer_request_room and flush_to_ldisc"
Date: Fri,  2 May 2014 10:56:11 -0400
Message-Id: <1399042572-6533-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 6a20dbd6caa2358716136144bf524331d70b1e03.

Although the commit correctly identifies an unsafe race condition
between __tty_buffer_request_room() and flush_to_ldisc(), the commit
fixes the race with an unnecessary spinlock in a lockless algorithm.

The follow-on commit, "tty: Fix lockless tty buffer race" fixes
the race locklessly.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 16 ++--------------
 include/linux/tty.h      |  1 -
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index f1d30f6..8ebd9f8 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -255,16 +255,11 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size,
 	if (change || left < size) {
 		/* This is the slow path - looking for new buffers to use */
 		if ((n = tty_buffer_alloc(port, size)) != NULL) {
-			unsigned long iflags;
-
 			n->flags = flags;
 			buf->tail = n;
-
-			spin_lock_irqsave(&buf->flush_lock, iflags);
 			b->commit = b->used;
+			smp_mb();
 			b->next = n;
-			spin_unlock_irqrestore(&buf->flush_lock, iflags);
-
 		} else if (change)
 			size = 0;
 		else
@@ -448,7 +443,6 @@ static void flush_to_ldisc(struct work_struct *work)
 	mutex_lock(&buf->lock);
 
 	while (1) {
-		unsigned long flags;
 		struct tty_buffer *head = buf->head;
 		int count;
 
@@ -456,19 +450,14 @@ static void flush_to_ldisc(struct work_struct *work)
 		if (atomic_read(&buf->priority))
 			break;
 
-		spin_lock_irqsave(&buf->flush_lock, flags);
 		count = head->commit - head->read;
 		if (!count) {
-			if (head->next == NULL) {
-				spin_unlock_irqrestore(&buf->flush_lock, flags);
+			if (head->next == NULL)
 				break;
-			}
 			buf->head = head->next;
-			spin_unlock_irqrestore(&buf->flush_lock, flags);
 			tty_buffer_free(port, head);
 			continue;
 		}
-		spin_unlock_irqrestore(&buf->flush_lock, flags);
 
 		count = receive_buf(tty, head, count);
 		if (!count)
@@ -523,7 +512,6 @@ void tty_buffer_init(struct tty_port *port)
 	struct tty_bufhead *buf = &port->buf;
 
 	mutex_init(&buf->lock);
-	spin_lock_init(&buf->flush_lock);
 	tty_buffer_reset(&buf->sentinel, 0);
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 036cccd..1c3316a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -61,7 +61,6 @@ struct tty_bufhead {
 	struct tty_buffer *head;	/* Queue head */
 	struct work_struct work;
 	struct mutex	   lock;
-	spinlock_t	   flush_lock;
 	atomic_t	   priority;
 	struct tty_buffer sentinel;
 	struct llist_head free;		/* Free queue head */
-- 
1.8.1.2

