Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3IZIWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:22:52 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50094 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3IZIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:22:50 -0400
MIME-Version: 1.0
X-Originating-IP: [111.240.64.25]
In-Reply-To: <004101ceba90$50592700$f10b7500$%han@samsung.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
	<003c01ceba8d$79872c60$6c958520$%han@samsung.com>
	<CAFRkauBTZQzSKgaNg781zsTU4u9V4rYATcWzC=BkJQy07sOBqA@mail.gmail.com>
	<004101ceba90$50592700$f10b7500$%han@samsung.com>
Date: Thu, 26 Sep 2013 16:22:50 +0800
Message-ID: <CAFRkauBbwEEaCiP2bnm57jB6KR0fySgsyk4S4oRLwF_=bqwncA@mail.gmail.com>
Subject: Re: [PATCH V3 12/14] regulator: tps6524x: use devm_regulator_register()
From: Axel Lin <axel.lin@ingics.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Axel,
>
> I really appreciate your comment.
>
> Then, you mean the following.
> If I am wrong, please let me know. :-)
> Thank you.

Then you can remove pmic_remove() function,like below diff.
With these change, you can add Reviewed-by: Axel Lin <axel.lin@ingics.com>

diff --git a/drivers/regulator/tps6524x-regulator.c
b/drivers/regulator/tps6524x-regulator.c
index 8b9ee39..0c0590d 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -577,20 +577,6 @@ static struct regulator_ops regulator_ops = {
  .get_current_limit = get_current_limit,
 };

-static int pmic_remove(struct spi_device *spi)
-{
- struct tps6524x *hw = spi_get_drvdata(spi);
- int i;
-
- if (!hw)
- return 0;
- for (i = 0; i < N_REGULATORS; i++) {
- regulator_unregister(hw->rdev[i]);
- hw->rdev[i] = NULL;
- }
- return 0;
-}
-
 static int pmic_probe(struct spi_device *spi)
 {
  struct tps6524x *hw;
@@ -598,7 +584,7 @@ static int pmic_probe(struct spi_device *spi)
  const struct supply_info *info = supply_info;
  struct regulator_init_data *init_data;
  struct regulator_config config = { };
- int ret = 0, i;
+ int i;

  init_data = dev_get_platdata(dev);
  if (!init_data) {
@@ -631,24 +617,17 @@ static int pmic_probe(struct spi_device *spi)
  config.init_data = init_data;
  config.driver_data = hw;

- hw->rdev[i] = regulator_register(&hw->desc[i], &config);
- if (IS_ERR(hw->rdev[i])) {
- ret = PTR_ERR(hw->rdev[i]);
- hw->rdev[i] = NULL;
- goto fail;
- }
+ hw->rdev[i] = devm_regulator_register(dev, &hw->desc[i],
+      &config);
+ if (IS_ERR(hw->rdev[i]))
+ return PTR_ERR(hw->rdev[i]);
  }

  return 0;
-
-fail:
- pmic_remove(spi);
- return ret;
 }

 static struct spi_driver pmic_driver = {
  .probe = pmic_probe,
- .remove = pmic_remove,
  .driver = {
  .name = "tps6524x",
  .owner = THIS_MODULE,
