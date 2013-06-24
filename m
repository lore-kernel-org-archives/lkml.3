Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3FXOy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:54:28 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59761 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3FXOy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:54:26 -0400
MIME-Version: 1.0
In-Reply-To: <1372077594-17052-4-git-send-email-t.figa@samsung.com>
References: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
	<1372077594-17052-4-git-send-email-t.figa@samsung.com>
Date: Mon, 24 Jun 2013 20:24:25 +0530
Message-ID: <CAK9yfHx+DrhkGiJMahKotc37_ubYxyuiyFTtcW=Znu1LF1pojg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mfd: max8998: Add support for Device Tree
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 24 June 2013 18:09, Tomasz Figa <t.figa@samsung.com> wrote:
> This patch adds Device Tree support to max8998 driver.
>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max8998.txt | 108 ++++++++++++++++
>  drivers/mfd/max8998.c                             |  75 +++++++++++-
>  drivers/regulator/max8998.c                       | 143 +++++++++++++++++++++-
>  drivers/rtc/rtc-max8998.c                         |   2 +-
>  include/linux/mfd/max8998-private.h               |   2 +
>  include/linux/mfd/max8998.h                       |   2 +
>  6 files changed, 325 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max8998.txt
>
> diff --git a/Documentation/devicetree/bindings/mfd/max8998.txt b/Documentation/devicetree/bindings/mfd/max8998.txt
> new file mode 100644
> index 0000000..5304558
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/max8998.txt
> @@ -0,0 +1,108 @@
> +* Maxim MAX8998, National/TI LP3974 Voltage and Current Regulator
> +
> +The Maxim MAX8998 is a multi-function device which includes volatage and

s/volatage/voltage

> +current regulators, rtc, charger controller and other sub-blocks. It is
> +interfaced to the host controller using a i2c interface. Each sub-block is
> +addressed by the host system using different i2c slave address. This document
> +describes the bindings for 'pmic' sub-block of max8998.
> +
> +Required properties:
> +- compatible: Should be one of the following:
> +    - "maxim,max8998" for Maxim MAX8998
> +    - "national,lp3974" or "ti,lp3974" for National/TI LP3974.
> +- reg: Specifies the i2c slave address of the pmic block. It should be 0x66.
> +
> +Optional properties:
> +- interrupt-parent: Specifies the phandle of the interrupt controller to which
> +  the interrupts from max8998 are delivered to.
> +- interrupts: Interrupt specifiers for two interrupt sources.
> +  - First interrupt specifier is for main interrupt.
> +  - Second interrupt specifier is for power-on/-off interrupt.
> +- max8998,pmic-buck1-dvs-gpios: GPIO specifiers for two host gpios used
> +  for buck 1 dvs. The format of the gpio specifier depends in the gpio

s/in/on

> +  controller.
> +- max8998,pmic-buck2-dvs-gpio: GPIO specifier for host gpio used
> +  for buck 2 dvs. The format of the gpio specifier depends in the gpio

ditto

> +  controller.
> +- max8998,pmic-buck1-default-dvs-idx: Default voltage setting selected from
> +  the possible 4 options selectable by the dvs gpios. The value of this
> +  property should be between 0 and 3. If not specified or if out of range, the
> +  default value of this property is set to 0.

[snip]

> +static struct max8998_platform_data *max8998_i2c_parse_dt_pdata(
> +                                                       struct device *dev)
> +{
> +       struct max8998_platform_data *pd;
> +
> +       pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> +       if (!pd) {
> +               dev_err(dev, "could not allocate memory for pdata\n");

Redundant print.

> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       pd->ono = irq_of_parse_and_map(dev->of_node, 1);
> +
> +       /*
> +        * ToDo: the 'wakeup' member in the platform data is more of a linux
> +        * specfic information. Hence, there is no binding for that yet and
> +        * not parsed here.
> +        */
> +
> +       return pd;
> +}
> +#else
> +static struct max8998_platform_data *max8998_i2c_parse_dt_pdata(
> +                                                       struct device *dev)
> +{
> +       return 0;

return NULL for syntactic correctness.

> +}
> +#endif
> +
> +static inline int max8998_i2c_get_driver_data(struct i2c_client *i2c,
> +                                               const struct i2c_device_id *id)
> +{
> +       if (i2c->dev.of_node) {
> +               const struct of_device_id *match;
> +               match = of_match_node(max8998_dt_match, i2c->dev.of_node);
> +               return (int)match->data;
> +       }
> +
> +       return (int)id->driver_data;
> +}
> +
>  static int max8998_i2c_probe(struct i2c_client *i2c,
>                             const struct i2c_device_id *id)
>  {
> @@ -139,11 +200,20 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
>         if (max8998 == NULL)
>                 return -ENOMEM;
>
> +       if (i2c->dev.of_node) {
> +               pdata = max8998_i2c_parse_dt_pdata(&i2c->dev);
> +               if (IS_ERR(pdata)) {
> +                       ret = PTR_ERR(pdata);
> +                       goto err;
> +               }
> +       }
> +
>         i2c_set_clientdata(i2c, max8998);
>         max8998->dev = &i2c->dev;
>         max8998->i2c = i2c;
>         max8998->irq = i2c->irq;
> -       max8998->type = id->driver_data;
> +       max8998->type = max8998_i2c_get_driver_data(i2c, id);
> +       max8998->pdata = pdata;
>         if (pdata) {
>                 max8998->ono = pdata->ono;
>                 max8998->irq_base = pdata->irq_base;
> @@ -158,7 +228,7 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
>
>         pm_runtime_set_active(max8998->dev);
>
> -       switch (id->driver_data) {
> +       switch (max8998->type) {
>         case TYPE_LP3974:
>                 ret = mfd_add_devices(max8998->dev, -1,
>                                       lp3974_devs, ARRAY_SIZE(lp3974_devs),
> @@ -314,6 +384,7 @@ static struct i2c_driver max8998_i2c_driver = {
>                    .name = "max8998",
>                    .owner = THIS_MODULE,
>                    .pm = &max8998_pm,
> +                  .of_match_table = of_match_ptr(max8998_dt_match),

Need to include <linux/of.h>.

-- 
With warm regards,
Sachin
