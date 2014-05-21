Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaEUR0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:26:53 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34431 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaEUR0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:26:52 -0400
Date: Wed, 21 May 2014 19:24:33 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v3 05/16] drm: sti: add HDA driver
Message-ID: <20140521172429.GS2014@ulmo>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
 <1400594186-8956-6-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bk6L21jbBNK7V1Rv"
Content-Disposition: inline
In-Reply-To: <1400594186-8956-6-git-send-email-benjamin.gaignard@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bk6L21jbBNK7V1Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 03:56:15PM +0200, Benjamin Gaignard wrote:
> Add driver to support analog TV ouput.

Unfortunate that this has the same abbreviation as High-Definition
Audio...

> diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
[...]
> +/* Video DACs control */
> +#define VIDEO_DACS_CONTROL_MASK         0x0FFF
> +#define VIDEO_DACS_CONTROL_SYSCFG2535   0x085C /* for stih416 */
> +#define DAC_CFG_HD_OFF_SHIFT            5
> +#define DAC_CFG_HD_OFF_MASK             (0x7 << DAC_CFG_HD_OFF_SHIFT)
> +#define VIDEO_DACS_CONTROL_SYSCFG5072   0x0120 /* for stih407 */

syscfg is starting to look more and more like it could be a syscon
driver or some other specialized, platform-specific driver.

> +/* Index (in supported modes table) of the preferred video mode */
> +#define HDA_PREF_MODE_IDX               0

I don't think this symbolic name is particularly useful.

> +/* Reference to the hda device */
> +struct device *hda_dev;

This shouldn't be needed.

> +static void sti_hda_configure_awg(struct sti_hda *hda, u32 *awg_instr, int nb)
> +{
> +	int i;

unsigned

> +/*
> + * Get modes
> + *
> + * @drm_connector: pointer on the drm connector
> + *
> + * Return number of modes
> + */
> +static int sti_hda_get_modes(struct drm_connector *drm_connector)
> +{
> +	struct drm_device *dev = drm_connector->dev;
> +	struct drm_display_mode *mode;
> +	int i, count;

unsigned for i. count should probably stay signed since DRM uses that
throughout.

> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	for (i = 0, count = 0; i < ARRAY_SIZE(hda_supported_modes); i++) {

You can initialize count when it's declared to make the loop more
idiomatic.

> +		mode = drm_mode_duplicate(dev, &hda_supported_modes[i].mode);
> +		if (!mode)
> +			continue;
> +		mode->vrefresh = drm_mode_vrefresh(mode);
> +
> +		/* Set the preferred mode */
> +		if (i == HDA_PREF_MODE_IDX)
> +			mode->type |= DRM_MODE_TYPE_PREFERRED;
> +
> +		drm_mode_probed_add(drm_connector, mode);
> +		count++;
> +	}
> +
> +	drm_mode_sort(&drm_connector->modes);
> +
> +	return count;
> +}
> +
> +

Gratuituous newline.

> +static int sti_hda_probe(struct platform_device *pdev)
> +{
[...]
> +}
> +
> +static int sti_hda_remove(struct platform_device *pdev)
> +{
[...]
> +}
> +
> +static struct of_device_id hda_match_types[] = {
> +	{
> +	 .compatible = "st,stih416-hda",
> +	 },
> +	{
> +	 .compatible = "st,stih407-hda",
> +	 },
> +	{ /* end node */ }
> +};
> +MODULE_DEVICE_TABLE(of, hda_match_types);
> +
> +struct platform_driver sti_hda_driver = {
> +	.driver = {
> +		   .name = "sti-hda",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = hda_match_types,
> +		   },
> +	.probe = sti_hda_probe,
> +	.remove = sti_hda_remove,
> +};
> +
> +module_platform_driver(sti_hda_driver);
> +
> +MODULE_LICENSE("GPL");

Same comments here as for all previous patches.

Thierry

--Bk6L21jbBNK7V1Rv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfOFNAAoJEN0jrNd/PrOh14gP+wcFMErGwKVBLhpPZK197iqE
t/gGJizx4feR/IRotLN+e4rjBKwBWbHR4FoarSJImJZIFNAVOx+YvadJAKmse0xm
iiJqa9RTOSbce6/12HM3481VZ0PzlA6O7EdQATj5a7LQ5d1za2FKzzYwbkkMaXmr
uqEFrcuhAf9D7gIuEZXXeA0E+R5I/LksbmPouN0CzDFzMhj8kvtwoD8rFFF2PKBX
W13CrXbchqTCLubYUVDl0effmwVyJrk3QvSMCpcBbyBwp9iZ0uop9Mzu7VPZuVZB
ZsIdb43Wfadtm/kmO6qqfinVbY14fdh6no/Mo5gBppII+awkuP65wejefyKk2jmn
nDWT68HQPhw+AOxi9eGNKLaLIhf8MlbABa/K/nj+8qPwIwDrZBnJKQRF2RcCg9c1
jR7dOr6mILHMAg3LZApQSSHLOdD2EMrai8siAqGRHXIx8VKLVlEkXtMuW2Wcsxig
FKuwDpQjPBCYPjsCu/YlFBkn6YzoLMeF2qv2wyitbinxGa+1QDtERrZvCejND9EC
A6B7A8NUNbAORWIZ8+ViUqi50w39FXblzo8WLGWuhSE1y/y7pyedywpruPGKVO57
qOIEf6KCJHox+P9WWPcca77aqwFjMVP+Fkh52kj1Z8BQlE6VaIU4mMRCenQJkLFE
wpise+mDNGGepc2FcqZw
=zLn8
-----END PGP SIGNATURE-----

--Bk6L21jbBNK7V1Rv--
