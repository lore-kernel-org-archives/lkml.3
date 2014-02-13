Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaBMOfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:35:51 -0500
Received: from 213083164162.static.sonofon.dk ([213.83.164.162]:34975 "EHLO
	HORWDSPRD01.spectralink.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751571AbaBMOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:35:46 -0500
From: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
To: richardcochran@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH v3 1/3] net:phy:dp83640: Program pulsewidth2 values of perout triggers 0 and 1
Date: Thu, 13 Feb 2014 15:35:27 +0100
Message-Id: <1392302129-24947-6-git-send-email-stefan.sorensen@spectralink.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
References: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Feb 2014 14:35:44.0010 (UTC) FILETIME=[E061A6A0:01CF28C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Periodic output triggers 0 and 1 of the dp83640 has a programmable
duty-cycle which is controlled by the Pulsewidth2 field of the trigger
data register.  This field is not documented in the datasheet, but it
is described in the "PHYTER Software Development Guide" section
3.1.4.1. Failing to set the field can result in unstable/no trigger
output.

This patch add programming of the Pulsewidth2 field, setting it to the
same value as the Pulsewidth field for a 50% duty cycle.

Signed-off-by: Stefan Sørensen <stefan.sorensen@spectralink.com>
---
 drivers/net/phy/dp83640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 5ff221d..a370814 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -312,6 +312,11 @@ static void periodic_output(struct dp83640_clock *clock,
 	ext_write(0, phydev, PAGE4, PTP_TDR, sec >> 16);       /* sec[31:16] */
 	ext_write(0, phydev, PAGE4, PTP_TDR, period & 0xffff); /* ns[15:0] */
 	ext_write(0, phydev, PAGE4, PTP_TDR, period >> 16);    /* ns[31:16] */
+	/* Triggers 0 and 1 has programmable pulsewidth2 */
+	if (trigger == 0 || trigger == 1) {
+		ext_write(0, phydev, PAGE4, PTP_TDR, period & 0xffff);
+		ext_write(0, phydev, PAGE4, PTP_TDR, period >> 16);
+	}
 
 	/*enable trigger*/
 	val &= ~TRIG_LOAD;
-- 
1.8.5.3

