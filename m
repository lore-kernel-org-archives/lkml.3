Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaKCDLE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:11:04 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:47787 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaKCDIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:08:24 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [RFC RESEND 02/10] fusbh200: Make Xen notificaiton consistent with EHCI
Date: Sun,  2 Nov 2014 21:07:49 -0600
Message-Id: <1414984077-9750-3-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414984077-9750-1-git-send-email-chris@rorvick.com>
References: <1414984077-9750-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_XEN_DOM0 is enabled, the ehci-dbgp driver notifies Xen of
controller reset events via xen_dbgp_reset_prep() and
xen_dbgp_external_startup() (via calls to xen_dbgp_op().)  Otherwise
<linux/usb/ehci_def.h> defines them as no-ops to disable this logic.

The fusbh200 driver copies much of the dbgp code from ehci_def.h, but it
unconditionally defines the Xen hooks as no-ops, effectively disabling
these notifications when CONFIG_EARLY_PRINTK_DBGP is disabled.  When
enabled, though, notifying Xen is dependent on CONFIG_XEN_DOM0 due to
fusbh200 leveraging the ehci-dbgp driver.

The following table compares the implementations of xen_dbgp_reset_prep()
and xen_dbgp_external_startup() in the ehci-dbgp and fusbh200 drivers
under the relevant configurations:

  EARLY_PRINTK_DBGP?  XEN_DOM0?  ehci-dbgp      fusbh200
  ------------------  ---------  -------------  -------------
  n                   n          no-op          no-op
  n                   y          xen_dbgp_op()  no-op
  y                   n          no-op          no-op
  y                   y          xen_dbgp_op()  xen_dbgp_op()

This suggests that fusbh200 is, at best, indifferent to whether Xen is
notified of these events.  Make fusbh200 consistent with ehci-dbgp as a
step towards consolidating this code duplication.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/usb/host/fusbh200.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/host/fusbh200.h b/drivers/usb/host/fusbh200.h
index 6b719e0..6e7b8c1 100644
--- a/drivers/usb/host/fusbh200.h
+++ b/drivers/usb/host/fusbh200.h
@@ -318,6 +318,10 @@ extern struct console early_dbgp_console;
 
 struct usb_hcd;
 
+#ifdef CONFIG_XEN_DOM0
+extern int xen_dbgp_reset_prep(struct usb_hcd *);
+extern int xen_dbgp_external_startup(struct usb_hcd *);
+#else
 static inline int xen_dbgp_reset_prep(struct usb_hcd *hcd)
 {
 	return 1; /* Shouldn't this be 0? */
@@ -327,6 +331,7 @@ static inline int xen_dbgp_external_startup(struct usb_hcd *hcd)
 {
 	return -1;
 }
+#endif
 
 #ifdef CONFIG_EARLY_PRINTK_DBGP
 /* Call backs from fusbh200 host driver to fusbh200 debug driver */
-- 
1.9.3

