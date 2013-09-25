Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3IYAUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3IYAUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 047/117] usb: dont check pm qos NO_POWER_OFF flag in usb_port_suspend()
Date: Tue, 24 Sep 2013 17:18:33 -0700
Message-Id: <20130925001745.967881355@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 98a4f1ff7bea8002ab79d6776e30d27932e88244 upstream.

The pm qos NO_POWER_OFF flag is checked twice during usb device suspend
to see if the usb port power off condition is met. This is redundant and
also will prevent the port from being powered off if the NO_POWER_OFF
flag is changed to 1 from 0 after the device was already suspended.

More detail in the following link.
	http://marc.info/?l=linux-usb&m=136543949130865&w=2

This patch should be backported to kernels as old as 3.7, that
contain the commit f7ac7787ad361e31a7972e2854ed8dc2eedfac3b "usb/acpi:
Use ACPI methods to power off ports."

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3043,19 +3043,9 @@ int usb_port_suspend(struct usb_device *
 		usb_set_device_state(udev, USB_STATE_SUSPENDED);
 	}
 
-	/*
-	 * Check whether current status meets the requirement of
-	 * usb port power off mechanism
-	 */
 	if (status == 0 && !udev->do_remote_wakeup && udev->persist_enabled) {
-		enum pm_qos_flags_status pm_qos_stat;
-
-		pm_qos_stat = dev_pm_qos_flags(&port_dev->dev,
-				PM_QOS_FLAG_NO_POWER_OFF);
-		if (pm_qos_stat != PM_QOS_FLAGS_ALL) {
-			pm_runtime_put_sync(&port_dev->dev);
-			port_dev->did_runtime_put = true;
-		}
+		pm_runtime_put_sync(&port_dev->dev);
+		port_dev->did_runtime_put = true;
 	}
 
 	usb_mark_last_busy(hub->hdev);


