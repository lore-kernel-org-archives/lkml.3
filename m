Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaGJNl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:41:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44374 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaGJNl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:41:57 -0400
Date: Thu, 10 Jul 2014 08:41:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <Peter.Chen@freescale.com>,
        <kishon@ti.com>, <stern@rowland.harvard.edu>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] usb: add support to the PHY framework for OTG
Message-ID: <20140710134140.GK15340@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-3-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ogUXNSQj4OI1q3LQ"
Content-Disposition: inline
In-Reply-To: <1404901036-27682-3-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ogUXNSQj4OI1q3LQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 09, 2014 at 12:17:14PM +0200, Antoine T=E9nart wrote:
> This patch adds the support to PHY framework in OTG code, and keeps the
> USB PHY compatibility. This is done in two steps: renaming 'phy' into
> 'usb_phy' and adding a new 'phy' member into the usb_otg structure.
> These modifications are done in all drivers accessing the OTG PHY.
>=20
> Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>

looks good to me

> ---
>  drivers/phy/phy-omap-usb2.c         |  6 ++--
>  drivers/usb/chipidea/otg_fsm.c      |  2 +-
>  drivers/usb/phy/phy-ab8500-usb.c    |  6 ++--
>  drivers/usb/phy/phy-fsl-usb.c       | 12 ++++----
>  drivers/usb/phy/phy-generic.c       |  2 +-
>  drivers/usb/phy/phy-gpio-vbus-usb.c |  2 +-
>  drivers/usb/phy/phy-isp1301-omap.c  | 10 +++----
>  drivers/usb/phy/phy-msm-usb.c       | 59 +++++++++++++++++++------------=
------
>  drivers/usb/phy/phy-mv-usb.c        |  4 +--
>  drivers/usb/phy/phy-samsung-usb2.c  |  2 +-
>  drivers/usb/phy/phy-tahvo.c         |  8 +++--
>  drivers/usb/phy/phy-ulpi.c          |  6 ++--
>  include/linux/usb/otg.h             |  5 +++-
>  13 files changed, 65 insertions(+), 59 deletions(-)
>=20
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index 1f444f91ed7d..13d3e36e208b 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -60,7 +60,7 @@ EXPORT_SYMBOL_GPL(omap_usb2_set_comparator);
> =20
>  static int omap_usb_set_vbus(struct usb_otg *otg, bool enabled)
>  {
> -	struct omap_usb *phy =3D phy_to_omapusb(otg->phy);
> +	struct omap_usb *phy =3D phy_to_omapusb(otg->usb_phy);
> =20
>  	if (!phy->comparator)
>  		return -ENODEV;
> @@ -70,7 +70,7 @@ static int omap_usb_set_vbus(struct usb_otg *otg, bool =
enabled)
> =20
>  static int omap_usb_start_srp(struct usb_otg *otg)
>  {
> -	struct omap_usb *phy =3D phy_to_omapusb(otg->phy);
> +	struct omap_usb *phy =3D phy_to_omapusb(otg->usb_phy);
> =20
>  	if (!phy->comparator)
>  		return -ENODEV;
> @@ -255,7 +255,7 @@ static int omap_usb2_probe(struct platform_device *pd=
ev)
>  		otg->set_vbus		=3D omap_usb_set_vbus;
>  	if (phy_data->flags & OMAP_USB2_HAS_START_SRP)
>  		otg->start_srp		=3D omap_usb_start_srp;
> -	otg->phy		=3D &phy->phy;
> +	otg->usb_phy		=3D &phy->phy;
> =20
>  	platform_set_drvdata(pdev, phy);
>  	pm_runtime_enable(phy->dev);
> diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fs=
m.c
> index 8cb2508a6b71..d8490e758a74 100644
> --- a/drivers/usb/chipidea/otg_fsm.c
> +++ b/drivers/usb/chipidea/otg_fsm.c
> @@ -788,7 +788,7 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
>  		return -ENOMEM;
>  	}
> =20
> -	otg->phy =3D ci->transceiver;
> +	otg->usb_phy =3D ci->transceiver;
>  	otg->gadget =3D &ci->gadget;
>  	ci->fsm.otg =3D otg;
>  	ci->transceiver->otg =3D ci->fsm.otg;
> diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab850=
0-usb.c
> index 2d5250143ce1..3a802fa7dae2 100644
> --- a/drivers/usb/phy/phy-ab8500-usb.c
> +++ b/drivers/usb/phy/phy-ab8500-usb.c
> @@ -1056,7 +1056,7 @@ static int ab8500_usb_set_peripheral(struct usb_otg=
 *otg,
>  	if (!otg)
>  		return -ENODEV;
> =20
> -	ab =3D phy_to_ab(otg->phy);
> +	ab =3D phy_to_ab(otg->usb_phy);
> =20
>  	ab->phy.otg->gadget =3D gadget;
> =20
> @@ -1080,7 +1080,7 @@ static int ab8500_usb_set_host(struct usb_otg *otg,=
 struct usb_bus *host)
>  	if (!otg)
>  		return -ENODEV;
> =20
> -	ab =3D phy_to_ab(otg->phy);
> +	ab =3D phy_to_ab(otg->usb_phy);
> =20
>  	ab->phy.otg->host =3D host;
> =20
> @@ -1382,7 +1382,7 @@ static int ab8500_usb_probe(struct platform_device =
*pdev)
>  	ab->phy.set_power	=3D ab8500_usb_set_power;
>  	ab->phy.otg->state	=3D OTG_STATE_UNDEFINED;
> =20
> -	otg->phy		=3D &ab->phy;
> +	otg->usb_phy		=3D &ab->phy;
>  	otg->set_host		=3D ab8500_usb_set_host;
>  	otg->set_peripheral	=3D ab8500_usb_set_peripheral;
> =20
> diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
> index a22f88fb8176..548bbc4a89d9 100644
> --- a/drivers/usb/phy/phy-fsl-usb.c
> +++ b/drivers/usb/phy/phy-fsl-usb.c
> @@ -499,7 +499,7 @@ int fsl_otg_start_host(struct otg_fsm *fsm, int on)
>  {
>  	struct usb_otg *otg =3D fsm->otg;
>  	struct device *dev;
> -	struct fsl_otg *otg_dev =3D container_of(otg->phy, struct fsl_otg, phy);
> +	struct fsl_otg *otg_dev =3D container_of(otg->usb_phy, struct fsl_otg, =
phy);
>  	u32 retval =3D 0;
> =20
>  	if (!otg->host)
> @@ -594,7 +594,7 @@ static int fsl_otg_set_host(struct usb_otg *otg, stru=
ct usb_bus *host)
>  	if (!otg)
>  		return -ENODEV;
> =20
> -	otg_dev =3D container_of(otg->phy, struct fsl_otg, phy);
> +	otg_dev =3D container_of(otg->usb_phy, struct fsl_otg, phy);
>  	if (otg_dev !=3D fsl_otg_dev)
>  		return -ENODEV;
> =20
> @@ -644,7 +644,7 @@ static int fsl_otg_set_peripheral(struct usb_otg *otg,
>  	if (!otg)
>  		return -ENODEV;
> =20
> -	otg_dev =3D container_of(otg->phy, struct fsl_otg, phy);
> +	otg_dev =3D container_of(otg->usb_phy, struct fsl_otg, phy);
>  	VDBG("otg_dev 0x%x\n", (int)otg_dev);
>  	VDBG("fsl_otg_dev 0x%x\n", (int)fsl_otg_dev);
>  	if (otg_dev !=3D fsl_otg_dev)
> @@ -717,7 +717,7 @@ static int fsl_otg_start_srp(struct usb_otg *otg)
>  	if (!otg || otg.state !=3D OTG_STATE_B_IDLE)
>  		return -ENODEV;
> =20
> -	otg_dev =3D container_of(otg->phy, struct fsl_otg, phy);
> +	otg_dev =3D container_of(otg->usb_phy, struct fsl_otg, phy);
>  	if (otg_dev !=3D fsl_otg_dev)
>  		return -ENODEV;
> =20
> @@ -735,7 +735,7 @@ static int fsl_otg_start_hnp(struct usb_otg *otg)
>  	if (!otg)
>  		return -ENODEV;
> =20
> -	otg_dev =3D container_of(otg->phy, struct fsl_otg, phy);
> +	otg_dev =3D container_of(otg->usb_phy, struct fsl_otg, phy);
>  	if (otg_dev !=3D fsl_otg_dev)
>  		return -ENODEV;
> =20
> @@ -857,7 +857,7 @@ static int fsl_otg_conf(struct platform_device *pdev)
>  	fsl_otg_tc->phy.dev =3D &pdev->dev;
>  	fsl_otg_tc->phy.set_power =3D fsl_otg_set_power;
> =20
> -	fsl_otg_tc->phy.otg->phy =3D &fsl_otg_tc->phy;
> +	fsl_otg_tc->phy.otg->usb_phy =3D &fsl_otg_tc->phy;
>  	fsl_otg_tc->phy.otg->set_host =3D fsl_otg_set_host;
>  	fsl_otg_tc->phy.otg->set_peripheral =3D fsl_otg_set_peripheral;
>  	fsl_otg_tc->phy.otg->start_hnp =3D fsl_otg_start_hnp;
> diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
> index 280a3458ff6b..0c01bd12cabc 100644
> --- a/drivers/usb/phy/phy-generic.c
> +++ b/drivers/usb/phy/phy-generic.c
> @@ -228,7 +228,7 @@ int usb_phy_gen_create_phy(struct device *dev, struct=
 usb_phy_generic *nop,
>  	nop->phy.type		=3D type;
> =20
>  	nop->phy.otg->state		=3D OTG_STATE_UNDEFINED;
> -	nop->phy.otg->phy		=3D &nop->phy;
> +	nop->phy.otg->usb_phy		=3D &nop->phy;
>  	nop->phy.otg->set_host		=3D nop_set_host;
>  	nop->phy.otg->set_peripheral	=3D nop_set_peripheral;
> =20
> diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gp=
io-vbus-usb.c
> index a4e88a28199a..0ca42bb2e661 100644
> --- a/drivers/usb/phy/phy-gpio-vbus-usb.c
> +++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
> @@ -271,7 +271,7 @@ static int gpio_vbus_probe(struct platform_device *pd=
ev)
>  	gpio_vbus->phy.set_suspend =3D gpio_vbus_set_suspend;
> =20
>  	gpio_vbus->phy.otg->state =3D OTG_STATE_UNDEFINED;
> -	gpio_vbus->phy.otg->phy =3D &gpio_vbus->phy;
> +	gpio_vbus->phy.otg->usb_phy =3D &gpio_vbus->phy;
>  	gpio_vbus->phy.otg->set_peripheral =3D gpio_vbus_set_peripheral;
> =20
>  	err =3D gpio_request(gpio, "vbus_detect");
> diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy-isp=
1301-omap.c
> index 69e49be8866b..cf0bd694ed1c 100644
> --- a/drivers/usb/phy/phy-isp1301-omap.c
> +++ b/drivers/usb/phy/phy-isp1301-omap.c
> @@ -1275,7 +1275,7 @@ static int isp1301_otg_enable(struct isp1301 *isp)
>  static int
>  isp1301_set_host(struct usb_otg *otg, struct usb_bus *host)
>  {
> -	struct isp1301	*isp =3D container_of(otg->phy, struct isp1301, phy);
> +	struct isp1301	*isp =3D container_of(otg->usb_phy, struct isp1301, phy);
> =20
>  	if (isp !=3D the_transceiver)
>  		return -ENODEV;
> @@ -1331,7 +1331,7 @@ isp1301_set_host(struct usb_otg *otg, struct usb_bu=
s *host)
>  static int
>  isp1301_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
>  {
> -	struct isp1301	*isp =3D container_of(otg->phy, struct isp1301, phy);
> +	struct isp1301	*isp =3D container_of(otg->usb_phy, struct isp1301, phy);
> =20
>  	if (isp !=3D the_transceiver)
>  		return -ENODEV;
> @@ -1411,7 +1411,7 @@ isp1301_set_power(struct usb_phy *dev, unsigned mA)
>  static int
>  isp1301_start_srp(struct usb_otg *otg)
>  {
> -	struct isp1301	*isp =3D container_of(otg->phy, struct isp1301, phy);
> +	struct isp1301	*isp =3D container_of(otg->usb_phy, struct isp1301, phy);
>  	u32		otg_ctrl;
> =20
>  	if (isp !=3D the_transceiver || isp->phy.state !=3D OTG_STATE_B_IDLE)
> @@ -1438,7 +1438,7 @@ static int
>  isp1301_start_hnp(struct usb_otg *otg)
>  {
>  #ifdef	CONFIG_USB_OTG
> -	struct isp1301	*isp =3D container_of(otg->phy, struct isp1301, phy);
> +	struct isp1301	*isp =3D container_of(otg->usb_phy, struct isp1301, phy);
>  	u32 l;
> =20
>  	if (isp !=3D the_transceiver)
> @@ -1583,7 +1583,7 @@ isp1301_probe(struct i2c_client *i2c, const struct =
i2c_device_id *id)
>  	isp->phy.label =3D DRIVER_NAME;
>  	isp->phy.set_power =3D isp1301_set_power,
> =20
> -	isp->phy.otg->phy =3D &isp->phy;
> +	isp->phy.otg->usb_phy =3D &isp->phy;
>  	isp->phy.otg->set_host =3D isp1301_set_host,
>  	isp->phy.otg->set_peripheral =3D isp1301_set_peripheral,
>  	isp->phy.otg->start_srp =3D isp1301_start_srp,
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index 4394397b1370..11e877964173 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -708,7 +708,7 @@ static void msm_otg_start_host(struct usb_phy *phy, i=
nt on)
> =20
>  static int msm_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
>  {
> -	struct msm_otg *motg =3D container_of(otg->phy, struct msm_otg, phy);
> +	struct msm_otg *motg =3D container_of(otg->usb_phy, struct msm_otg, phy=
);
>  	struct usb_hcd *hcd;
> =20
>  	/*
> @@ -716,14 +716,14 @@ static int msm_otg_set_host(struct usb_otg *otg, st=
ruct usb_bus *host)
>  	 * only peripheral configuration.
>  	 */
>  	if (motg->pdata->mode =3D=3D USB_DR_MODE_PERIPHERAL) {
> -		dev_info(otg->phy->dev, "Host mode is not supported\n");
> +		dev_info(otg->usb_phy->dev, "Host mode is not supported\n");
>  		return -ENODEV;
>  	}
> =20
>  	if (!host) {
>  		if (otg->state =3D=3D OTG_STATE_A_HOST) {
> -			pm_runtime_get_sync(otg->phy->dev);
> -			msm_otg_start_host(otg->phy, 0);
> +			pm_runtime_get_sync(otg->usb_phy->dev);
> +			msm_otg_start_host(otg->usb_phy, 0);
>  			otg->host =3D NULL;
>  			otg->state =3D OTG_STATE_UNDEFINED;
>  			schedule_work(&motg->sm_work);
> @@ -738,14 +738,14 @@ static int msm_otg_set_host(struct usb_otg *otg, st=
ruct usb_bus *host)
>  	hcd->power_budget =3D motg->pdata->power_budget;
> =20
>  	otg->host =3D host;
> -	dev_dbg(otg->phy->dev, "host driver registered w/ tranceiver\n");
> +	dev_dbg(otg->usb_phy->dev, "host driver registered w/ tranceiver\n");
> =20
>  	/*
>  	 * Kick the state machine work, if peripheral is not supported
>  	 * or peripheral is already registered with us.
>  	 */
>  	if (motg->pdata->mode =3D=3D USB_DR_MODE_HOST || otg->gadget) {
> -		pm_runtime_get_sync(otg->phy->dev);
> +		pm_runtime_get_sync(otg->usb_phy->dev);
>  		schedule_work(&motg->sm_work);
>  	}
> =20
> @@ -782,21 +782,21 @@ static void msm_otg_start_peripheral(struct usb_phy=
 *phy, int on)
>  static int msm_otg_set_peripheral(struct usb_otg *otg,
>  					struct usb_gadget *gadget)
>  {
> -	struct msm_otg *motg =3D container_of(otg->phy, struct msm_otg, phy);
> +	struct msm_otg *motg =3D container_of(otg->usb_phy, struct msm_otg, phy=
);
> =20
>  	/*
>  	 * Fail peripheral registration if this board can support
>  	 * only host configuration.
>  	 */
>  	if (motg->pdata->mode =3D=3D USB_DR_MODE_HOST) {
> -		dev_info(otg->phy->dev, "Peripheral mode is not supported\n");
> +		dev_info(otg->usb_phy->dev, "Peripheral mode is not supported\n");
>  		return -ENODEV;
>  	}
> =20
>  	if (!gadget) {
>  		if (otg->state =3D=3D OTG_STATE_B_PERIPHERAL) {
> -			pm_runtime_get_sync(otg->phy->dev);
> -			msm_otg_start_peripheral(otg->phy, 0);
> +			pm_runtime_get_sync(otg->usb_phy->dev);
> +			msm_otg_start_peripheral(otg->usb_phy, 0);
>  			otg->gadget =3D NULL;
>  			otg->state =3D OTG_STATE_UNDEFINED;
>  			schedule_work(&motg->sm_work);
> @@ -807,14 +807,15 @@ static int msm_otg_set_peripheral(struct usb_otg *o=
tg,
>  		return 0;
>  	}
>  	otg->gadget =3D gadget;
> -	dev_dbg(otg->phy->dev, "peripheral driver registered w/ tranceiver\n");
> +	dev_dbg(otg->usb_phy->dev,
> +		"peripheral driver registered w/ tranceiver\n");
> =20
>  	/*
>  	 * Kick the state machine work, if host is not supported
>  	 * or host is already registered with us.
>  	 */
>  	if (motg->pdata->mode =3D=3D USB_DR_MODE_PERIPHERAL || otg->host) {
> -		pm_runtime_get_sync(otg->phy->dev);
> +		pm_runtime_get_sync(otg->usb_phy->dev);
>  		schedule_work(&motg->sm_work);
>  	}
> =20
> @@ -1172,17 +1173,17 @@ static void msm_otg_sm_work(struct work_struct *w)
> =20
>  	switch (otg->state) {
>  	case OTG_STATE_UNDEFINED:
> -		dev_dbg(otg->phy->dev, "OTG_STATE_UNDEFINED state\n");
> -		msm_otg_reset(otg->phy);
> +		dev_dbg(otg->usb_phy->dev, "OTG_STATE_UNDEFINED state\n");
> +		msm_otg_reset(otg->usb_phy);
>  		msm_otg_init_sm(motg);
>  		otg->state =3D OTG_STATE_B_IDLE;
>  		/* FALL THROUGH */
>  	case OTG_STATE_B_IDLE:
> -		dev_dbg(otg->phy->dev, "OTG_STATE_B_IDLE state\n");
> +		dev_dbg(otg->usb_phy->dev, "OTG_STATE_B_IDLE state\n");
>  		if (!test_bit(ID, &motg->inputs) && otg->host) {
>  			/* disable BSV bit */
>  			writel(readl(USB_OTGSC) & ~OTGSC_BSVIE, USB_OTGSC);
> -			msm_otg_start_host(otg->phy, 1);
> +			msm_otg_start_host(otg->usb_phy, 1);
>  			otg->state =3D OTG_STATE_A_HOST;
>  		} else if (test_bit(B_SESS_VLD, &motg->inputs)) {
>  			switch (motg->chg_state) {
> @@ -1198,13 +1199,13 @@ static void msm_otg_sm_work(struct work_struct *w)
>  				case USB_CDP_CHARGER:
>  					msm_otg_notify_charger(motg,
>  							IDEV_CHG_MAX);
> -					msm_otg_start_peripheral(otg->phy, 1);
> +					msm_otg_start_peripheral(otg->usb_phy, 1);
>  					otg->state
>  						=3D OTG_STATE_B_PERIPHERAL;
>  					break;
>  				case USB_SDP_CHARGER:
>  					msm_otg_notify_charger(motg, IUNIT);
> -					msm_otg_start_peripheral(otg->phy, 1);
> +					msm_otg_start_peripheral(otg->usb_phy, 1);
>  					otg->state
>  						=3D OTG_STATE_B_PERIPHERAL;
>  					break;
> @@ -1222,8 +1223,8 @@ static void msm_otg_sm_work(struct work_struct *w)
>  			 * is incremented in charger detection work.
>  			 */
>  			if (cancel_delayed_work_sync(&motg->chg_work)) {
> -				pm_runtime_put_sync(otg->phy->dev);
> -				msm_otg_reset(otg->phy);
> +				pm_runtime_put_sync(otg->usb_phy->dev);
> +				msm_otg_reset(otg->usb_phy);
>  			}
>  			msm_otg_notify_charger(motg, 0);
>  			motg->chg_state =3D USB_CHG_STATE_UNDEFINED;
> @@ -1231,27 +1232,27 @@ static void msm_otg_sm_work(struct work_struct *w)
>  		}
> =20
>  		if (otg->state =3D=3D OTG_STATE_B_IDLE)
> -			pm_runtime_put_sync(otg->phy->dev);
> +			pm_runtime_put_sync(otg->usb_phy->dev);
>  		break;
>  	case OTG_STATE_B_PERIPHERAL:
> -		dev_dbg(otg->phy->dev, "OTG_STATE_B_PERIPHERAL state\n");
> +		dev_dbg(otg->usb_phy->dev, "OTG_STATE_B_PERIPHERAL state\n");
>  		if (!test_bit(B_SESS_VLD, &motg->inputs) ||
>  				!test_bit(ID, &motg->inputs)) {
>  			msm_otg_notify_charger(motg, 0);
> -			msm_otg_start_peripheral(otg->phy, 0);
> +			msm_otg_start_peripheral(otg->usb_phy, 0);
>  			motg->chg_state =3D USB_CHG_STATE_UNDEFINED;
>  			motg->chg_type =3D USB_INVALID_CHARGER;
>  			otg->state =3D OTG_STATE_B_IDLE;
> -			msm_otg_reset(otg->phy);
> +			msm_otg_reset(otg->usb_phy);
>  			schedule_work(w);
>  		}
>  		break;
>  	case OTG_STATE_A_HOST:
> -		dev_dbg(otg->phy->dev, "OTG_STATE_A_HOST state\n");
> +		dev_dbg(otg->usb_phy->dev, "OTG_STATE_A_HOST state\n");
>  		if (test_bit(ID, &motg->inputs)) {
> -			msm_otg_start_host(otg->phy, 0);
> +			msm_otg_start_host(otg->usb_phy, 0);
>  			otg->state =3D OTG_STATE_B_IDLE;
> -			msm_otg_reset(otg->phy);
> +			msm_otg_reset(otg->usb_phy);
>  			schedule_work(w);
>  		}
>  		break;
> @@ -1388,7 +1389,7 @@ static ssize_t msm_otg_mode_write(struct file *file=
, const char __user *ubuf,
>  		goto out;
>  	}
> =20
> -	pm_runtime_get_sync(otg->phy->dev);
> +	pm_runtime_get_sync(otg->usb_phy->dev);
>  	schedule_work(&motg->sm_work);
>  out:
>  	return status;
> @@ -1671,7 +1672,7 @@ static int msm_otg_probe(struct platform_device *pd=
ev)
> =20
>  	phy->io_ops =3D &msm_otg_io_ops;
> =20
> -	phy->otg->phy =3D &motg->phy;
> +	phy->otg->usb_phy =3D &motg->phy;
>  	phy->otg->set_host =3D msm_otg_set_host;
>  	phy->otg->set_peripheral =3D msm_otg_set_peripheral;
> =20
> diff --git a/drivers/usb/phy/phy-mv-usb.c b/drivers/usb/phy/phy-mv-usb.c
> index d6b3c473f068..d948275d55e5 100644
> --- a/drivers/usb/phy/phy-mv-usb.c
> +++ b/drivers/usb/phy/phy-mv-usb.c
> @@ -56,7 +56,7 @@ static char *state_string[] =3D {
> =20
>  static int mv_otg_set_vbus(struct usb_otg *otg, bool on)
>  {
> -	struct mv_otg *mvotg =3D container_of(otg->phy, struct mv_otg, phy);
> +	struct mv_otg *mvotg =3D container_of(otg->usb_phy, struct mv_otg, phy);
>  	if (mvotg->pdata->set_vbus =3D=3D NULL)
>  		return -ENODEV;
> =20
> @@ -718,8 +718,8 @@ static int mv_otg_probe(struct platform_device *pdev)
>  	mvotg->phy.otg =3D otg;
>  	mvotg->phy.label =3D driver_name;
> =20
> -	otg->phy =3D &mvotg->phy;
>  	otg->state =3D OTG_STATE_UNDEFINED;
> +	otg->usb_phy =3D &mvotg->phy;
>  	otg->set_host =3D mv_otg_set_host;
>  	otg->set_peripheral =3D mv_otg_set_peripheral;
>  	otg->set_vbus =3D mv_otg_set_vbus;
> diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-sam=
sung-usb2.c
> index b3ba86627b72..2a6d8cfa8839 100644
> --- a/drivers/usb/phy/phy-samsung-usb2.c
> +++ b/drivers/usb/phy/phy-samsung-usb2.c
> @@ -420,7 +420,7 @@ static int samsung_usb2phy_probe(struct platform_devi=
ce *pdev)
>  		return -EINVAL;
> =20
>  	sphy->phy.otg		=3D otg;
> -	sphy->phy.otg->phy	=3D &sphy->phy;
> +	sphy->phy.otg->usb_phy	=3D &sphy->phy;
>  	sphy->phy.otg->set_host =3D samsung_usbphy_set_host;
> =20
>  	spin_lock_init(&sphy->lock);
> diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
> index cc61ee44b911..402e6af29c65 100644
> --- a/drivers/usb/phy/phy-tahvo.c
> +++ b/drivers/usb/phy/phy-tahvo.c
> @@ -196,7 +196,8 @@ static int tahvo_usb_set_suspend(struct usb_phy *dev,=
 int suspend)
> =20
>  static int tahvo_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
>  {
> -	struct tahvo_usb *tu =3D container_of(otg->phy, struct tahvo_usb, phy);
> +	struct tahvo_usb *tu =3D container_of(otg->usb_phy, struct tahvo_usb,
> +					    phy);
> =20
>  	dev_dbg(&tu->pt_dev->dev, "%s %p\n", __func__, host);
> =20
> @@ -225,7 +226,8 @@ static int tahvo_usb_set_host(struct usb_otg *otg, st=
ruct usb_bus *host)
>  static int tahvo_usb_set_peripheral(struct usb_otg *otg,
>  				    struct usb_gadget *gadget)
>  {
> -	struct tahvo_usb *tu =3D container_of(otg->phy, struct tahvo_usb, phy);
> +	struct tahvo_usb *tu =3D container_of(otg->usb_phy, struct tahvo_usb,
> +					    phy);
> =20
>  	dev_dbg(&tu->pt_dev->dev, "%s %p\n", __func__, gadget);
> =20
> @@ -383,7 +385,7 @@ static int tahvo_usb_probe(struct platform_device *pd=
ev)
>  	tu->phy.label =3D DRIVER_NAME;
>  	tu->phy.set_suspend =3D tahvo_usb_set_suspend;
> =20
> -	tu->phy.otg->phy =3D &tu->phy;
> +	tu->phy.otg->usb_phy =3D &tu->phy;
>  	tu->phy.otg->set_host =3D tahvo_usb_set_host;
>  	tu->phy.otg->set_peripheral =3D tahvo_usb_set_peripheral;
> =20
> diff --git a/drivers/usb/phy/phy-ulpi.c b/drivers/usb/phy/phy-ulpi.c
> index 4e3877c329f2..f48a7a21e3c2 100644
> --- a/drivers/usb/phy/phy-ulpi.c
> +++ b/drivers/usb/phy/phy-ulpi.c
> @@ -211,7 +211,7 @@ static int ulpi_init(struct usb_phy *phy)
> =20
>  static int ulpi_set_host(struct usb_otg *otg, struct usb_bus *host)
>  {
> -	struct usb_phy *phy =3D otg->phy;
> +	struct usb_phy *phy =3D otg->usb_phy;
>  	unsigned int flags =3D usb_phy_io_read(phy, ULPI_IFC_CTRL);
> =20
>  	if (!host) {
> @@ -237,7 +237,7 @@ static int ulpi_set_host(struct usb_otg *otg, struct =
usb_bus *host)
> =20
>  static int ulpi_set_vbus(struct usb_otg *otg, bool on)
>  {
> -	struct usb_phy *phy =3D otg->phy;
> +	struct usb_phy *phy =3D otg->usb_phy;
>  	unsigned int flags =3D usb_phy_io_read(phy, ULPI_OTG_CTRL);
> =20
>  	flags &=3D ~(ULPI_OTG_CTRL_DRVVBUS | ULPI_OTG_CTRL_DRVVBUS_EXT);
> @@ -276,7 +276,7 @@ otg_ulpi_create(struct usb_phy_io_ops *ops,
>  	phy->otg	=3D otg;
>  	phy->init	=3D ulpi_init;
> =20
> -	otg->phy	=3D phy;
> +	otg->usb_phy	=3D phy;
>  	otg->set_host	=3D ulpi_set_host;
>  	otg->set_vbus	=3D ulpi_set_vbus;
> =20
> diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
> index 33d3480c9cda..52661c5da690 100644
> --- a/include/linux/usb/otg.h
> +++ b/include/linux/usb/otg.h
> @@ -9,12 +9,15 @@
>  #ifndef __LINUX_USB_OTG_H
>  #define __LINUX_USB_OTG_H
> =20
> +#include <linux/phy/phy.h>
>  #include <linux/usb/phy.h>
> =20
>  struct usb_otg {
>  	u8			default_a;
> =20
> -	struct usb_phy		*phy;
> +	struct phy		*phy;
> +	/* old usb_phy interface */
> +	struct usb_phy		*usb_phy;
>  	struct usb_bus		*host;
>  	struct usb_gadget	*gadget;
> =20
> --=20
> 1.9.1
>=20

--=20
balbi

--ogUXNSQj4OI1q3LQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvpgUAAoJEIaOsuA1yqREoT0QAKV4c5wNDfZoANTX9a+GLKFc
bla2TQ0xOwYVNWAFauccywNINcv37nGsX/QlhakxDWismB05rpmBG+pzOo9J74/s
BibTDCJq0FHbDPFoEuVk9/JlUfltmHvu+gwAUs7945myyx3xxFeUTUvrHRMBSA1g
q0Jsj0wlsP6cTQRrcPEU6WuI1UNY3QNNsN3PbrKp+VX1uLf8ujT4bjaX42TXD7OO
cSxQaMXyaYIAsqOTFnGJ0EhCZV/iw8imy+I66BT+FZkmPTX0YKoLvoCfCEHQKnS2
ABv+BygD0rwHxHmtO+aT6mFRrX+AaWJ2i0WQguoVcRYpTp0KlGn+1/eTmFyRDHja
IMqMI1UPyCSH2QcOwvhZEnX4KXSlTmc1Bw3md7MsZg0oBqIRa0s9oYHBHZky6T0J
NzjZXjPp4Bq3OFvOCNi3FMNu9mNUV13hgwBqAzJL6LuUUQBwqdFvihA6WVdshcch
g7VWd01ZjAs6q1NsJzUEedQ9lzgGEUgC15PqCxiIA6htzsra7+OlQU0cUCl/oSF/
m1H0TTp+fLv/AfA4BugsazJyjQMI8S4XSaEXr9FsYvyJARRACsjF+xiW2ozOU9gf
G90EiG6TquwF0Fgv/8Qdvpl69PRPtBlM7EU2hypbV9SQ0FJs5HqTskOXH5pdUNjk
BlRk74HmHmJKxxAFowYw
=ATws
-----END PGP SIGNATURE-----

--ogUXNSQj4OI1q3LQ--
