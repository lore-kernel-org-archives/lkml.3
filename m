Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaEEP1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:27:45 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:44570 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaEEP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:27:43 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.129.79]
In-Reply-To: <1399302603-1427-2-git-send-email-k.kozlowski@samsung.com>
References: <1399302603-1427-1-git-send-email-k.kozlowski@samsung.com>
	<1399302603-1427-2-git-send-email-k.kozlowski@samsung.com>
Date: Mon, 5 May 2014 23:27:43 +0800
Message-ID: <CAFRkauDO4auf7E4LK4Ms0humK=aRr3496=vEd3FK5jxa3Am-+A@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: s2mpa01: Fix accidental enable of buck4
 ramp delay
From: Axel Lin <axel.lin@ingics.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-05 23:10 GMT+08:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> S2MPA01 supports enabling/disabling ramp delay only for buck[1234].
> Other bucks have ramp delay enabled always.
>
> However the bit shift for enabling buck4 ramp delay in register is equal
> to 0. When ramp delay was set for these other bucks (buck[56789] and
> buck10), the ramp delay for buck4 was also enabled.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: f7b1a8dc1c1c ("regulator: s2mpa01: Don't check enable_shift before setting enable ramp rate")
> ---
>  drivers/regulator/s2mpa01.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
> index f19a30f0fb42..901504880ab6 100644
> --- a/drivers/regulator/s2mpa01.c
> +++ b/drivers/regulator/s2mpa01.c
> @@ -99,7 +99,8 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
>  {
>         struct s2mpa01_info *s2mpa01 = rdev_get_drvdata(rdev);
>         unsigned int ramp_val, ramp_shift, ramp_reg = S2MPA01_REG_RAMP2;
> -       unsigned int ramp_enable = 1, enable_shift = 0;
> +       unsigned int ramp_enable = 1;
> +       int enable_shift = -1;
Hi Krzysztof,
This makes the meaning of enable_shift looks confusing.
I think below change has better readability.

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index f19a30f..eb5ce18 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -192,11 +192,15 @@ static int s2mpa01_set_ramp_delay(struct
regulator_dev *rdev, int ramp_delay)
  if (!ramp_enable)
  goto ramp_disable;

- ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
- 1 << enable_shift, 1 << enable_shift);
- if (ret) {
- dev_err(&rdev->dev, "failed to enable ramp rate\n");
- return ret;
+ /* S2MPA01 supports enabling/disabling ramp delay only for buck[1234] */
+ if (rdev->desc->id >= S2MPA01_BUCK1 &&
+    rdev->desc->id <= S2MPA01_BUCK4) {
+ ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
+ 1 << enable_shift, 1 << enable_shift);
+ if (ret) {
+ dev_err(&rdev->dev, "failed to enable ramp rate\n");
+ return ret;
+ }
  }

  ramp_val = get_ramp_delay(ramp_delay);
