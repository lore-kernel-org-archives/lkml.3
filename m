Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbbA0RuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:50:03 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:47625 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932442AbbA0Rti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:49:38 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] staging: comedi: comedi_usb.h: move USB stuff out of comedidev.h
Date: Tue, 27 Jan 2015 17:49:09 +0000
Message-Id: <1422380949-5994-10-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
References: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the USB-specific stuff out of "comedidev.h" into "comedi_usb.h".
Comedi USB drivers now include "comedi_usb.h" instead of "comedidev.h",
which now gets pulled in indirectly.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_usb.h | 24 ++++++++++++++++++++++--
 drivers/staging/comedi/comedidev.h  | 29 -----------------------------
 2 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/comedi_usb.h b/drivers/staging/comedi/comedi_usb.h
index a57025b..721128b 100644
--- a/drivers/staging/comedi/comedi_usb.h
+++ b/drivers/staging/comedi/comedi_usb.h
@@ -23,8 +23,28 @@
 
 #include "comedidev.h"
 
-/*
- * TODO: Move USB-specific stuff into here from "comedidev.h".
+struct usb_interface *comedi_to_usb_interface(struct comedi_device *);
+struct usb_device *comedi_to_usb_dev(struct comedi_device *);
+
+int comedi_usb_auto_config(struct usb_interface *, struct comedi_driver *,
+			   unsigned long context);
+void comedi_usb_auto_unconfig(struct usb_interface *);
+
+int comedi_usb_driver_register(struct comedi_driver *, struct usb_driver *);
+void comedi_usb_driver_unregister(struct comedi_driver *, struct usb_driver *);
+
+/**
+ * module_comedi_usb_driver() - Helper macro for registering a comedi USB driver
+ * @__comedi_driver: comedi_driver struct
+ * @__usb_driver: usb_driver struct
+ *
+ * Helper macro for comedi USB drivers which do not do anything special
+ * in module init/exit. This eliminates a lot of boilerplate. Each
+ * module may only use this macro once, and calling it replaces
+ * module_init() and module_exit()
  */
+#define module_comedi_usb_driver(__comedi_driver, __usb_driver) \
+	module_driver(__comedi_driver, comedi_usb_driver_register, \
+			comedi_usb_driver_unregister, &(__usb_driver))
 
 #endif /* _COMEDI_USB_H */
diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index e5daaeb..bc1dfc1 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -629,33 +629,4 @@ void comedi_pcmcia_driver_unregister(struct comedi_driver *,
 	module_driver(__comedi_driver, comedi_pcmcia_driver_register, \
 			comedi_pcmcia_driver_unregister, &(__pcmcia_driver))
 
-/* comedi_usb.c - comedi USB driver specific functions */
-
-struct usb_driver;
-struct usb_interface;
-
-struct usb_interface *comedi_to_usb_interface(struct comedi_device *);
-struct usb_device *comedi_to_usb_dev(struct comedi_device *);
-
-int comedi_usb_auto_config(struct usb_interface *, struct comedi_driver *,
-			   unsigned long context);
-void comedi_usb_auto_unconfig(struct usb_interface *);
-
-int comedi_usb_driver_register(struct comedi_driver *, struct usb_driver *);
-void comedi_usb_driver_unregister(struct comedi_driver *, struct usb_driver *);
-
-/**
- * module_comedi_usb_driver() - Helper macro for registering a comedi USB driver
- * @__comedi_driver: comedi_driver struct
- * @__usb_driver: usb_driver struct
- *
- * Helper macro for comedi USB drivers which do not do anything special
- * in module init/exit. This eliminates a lot of boilerplate. Each
- * module may only use this macro once, and calling it replaces
- * module_init() and module_exit()
- */
-#define module_comedi_usb_driver(__comedi_driver, __usb_driver) \
-	module_driver(__comedi_driver, comedi_usb_driver_register, \
-			comedi_usb_driver_unregister, &(__usb_driver))
-
 #endif /* _COMEDIDEV_H */
-- 
2.1.4

