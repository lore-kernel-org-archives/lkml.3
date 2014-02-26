Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaBZWoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:44:32 -0500
Received: from arlo.cworth.org ([50.126.95.6]:51974 "EHLO arlo.cworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaBZWo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:44:27 -0500
From: Carl Worth <cworth@cworth.org>
To: Ping Cheng <pingc@wacom.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carl Worth <cworth@cworth.org>
Subject: [PATCH 2/3] Input: wacom - Don't discard bits from upper byte of pressure value
Date: Wed, 26 Feb 2014 14:38:15 -0800
Message-Id: <1393454296-32735-3-git-send-email-cworth@cworth.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393454296-32735-2-git-send-email-cworth@cworth.org>
References: <1393454296-32735-1-git-send-email-cworth@cworth.org>
 <1393454296-32735-2-git-send-email-cworth@cworth.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mask here previously discarded all but one bit of data from the
upper byte of the pressure value. That would be correct for a tablet
with at most 512 pressure values, but is incorrect for a tablet with
1024 or more pressure values.

We can support as many tablets as possible by simply not discarding
any of the bits from this byte.

Signed-off-by: Carl Worth <cworth@cworth.org>
---
 drivers/input/tablet/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 4958081..563f197 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1037,7 +1037,7 @@ static int wacom_tpc_pen(struct wacom_wac *wacom)
 		input_report_key(input, BTN_STYLUS2, data[1] & 0x10);
 		input_report_abs(input, ABS_X, le16_to_cpup((__le16 *)&data[2]));
 		input_report_abs(input, ABS_Y, le16_to_cpup((__le16 *)&data[4]));
-		pressure = ((data[7] & 0x01) << 8) | data[6];
+		pressure = (data[7] << 8) | data[6];
 		if (pressure < 0)
 			pressure = features->pressure_max + pressure + 1;
 		input_report_abs(input, ABS_PRESSURE, pressure);
-- 
1.9.0

