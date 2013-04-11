Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935841Ab3DKVAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:00:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935797Ab3DKUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:21 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fM6GcaWpENEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=YEaYf3av5csA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=E6k37eg1NvgA:10 a=MSl-tDqOz04A:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202600.934521786@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 090/171 ] b43: N-PHY: use more bits for offset in RSSI calibration
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0090-b43-N-PHY-use-more-bits-for-offset-in-RSSI-calibrati.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

[ Upstream commit 2e1253d640eb7f8707d2591c93097c1e9f9c71d5 ]

When calculating "offset" for final RSSI calibration we're using numbers
bigger than s8 can hold. We have for example:
offset[j] = 232 - poll_results[j];
formula. If poll_results[j] is small enough (it usually is) we treat
number's bit as a sign bit. For example 232 - 1 becomes:
0xE8 - 0x1 = 0xE7, which is not 231 but -25.

This code was introduced in e0c9a0219a8f542e3946fe972a68aacf8c3f906c
and caused stability regression on some cards, for ex. BCM4322.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e167a88..914718a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1320,7 +1320,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
 
 	u8 vcm_final = 0;
-	s8 offset[4];
+	s32 offset[4];
 	s32 results[8][4] = { };
 	s32 results_min[4] = { };
 	s32 poll_results[4] = { };
@@ -1488,7 +1488,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	u8 regs_save_radio[2];
 	u16 regs_save_phy[2];
 
-	s8 offset[4];
+	s32 offset[4];
 	u8 core;
 	u8 rail;
 
-- 
1.7.10.4


