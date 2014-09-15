Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaIOMsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:48:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34909 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaIOMqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] staging: comedi: add comedi_handle_events()
Date: Mon, 15 Sep 2014 13:46:01 +0100
Message-Id: <1410785167-28506-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "comedi_fc" module contains a few functions useful to Comedi
drivers.  Their functionality is being migrated to the core "comedi"
module and renamed to start with the prefix `comedi_`.  As part of this
migration, move `cfc_handle_events()` into the core comedi module and
rename it to `comedi_handle_events()`.  Change the external declaration
of `cfc_handle_events()` into an inline function that calls
`comedi_handle_events()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedidev.h         |  3 +++
 drivers/staging/comedi/drivers.c           | 33 ++++++++++++++++++++++++++++++
 drivers/staging/comedi/drivers/comedi_fc.c | 17 ---------------
 drivers/staging/comedi/drivers/comedi_fc.h |  7 +++++--
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index de69725..e2ba025 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -442,6 +442,9 @@ int comedi_timeout(struct comedi_device *, struct comedi_subdevice *,
 			     struct comedi_insn *, unsigned long context),
 		   unsigned long context);
 
+unsigned int comedi_handle_events(struct comedi_device *dev,
+				  struct comedi_subdevice *s);
+
 int comedi_dio_insn_config(struct comedi_device *, struct comedi_subdevice *,
 			   struct comedi_insn *, unsigned int *data,
 			   unsigned int mask);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 691a2c4..3c7d865 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -351,6 +351,39 @@ void comedi_inc_scan_progress(struct comedi_subdevice *s,
 }
 EXPORT_SYMBOL_GPL(comedi_inc_scan_progress);
 
+/**
+ * comedi_handle_events - handle events and possibly stop acquisition
+ * @dev: comedi_device struct
+ * @s: comedi_subdevice struct
+ *
+ * Handles outstanding asynchronous acquisition event flags associated
+ * with the subdevice.  Call the subdevice's "->cancel()" handler if the
+ * "end of acquisition", "error" or "overflow" event flags are set in order
+ * to stop the acquisition at the driver level.
+ *
+ * Calls comedi_event() to further process the event flags, which may mark
+ * the asynchronous command as no longer running, possibly terminated with
+ * an error, and may wake up tasks.
+ *
+ * Return a bit-mask of the handled events.
+ */
+unsigned int comedi_handle_events(struct comedi_device *dev,
+				  struct comedi_subdevice *s)
+{
+	unsigned int events = s->async->events;
+
+	if (events == 0)
+		return events;
+
+	if (events & (COMEDI_CB_EOA | COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW))
+		s->cancel(dev, s);
+
+	comedi_event(dev, s);
+
+	return events;
+}
+EXPORT_SYMBOL_GPL(comedi_handle_events);
+
 static int insn_rw_emulate_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index 7401e78..ed0e79f 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -64,23 +64,6 @@ unsigned int cfc_read_array_from_buffer(struct comedi_subdevice *s,
 }
 EXPORT_SYMBOL_GPL(cfc_read_array_from_buffer);
 
-unsigned int cfc_handle_events(struct comedi_device *dev,
-			       struct comedi_subdevice *s)
-{
-	unsigned int events = s->async->events;
-
-	if (events == 0)
-		return events;
-
-	if (events & (COMEDI_CB_EOA | COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW))
-		s->cancel(dev, s);
-
-	comedi_event(dev, s);
-
-	return events;
-}
-EXPORT_SYMBOL_GPL(cfc_handle_events);
-
 static int __init comedi_fc_init_module(void)
 {
 	return 0;
diff --git a/drivers/staging/comedi/drivers/comedi_fc.h b/drivers/staging/comedi/drivers/comedi_fc.h
index d0fe26c..c570c6eb 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.h
+++ b/drivers/staging/comedi/drivers/comedi_fc.h
@@ -53,8 +53,11 @@ static inline unsigned int cfc_write_long_to_buffer(struct comedi_subdevice *s,
 unsigned int cfc_read_array_from_buffer(struct comedi_subdevice *,
 					void *data, unsigned int num_bytes);
 
-unsigned int cfc_handle_events(struct comedi_device *,
-			       struct comedi_subdevice *);
+static inline unsigned int cfc_handle_events(struct comedi_device *dev,
+					     struct comedi_subdevice *s)
+{
+	return comedi_handle_events(dev, s);
+}
 
 /**
  * cfc_check_trigger_src() - trivially validate a comedi_cmd trigger source
-- 
2.1.0

