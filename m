Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaIOMq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:46:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34909 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaIOMq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:27 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] staging: comedi: add comedi_write_array_to_buffer()
Date: Mon, 15 Sep 2014 13:46:03 +0100
Message-Id: <1410785167-28506-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "comedi_fc" module contains a few functions useful to Comedi
drivers.  Their functionality is being migrated to the core "comedi"
module and renamed to start with the prefix `comedi_`.  As part of this
migration, move `cfc_write_array_to_buffer()` into the core comedi
module and rename it to `comedi_write_array_to_buffer()`.  Change the
external declaration of `cfc_write_array_to_buffer()` into an inline
function that calls `comedi_write_array_to_buffer()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_buf.c        | 27 +++++++++++++++++++++++++++
 drivers/staging/comedi/comedidev.h         |  3 +++
 drivers/staging/comedi/drivers/comedi_fc.c | 26 --------------------------
 drivers/staging/comedi/drivers/comedi_fc.h | 10 ++++++----
 4 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/comedi_buf.c b/drivers/staging/comedi/comedi_buf.c
index df4a9c4..5aa8684 100644
--- a/drivers/staging/comedi/comedi_buf.c
+++ b/drivers/staging/comedi/comedi_buf.c
@@ -509,3 +509,30 @@ void comedi_buf_memcpy_from(struct comedi_subdevice *s, unsigned int offset,
 	}
 }
 EXPORT_SYMBOL_GPL(comedi_buf_memcpy_from);
+
+/* Writes an array of data points to comedi's buffer */
+unsigned int comedi_write_array_to_buffer(struct comedi_subdevice *s,
+					  const void *data,
+					  unsigned int num_bytes)
+{
+	struct comedi_async *async = s->async;
+	unsigned int retval;
+
+	if (num_bytes == 0)
+		return 0;
+
+	retval = comedi_buf_write_alloc(s, num_bytes);
+	if (retval != num_bytes) {
+		dev_warn(s->device->class_dev, "buffer overrun\n");
+		async->events |= COMEDI_CB_OVERFLOW;
+		return 0;
+	}
+
+	comedi_buf_memcpy_to(s, 0, data, num_bytes);
+	comedi_buf_write_free(s, num_bytes);
+	comedi_inc_scan_progress(s, num_bytes);
+	async->events |= COMEDI_CB_BLOCK;
+
+	return num_bytes;
+}
+EXPORT_SYMBOL_GPL(comedi_write_array_to_buffer);
diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index e2ba025..cbcbf9e 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -431,6 +431,9 @@ void comedi_buf_memcpy_to(struct comedi_subdevice *s, unsigned int offset,
 			  const void *source, unsigned int num_bytes);
 void comedi_buf_memcpy_from(struct comedi_subdevice *s, unsigned int offset,
 			    void *destination, unsigned int num_bytes);
+unsigned int comedi_write_array_to_buffer(struct comedi_subdevice *s,
+					  const void *data,
+					  unsigned int num_bytes);
 
 /* drivers.c - general comedi driver functions */
 
diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index 6f87220..d4244eb 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -22,32 +22,6 @@
 
 #include "comedi_fc.h"
 
-/* Writes an array of data points to comedi's buffer */
-unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *s,
-				       const void *data, unsigned int num_bytes)
-{
-	struct comedi_async *async = s->async;
-	unsigned int retval;
-
-	if (num_bytes == 0)
-		return 0;
-
-	retval = comedi_buf_write_alloc(s, num_bytes);
-	if (retval != num_bytes) {
-		dev_warn(s->device->class_dev, "buffer overrun\n");
-		async->events |= COMEDI_CB_OVERFLOW;
-		return 0;
-	}
-
-	comedi_buf_memcpy_to(s, 0, data, num_bytes);
-	comedi_buf_write_free(s, num_bytes);
-	comedi_inc_scan_progress(s, num_bytes);
-	async->events |= COMEDI_CB_BLOCK;
-
-	return num_bytes;
-}
-EXPORT_SYMBOL_GPL(cfc_write_array_to_buffer);
-
 unsigned int cfc_read_array_from_buffer(struct comedi_subdevice *s,
 					void *data, unsigned int num_bytes)
 {
diff --git a/drivers/staging/comedi/drivers/comedi_fc.h b/drivers/staging/comedi/drivers/comedi_fc.h
index fa3de9e..51b3157 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.h
+++ b/drivers/staging/comedi/drivers/comedi_fc.h
@@ -34,10 +34,12 @@ static inline void cfc_inc_scan_progress(struct comedi_subdevice *s,
 	comedi_inc_scan_progress(s, num_bytes);
 }
 
-/* Writes an array of data points to comedi's buffer */
-unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *s,
-				       const void *data,
-				       unsigned int num_bytes);
+static inline unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *s,
+						     const void *data,
+						     unsigned int num_bytes)
+{
+	return comedi_write_array_to_buffer(s, data, num_bytes);
+}
 
 static inline unsigned int cfc_write_to_buffer(struct comedi_subdevice *s,
 					       unsigned short data)
-- 
2.1.0

