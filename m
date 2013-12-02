Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3LBTxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:53:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3LBTSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 121/212] regulator: pfuze100: allow misprogrammed ID
Date: Mon,  2 Dec 2013 11:15:12 -0800
Message-Id: <20131202191300.626967701@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

commit 88baf7148e899db7e0b676e4363647f50e48eaed upstream.

prior to week 08 of 2013 Freescale misprogrammed between 1 and 3% of
PFUZE1000 parts with a ID=0x8 instead of the expected ID=0x0

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/pfuze100-regulator.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -308,9 +308,15 @@ static int pfuze_identify(struct pfuze_c
 	if (ret)
 		return ret;
 
-	if (value & 0x0f) {
-		dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
-		return -ENODEV;
+	switch (value & 0x0f) {
+		/* Freescale misprogrammed 1-3% of parts prior to week 8 of 2013 as ID=8 */
+		case 0x8:
+			dev_info(pfuze_chip->dev, "Assuming misprogrammed ID=0x8");
+		case 0x0:
+			break;
+		default:
+			dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
+			return -ENODEV;
 	}
 
 	ret = regmap_read(pfuze_chip->regmap, PFUZE100_REVID, &value);


