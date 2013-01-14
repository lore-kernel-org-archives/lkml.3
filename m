Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3ANHKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:10:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3ANHKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:10:37 -0500
Date: Mon, 14 Jan 2013 08:10:34 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Philip Avinash <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, nsekhar@ti.com,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH 2/2] pwm: pwm-tiecap: Low power sleep support
Message-ID: <20130114071034.GB21994@avionic-0098.adnet.avionic-design.de>
References: <1357823024-17585-1-git-send-email-avinashphilip@ti.com>
 <1357823024-17585-3-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <1357823024-17585-3-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:X1cjdd0A6/D5q97Z+NApC6seYro8uBBkPH+HOzEA19K
 Lk1S3bqL6FdymGCl5FlOFy0sJtOdrtYW+K5Sedk4MBE5X/HGbb
 /G4RUw5O9L3Pj97hpC12d486+yI/g+j9JqNuhqnmDKl3NX1KyO
 pHQRR0q5sT36PEYpRciR6T6JHI6RrpDPtiBErOTURjJhoILH/q
 riwZSs5gK66HYyUMGOFuFVGdoT0FvD4XVhhJn2pRvFFfpncviU
 LoMCVW5QRnwWnzwKKH/NGX1auTeGhzcTVMcwO29JdSVQrdKpJM
 IPg+59fJrJmTI7yr5DjEAVSfOz19s0v+IDOKso0kh3ZpFfL+0a
 XGqIP+Yg3mSj2RX7u+HE61OCWXyOK9lKmzluOBzu+kMaXekIiv
 5gDO0EOeQTZ82H7ZEA964IO+7SuLqGoMNTj7rtdOByAWqsTO8B
 mSH04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 06:33:44PM +0530, Philip Avinash wrote:
> In low power modes of AM33XX platforms, peripherals power is cut off.
> This patch supports low power sleep transition support for ECAP driver.
>=20
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
>  drivers/pwm/pwm-tiecap.c |   44 ++++++++++++++++++++++++++++++++++++++++=
++++
>  1 file changed, 44 insertions(+)
>=20
> diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
> index 5cf016d..9dde1fe 100644
> --- a/drivers/pwm/pwm-tiecap.c
> +++ b/drivers/pwm/pwm-tiecap.c
> @@ -41,10 +41,17 @@
>  #define ECCTL2_SYNC_SEL_DISA	(BIT(7) | BIT(6))
>  #define ECCTL2_TSCTR_FREERUN	BIT(4)
> =20
> +struct ecap_regs {
> +	u32	cap3;
> +	u32	cap4;
> +	u16	ecctl2;
> +};

Perhaps name this ecap_context for consistency with the EHRPWM driver?

> +void ecap_pwm_save_reg(struct ecap_pwm_chip *pc)
> +{
> +	pm_runtime_get_sync(pc->chip.dev);
> +	pc->ctx.ecctl2 =3D readw(pc->mmio_base + ECCTL2);
> +	pc->ctx.cap4 =3D readl(pc->mmio_base + CAP4);
> +	pc->ctx.cap3 =3D readl(pc->mmio_base + CAP3);
> +	pm_runtime_put_sync(pc->chip.dev);
> +}
> +
> +void ecap_pwm_restore_reg(struct ecap_pwm_chip *pc)
> +{
> +	writel(pc->ctx.cap3, pc->mmio_base + CAP3);
> +	writel(pc->ctx.cap4, pc->mmio_base + CAP4);
> +	writew(pc->ctx.ecctl2, pc->mmio_base + ECCTL2);
> +}

Then rename these ecap_pwm_{save,restore}_context()?

> +static int ecap_pwm_suspend(struct device *dev)
> +{
> +	struct ecap_pwm_chip *pc =3D dev_get_drvdata(dev);
> +
> +	ecap_pwm_save_reg(pc);
> +	pm_runtime_put_sync(dev);
> +	return 0;
> +}
> +
> +static int ecap_pwm_resume(struct device *dev)
> +{
> +	struct ecap_pwm_chip *pc =3D dev_get_drvdata(dev);
> +
> +	pm_runtime_get_sync(dev);
> +	ecap_pwm_restore_reg(pc);
> +	return 0;
> +}

Same comment as for the EHRPWM driver applies here.

Thierry

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ869qAAoJEN0jrNd/PrOhle4QAIFlKUF4gOsbn8K2b3m84PIY
VzBrkZQ9WfX03B/YhQHcIHiNRcxcKYihTnKSsPXP5lkJ+Dva6W7mVPTInj0S0Eet
xJ+LbdWLNfKK6Mwku5+U9W8PoKuFsvT0H11lAvx/rel7xlKCx0jx5KSzXOLW/Df5
iMJdsvpsVllJi4BHgJiDO4Xvm6d5YEMEcJOsS4L3QYn5OH6qHHFIeuzca3eJOMjB
+iDg36p5Hs0tIYJS3nfzJD0/rLsz791IXu7OXag+HtG8SL6pqp8o3fTbjea4PnYt
RvCyxc3Y3PLgjkZsKUg8golonyM4XtTpAfE5sZgneAgfye3LS0mCTXUn1PU7jIV+
Lch1UIxNu7HV3qnU1a9ienl6yR/+mGmbI9omMwDlcM3e/Opxr5xicg+f0tXqf4A5
pQrzFuD5D0Y+Q/9X4F12JtEFTZxx179zPpcKYIXwE5RpsaXYttVMblkyfZGd7g/Q
hOty/3t649oTONyXA3PTdr69oqMhX6hYTuBmu52aZ4gUZwEGQdpbibv362lAZ84p
hL26HqUD7tlZ/MjRfn5VFFZY8CkPH5f4mEu0nf51Lx9cDgXItLI5WKHGy/sGxzWd
Ss+SL5plaZiv6bdWgHkXlyPY0d7RJbH2vPKHtu2k7RmUd8fYL263AhXldWHZVHEm
AJW65kzS7n84cWso7ToZ
=sy60
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
