Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaLVOLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:11:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43982 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaLVOLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:11:08 -0500
Date: Mon, 22 Dec 2014 14:10:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222141014.GS17800@sirena.org.uk>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
 <9699e11a566938b8d1821f9be3df3276d57cd979.1418826016.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aJ74fq0Y6SrIeKCM"
Content-Disposition: inline
In-Reply-To: <9699e11a566938b8d1821f9be3df3276d57cd979.1418826016.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/5] ASoC: dwc: Add devicetree support for Designware
 I2S
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aJ74fq0Y6SrIeKCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2014 at 04:18:08PM +0000, Andrew Jackson wrote:

> +union snd_dma_data {
> +	struct i2s_dma_data pd;
> +	struct snd_dmaengine_dai_dma_data dt;
> +};
> +

This is a driver local union with a very generic name, it seems likely
that this will collide in future causing build breaks

> -	ret = dev->i2s_clk_cfg(config);
> -	if (ret < 0) {
> -		dev_err(dev->dev, "runtime audio clk config fail\n");
> -		return ret;
> +		/* TODO: Validate sample rate against permissible set */
> +		bitclk = config->sample_rate * config->data_width * 2;
> +		clk_set_rate(dev->clk, bitclk);
>  	}

This is ignoring errors in clk_set_rate().

> +/* Maximum resolution of a channel - not uniformly spaced */
> +static const u32 fifo_width[] = {
> +	12, 16, 20, 24, 32, 0, 0, 0
> +};
> +
> +/* Width of (DMA) bus */
> +static const u32 bus_widths[] = {
> +	DMA_SLAVE_BUSWIDTH_1_BYTE,
> +	DMA_SLAVE_BUSWIDTH_2_BYTES,
> +	DMA_SLAVE_BUSWIDTH_4_BYTES,
> +	DMA_SLAVE_BUSWIDTH_UNDEFINED
> +};

> +	u32 bus_width = bus_widths[COMP1_APB_DATA_WIDTH(comp1)];
> +	u32 fifo_depth = 1 << (1 + COMP1_FIFO_DEPTH_GLOBAL(comp1));
> +	u32 max_size;

I'd feel a lot more comfortable if there were bounds checking on these
array indexes, especially since the arrays aren't explicitly sized and
instead just have the number of elements that is (hopefully) safe with
no comments or anything.  As things stand this is all using really
fraigle idioms, this could easily be broken if someone is updating the
driver for new IP features or even just cleaning up the code.

> -	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
> -	dev->clk = clk_get(&pdev->dev, NULL);
> +		dev->clk = clk_get(&pdev->dev, NULL);
> +	} else {
> +		dw_configure_dai_by_dt(dev, dw_i2s_dai, res);
> +
> +		dev->clk = devm_clk_get(&pdev->dev, "i2sclk");
> +	}

This changes from clk_get() to devm_clk_get() but I'm not seeing
anything that removes clk_put() calls.

> +#ifdef CONFIG_OF
> +		.of_match_table = dw_i2s_of_match,
> +#endif

of_match_ptr().

--aJ74fq0Y6SrIeKCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmCZFAAoJECTWi3JdVIfQfh8IAIJxu0pzThxkOXZcBZneK6x9
/R3zl5ZoWlMFKUS9gW0V884W3AA2JcPkEXYCxSWiMb00Gpg/ZU86bU2vhsMTTxFf
2swDgum7nGIlU0ocHnWUa4gHMZg0zTcUgTuepfgMuHkOXmDDmsUtXEgQwJtQOdlA
NpAFK2nnQQ3tWUegHBJaqPg7gsz45fEePdHjOT+84XEfOMWQVqIOrVYdadNl3CzF
+fxLRDaK6+vHh9YxBinqAWqoOaz/FO3b4z8LlTPXY7O1PievOyB8iVFE9mTVMG9p
Gqhyy1A1JRYwlj4iO69be21tTRwKuSp4ToYbZ7OTCKWA0cu+L0JOS9nsHbC2Uv0=
=GsEN
-----END PGP SIGNATURE-----

--aJ74fq0Y6SrIeKCM--
