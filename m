Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967617AbaFTNPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:15:21 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49869 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967610AbaFTNPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:15:17 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: describe struct comedi_async
Date: Fri, 20 Jun 2014 14:15:04 +0100
Message-Id: <1403270104-26365-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe `struct comedi_async` in kerneldoc format.  Expand on the
members involved in reading/writing the buffer.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
This replaces a previous patch titled "staging: comedi: describe members
involved when reading/writing buffer", Message-ID:
<1401970286-32676-1-git-send-email-abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h | 117 +++++++++++++++++++++++++++++--------
 1 file changed, 92 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 8f4e44b..71851bd 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -107,43 +107,110 @@ struct comedi_buf_map {
 	struct kref refcount;
 };
 
+/**
+ * struct comedi_async - control data for asynchronous comedi commands
+ * @prealloc_buf:	preallocated buffer
+ * @prealloc_bufsz:	buffer size (in bytes)
+ * @buf_map:		map of buffer pages
+ * @max_bufsize:	maximum buffer size (in bytes)
+ * @buf_write_count:	"write completed" count (in bytes, modulo 2**32)
+ * @buf_write_alloc_count: "allocated for writing" count (in bytes,
+ *			modulo 2**32)
+ * @buf_read_count:	"read completed" count (in bytes, modulo 2**32)
+ * @buf_read_alloc_count: "allocated for reading" count (in bytes,
+ *			modulo 2**32)
+ * @buf_write_ptr:	buffer position for writer
+ * @buf_read_ptr:	buffer position for reader
+ * @cur_chan:		current position in chanlist for scan (for those
+ *			drivers that use it)
+ * @scan_progress:	amount received or sent for current scan (in bytes)
+ * @munge_chan:		current position in chanlist for "munging"
+ * @munge_count:	"munge" count (in bytes, modulo 2**32)
+ * @munge_ptr:		buffer position for "munging"
+ * @events:		bit-vector of events that have occurred
+ * @cmd:		details of comedi command in progress
+ * @wait_head:		task wait queue for file reader or writer
+ * @cb_mask:		bit-vector of events that should wake waiting tasks
+ * @inttrig:		software trigger function for command, or NULL
+ *
+ * Note about the ..._count and ..._ptr members:
+ *
+ * Think of the _Count values being integers of unlimited size, indexing
+ * into a buffer of infinite length (though only an advancing portion
+ * of the buffer of fixed length prealloc_bufsz is accessible at any time).
+ * Then:
+ *
+ *   Buf_Read_Count <= Buf_Read_Alloc_Count <= Munge_Count <=
+ *   Buf_Write_Count <= Buf_Write_Alloc_Count <=
+ *   (Buf_Read_Count + prealloc_bufsz)
+ *
+ * (Those aren't the actual members, apart from prealloc_bufsz.) When
+ * the buffer is reset, those _Count values start at 0 and only increase
+ * in value, maintaining the above inequalities until the next time the
+ * buffer is reset.  The buffer is divided into the following regions by
+ * the inequalities:
+ *
+ *   [0, Buf_Read_Count):
+ *     old region no longer accessible
+ *   [Buf_Read_Count, Buf_Read_Alloc_Count):
+ *     filled and munged region allocated for reading but not yet read
+ *   [Buf_Read_Alloc_Count, Munge_Count):
+ *     filled and munged region not yet allocated for reading
+ *   [Munge_Count, Buf_Write_Count):
+ *     filled region not yet munged
+ *   [Buf_Write_Count, Buf_Write_Alloc_Count):
+ *     unfilled region allocated for writing but not yet written
+ *   [Buf_Write_Alloc_Count, Buf_Read_Count + prealloc_bufsz):
+ *     unfilled region not yet allocated for writing
+ *   [Buf_Read_Count + prealloc_bufsz, infinity):
+ *     unfilled region not yet accessible
+ *
+ * Data needs to be written into the buffer before it can be read out,
+ * and may need to be converted (or "munged") between the two
+ * operations.  Extra unfilled buffer space may need to allocated for
+ * writing (advancing Buf_Write_Alloc_Count) before new data is written.
+ * After writing new data, the newly filled space needs to be released
+ * (advancing Buf_Write_Count).  This also results in the new data being
+ * "munged" (advancing Munge_Count).  Before data is read out of the
+ * buffer, extra space may need to be allocated for reading (advancing
+ * Buf_Read_Alloc_Count).  After the data has been read out, the space
+ * needs to be released (advancing Buf_Read_Count).
+ *
+ * The actual members, buf_read_count, buf_read_alloc_count,
+ * munge_count, buf_write_count, and buf_write_alloc_count take the
+ * value of the corresponding capitalized _Count values modulo 2^32
+ * (UINT_MAX+1).  Subtracting a "higher" _count value from a "lower"
+ * _count value gives the same answer as subtracting a "higher" _Count
+ * value from a lower _Count value because prealloc_bufsz < UINT_MAX+1.
+ * The modulo operation is done implicitly.
+ *
+ * The buf_read_ptr, munge_ptr, and buf_write_ptr members take the value
+ * of the corresponding capitalized _Count values modulo prealloc_bufsz.
+ * These correspond to byte indices in the physical buffer.  The modulo
+ * operation is done by subtracting prealloc_bufsz when the value
+ * exceeds prealloc_bufsz (assuming prealloc_bufsz plus the increment is
+ * less than or equal to UINT_MAX).
+ */
 struct comedi_async {
-	void *prealloc_buf;	/* pre-allocated buffer */
-	unsigned int prealloc_bufsz;	/* buffer size, in bytes */
-	struct comedi_buf_map *buf_map;	/* map of buffer pages */
-
-	unsigned int max_bufsize;	/* maximum buffer size, bytes */
-
-	/* byte count for writer (write completed) */
+	void *prealloc_buf;
+	unsigned int prealloc_bufsz;
+	struct comedi_buf_map *buf_map;
+	unsigned int max_bufsize;
 	unsigned int buf_write_count;
-	/* byte count for writer (allocated for writing) */
 	unsigned int buf_write_alloc_count;
-	/* byte count for reader (read completed) */
 	unsigned int buf_read_count;
-	/* byte count for reader (allocated for reading) */
 	unsigned int buf_read_alloc_count;
-
-	unsigned int buf_write_ptr;	/* buffer marker for writer */
-	unsigned int buf_read_ptr;	/* buffer marker for reader */
-
-	unsigned int cur_chan;	/* useless channel marker for interrupt */
-	/* number of bytes that have been received for current scan */
+	unsigned int buf_write_ptr;
+	unsigned int buf_read_ptr;
+	unsigned int cur_chan;
 	unsigned int scan_progress;
-	/* keeps track of where we are in chanlist as for munging */
 	unsigned int munge_chan;
-	/* number of bytes that have been munged */
 	unsigned int munge_count;
-	/* buffer marker for munging */
 	unsigned int munge_ptr;
-
-	unsigned int events;	/* events that have occurred */
-
+	unsigned int events;
 	struct comedi_cmd cmd;
-
 	wait_queue_head_t wait_head;
-
 	unsigned int cb_mask;
-
 	int (*inttrig)(struct comedi_device *dev, struct comedi_subdevice *s,
 		       unsigned int x);
 };
-- 
2.0.0

