Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaIOMqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:46:24 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34901 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaIOMqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] staging: comedi: add comedi_bytes_per_scan()
Date: Mon, 15 Sep 2014 13:45:57 +0100
Message-Id: <1410785167-28506-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "comedi_fc" module contains a few functions useful to Comedi
drivers.  Their functionality is being migrated to the core "comedi"
module and renamed to start with the prefix `comedi_`.  As part of this
migration, move `cfc_bytes_per_scan()` into the core comedi module and
rename it to `comedi_bytes_per_scan()`.  Change the external declaration
of `cfc_bytes_per_scan()` into an inline function that calls
`comedi_bytes_per_scan()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h         |  1 +
 drivers/staging/comedi/drivers.c           | 37 ++++++++++++++++++++++++++++++
 drivers/staging/comedi/drivers/comedi_fc.c | 22 ------------------
 drivers/staging/comedi/drivers/comedi_fc.h |  6 ++++-
 4 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index bda5304..1c69509 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -447,6 +447,7 @@ int comedi_dio_insn_config(struct comedi_device *, struct comedi_subdevice *,
 			   unsigned int mask);
 unsigned int comedi_dio_update_state(struct comedi_subdevice *,
 				     unsigned int *data);
+unsigned int comedi_bytes_per_scan(struct comedi_subdevice *s);
 
 void *comedi_alloc_devpriv(struct comedi_device *, size_t);
 int comedi_alloc_subdevices(struct comedi_device *, int);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index c4ed8fd..891c092 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -290,6 +290,43 @@ unsigned int comedi_dio_update_state(struct comedi_subdevice *s,
 }
 EXPORT_SYMBOL_GPL(comedi_dio_update_state);
 
+/**
+ * comedi_bytes_per_scan - get length of asynchronous command "scan" in bytes
+ * @s: comedi_subdevice struct
+ *
+ * Determines the overall scan length according to the subdevice type and the
+ * number of channels in the scan.
+ *
+ * For digital input, output or input/output subdevices, samples for multiple
+ * channels are assumed to be packed into one or more unsigned short or
+ * unsigned int values according to the subdevice's SDF_LSAMPL flag.  For other
+ * types of subdevice, samples are assumed to occupy a whole unsigned short or
+ * unsigned int according to the SDF_LSAMPL flag.
+ *
+ * Returns the overall scan length in bytes.
+ */
+unsigned int comedi_bytes_per_scan(struct comedi_subdevice *s)
+{
+	struct comedi_cmd *cmd = &s->async->cmd;
+	unsigned int num_samples;
+	unsigned int bits_per_sample;
+
+	switch (s->type) {
+	case COMEDI_SUBD_DI:
+	case COMEDI_SUBD_DO:
+	case COMEDI_SUBD_DIO:
+		bits_per_sample = 8 * bytes_per_sample(s);
+		num_samples = (cmd->chanlist_len + bits_per_sample - 1) /
+				bits_per_sample;
+		break;
+	default:
+		num_samples = cmd->chanlist_len;
+		break;
+	}
+	return num_samples * bytes_per_sample(s);
+}
+EXPORT_SYMBOL_GPL(comedi_bytes_per_scan);
+
 static int insn_rw_emulate_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index c33c3e5..407ec70 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -22,28 +22,6 @@
 
 #include "comedi_fc.h"
 
-unsigned int cfc_bytes_per_scan(struct comedi_subdevice *s)
-{
-	struct comedi_cmd *cmd = &s->async->cmd;
-	unsigned int num_samples;
-	unsigned int bits_per_sample;
-
-	switch (s->type) {
-	case COMEDI_SUBD_DI:
-	case COMEDI_SUBD_DO:
-	case COMEDI_SUBD_DIO:
-		bits_per_sample = 8 * bytes_per_sample(s);
-		num_samples = (cmd->chanlist_len + bits_per_sample - 1) /
-				bits_per_sample;
-		break;
-	default:
-		num_samples = cmd->chanlist_len;
-		break;
-	}
-	return num_samples * bytes_per_sample(s);
-}
-EXPORT_SYMBOL_GPL(cfc_bytes_per_scan);
-
 void cfc_inc_scan_progress(struct comedi_subdevice *s, unsigned int num_bytes)
 {
 	struct comedi_async *async = s->async;
diff --git a/drivers/staging/comedi/drivers/comedi_fc.h b/drivers/staging/comedi/drivers/comedi_fc.h
index 541b937..90acb8f 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.h
+++ b/drivers/staging/comedi/drivers/comedi_fc.h
@@ -23,7 +23,11 @@
 
 #include "../comedidev.h"
 
-unsigned int cfc_bytes_per_scan(struct comedi_subdevice *);
+static inline unsigned int cfc_bytes_per_scan(struct comedi_subdevice *s)
+{
+	return comedi_bytes_per_scan(s);
+}
+
 void cfc_inc_scan_progress(struct comedi_subdevice *, unsigned int num_bytes);
 
 /* Writes an array of data points to comedi's buffer */
-- 
2.1.0

