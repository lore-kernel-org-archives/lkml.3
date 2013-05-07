Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab3EGNwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:52:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328Ab3EGNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Alex A. Mihaylov" <minimumlaw@rambler.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 096/118] rt2x00: Fix transmit power troubles on some Ralink RT30xx cards
Date: Tue,  7 May 2013 14:39:02 +0100
Message-Id: <1367933964-1564-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 346af52..6d0c1ec 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3862,7 +3862,9 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
 
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-		!rt2x00_rt(rt2x00dev, RT5392)) {
+	    !rt2x00_rt(rt2x00dev, RT5392)) {
+		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
+
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -3873,8 +3875,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
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
 
-- 
1.8.1.2

