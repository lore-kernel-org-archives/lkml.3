Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaI2EvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:51:16 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56834 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaI2Etj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:49:39 -0400
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [RFC RESEND 06/10] fotg210: Make Xen notificaiton consistent with EHCI
Date: Sun, 28 Sep 2014 23:48:54 -0500
Message-Id: <1411966138-3053-7-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411966138-3053-1-git-send-email-chris@rorvick.com>
References: <1411966138-3053-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_XEN_DOM0 is enabled, the ehci-dbgp driver notifies Xen of
controller reset events via xen_dbgp_reset_prep() and
xen_dbgp_external_startup() (via calls to xen_dbgp_op().)  Otherwise
<linux/usb/ehci_def.h> defines them as no-ops to disable this logic.

The fotg210 driver copies much of the dbgp code from ehci_def.h, but it
unconditionally defines the Xen hooks as no-ops, effectively disabling
these notifications when CONFIG_EARLY_PRINTK_DBGP is disabled.  When
enabled, though, notifying Xen is dependent on CONFIG_XEN_DOM0 due to
fotg210 leveraging the ehci-dbgp driver.

The following table compares the implementations of xen_dbgp_reset_prep()
and xen_dbgp_external_startup() in the ehci-dbgp and fotg210 drivers
under the relevant configurations:

  EARLY_PRINTK_DBGP?  XEN_DOM0?  ehci-dbgp      fotg210
  ------------------  ---------  -------------  -------------
  n                   n          no-op          no-op
  n                   y          xen_dbgp_op()  no-op
  y                   n          no-op          no-op
  y                   y          xen_dbgp_op()  xen_dbgp_op()

This suggests that fotg210 is, at best, indifferent to whether Xen is
notified of these events.  Make fotg210 consistent with ehci-dbgp as a
step towards consolidating this code duplication.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/usb/host/fotg210.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/host/fotg210.h b/drivers/usb/host/fotg210.h
index ac6cd1b..98c9670 100644
--- a/drivers/usb/host/fotg210.h
+++ b/drivers/usb/host/fotg210.h
@@ -326,6 +326,10 @@ extern struct console early_dbgp_console;
 
 struct usb_hcd;
 
+#ifdef CONFIG_XEN_DOM0
+extern int xen_dbgp_reset_prep(struct usb_hcd *);
+extern int xen_dbgp_external_startup(struct usb_hcd *);
+#else
 static inline int xen_dbgp_reset_prep(struct usb_hcd *hcd)
 {
 	return 1; /* Shouldn't this be 0? */
@@ -335,6 +339,7 @@ static inline int xen_dbgp_external_startup(struct usb_hcd *hcd)
 {
 	return -1;
 }
+#endif
 
 #ifdef CONFIG_EARLY_PRINTK_DBGP
 /* Call backs from fotg210 host driver to fotg210 debug driver */
-- 
1.9.3

