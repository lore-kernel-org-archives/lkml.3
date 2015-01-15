Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbbAOHMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:12:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49427 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbAOHMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:12:31 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0F7Bo51016246, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>, Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 1/2] mfd: rtsx_usb: Fix runtime PM deadlock
Date: Thu, 15 Jan 2015 15:14:44 +0800
Message-ID: <1421306085-32254-2-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421306085-32254-1-git-send-email-rogerable@realtek.com>
References: <1421306085-32254-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.121]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd_set_power_mode() in derived module drivers/mmc/host/rtsx_usb_sdmmc.c
acquires dev_mutex and then calls pm_runtime_get_sync() to make sure the
device is awake while initializing a newly inserted card. Once it is
called during suspending state and explicitly before rtsx_usb_suspend()
acquires the same dev_mutex, both routine deadlock and further hang the
driver because pm_runtime_get_sync() waits the pending PM operations.

Fix this by using an empty suspend method. mmc_core always turns the
LED off after a request is done and thus it is ok to remove the only
rtsx_usb_turn_off_led() here.

Cc: <stable@vger.kernel.org> # v3.16+
Fixes: 730876be2566 ("mfd: Add realtek USB card reader driver")
Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/mfd/rtsx_usb.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index dbdd0faeb6ce..076694126e5d 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -687,15 +687,6 @@ static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
 			__func__, message.event);
 
-	/*
-	 * Call to make sure LED is off during suspend to save more power.
-	 * It is NOT a permanent state and could be turned on anytime later.
-	 * Thus no need to call turn_on when resunming.
-	 */
-	mutex_lock(&ucr->dev_mutex);
-	rtsx_usb_turn_off_led(ucr);
-	mutex_unlock(&ucr->dev_mutex);
-
 	return 0;
 }
 
-- 
2.1.3

