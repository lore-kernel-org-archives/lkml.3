Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab3DBWaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:30:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651Ab3DBWOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 17/68] b43: N-PHY: use more bits for offset in RSSI calibration
Date: Tue,  2 Apr 2013 15:13:06 -0700
Message-Id: <20130402221331.940836907@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

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

---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1320,7 +1320,7 @@ static void b43_nphy_rev3_rssi_cal(struc
 	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
 
 	u8 vcm_final = 0;
-	s8 offset[4];
+	s32 offset[4];
 	s32 results[8][4] = { };
 	s32 results_min[4] = { };
 	s32 poll_results[4] = { };
@@ -1487,7 +1487,7 @@ static void b43_nphy_rev2_rssi_cal(struc
 	u8 regs_save_radio[2];
 	u16 regs_save_phy[2];
 
-	s8 offset[4];
+	s32 offset[4];
 	u8 core;
 	u8 rail;
 


