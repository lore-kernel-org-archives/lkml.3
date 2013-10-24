Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3JXVmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 17:42:36 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55012 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3JXVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 17:42:35 -0400
Subject: [PATCH] device: Make dev_WARN/dev_WARN_ONCE print device as well as
 driver name
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Date: Thu, 24 Oct 2013 15:42:33 -0600
Message-ID: <20131024214233.12347.95711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_WARN() and dev_WARN_ONCE() are annoying because (1) they include
only the driver name, not the device name, and (2) they print a spurious
newline in the middle.  This results in messages like this that are less
useful than they should be:

  [   40.094995] Device pcieport
  disabling already-disabled device

This patch makes them work more like dev_printk().

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/linux/device.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 2a9d6ed..7136a5c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1149,16 +1149,15 @@ do {									\
 #endif
 
 /*
- * dev_WARN*() acts like dev_printk(), but with the key difference
- * of using a WARN/WARN_ON to get the message out, including the
- * file/line information and a backtrace.
+ * dev_WARN*() acts like dev_printk(), but with the key difference of
+ * using WARN/WARN_ONCE to include file/line information and a backtrace.
  */
 #define dev_WARN(dev, format, arg...) \
-	WARN(1, "Device: %s\n" format, dev_driver_string(dev), ## arg);
+	WARN(1, "%s %s: " format, dev_driver_string(dev), dev_name(dev), ## arg);
 
 #define dev_WARN_ONCE(dev, condition, format, arg...) \
-	WARN_ONCE(condition, "Device %s\n" format, \
-			dev_driver_string(dev), ## arg)
+	WARN_ONCE(condition, "%s %s: " format, \
+			dev_driver_string(dev), dev_name(dev), ## arg)
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \

