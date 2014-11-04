Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaKDIvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:51:49 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32145 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaKDIuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:50:03 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-95-54589337b9e7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFT 3/6] regulator: max77802: Don't ignore return value of current
 opmode
Date: Tue, 04 Nov 2014 09:49:43 +0100
Message-id: <1415090986-30623-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4NV3zyREhBi8brC02zljPajH14RM2
	i6O/CyxevzC0ONv0ht3i/tejjBbfrnQwWVzeNYfNYu2Ru+wWp7tZHbg8/j6/zuKxc9Zddo9N
	qzrZPO5c28PmMe9koEffllWMHp83yQWwR3HZpKTmZJalFunbJXBlLP7YwFbwmLNi67z9jA2M
	zRxdjJwcEgImElN3XWWCsMUkLtxbz9bFyMUhJLCUUeLnxbmsEE4fk8SH7w2sIFVsAsYSm5cv
	AasSEdjEKDGp/wpYglmgmUni9PucLkYODmGBUImrE6VBwiwCqhJzdswC28Ar4C7x+u5jVoht
	chInj01mBSnnFPCQuN/NDBIWAippWr+IZQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5
	uZsYIeH3ZQfj4mNWhxgFOBiVeHgz1CNChFgTy4orcw8xSnAwK4nwrq4CCvGmJFZWpRblxxeV
	5qQWH2Jk4uCUamDUDbqd3DvtCbccr66Q5BsfDtfEUK5f24+2vZu16dM64Ql7bqbvdFTfuER0
	rtB1Lr1Xp5bdyLjoJ/q21emHxpkz/xMuf6pJ9PdRcfTMuNo1u/vh1p9Lt1ycL2Nx5uM+1icy
	0sdmu3NpR99ZtET5bCrHY9b4fDuBxpvXzryUFQ/ffVKYOzRuyZdjSizFGYmGWsxFxYkA/9aS
	Cx0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of regmap_read() of current opmode for regulator was
silently ignored and whatever happened to be in 'val' variable was used
as new opmode. This could lead to using bogus opmode.

Don't ignore what regmap_read() returns. If it fails just fall back to
normal opmode.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index a0d146278b76..7cbff7038b43 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -606,7 +606,13 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 		config.of_node = pdata->regulators[i].of_node;
 
 		ret = regmap_read(iodev->regmap, regulators[i].enable_reg, &val);
-		val = val >> shift & MAX77802_OPMODE_MASK;
+		if (ret < 0) {
+			dev_warn(&pdev->dev,
+				"cannot read current mode for %d\n", i);
+			val = MAX77802_OPMODE_NORMAL;
+		} else {
+			val = val >> shift & MAX77802_OPMODE_MASK;
+		}
 
 		/*
 		 * If the regulator is disabled and the system warm rebooted,
-- 
1.9.1

