Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaKSHkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:40:10 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45258 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbaKSHkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:40:06 -0500
Date: Wed, 19 Nov 2014 16:39:54 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v7 7/9] regulator: sky81452: Modify Device Tree
 structure
Message-ID: <20141119073954.GA3665@jack-ThinkPad-T520>
References: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
 <1416213190-20935-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141117141836.GA2722@sirena.org.uk>
 <20141118080451.GA3319@jack-ThinkPad-T520>
 <20141118112056.GA14734@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141118112056.GA14734@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:20:56AM +0000, Mark Brown wrote:
> On Tue, Nov 18, 2014 at 05:04:51PM +0900, Gyungoh Yoo wrote:
> > On Mon, Nov 17, 2014 at 02:18:36PM +0000, Mark Brown wrote:
> 
> > > Don't open code this, use regulators_node and of_match as previously
> > > advised.
> 
> > I think I had a misunderstanding.
> > But I have no idea about regulators_node and of_match.
> > Could you let me know more about them?
> 
> They are fields in regulator_desc, there are documentation and examples
> in current mainline - take a look at that and ask questions if it is
> unclear.

Okay. Thank you.
If of_match and regulators_node are assigned, don't I need to
call of_regulator_match()? Does regulator_register() call it internally?
So can I write code like below?

static const struct regulator_desc sky81452_reg = {
	.name = "LOUT",
	.of_match = of_match_ptr("lout"),
	.regulators_node = of_match_ptr("regulator"),
	.ops = &sky81452_reg_ops,
	...
};

static int sky81452_reg_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	const struct regulator_init_data *init_data = dev_get_platdata(dev);
	struct regulator_config config = { };
	struct regulator_dev *rdev;

	config.dev = dev->parent;
	config.init_data = init_data;
	config.of_node = dev->of_node;
	config.regmap = dev_get_drvdata(dev->parent);

	rdev = devm_regulator_register(dev, &sky81452_reg, &config);
	if (IS_ERR(rdev)) {
		dev_err(dev, "failed to register. err=%ld\n", PTR_ERR(rdev));
		return PTR_ERR(rdev);
	}

	platform_set_drvdata(pdev, rdev);

	return 0;
}
