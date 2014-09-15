Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaIOMrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:47:53 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34915 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbaIOMq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:27 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] staging: comedi: add comedi_inc_scan_progress()
Date: Mon, 15 Sep 2014 13:45:59 +0100
Message-Id: <1410785167-28506-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "comedi_fc" module contains a few functions useful to Comedi
drivers.  Their functionality is being migrated to the core "comedi"
module and renamed to start with the prefix `comedi_`.  As part of this
migration, move `cfc_inc_scan_progress()` into the core comedi module
and rename it to `comedi_inc_scan_progress()`.  Change the external
declaration of `cfc_inc_scan_progress()` into an inline function that
calls `comedi_inc_scan_progress()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h         |  2 ++
 drivers/staging/comedi/drivers.c           | 24 ++++++++++++++++++++++++
 drivers/staging/comedi/drivers/comedi_fc.c | 13 -------------
 drivers/staging/comedi/drivers/comedi_fc.h |  6 +++++-
 4 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 1c69509..de69725 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -448,6 +448,8 @@ int comedi_dio_insn_config(struct comedi_device *, struct comedi_subdevice *,
 unsigned int comedi_dio_update_state(struct comedi_subdevice *,
 				     unsigned int *data);
 unsigned int comedi_bytes_per_scan(struct comedi_subdevice *s);
+void comedi_inc_scan_progress(struct comedi_subdevice *s,
+			      unsigned int num_bytes);
 
 void *comedi_alloc_devpriv(struct comedi_device *, size_t);
 int comedi_alloc_subdevices(struct comedi_device *, int);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 891c092..691a2c4 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -327,6 +327,30 @@ unsigned int comedi_bytes_per_scan(struct comedi_subdevice *s)
 }
 EXPORT_SYMBOL_GPL(comedi_bytes_per_scan);
 
+/**
+ * comedi_inc_scan_progress - update scan progress in asynchronous command
+ * @s: comedi_subdevice struct
+ * @num_bytes: amount of data in bytes to increment scan progress
+ *
+ * Increments the scan progress by the number of bytes specified by num_bytes.
+ * If the scan progress reaches or exceeds the scan length in bytes, reduce
+ * it modulo the scan length in bytes and set the "end of scan" asynchronous
+ * event flag to be processed later.
+ */
+void comedi_inc_scan_progress(struct comedi_subdevice *s,
+			      unsigned int num_bytes)
+{
+	struct comedi_async *async = s->async;
+	unsigned int scan_length = comedi_bytes_per_scan(s);
+
+	async->scan_progress += num_bytes;
+	if (async->scan_progress >= scan_length) {
+		async->scan_progress %= scan_length;
+		async->events |= COMEDI_CB_EOS;
+	}
+}
+EXPORT_SYMBOL_GPL(comedi_inc_scan_progress);
+
 static int insn_rw_emulate_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index 72fa718..8a4abe8 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -22,19 +22,6 @@
 
 #include "comedi_fc.h"
 
-void cfc_inc_scan_progress(struct comedi_subdevice *s, unsigned int num_bytes)
-{
-	struct comedi_async *async = s->async;
-	unsigned int scan_length = comedi_bytes_per_scan(s);
-
-	async->scan_progress += num_bytes;
-	if (async->scan_progress >= scan_length) {
-		async->scan_progress %= scan_length;
-		async->events |= COMEDI_CB_EOS;
-	}
-}
-EXPORT_SYMBOL_GPL(cfc_inc_scan_progress);
-
 /* Writes an array of data points to comedi's buffer */
 unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *s,
 				       void *data, unsigned int num_bytes)
diff --git a/drivers/staging/comedi/drivers/comedi_fc.h b/drivers/staging/comedi/drivers/comedi_fc.h
index 90acb8f..d0fe26c 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.h
+++ b/drivers/staging/comedi/drivers/comedi_fc.h
@@ -28,7 +28,11 @@ static inline unsigned int cfc_bytes_per_scan(struct comedi_subdevice *s)
 	return comedi_bytes_per_scan(s);
 }
 
-void cfc_inc_scan_progress(struct comedi_subdevice *, unsigned int num_bytes);
+static inline void cfc_inc_scan_progress(struct comedi_subdevice *s,
+					 unsigned int num_bytes)
+{
+	comedi_inc_scan_progress(s, num_bytes);
+}
 
 /* Writes an array of data points to comedi's buffer */
 unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *,
-- 
2.1.0

