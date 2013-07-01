Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3GAUKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:10:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3GAUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 15/26] rt2800: fix RT5390 & RT3290 TX power settings regression
Date: Mon,  1 Jul 2013 13:10:10 -0700
Message-Id: <20130701200731.628242148@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 8c8d2017ba25c510ddf093419048460db1109bc4 upstream.

My change:

commit cee2c7315f60beeff6137ee59e99acc77d636eeb
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Oct 5 13:44:09 2012 +0200

    rt2800: use BBP_R1 for setting tx power

unfortunately does not work well with RT5390 and RT3290 chips as they
require different temperature compensation TX power settings (TSSI
tuning). Since that commit make wireless connection very unstable on
those chips, restore previous behavior to fix regression. Once we
implement proper TSSI tuning on 5390/3290 we can restore back setting
TX power by BBP_R1 register for those chips.

Reported-and-tested-by: Mike Romberg <mike-romberg@comcast.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2634,19 +2634,26 @@ static void rt2800_config_txpower(struct
 	 * TODO: we do not use +6 dBm option to do not increase power beyond
 	 * regulatory limit, however this could be utilized for devices with
 	 * CAPABILITY_POWER_LIMIT.
+	 *
+	 * TODO: add different temperature compensation code for RT3290 & RT5390
+	 * to allow to use BBP_R1 for those chips.
 	 */
-	rt2800_bbp_read(rt2x00dev, 1, &r1);
-	if (delta <= -12) {
-		power_ctrl = 2;
-		delta += 12;
-	} else if (delta <= -6) {
-		power_ctrl = 1;
-		delta += 6;
-	} else {
-		power_ctrl = 0;
+	if (!rt2x00_rt(rt2x00dev, RT3290) &&
+	    !rt2x00_rt(rt2x00dev, RT5390)) {
+		rt2800_bbp_read(rt2x00dev, 1, &r1);
+		if (delta <= -12) {
+			power_ctrl = 2;
+			delta += 12;
+		} else if (delta <= -6) {
+			power_ctrl = 1;
+			delta += 6;
+		} else {
+			power_ctrl = 0;
+		}
+		rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, power_ctrl);
+		rt2800_bbp_write(rt2x00dev, 1, r1);
 	}
-	rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, power_ctrl);
-	rt2800_bbp_write(rt2x00dev, 1, r1);
+
 	offset = TX_PWR_CFG_0;
 
 	for (i = 0; i < EEPROM_TXPOWER_BYRATE_SIZE; i += 2) {


