Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936075Ab3DHJ5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:57:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935936Ab3DHJws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 090/102] b43: N-PHY: use more bits for offset in RSSI calibration
Date: Mon,  8 Apr 2013 10:50:45 +0100
Message-Id: <1365414657-29191-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

commit 2e1253d640eb7f8707d2591c93097c1e9f9c71d5 upstream.

When calculating "offset" for final RSSI calibration we're using numbers
bigger than s8 can hold. We have for example:
offset[j] = 232 - poll_results[j];
formula. If poll_results[j] is small enough (it usually is) we treat
number's bit as a sign bit. For example 232 - 1 becomes:
0xE8 - 0x1 = 0xE7, which is not 231 but -25.

This code was introduced in e0c9a0219a8f542e3946fe972a68aacf8c3f906c
and caused stability regression on some cards, for ex. BCM4322.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/phy_n.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 5ae0b6a..6be2f73 100644
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
@@ -1487,7 +1487,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	u8 regs_save_radio[2];
 	u16 regs_save_phy[2];
 
-	s8 offset[4];
+	s32 offset[4];
 	u8 core;
 	u8 rail;
 
-- 
1.8.1.2

