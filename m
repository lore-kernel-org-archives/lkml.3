Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3A3M7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:59:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab3A3M7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:59:40 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Kurachkin Michail <Michail.Kurachkin@promwad.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re: TDM bus support in Linux Kernel [PATCH]
Date: Wed, 30 Jan 2013 13:59:42 +0100
Message-ID: <1445550.3M3gD8CvZe@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 12:37:25 Kurachkin Michail wrote:
> Hi Greg,
> 
> I followed your recommendations and created a diff using Linux 3.8-rc5 sources. Please review it and give your comments.

Hi,

given the size of the thing I hope you don't mind a review in parts.
Here we go.


Do you really need all those helpers? At a minimum they should become static
to not pollute common namespaces.

	Regards
		Oliver

+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include "fifo.h"
+
+static void inc_pointer(int *pointer, int item_size, int count_items);
+
+
+/**
+ * Init circular fifo buffer
+ * @param buf - buffer descriptor
+ * @param item_size - item size in bytes
+ * @param count - count items in buffer
+ * @return 0 - ok
+ */
+int init_fifo(struct fifo_buffer *fifo, int item_size, int count)
+{
+	fifo->read_pointer = 0;
+	fifo->write_pointer = 0;
+
+	fifo->buf = kzalloc(item_size * count, GFP_KERNEL);
+	if(!fifo->buf)
+		return -ENOMEM;
+
+	fifo->count = count;
+	fifo->item_size = item_size;
+	memset(fifo->buf, 0, item_size * count);
+	return 0;
+}
+
+
+/**
+ * free fifo buffer
+ * @param fifo
+ */
+void free_fifo(struct fifo_buffer *fifo)
+{
+	if(!fifo)
+		return;
+
+	if(!fifo->buf) {
+		kfree(fifo);
+		return;
+	}
+
+	kfree(fifo->buf);
+}
+
+
+/**
+ * Push into fifo
+ * @param fifo - fifo descriptor
+ * @param item - pointer to item
+ * @return 0 - ok, 1 - item pushed and buffer is full
+ */
+int fifo_push(struct fifo_buffer *fifo, void *item)
+{
+	memcpy(fifo->buf + fifo->write_pointer, item, fifo->item_size);
+
+	inc_pointer(&fifo->write_pointer, fifo->item_size, fifo->count);
+
+	if(fifo->write_pointer == fifo->read_pointer) { // If fifo is full
+		inc_pointer(&fifo->read_pointer, fifo->item_size, fifo->count);
+		return 1;
+	}
+
+	return 0;
+}
+
+
+/**
+ * Check fifo buffer is full
+ * @param fifo - fifo descriptor
+ * @return 1 - buffer is full
+ */
+int fifo_is_full(struct fifo_buffer *fifo)
+{
+	int p;
+	p = fifo->write_pointer;
+	inc_pointer(&p, fifo->item_size, fifo->count);
+	if(p == fifo->read_pointer)
+		return 1;
+
+	return 0;
+}
+
+
+/**
+ * Check fifo is empty
+ * @param fifo - fifo descriptor
+ * @return 1 - buffer is empty
+ */
+int fifo_is_empty(struct fifo_buffer *fifo)
+{
+	return fifo->read_pointer == fifo->write_pointer;
+}
+
+
+/**
+ * Pop from fifo buffer
+ * @param fifo - fifo descriptor
+ * @param item - pointer to poped item
+ * @return 0 - ok, 1 - buffer is empty
+ */
+int fifo_pop(struct fifo_buffer *fifo, void *item)
+{
+	if(fifo->read_pointer == fifo->write_pointer)
+		return 1;
+
+	memcpy(item, fifo->buf + fifo->read_pointer, fifo->item_size);
+	inc_pointer(&fifo->read_pointer, fifo->item_size, fifo->count);
+	return 0;
+}
+
+
+/**
+ * Increment pointer in circular buffer
+ * @param pointer - pointer in circular buffer
+ * @param item_size - item size in bytes
+ * @param count_items - count items in fifo
+ */
+static void inc_pointer(int *pointer, int item_size, int count_items)
+{
+	(*pointer) += item_size;
+
+	if(*pointer >= (count_items * item_size))
+		*pointer = 0;
+}
+
