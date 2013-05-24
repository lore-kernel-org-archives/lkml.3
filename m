Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3EXSNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 14:13:32 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47920 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3EXSNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 14:13:31 -0400
From: Shawn Nematbakhsh <shawnn@chromium.org>
To: linux-usb@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Julius Werner <jwerner@chromium.org>,
        Shawn Nematbakhsh <shawnn@chromium.org>
Subject: [PATCH] usb: xhci: Disable runtime PM suspend for quirky controllers.
Date: Fri, 24 May 2013 11:12:57 -0700
Message-Id: <1369419177-23281-1-git-send-email-shawnn@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a USB controller with XHCI_RESET_ON_RESUME goes to runtime suspend,
a reset will be performed upon runtime resume. Any previously suspended
devices attached to the controller will be re-enumerated at this time.
This will cause problems, for example, if an open system call on the
device triggered the resume (the open call will fail).

Note that this change is only relevant when persist_enabled is not set
for USB devices.

Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
---
 drivers/usb/host/xhci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index b4aa79d..7455156 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4687,6 +4687,12 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 
 	get_quirks(dev, xhci);
 
+	/* If we are resetting upon resume, we must disable runtime PM.
+	 * Otherwise, an open() syscall to a device on our runtime suspended
+	 * controller will trigger controller reset and device re-enumeration */
+	if (xhci->quirks & XHCI_RESET_ON_RESUME)
+		pm_runtime_get_noresume(dev);
+
 	/* Make sure the HC is halted. */
 	retval = xhci_halt(xhci);
 	if (retval)
-- 
1.7.12.4

