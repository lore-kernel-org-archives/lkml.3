Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbaJ3ODh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:03:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44918 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758258AbaJ3ODf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:03:35 -0400
Date: Thu, 30 Oct 2014 09:00:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: <dinguyen@opensource.altera.com>
CC: <paulz@synopsys.com>, <balbi@ti.com>, <dinh.linux@gmail.com>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 4/8] usb: dwc2: Update common interrupt handler to call
 gadget interrupt handler
Message-ID: <20141030140043.GD6482@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-5-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Content-Disposition: inline
In-Reply-To: <1414538749-14735-5-git-send-email-dinguyen@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 06:25:45PM -0500, dinguyen@opensource.altera.com wr=
ote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>=20
> Make dwc2_handle_common_intr call the gadget interrupt function when oper=
ating
> in peripheral mode. Remove the spinlock functions in s3c_hsotg_irq as
> dwc2_handle_common_intr() already has the spinlocks.
>=20
> Move the registeration of the IRQ to common code for platform and PCI.
>=20
> Remove duplicate interrupt conditions that was in gadget, as those are ha=
ndled
> by dwc2 common interrupt handler.
>=20
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
> v5: remove individual devm_request_irq from gadget and hcd, and place a
>     single devm_request_irq in platform and pci.
> v2: Keep interrupt handler for host and peripheral modes separate
> ---
>  drivers/usb/dwc2/core.c      | 10 --------
>  drivers/usb/dwc2/core.h      |  3 +++
>  drivers/usb/dwc2/core_intr.c |  3 +++
>  drivers/usb/dwc2/gadget.c    | 57 ++------------------------------------=
------
>  drivers/usb/dwc2/pci.c       |  6 +++++
>  drivers/usb/dwc2/platform.c  |  9 +++++++
>  6 files changed, 23 insertions(+), 65 deletions(-)
>=20
> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
> index d926945..7605850b 100644
> --- a/drivers/usb/dwc2/core.c
> +++ b/drivers/usb/dwc2/core.c
> @@ -458,16 +458,6 @@ int dwc2_core_init(struct dwc2_hsotg *hsotg, bool se=
lect_phy, int irq)
>  	/* Clear the SRP success bit for FS-I2c */
>  	hsotg->srp_success =3D 0;
> =20
> -	if (irq >=3D 0) {
> -		dev_dbg(hsotg->dev, "registering common handler for irq%d\n",
> -			irq);
> -		retval =3D devm_request_irq(hsotg->dev, irq,
> -					  dwc2_handle_common_intr, IRQF_SHARED,
> -					  dev_name(hsotg->dev), hsotg);
> -		if (retval)
> -			return retval;
> -	}
> -
>  	/* Enable common interrupts */
>  	dwc2_enable_common_interrupts(hsotg);
> =20
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index 80d29c7..ec70862 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -967,6 +967,7 @@ extern int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2);
>  extern int s3c_hsotg_resume(struct dwc2_hsotg *dwc2);
>  extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
>  extern void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2);
> +irqreturn_t s3c_hsotg_irq(int irq, void *pw);
>  #else
>  static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
>  { return 0; }
> @@ -977,6 +978,8 @@ static inline int s3c_hsotg_resume(struct dwc2_hsotg =
*dwc2)
>  static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
>  { return 0; }
>  static inline void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2) {}
> +static inline irqreturn_t s3c_hsotg_irq(int irq, void *pw)
> +{ return IRQ_HANDLED; }
>  #endif
> =20
>  #if IS_ENABLED(CONFIG_USB_DWC2_HOST) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_=
ROLE)
> diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
> index b176c2f..b0c14e0 100644
> --- a/drivers/usb/dwc2/core_intr.c
> +++ b/drivers/usb/dwc2/core_intr.c
> @@ -474,6 +474,9 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *de=
v)
> =20
>  	spin_lock(&hsotg->lock);
> =20
> +	if (dwc2_is_device_mode(hsotg))
> +		retval =3D s3c_hsotg_irq(irq, dev);
> +
>  	gintsts =3D dwc2_read_common_intr(hsotg);
>  	if (gintsts & ~GINTSTS_PRTINT)
>  		retval =3D IRQ_HANDLED;
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 19d1b03..202f8cc 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -2257,14 +2257,13 @@ void s3c_hsotg_core_init(struct dwc2_hsotg *hsotg)
>   * @irq: The IRQ number triggered
>   * @pw: The pw value when registered the handler.
>   */
> -static irqreturn_t s3c_hsotg_irq(int irq, void *pw)
> +irqreturn_t s3c_hsotg_irq(int irq, void *pw)

why ? It would've been a lot easier to just make the IRQ line shared.

--=20
balbi

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUkSLAAoJEIaOsuA1yqRE5yAQAJlo2eZPHV5W+5+g1tlKh6Yc
g7I7hoYhExWSXrYAXrZYkT9DA8p6AJrC5TvXUooLP7afAobghZFOUNrMa2f+Vw6H
CA3lYfpucxTBD/6L1OyBd/2C19m3XuVulReSovARg8cDKqCrLTUR5X0EHISBFqFV
9MELlNcvGI5czQAVuab1U97Ze9R7oRAR4iXWzepd0BkJi7CPWIATyIMN1SLLluFH
fz0nhWmb+9k4PlQJfPnV1V076ArL/xxsuUYwF7CSLkXBSDad86diAHTBnuY5y9un
On5cKZA3dXijAibFvbgUgfX2BLaCA3FlBUw6BU3rtrZ2kecFwUWRs3rd3C8tntw6
ejGm7IaUhc13bq5rJSKRE0mN50c4lro37FTjYLMPKobHd2SYkAx5xp8SvnwT8Mwf
Qdz/AZfKjYFYYncuIE8m3yMht369jlkGXW78XYcFQzKM/1ELFFFwUOSm9pDu+A0D
cvmZBtOhwYH6R4GMXmUU6O4LNOlidDhs8pMuGZlPp/PSyTLq8mciuFmGpcy0nphT
S2qsovQOHF9F6jtuwcn//OHPiHQjYrPzubeYZH5pTODwo4NjmHTWU4EdxuvFn2JY
t3GZKJO+zSovHhCLA2WpRg0flzfICluiZOAdofXcV39V6Eh+JTiswWs4FpfsOS8R
K9AJXmENSSsKa9rt8xK8
=YOcp
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
