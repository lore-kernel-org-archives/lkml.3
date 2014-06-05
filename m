Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaFEMLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:11:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38499 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFEMLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:11:43 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: describe members involved when reading/writing buffer
Date: Thu,  5 Jun 2014 13:11:26 +0100
Message-Id: <1401970286-32676-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
I was originally going to put it in comedidev.h but as that gets passed
through the compiler more often, I thought it would be better in
comedi_buf.c.
---
 drivers/staging/comedi/comedi_buf.c | 60 +++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/staging/comedi/comedi_buf.c b/drivers/staging/comedi/comedi_buf.c
index df4a9c4..c982393 100644
--- a/drivers/staging/comedi/comedi_buf.c
+++ b/drivers/staging/comedi/comedi_buf.c
@@ -27,6 +27,66 @@
 #define COMEDI_PAGE_PROTECTION		PAGE_KERNEL
 #endif
 
+/*
+ * Note about the ..._count and ..._ptr members in struct comedi_async:
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
+
 static void comedi_buf_map_kref_release(struct kref *kref)
 {
 	struct comedi_buf_map *bm =
-- 
1.9.2

