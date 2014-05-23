Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbaEWRuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:50:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40459 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaEWRuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:50:03 -0400
Date: Fri, 23 May 2014 18:49:25 +0100
From: Mark Brown <broonie@kernel.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Message-ID: <20140523174925.GH22111@sirena.org.uk>
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
 <1400805629-10322-2-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GFHRPGHrS2AOMWit"
Content-Disposition: inline
In-Reply-To: <1400805629-10322-2-git-send-email-lejun.zhu@linux.intel.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.182
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND v2 1/4] mfd: intel_soc_pmic: Core driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GFHRPGHrS2AOMWit
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 08:40:26AM +0800, Zhu, Lejun wrote:

> +struct device *intel_soc_pmic_dev(void)
> +{
> +	return pmic->dev;
> +}
> +EXPORT_SYMBOL(intel_soc_pmic_dev);

Why do you need to take a global reference to this?

> +/*
> + * Read from a PMIC register
> + */
> +int intel_soc_pmic_readb(int reg)
> +{
> +	int ret;
> +	unsigned int val;
> +
> +	mutex_lock(&pmic_lock);
> +
> +	if (!pmic) {
> +		ret = -EIO;
> +	} else {
> +		ret = regmap_read(pmic->regmap, reg, &val);
> +		if (!ret)
> +			ret = val;
> +	}
> +
> +	mutex_unlock(&pmic_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(intel_soc_pmic_readb);

This is wrapping the EXPORT_SYMBOL_GPL() regmap API with an
EXPORT_SYMBOL() API.  Don't do that, if you really do need these
wrappers make them EXPORT_SYMBOL_GPL().

There should also be no need to add extra locking around regmap calls,
the regmap API has locking as standard.

It's also not clear why this API exists at all, surely all the
interaction with the device happens from the core or function drivers
for the device which ought to be able to get a direct reference to the
regmap anyway and only be instantiated when one is present.

> +/*
> + * Set platform_data of the child devices. Needs to be called before
> + * the MFD device is added.
> + */
> +int intel_soc_pmic_set_pdata(const char *name, void *data, int len)
> +{
> +	struct cell_dev_pdata *pdata;
> +
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		pr_err("intel_pmic: can't set pdata!\n");
> +		return -ENOMEM;
> +	}
> +
> +	pdata->name = name;
> +	pdata->data = data;
> +	pdata->len = len;
> +
> +	list_add_tail(&pdata->list, &pdata_list);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(intel_soc_pmic_set_pdata);

What is going on here, why aren't the normal ways of getting data to the
devices (such as reading the platform data of the parent device) OK?

> +static void __pmic_regmap_flush(void)
> +{
> +	if (cache_write_pending)
> +		WARN_ON(regmap_write(pmic->regmap, cache_offset,
> +				     cache_write_val));

> +static int pmic_regmap_load_from_hw(struct intel_pmic_regmap *map)
> +{
> +	int ret;

This all appears to be an open coded cache layer - there is already
cache support in regmap, just reuse that.

> +static irqreturn_t pmic_irq_isr(int irq, void *data)
> +{
> +	return IRQ_WAKE_THREAD;
> +}

Just register the IRQ as IRQF_ONESHOT and only provide the threaded
handler.

> +static irqreturn_t pmic_irq_thread(int irq, void *data)
> +{
> +	int i;
> +
> +	mutex_lock(&pmic->irq_lock);
> +
> +	for (i = 0; i < pmic->irq_num; i++) {
> +		if (test_bit(PMIC_IRQ_MASK_BIT(i), &PMIC_IRQ_MASK(pmic, i)))
> +			continue;
> +
> +		if (pmic_regmap_read(&pmic->irq_regmap[i].status)) {
> +			pmic_regmap_write(&pmic->irq_regmap[i].ack, 1);
> +			handle_nested_irq(pmic->irq_base + i);
> +		}
> +	}

This looks like you should be using regmap-irq, or at least like there's
some small additions needed to make it usable.

> +	if (gpio_is_valid(pmic->pmic_int_gpio)) {
> +		ret = gpio_request_one(pmic->pmic_int_gpio,
> +				       GPIOF_DIR_IN, "PMIC Interupt");
> +		if (ret) {
> +			dev_err(pmic->dev, "Request PMIC_INT gpio error\n");
> +			goto out_free_desc;
> +		}
> +
> +		pmic->irq = gpio_to_irq(pmic->pmic_int_gpio);
> +	}

There should be no need to do this, simply requesting the interrupt
should be sufficient to ensure the pin is in the correct mode.  If this
isn't the case the interrupt controller driver probably needs an update,
there's some support for helping with this in the GPIO framework IIRC.

You're also not using managed (devm) allocations for anything here.

--GFHRPGHrS2AOMWit
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTf4oiAAoJELSic+t+oim9TM4P/R+WA4A5hg6/96aDThL+ll8K
W8mVMWzyVyxjw/uYUYw+QjlXpec+ny+TePpNzG00YVPkMvcKtUuCU+lj9LXa7iyX
nNi1h1f/jKdjXBbgR488hYisSQ+nll/j2xK8rIzJ92Oqrtk8zQc/3wJ0s/MlZTDN
LmbJ87tRcEh/QB0b1Nrfg9LadTLhvlgBfz7NwvRo4G0YpS/yadiSGr30Pv/DQE2B
BJgPDIS6bORp91XauwMIKT5h8D3SsLE0QvzVeVWqfDNHae4RhBFoqP625Tp0AuUV
rB9doV/7bE73BntHXfz85QQIqZia/frI/Nf8WyYhJvwqX8Atlin4qtmbr0bv2GKG
JXsgsrTRVrfFqbcg+pwZww2tq+t3bYhHpLFvh6fSnb0IksdkEqvOnKJFHJBCg624
JaMU5z6I41LfveP6YznIA0x78cAnAyzzG6MylDrUFcS+1ou3u7wa3R/ifi2IV/vX
w0dnFCnvVKG3E0KLmPbJjPTN4NhsPMsMKSbBSRV7eYyNdm2IOteAkO/FpXre/OlA
C4T13H6isRuHLVUEhfsWVbiiCay+xdSTkoMadIlySofj1mpZexdfa8MwPJ8vN/02
AG14IeaD0WqAf3BCg/L3P5qZ5jdXsbtq6yi+naL9KzVtkesYDlYIZNrnBMLk2K8v
DN3+uupmJBvfMYpMlfjf
=iii8
-----END PGP SIGNATURE-----

--GFHRPGHrS2AOMWit--
