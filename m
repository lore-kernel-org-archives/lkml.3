Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab3K0BcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:32:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3K0A6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabor Juhos <juhosg@openwrt.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 032/116] rt2x00: rt2800lib: fix VGC adjustment for RT5592
Date: Tue, 26 Nov 2013 16:56:45 -0800
Message-Id: <20131127005739.183121948@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit 0beb1bbf19c72f17809e42b8f33522a55c2cc18c upstream.

In commit 3d81535ea5940446510a8a5cee1c6ad23c90c753
(rt2800: 5592: add chip specific vgc calculations)
the rt2800_link_tuner function has been modified to
adjust VGC level for the RT5592 chipset.

On the RT5592 chipset, the VGC level must be adjusted
only if rssi is greater than -65. However the current
code adjusts the VGC value by 0x10 regardless of the
actual chipset if the rssi value is between -80 and
-65.

Fix the broken behaviour by reordering the if-else
statements.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4461,10 +4461,13 @@ void rt2800_link_tuner(struct rt2x00_dev
 
 	vgc = rt2800_get_default_vgc(rt2x00dev);
 
-	if (rt2x00_rt(rt2x00dev, RT5592) && qual->rssi > -65)
-		vgc += 0x20;
-	else if (qual->rssi > -80)
-		vgc += 0x10;
+	if (rt2x00_rt(rt2x00dev, RT5592)) {
+		if (qual->rssi > -65)
+			vgc += 0x20;
+	} else {
+		if (qual->rssi > -80)
+			vgc += 0x10;
+	}
 
 	rt2800_set_vgc(rt2x00dev, qual, vgc);
 }


