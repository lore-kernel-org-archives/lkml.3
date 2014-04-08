Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaDHMnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:43:49 -0400
Received: from mout.gmx.net ([212.227.15.15]:64003 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbaDHMns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:43:48 -0400
Message-ID: <5343EE9C.9010004@gmx.at>
Date: Tue, 08 Apr 2014 14:42:04 +0200
From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org,
        Manfred Schlaegl <manfred.schlaegl@ginzinger.com>
Subject: [PATCH] tty: Fix race condition between __tty_buffer_request_room
 and flush_to_ldisc
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:s+j4LztolYKakSOxHL4+53xHFKoaaIWPJLKUb5+3yRIIFPVrg0l
 a6ISdhgeAUQKUVO+gbbuBD9k8wbmwhysiJ4dr2uSMXsETLtWnbZNbIfPb3g/LbEWKOYA5Da
 2UEDJGNG230YRqClSNkg7Ab2Y/oIENB1N2L+UdLExuZVj6gQ81VJlLLhtWEt+2YnKKNSN7G
 QV8xpWU76Dd13sGq77d4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The race was introduced while development of linux-3.11 by
e8437d7ecbc50198705331449367d401ebb3181f and
e9975fdec0138f1b2a85b9624e41660abd9865d4.
Originally it was found and reproduced on linux-3.12.15 and
linux-3.12.15-rt25, by sending 500 byte blocks with 115kbaud to the
target uart in a loop with 100 milliseconds delay.

In short:
 1. The consumer flush_to_ldisc is on to remove the head tty_buffer.
 2. The producer adds a number of bytes, so that a new tty_buffer must
	be allocated and added by __tty_buffer_request_room.
 3. The consumer removes the head tty_buffer element, without handling
	newly committed data.

Detailed example:
 * Initial buffer:
   * Head, Tail -> 0: used=250; commit=250; read=240; next=NULL
 * Consumer: ''flush_to_ldisc''
   * consumed 10 Byte
   * buffer:
     * Head, Tail -> 0: used=250; commit=250; read=250; next=NULL
{{{
		count = head->commit - head->read;	// count = 0
		if (!count) {				// enter
			// INTERRUPTED BY PRODUCER ->
			if (head->next == NULL)
				break;
			buf->head = head->next;
			tty_buffer_free(port, head);
			continue;
		}
}}}
 * Producer: tty_insert_flip_... 10 bytes + tty_flip_buffer_push
   * buffer:
     * Head, Tail -> 0: used=250; commit=250; read=250; next=NULL
   * added 6 bytes: head-element filled to maximum.
     * buffer:
       * Head, Tail -> 0: used=256; commit=250; read=250; next=NULL
   * added 4 bytes: __tty_buffer_request_room is called
     * buffer:
       * Head -> 0: used=256; commit=256; read=250; next=1
       * Tail -> 1: used=4; commit=0; read=250 next=NULL
   * push (tty_flip_buffer_push)
     * buffer:
       * Head -> 0: used=256; commit=256; read=250; next=1
       * Tail -> 1: used=4; commit=4; read=250 next=NULL
 * Consumer
{{{
		count = head->commit - head->read;
		if (!count) {
			// INTERRUPTED BY PRODUCER <-
			if (head->next == NULL)		// -> no break
				break;
			buf->head = head->next;
			tty_buffer_free(port, head);
			// ERROR: tty_buffer head freed -> 6 bytes lost
			continue;
		}
}}}

This patch reintroduces a spin_lock to protect this case. Perhaps later
a lock-less solution could be found.

Signed-off-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
---
 drivers/tty/tty_buffer.c |   16 ++++++++++++++--
 include/linux/tty.h      |    1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 8ebd9f8..f1d30f6 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -255,11 +255,16 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size,
 	if (change || left < size) {
 		/* This is the slow path - looking for new buffers to use */
 		if ((n = tty_buffer_alloc(port, size)) != NULL) {
+			unsigned long iflags;
+
 			n->flags = flags;
 			buf->tail = n;
+
+			spin_lock_irqsave(&buf->flush_lock, iflags);
 			b->commit = b->used;
-			smp_mb();
 			b->next = n;
+			spin_unlock_irqrestore(&buf->flush_lock, iflags);
+
 		} else if (change)
 			size = 0;
 		else
@@ -443,6 +448,7 @@ static void flush_to_ldisc(struct work_struct *work)
 	mutex_lock(&buf->lock);

 	while (1) {
+		unsigned long flags;
 		struct tty_buffer *head = buf->head;
 		int count;

@@ -450,14 +456,19 @@ static void flush_to_ldisc(struct work_struct *work)
 		if (atomic_read(&buf->priority))
 			break;

+		spin_lock_irqsave(&buf->flush_lock, flags);
 		count = head->commit - head->read;
 		if (!count) {
-			if (head->next == NULL)
+			if (head->next == NULL) {
+				spin_unlock_irqrestore(&buf->flush_lock, flags);
 				break;
+			}
 			buf->head = head->next;
+			spin_unlock_irqrestore(&buf->flush_lock, flags);
 			tty_buffer_free(port, head);
 			continue;
 		}
+		spin_unlock_irqrestore(&buf->flush_lock, flags);

 		count = receive_buf(tty, head, count);
 		if (!count)
@@ -512,6 +523,7 @@ void tty_buffer_init(struct tty_port *port)
 	struct tty_bufhead *buf = &port->buf;

 	mutex_init(&buf->lock);
+	spin_lock_init(&buf->flush_lock);
 	tty_buffer_reset(&buf->sentinel, 0);
 	buf->head = &buf->sentinel;
 	buf->tail = &buf->sentinel;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1c3316a..036cccd 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -61,6 +61,7 @@ struct tty_bufhead {
 	struct tty_buffer *head;	/* Queue head */
 	struct work_struct work;
 	struct mutex	   lock;
+	spinlock_t	   flush_lock;
 	atomic_t	   priority;
 	struct tty_buffer sentinel;
 	struct llist_head free;		/* Free queue head */

