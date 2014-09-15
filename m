Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaIOMrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:47:32 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34909 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaIOMq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:28 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] staging: comedi: add comedi_read_array_from_buffer()
Date: Mon, 15 Sep 2014 13:46:05 +0100
Message-Id: <1410785167-28506-10-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "comedi_fc" module contains a few functions useful to Comedi
drivers.  Their functionality is being migrated to the core "comedi"
module and renamed to start with the prefix `comedi_`.  As part of this
migration, move `cfc_read_array_from_buffer()` into the core comedi
module and rename it to `comedi_read_array_from_buffer()`.  Change the
external declaration of `cfc_read_array_from_buffer()` into an inline
function that calls `comedi_read_array_from_buffer()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_buf.c        | 27 +++++++++++++++++++++++++++
 drivers/staging/comedi/comedidev.h         |  2 ++
 drivers/staging/comedi/drivers/comedi_fc.c | 16 ----------------
 drivers/staging/comedi/drivers/comedi_fc.h |  8 ++++++--
 4 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/comedi_buf.c b/drivers/staging/comedi/comedi_buf.c
index 52a75d2..c3f5751 100644
--- a/drivers/staging/comedi/comedi_buf.c
+++ b/drivers/staging/comedi/comedi_buf.c
@@ -547,3 +547,30 @@ unsigned int comedi_write_array_to_buffer(struct comedi_subdevice *s,
 	return num_bytes;
 }
 EXPORT_SYMBOL_GPL(comedi_write_array_to_buffer);
+
+/**
+ * comedi_read_array_from_buffer - read data from comedi buffer
+ * @s: comedi_subdevice struct
+ * @data: destination
+ * @num_bytes: number of bytes to read
+ *
+ * Reads up to num_bytes bytes of data from the comedi buffer associated with
+ * the subdevice, marks it as read and updates the acquisition scan progress.
+ *
+ * Returns the amount of data read in bytes.
+ */
+unsigned int comedi_read_array_from_buffer(struct comedi_subdevice *s,
+					   void *data, unsigned int num_bytes)
+{
+	if (num_bytes == 0)
+		return 0;
+
+	num_bytes = comedi_buf_read_alloc(s, num_bytes);
+	comedi_buf_memcpy_from(s, 0, data, num_bytes);
+	comedi_buf_read_free(s, num_bytes);
+	comedi_inc_scan_progress(s, num_bytes);
+	s->async->events |= COMEDI_CB_BLOCK;
+
+	return num_bytes;
+}
+EXPORT_SYMBOL_GPL(comedi_read_array_from_buffer);
diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index cbcbf9e..feec9f8 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -434,6 +434,8 @@ void comedi_buf_memcpy_from(struct comedi_subdevice *s, unsigned int offset,
 unsigned int comedi_write_array_to_buffer(struct comedi_subdevice *s,
 					  const void *data,
 					  unsigned int num_bytes);
+unsigned int comedi_read_array_from_buffer(struct comedi_subdevice *s,
+					   void *data, unsigned int num_bytes);
 
 /* drivers.c - general comedi driver functions */
 
diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index d4244eb..6f99a1e 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -22,22 +22,6 @@
 
 #include "comedi_fc.h"
 
-unsigned int cfc_read_array_from_buffer(struct comedi_subdevice *s,
-					void *data, unsigned int num_bytes)
-{
-	if (num_bytes == 0)
-		return 0;
-
-	num_bytes = comedi_buf_read_alloc(s, num_bytes);
-	comedi_buf_memcpy_from(s, 0, data, num_bytes);
-	comedi_buf_read_free(s, num_bytes);
-	comedi_inc_scan_progress(s, num_bytes);
-	s->async->events |= COMEDI_CB_BLOCK;
-
-	return num_bytes;
-}
-EXPORT_SYMBOL_GPL(cfc_read_array_from_buffer);
-
 static int __init comedi_fc_init_module(void)
 {
 	return 0;
diff --git a/drivers/staging/comedi/drivers/comedi_fc.h b/drivers/staging/comedi/drivers/comedi_fc.h
index 75bbc31..ce28359 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.h
+++ b/drivers/staging/comedi/drivers/comedi_fc.h
@@ -53,8 +53,12 @@ static inline unsigned int cfc_write_long_to_buffer(struct comedi_subdevice *s,
 	return comedi_write_array_to_buffer(s, &data, sizeof(data));
 };
 
-unsigned int cfc_read_array_from_buffer(struct comedi_subdevice *,
-					void *data, unsigned int num_bytes);
+static inline unsigned int
+cfc_read_array_from_buffer(struct comedi_subdevice *s, void *data,
+			   unsigned int num_bytes)
+{
+	return comedi_read_array_from_buffer(s, data, num_bytes);
+}
 
 static inline unsigned int cfc_handle_events(struct comedi_device *dev,
 					     struct comedi_subdevice *s)
-- 
2.1.0

