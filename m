Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbaF1SQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:16:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbaF1Rvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.15 041/139] regulator: s2mps11: Fix accidental enable of buck6 ramp delay
Date: Sat, 28 Jun 2014 10:46:42 -0700
Message-Id: <20140628174607.304277990@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit b203e0dfe1a2b0ae5e2681e9285056e4ae8560af upstream.

S2MPS11 supports enabling/disabling ramp delay only for buck[2346].
Other bucks have ramp delay enabled always.

However the bit shift for enabling buck6 ramp delay in register is equal
to 0. When ramp delay was set for the bucks unsupporting enable/disable
(buck[15789] and buck10), the ramp delay for buck6 was also enabled.

Fixes: b96244fad953 ("regulator: s2mps11: Don't check enable_shift before setting enable ramp rate")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/s2mps11.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -202,11 +202,16 @@ static int s2mps11_set_ramp_delay(struct
 	if (!ramp_enable)
 		goto ramp_disable;
 
-	ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
-				 1 << enable_shift, 1 << enable_shift);
-	if (ret) {
-		dev_err(&rdev->dev, "failed to enable ramp rate\n");
-		return ret;
+	/* Ramp delay can be enabled/disabled only for buck[2346] */
+	if ((rdev_get_id(rdev) >= S2MPS11_BUCK2 &&
+			rdev_get_id(rdev) <= S2MPS11_BUCK4) ||
+			rdev_get_id(rdev) == S2MPS11_BUCK6)  {
+		ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
+					 1 << enable_shift, 1 << enable_shift);
+		if (ret) {
+			dev_err(&rdev->dev, "failed to enable ramp rate\n");
+			return ret;
+		}
 	}
 
 	ramp_val = get_ramp_delay(ramp_delay);


