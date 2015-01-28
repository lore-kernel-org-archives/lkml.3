Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbbA1CGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:06:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759779AbbA1B21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Tseng <rogerable@realtek.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.18 07/61] mfd: rtsx_usb: Fix runtime PM deadlock
Date: Tue, 27 Jan 2015 17:26:19 -0800
Message-Id: <20150128012637.712990042@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Tseng <rogerable@realtek.com>

commit b166010f6afbadb896efa37ff85eb681a8f89392 upstream.

sd_set_power_mode() in derived module drivers/mmc/host/rtsx_usb_sdmmc.c
acquires dev_mutex and then calls pm_runtime_get_sync() to make sure the
device is awake while initializing a newly inserted card. Once it is
called during suspending state and explicitly before rtsx_usb_suspend()
acquires the same dev_mutex, both routine deadlock and further hang the
driver because pm_runtime_get_sync() waits the pending PM operations.

Fix this by using an empty suspend method. mmc_core always turns the
LED off after a request is done and thus it is ok to remove the only
rtsx_usb_turn_off_led() here.

Fixes: 730876be2566 ("mfd: Add realtek USB card reader driver")
Signed-off-by: Roger Tseng <rogerable@realtek.com>
[Lee: Removed newly unused variable]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/rtsx_usb.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -681,21 +681,9 @@ static void rtsx_usb_disconnect(struct u
 #ifdef CONFIG_PM
 static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
 {
-	struct rtsx_ucr *ucr =
-		(struct rtsx_ucr *)usb_get_intfdata(intf);
-
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
 


