Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab3EFXaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:30:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760504Ab3EFXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Alex A. Mihaylov" <minimumlaw@rambler.ru>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 050/104] rt2x00: Fix transmit power troubles on some Ralink RT30xx cards
Date: Mon,  6 May 2013 16:12:09 -0700
Message-Id: <20130506230048.733788326@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>

commit 7e9dafd873034dd64ababcb858be424c4780ae13 upstream.

Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
value in them EEPROM/EFUSE. In this case, we must use default value,
but always used EEPROM/EFUSE value. As result we have tranmitt power
range from -10dBm to +6dBm instead 0dBm to +16dBm.

Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
more for other RT30xx chips.

Tested on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
embedded Wi-Fi module.

Signed-off-by: Alex A. Mihaylov <minimumlaw@rambler.ru>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4386,6 +4386,8 @@ static int rt2800_init_rfcsr(struct rt2x
 
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
 	    !rt2x00_rt(rt2x00dev, RT5392)) {
+		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
+
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -4396,8 +4398,10 @@ static int rt2800_init_rfcsr(struct rt2x
 				      &rt2x00dev->cap_flags))
 				rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
 		}
-		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
-				  drv_data->txmixer_gain_24g);
+		if (drv_data->txmixer_gain_24g >= min_gain) {
+			rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+					  drv_data->txmixer_gain_24g);
+		}
 		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 	}
 


