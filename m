Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaG1WjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:39:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43155 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751425AbaG1WjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:39:03 -0400
Date: Tue, 29 Jul 2014 00:38:59 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        voice.shen@atmel.com, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ARM: at91: spi: request all csgpio in spi probe
Message-ID: <20140728223859.GA3214@piout.net>
References: <b033d16ec31d26a895726ee72ec89b43943dfbae.1406547656.git.jiri.prchal@aksignal.cz>
 <20140728122103.GR9532@piout.net>
 <53D64ADA.1000102@aksignal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D64ADA.1000102@aksignal.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Mark in Cc:)

On 28/07/2014 at 15:06:34 +0200, Jiří Prchal wrote :
> >>+#define DRIVER_NAME "atmel-spi"
> >>+
> >
> >This is not really related to the issue solved by that patch, maybe it
> >could go in another patch ?
> Probably yes, but is used for this patch, I based it upon spi-efm32.
> >

Yeah, I wouldn't use it anyway, see my comment below.

> >>  	asd->csr = csr;
> >>@@ -1290,6 +1276,15 @@ static int atmel_spi_probe(struct platform_device *pdev)
> >>  	int			ret;
> >>  	struct spi_master	*master;
> >>  	struct atmel_spi	*as;
> >>+	struct device_node *np = pdev->dev.of_node;
> >>+	int num_cs, i;
> >>+
> >>+	if (!np)
> >>+		return -EINVAL;
> >>+
> >>+	num_cs = of_gpio_named_count(np, "cs-gpios");
> >>+	if (num_cs < 0)
> >>+		return num_cs;
> >>
> >
> >This driver can still be probed without DT, this will break here, please
> >don't assume that DT is present.
> Yes, but I copied it from spi-efm32 and looked at others, is almost the same.

Maybe it is similar in other drivers but at91 platforms can still be
booted without DT, This will fail with:
atmel_spi: probe of atmel_spi.0 failed with error -22

The efm32 only supports DT, it doesn't have board files/platform data.

> >
> >
> >>  	/* Select default pin state */
> >>  	pinctrl_pm_select_default_state(&pdev->dev);
> >>@@ -1308,7 +1303,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
> >>
> >>  	/* setup spi core then atmel-specific driver state */
> >>  	ret = -ENOMEM;
> >>-	master = spi_alloc_master(&pdev->dev, sizeof(*as));
> >>+	master = spi_alloc_master(&pdev->dev, sizeof(*as) + num_cs * sizeof(unsigned));
> >>  	if (!master)
> >>  		goto out_free;
> >>
> >>@@ -1317,7 +1312,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
> >>  	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(8, 16);
> >>  	master->dev.of_node = pdev->dev.of_node;
> >>  	master->bus_num = pdev->id;
> >>-	master->num_chipselect = master->dev.of_node ? 0 : 4;
> >>+	master->num_chipselect = num_cs;
> >
> >My guess is that you don't need to change that part.
> I think I need it. What about 3 cs?

This will be taken care of by the spi core, in of_spi_register_master():

	nb = of_gpio_named_count(np, "cs-gpios");
	master->num_chipselect = max_t(int, nb, master->num_chipselect);


> >
> >>  	master->setup = atmel_spi_setup;
> >>  	master->transfer_one_message = atmel_spi_transfer_one_message;
> >>  	master->cleanup = atmel_spi_cleanup;
> >>@@ -1325,6 +1320,25 @@ static int atmel_spi_probe(struct platform_device *pdev)
> >>
> >>  	as = spi_master_get_devdata(master);
> >>
> >>+	for (i = 0; i < master->num_chipselect; ++i) {
> >>+		ret = of_get_named_gpio(np, "cs-gpios", i);
> >
> >Again, DT maybe not be compiled in or that driver may be probed from
> >platform data.
> Is another way how to do it? I see cs-gpios in master struct, but where it gets filled.
> >

It is filled when registering the master, here when calling
devm_spi_register_master(). It may be too late at that point.

> >>+		if (ret < 0) {
> >>+			dev_err(&pdev->dev, "failed to get csgpio#%u (%d)\n",
> >>+				i, ret);
> >>+			goto out_free;
> >>+		}
> >>+		as->csgpio[i] = ret;
> >>+		dev_dbg(&pdev->dev, "csgpio#%u = %u\n", i, as->csgpio[i]);
> >>+		ret = devm_gpio_request_one(&pdev->dev, as->csgpio[i],
> >>+					    GPIOF_OUT_INIT_HIGH, DRIVER_NAME);

Maybe you could use the CS number ifor the label here instead of
DRIVER_NAME, at least, use pdev->dev->name and completely drop
DRIVER_NAME.

> >>+		if (ret < 0) {
> >>+			dev_err(&pdev->dev,
> >>+				"failed to configure csgpio#%u (%d)\n",
> >>+				i, ret);
> >>+			goto out_free;
> >>+		}
> >>+	}
> >>+

Mark: maybe it would make sense to do devm_gpio_request_one() in
of_spi_register_master(), after of_get_named_gpio.

While this solves the particular issue Jiří is seeing, this will not
solve the case where PA14 (CS0) is not used by the spi driver at all. It
will remained muxed as CS0 and toggle when the spi master needs to
access CS0 until another driver muxes it to something else. I still
believe we should explicitly ask pinctrl to mux them as gpios.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
