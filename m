Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3ARMDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:03:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53347 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3ARMDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:03:13 -0500
Date: Fri, 18 Jan 2013 14:02:56 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/4] drivers: usb: start using the control module driver
Message-ID: <20130118120256.GC4672@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358502045-27008-1-git-send-email-kishon@ti.com>
 <1358502045-27008-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <1358502045-27008-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 18, 2013 at 03:10:45PM +0530, Kishon Vijay Abraham I wrote:
> Start using the control module driver for powering on the PHY and for
> writing to the mailbox instead of writing to the control module
> registers on their own.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/omap-usb.txt |    4 ++
>  Documentation/devicetree/bindings/usb/usb-phy.txt  |    7 +--
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   13 ----
>  drivers/usb/musb/Kconfig                           |    1 +
>  drivers/usb/musb/omap2430.c                        |   64 ++++++++------=
------
>  drivers/usb/musb/omap2430.h                        |    9 ---
>  drivers/usb/phy/Kconfig                            |    1 +
>  drivers/usb/phy/omap-usb2.c                        |   38 +++---------
>  include/linux/usb/omap_usb.h                       |    4 +-
>  9 files changed, 42 insertions(+), 99 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documen=
tation/devicetree/bindings/usb/omap-usb.txt
> index ead6ba9..8bedbba 100644
> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -3,6 +3,9 @@ OMAP GLUE AND OTHER OMAP SPECIFIC COMPONENTS
>  OMAP MUSB GLUE
>   - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
>   - ti,hwmods : must be "usb_otg_hs"
> + - ti,has_mailbox : to specify that omap uses an external mailbox
> +   (in control module) to communicate with the musb core during device c=
onnect
> +   and disconnect.
>   - multipoint : Should be "1" indicating the musb controller supports
>     multipoint. This is a MUSB configuration-specific setting.
>   - num_eps : Specifies the number of endpoints. This is also a
> @@ -24,6 +27,7 @@ SOC specific device node entry
>  usb_otg_hs: usb_otg_hs@4a0ab000 {
>  	compatible =3D "ti,omap4-musb";
>  	ti,hwmods =3D "usb_otg_hs";
> +	ti,has_mailbox;
>  	multipoint =3D <1>;
>  	num_eps =3D <16>;
>  	ram_bits =3D <12>;
> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Document=
ation/devicetree/bindings/usb/usb-phy.txt
> index 2466b6f..48761a2 100644
> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> @@ -4,9 +4,7 @@ OMAP USB2 PHY
> =20
>  Required properties:
>   - compatible: Should be "ti,omap-usb2"
> - - reg : Address and length of the register set for the device. Also
> -add the address of control module dev conf register until a driver for
> -control module is added
> + - reg : Address and length of the register set for the device.
> =20
>  Optional properties:
>   - ctrl_module : phandle of the control module used by PHY driver to pow=
er on
> @@ -16,7 +14,6 @@ This is usually a subnode of ocp2scp to which it is con=
nected.
> =20
>  usb2phy@4a0ad080 {
>  	compatible =3D "ti,omap-usb2";
> -	reg =3D <0x4a0ad080 0x58>,
> -	      <0x4a002300 0x4>;
> +	reg =3D <0x4a0ad080 0x58>;
>  	ctrl_module =3D <&omap_control_usb>;
>  };
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-o=
map2/omap_hwmod_44xx_data.c
> index 129d508..103f4ba 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -2698,13 +2698,6 @@ static struct resource omap44xx_usb_phy_and_pll_ad=
drs[] =3D {
>  		.end		=3D 0x4a0ae000,
>  		.flags		=3D IORESOURCE_MEM,
>  	},
> -	{
> -		/* XXX: Remove this once control module driver is in place */
> -		.name		=3D "ctrl_dev",
> -		.start		=3D 0x4a002300,
> -		.end		=3D 0x4a002303,
> -		.flags		=3D IORESOURCE_MEM,
> -	},
>  	{ }
>  };
> =20
> @@ -6152,12 +6145,6 @@ static struct omap_hwmod_addr_space omap44xx_usb_o=
tg_hs_addrs[] =3D {
>  		.pa_end		=3D 0x4a0ab7ff,
>  		.flags		=3D ADDR_TYPE_RT
>  	},
> -	{
> -		/* XXX: Remove this once control module driver is in place */
> -		.pa_start	=3D 0x4a00233c,
> -		.pa_end		=3D 0x4a00233f,
> -		.flags		=3D ADDR_TYPE_RT
> -	},
>  	{ }
>  };
> =20
> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> index 23a0b7f..de6e5ce 100644
> --- a/drivers/usb/musb/Kconfig
> +++ b/drivers/usb/musb/Kconfig
> @@ -11,6 +11,7 @@ config USB_MUSB_HDRC
>  	select NOP_USB_XCEIV if (SOC_TI81XX || SOC_AM33XX)
>  	select TWL4030_USB if MACH_OMAP_3430SDP
>  	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
> +	select OMAP_CONTROL_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
>  	select USB_OTG_UTILS
>  	help
>  	  Say Y here if your system has a dual role high speed USB
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index da00af4..3e7ceef 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -37,6 +37,7 @@
>  #include <linux/err.h>
>  #include <linux/delay.h>
>  #include <linux/usb/musb-omap.h>
> +#include <linux/usb/omap_control_usb.h>
> =20
>  #include "musb_core.h"
>  #include "omap2430.h"
> @@ -46,7 +47,7 @@ struct omap2430_glue {
>  	struct platform_device	*musb;
>  	enum omap_musb_vbus_id_status status;
>  	struct work_struct	omap_musb_mailbox_work;
> -	u32 __iomem		*control_otghs;
> +	struct device		*control_otghs;
>  };
>  #define glue_to_musb(g)		platform_get_drvdata(g->musb)
> =20
> @@ -54,26 +55,6 @@ struct omap2430_glue		*_glue;
> =20
>  static struct timer_list musb_idle_timer;
> =20
> -/**
> - * omap4_usb_phy_mailbox - write to usb otg mailbox
> - * @glue: struct omap2430_glue *
> - * @val: the value to be written to the mailbox
> - *
> - * On detection of a device (ID pin is grounded), this API should be cal=
led
> - * to set AVALID, VBUSVALID and ID pin is grounded.
> - *
> - * When OMAP is connected to a host (OMAP in device mode), this API
> - * is called to set AVALID, VBUSVALID and ID pin in high impedance.
> - *
> - * XXX: This function will be removed once we have a seperate driver for
> - * control module
> - */
> -static void omap4_usb_phy_mailbox(struct omap2430_glue *glue, u32 val)
> -{
> -	if (glue->control_otghs)
> -		writel(val, glue->control_otghs);
> -}
> -
>  static void musb_do_idle(unsigned long _musb)
>  {
>  	struct musb	*musb =3D (void *)_musb;
> @@ -269,7 +250,6 @@ EXPORT_SYMBOL_GPL(omap_musb_mailbox);
> =20
>  static void omap_musb_set_mailbox(struct omap2430_glue *glue)
>  {
> -	u32 val;
>  	struct musb *musb =3D glue_to_musb(glue);
>  	struct device *dev =3D musb->controller;
>  	struct musb_hdrc_platform_data *pdata =3D dev->platform_data;
> @@ -285,8 +265,8 @@ static void omap_musb_set_mailbox(struct omap2430_glu=
e *glue)
>  		musb->xceiv->last_event =3D USB_EVENT_ID;
>  		if (musb->gadget_driver) {
>  			pm_runtime_get_sync(dev);
> -			val =3D AVALID | VBUSVALID;
> -			omap4_usb_phy_mailbox(glue, val);
> +			if (!IS_ERR(glue->control_otghs))
> +				omap_control_usb_host_mode(glue->control_otghs);

you could introduce a helper to do the checks for you. something like:

static inline void omap_control_set_mode(*ctrl, int mode)
{
	if (IS_ERR(glue->control_otghs))
		return;

	switch (mode) {
	case HOST:
		omap_control_usb_host_mode(ctrl);
		break;
	case DEVICE:
		omap_control_usb_device(ctrl)
		break;
	default:
		meh();
	}
}

likewise for power() method

--=20
balbi

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+TnwAAoJEIaOsuA1yqREdaoP/icxkpCrDThmnQZfpbKOrMLP
BomaZ/8pmW5KG776UI8aS3t1szQRwpluXE8UhIxFt2K5TG2/4Cnh+FhgPiEaU/DU
/uGcAh1QXdUnJ8/nLgBX52CajTZGuWXM7j7Axnj9OIqkW9Ua5zD9FkcELz2E8pga
YOWFOzZyqIkkYuLsDpA//0E3yQ5A3wO+6h8SEUU3RWQTvBW2VkMMGbo0FPdHHfEI
lt4msHIz51NibISRyWFXZpreNdPVYisd/on1GRlZfrV4q5xbxP+tGSWI1hAQsK9H
NVWHGMsMaAHzi90+vhxlOaRXoCM97oIJNxhwb+5NaBVAWCKj2kHgs+nFN/A17rQt
QG2I7t2blrE/R1OAHBCQb5TBEvbl2VvzopCTVIFyIUqBQfb4A/PRrIx1iAnCunHo
zeTW2/yElV/lEdOZPOgKAzDYZiwUiNKBPLU27H3s/WesL5W7aJoH+XIKsV6gUBkh
kYIt4YDmdiFLk19yX18Yge5PM5yVCTl2GJYMzKHSfyeAGdsBKNiqcdgBemljdh7R
Z+BAjCEedLIwbYS/aEGteDtgG/zO6NCSFtO3Tc7vBO6wAvA3PUsoiYuFsvOeKDVJ
rs4ywLn3JjbevO0Nwt4DHuyoIQZyHTixGuhUOuetGvLdLoimqqNz2aj4yYLz1g5L
iUDlST/UK6bkwjKDZyb6
=ze0a
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
