Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3FDQpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:45:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59670 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3FDQpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:45:07 -0400
Date: Tue, 4 Jun 2013 17:44:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: sameo@linux.intel.com, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@linaro.org, Haojian Zhuang <haojian.zhuang@linaro.org>
Message-ID: <20130604164440.GE31367@sirena.org.uk>
References: <1370356123-22357-1-git-send-email-guodong.xu@linaro.org>
 <1370356123-22357-2-git-send-email-guodong.xu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hW3Q5Oh0pcvvyJMS"
Content-Disposition: inline
In-Reply-To: <1370356123-22357-2-git-send-email-guodong.xu@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] mfd: Add hi6421 PMIC core driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hW3Q5Oh0pcvvyJMS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 10:28:41PM +0800, Guodong Xu wrote:

> +static struct of_device_id of_hi6421_pmic_child_match_tbl[] = {
> +	/* regulators */
> +	{
> +		.compatible = "hisilicon,hi6421-ldo",
> +	},
> +	{
> +		.compatible = "hisilicon,hi6421-buck012",
> +	},
> +	{
> +		.compatible = "hisilicon,hi6421-buck345",
> +	},
> +	{ /* end */ }
> +};

I would expect this to be in the regulator driver.

> +/*
> + * The PMIC register is only 8-bit.
> + * Hisilicon SoC use hardware to map PMIC register into SoC mapping.
> + * At here, we are accessing SoC register with 32-bit.
> + */
> +u32 hi6421_pmic_read(struct hi6421_pmic *pmic, int reg)
> +{
> +	unsigned long flags;
> +	u32 ret;
> +	spin_lock_irqsave(&pmic->lock, flags);
> +	ret = readl_relaxed(pmic->regs + (reg << 2));
> +	spin_unlock_irqrestore(&pmic->lock, flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL(hi6421_pmic_read);

This all looks like you want to be using regmap MMIO.  This would save a
bit of code and get you access to infrastructure like tracepoints and
debugfs regiseter dumps as well as the regulator API helpers.

> +	if (!devm_request_mem_region(dev, pmic->res->start,
> +				     resource_size(pmic->res),
> +				     pdev->name)) {
> +		dev_err(dev, "cannot claim register memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	pmic->regs = devm_ioremap(dev, pmic->res->start,
> +				  resource_size(pmic->res));

devm_request_and_ioremap().

> +	/* populate sub nodes */
> +	of_platform_populate(np, of_hi6421_pmic_child_match_tbl, NULL, dev);

You should be using the MFD API for this.

> +static int hi6421_pmic_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct hi6421_pmic *pmic = platform_get_drvdata(pdev);
> +
> +	devm_iounmap(dev, pmic->regs);
> +	devm_release_mem_region(dev, pmic->res->start,
> +				resource_size(pmic->res));
> +	devm_kfree(dev, pmic);

No point in cleaning up devm_ stuff, a major goal of the API is to save
writing that code.  The only thing that's needed is to remove the MFD
children which you're not doing.

> +	platform_set_drvdata(pdev, NULL);

This isn't required, it's never OK to access the driver data unless from
code that set it.

> +#define	OCP_DEB_CTRL_REG		(0x51)
> +#define	OCP_DEB_SEL_MASK		(0x0C)
> +#define OCP_DEB_SEL_8MS			(0x00)
> +#define OCP_DEB_SEL_16MS		(0x04)
> +#define OCP_DEB_SEL_32MS		(0x08)
> +#define OCP_DEB_SEL_64MS		(0x0C)
> +#define OCP_EN_DEBOUNCE_MASK		(0x02)
> +#define OCP_EN_DEBOUNCE_ENABLE		(0x02)
> +#define OCP_AUTO_STOP_MASK		(0x01)
> +#define OCP_AUTO_STOP_ENABLE		(0x01)

These should be namespaced.

--hW3Q5Oh0pcvvyJMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrhl1AAoJELSic+t+oim9b4cP/1EmwzxRfieXEJyJFCvoc9O0
C9w5poeZS6yEElEJVWkcm1Efvo82IrOVPSBgC+kwPgTzI0bf0sAaNBMazCv1EEaU
go4a9/e8/RDcbIK5DGhknzaBaL2TG/2d0ZFDEvTjjgPyz04c+9nL6R3z3GTTqABz
HDPwj02u7Y5vW2D3UsuIdsJjg0rM+AtuTIKePK6gVW626gIcIKdzo7lk5RGeX2h0
e4rNS01HGVVDwGiSd96KHc8bvMEplgrAMBvVtJMzumBJS4CfGw8d2QXRCRo4hIb/
TxNHwy2zBqj3Ts1uAGDavbFQoxy/dK2vE1ma47YyEPexANWfUcIaukcP6SUPra/Y
pHVex49IlLkYkD7DINZOSgJJ8ub8BS22fL0hTKhm1nQPsiVn2JBvhaqM8RoG9V+p
0nCmx4ScppYciyYA3aHBxJLkYN9zjKeuIhcGlA7wR/L/yZNYIGUh0hXwLayBrTgL
8dkuPHTOS7AKtSHJ2NdEfXVLhBEZ4Py/BsoDwv+1VwBhB2Bwa6DtTckjbUJLPopf
T9DOqDiba0MX66k+BoaEhZN0eVYMxi9wD/MN5RzKsDINR3TC/YFN0yoVzns7/YsT
3QoW2UoRDTBPFvSZOmSsrShvEWJ1OhtZ7Ux+9xMhSLcu7Dznc8JiQoOhs/8Rvv7l
NuRijjSnS9aTzd2RX62a
=uURk
-----END PGP SIGNATURE-----

--hW3Q5Oh0pcvvyJMS--
