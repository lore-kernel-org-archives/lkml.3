Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3FXVKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:10:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FXVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:10:37 -0400
Date: Mon, 24 Jun 2013 23:10:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulators: max8973: initial DT support
In-Reply-To: <51C88E96.2010408@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1306242305150.26438@axis700.grange>
References: <Pine.LNX.4.64.1306241246580.19735@axis700.grange>
 <51C88E96.2010408@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:4Ofw/r9XbBI655acaZ1SW6vFrmmFjVodUztDId0mab/
 oDeJGiGgJWgOW2ESccTdecBRQJdVMNN/3tWUU4AMldxTgQoFO7
 Sc34Aa9VszHLjNKwvv+CtzQL22QA1r39zrMRSejhkagBGSofIf
 b3J21WWaRyPa12tZA23vXaqqP1yqa1rYVCFE+wkW64B6ANdOnW
 4Ys06UwdY4wXJhy9jaRqrvI1YkJK9IRuexXPdwL1s9zoZQxg/M
 TNVeP1LdIj1uEHnnp+7/ahWp/v3PE9X1PJ0cVg0PoklANrEy4Z
 HHAWCi4QMtBe3zA4CS3ld4ATZVO84zo17vAIbA2Jx+j0cGEols
 0J0XPTNKneCBsjS1xfXgEvAx4IGmgBjfufs+/l4YCUqfBeofgx
 2Q0c7TFBHOjMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Sergei Shtylyov wrote:

> Hello.
> 
> On 06/24/2013 02:50 PM, Guennadi Liakhovetski wrote:
> 
> > This patch adds primitive DT support to the max8973 regulator driver. None
> > of the configuration parameters, supported in the platform data are yet
> > available in DT, therefore no configuration is performed if booting with
> > no platform data. This means, that DT instantiation can only be used on
> > boards, where no run-time configuration of the chip is required. In such
> > cases the driver can be used to scale its output voltage. In the future
> > support for configuration parameters should be added.
> 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > ---
> 
> > v2: as suggested by Mark, regulator bindings are now directly under the
> > main max8973 I2C device node.
> 
> >   .../bindings/regulator/max8973-regulator.txt       |   21 +++++++++++
> >   drivers/regulator/max8973-regulator.c              |   37
> > +++++++++++++------
> >   2 files changed, 46 insertions(+), 12 deletions(-)
> >   create mode 100644
> > Documentation/devicetree/bindings/regulator/max8973-regulator.txt
> 
> > diff --git
> > a/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
> > b/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
> > new file mode 100644
> > index 0000000..8d38ab2
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
> > @@ -0,0 +1,21 @@
> > +* Maxim MAX8973 Voltage Regulator
> > +
> > +Required properties:
> > +
> > +- compatible:	must be "maxium,max8973"
> 
>    I see only "maxim" and "dallas" for Maxim Integrated Products in
> Documentation/devicetree/bindings/vendor-prefixes.txt. Is "maxium" some new,
> unknown vendor?

Yeah, it's an alias ;-) No, sure, it's a typo, thanks for catching. In 
fact, it still works, becaus I2C OF parsing doesn't use the vendor string, 
but it's better to get it right.

Mark, you said you'd already applied this. Would you prefer an incremental 
patch or shall I send an updated version?

> 
> > +- reg:		the i2c slave address of the regulator. It should be
> > 0x1b.
> > +
> > +Any standard regulator properties can be used to configure the single
> > max8973
> > +DCDC.
> > +
> > +Example:
> > +
> > +	max8973@1b {
> > +		compatible = "maxium,max8973";
> > +		reg = <0x1b>;
> > +
> > +		regulator-min-microvolt = <935000>;
> > +		regulator-max-microvolt = <1200000>;
> > +		regulator-boot-on;
> > +		regulator-always-on;
> > +	};
> > diff --git a/drivers/regulator/max8973-regulator.c
> > b/drivers/regulator/max8973-regulator.c
> > index b2dbdd7..0c5195a 100644
> > --- a/drivers/regulator/max8973-regulator.c
> > +++ b/drivers/regulator/max8973-regulator.c
> [...]
> > @@ -439,16 +447,21 @@ static int max8973_probe(struct i2c_client *client,
> [...]
> > +	if (pdata) {
> > +		ret = max8973_init_dcdc(max, pdata);
> > +		if (ret < 0) {
> > +			dev_err(max->dev, "Max8973 Init failed, err = %d\n",
> > ret);
> 
>    Not "MAX8973"?

If you hadn't removed the "-" lines, you would've seen, that I didn't 
invent this string but just moved it from one place to another.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
