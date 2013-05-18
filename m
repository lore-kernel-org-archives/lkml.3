Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab3ERCWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:22:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3ERCQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:53 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JvklQo6eCg0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yjFByQXMy3wA:10 a=55jZN7dOAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=vmLDa1wCAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=DOhmyJaKgYsw1r8E:21 a=woLTOoQ6ZnmcVN41:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021648.245803875@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Alex A. Mihaylov" <minimumlaw@rambler.ru>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 040/136 ] rt2x00: Fix transmit power troubles on some Ralink RT30xx cards
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0040-rt2x00-Fix-transmit-power-troubles-on-some-Ralink-RT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>

[ Upstream commit 7e9dafd873034dd64ababcb858be424c4780ae13 ]

Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
value in them EEPROM/EFUSE. In this case, we must use default value,
but always used EEPROM/EFUSE value. As result we have tranmitt power
range from -10dBm to +6dBm instead 0dBm to +16dBm.

Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
more for other RT30xx chips.

Tested on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
embedded Wi-Fi module.

Signed-off-by: Alex A. Mihaylov <minimumlaw@rambler.ru>
Cc: stable@vger.kernel.org
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1345bdd..6c85ba5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4148,7 +4148,9 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
 
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-		!rt2x00_rt(rt2x00dev, RT5392)) {
+	    !rt2x00_rt(rt2x00dev, RT5392)) {
+		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
+
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -4159,8 +4161,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
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
1.7.10.4


