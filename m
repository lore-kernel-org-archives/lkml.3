Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaJ2M1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:27:50 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54959 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaJ2M1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:27:47 -0400
Date: Wed, 29 Oct 2014 13:27:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH RESEND V4 4/9] pinctrl: tegra-xusb: Add USB PHY support
Message-ID: <20141029122738.GE28356@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
 <1414535277-15645-5-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
In-Reply-To: <1414535277-15645-5-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 03:27:51PM -0700, Andrew Bresticker wrote:
[...]
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index c6a66de..0f4cdef 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -163,6 +163,7 @@ config PINCTRL_TEGRA_XUSB
>  	select GENERIC_PHY
>  	select PINCONF
>  	select PINMUX
> +	select MAILBOX

I think this should be a "depends on" because we use the mailbox API as
a client rather than a provider.

> diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinct=
rl-tegra-xusb.c
[...]
>  struct tegra_xusb_padctl_function {
>  	const char *name;
>  	const char * const *groups;
> @@ -72,6 +222,16 @@ struct tegra_xusb_padctl_soc {
> =20
>  	const struct tegra_xusb_padctl_lane *lanes;
>  	unsigned int num_lanes;
> +
> +	u32 rx_wander;
> +	u32 rx_eq;
> +	u32 cdr_cntl;
> +	u32 dfe_cntl;
> +	u32 hs_slew;
> +	u32 ls_rslew[TEGRA_XUSB_UTMI_PHYS];
> +	u32 hs_discon_level;
> +	u32 spare_in;
> +	int hsic_port_offset;

unsigned int? Are these values all SoC-specific or can they vary per
board?

> +struct tegra_xusb_fuse_calibration {
> +	u32 hs_curr_level[TEGRA_XUSB_UTMI_PHYS];
> +	u32 hs_iref_cap;
> +	u32 hs_term_range_adj;
> +	u32 hs_squelch_level;
> +};
> +
> +struct tegra_xusb_usb3_port {
> +	int lane;

unsigned

> +	bool context_saved;
> +	u32 tap1_val;
> +	u32 amp_val;
> +	u32 ctle_z_val;
> +	u32 ctle_g_val;
> +};
> +
[...]
> +static inline bool is_otg_lane(unsigned int lane)
> +{
> +	return lane >=3D TEGRA_XUSB_PADCTL_PIN_OTG_0 &&
> +		lane <=3D TEGRA_XUSB_PADCTL_PIN_OTG_2;
> +}
> +
> +static inline bool is_hsic_lane(unsigned int lane)
> +{
> +	return lane >=3D TEGRA_XUSB_PADCTL_PIN_HSIC_0 &&
> +		lane <=3D TEGRA_XUSB_PADCTL_PIN_HSIC_1;
> +}
> +
> +static inline bool is_pcie_or_sata_lane(unsigned int lane)
> +{
> +	return lane >=3D TEGRA_XUSB_PADCTL_PIN_PCIE_0 &&
> +		lane <=3D TEGRA_XUSB_PADCTL_PIN_SATA_0;
> +}
> +
> +static int lane_to_usb3_port(struct tegra_xusb_padctl *padctl,
> +			     unsigned int lane)
> +{
> +	int i;

unsigned

> +
> +	for (i =3D 0; i < TEGRA_XUSB_USB3_PHYS; i++) {
> +		if (padctl->usb3_ports[i].lane =3D=3D lane)
> +			return i;
> +	}
> +
> +	return -1;
> +}

Why not return a proper error code here that callers can simply
propagate?

Also, for consistency, I'd prefer the is_*_lane() functions to be
renamed to lane_is_*().

> @@ -321,6 +561,7 @@ static int tegra_xusb_padctl_pinconf_group_get(struct=
 pinctrl_dev *pinctrl,
>  	struct tegra_xusb_padctl *padctl =3D pinctrl_dev_get_drvdata(pinctrl);
>  	const struct tegra_xusb_padctl_lane *lane;
>  	enum tegra_xusb_padctl_param param;
> +	int port;
>  	u32 value;

The variable here were sorted in inverse christmas tree order, so port
should be below value.

> +static int usb3_phy_to_port(struct phy *phy)
> +{
> +	struct tegra_xusb_padctl *padctl =3D phy_get_drvdata(phy);
> +	int i;

unsigned

> +
> +	for (i =3D 0; i < TEGRA_XUSB_USB3_PHYS; i++) {
> +		if (phy =3D=3D padctl->phys[TEGRA_XUSB_PADCTL_USB3_P0 + i])
> +			break;

You could simply return i here and then BUG_ON unconditionally.

> +	}
> +	BUG_ON(i =3D=3D TEGRA_XUSB_USB3_PHYS);
> +
> +	return i;
> +}

Actually, thinking about it some more, perhaps making this a WARN_ON()
and returning an error so that we can continue and propagate the error
would be more useful. BUG_ON() will completely hang the kernel with no
way out but rebooting. WARN_ON() will give a hint about something being
wrong and returning an error will allow the kernel to continue to run,
which might be the only way to diagnose and fix the problem, even if it
means that USB 3.0 support will be disabled.

> +static void usb3_phy_save_context(struct tegra_xusb_padctl *padctl, int =
port)

unsigned for port...

> +{
> +	int lane =3D padctl->usb3_ports[port].lane;

=2E.. and lane.

> +	u32 value, offset;
> +
> +	padctl->usb3_ports[port].context_saved =3D true;

What's the purpose of saving the context here? This seems to be
triggered by a request from XUSB, but it's then restored when the PHY is
powered on. How does that even happen? Won't the PHY stay powered all
the time? Or shouldn't the context be saved when powering off the PHY?

> +static int utmi_phy_to_port(struct phy *phy)
> +{
> +	struct tegra_xusb_padctl *padctl =3D phy_get_drvdata(phy);
> +	int i;
> +
> +	for (i =3D 0; i < TEGRA_XUSB_UTMI_PHYS; i++) {
> +		if (phy =3D=3D padctl->phys[TEGRA_XUSB_PADCTL_UTMI_P0 + i])
> +			break;
> +	}
> +	BUG_ON(i =3D=3D TEGRA_XUSB_UTMI_PHYS);
> +
> +	return i;
> +}

Same comment as before.

> +static int utmi_phy_power_on(struct phy *phy)
> +{
> +	struct tegra_xusb_padctl *padctl =3D phy_get_drvdata(phy);
> +	int port =3D utmi_phy_to_port(phy);
> +	int ret;

The driver uses err as the name for variables that store error codes.
I'd like to remain consistent with that.

> +static int hsic_phy_to_port(struct phy *phy)
> +{
> +	struct tegra_xusb_padctl *padctl =3D phy_get_drvdata(phy);
> +	int i;
> +
> +	for (i =3D 0; i < TEGRA_XUSB_HSIC_PHYS; i++) {
> +		if (phy =3D=3D padctl->phys[TEGRA_XUSB_PADCTL_HSIC_P0 + i])
> +			break;
> +	}
> +	BUG_ON(i =3D=3D TEGRA_XUSB_HSIC_PHYS);
> +
> +	return i;
> +}

Again, as mentioned before.

> +static int hsic_phy_power_on(struct phy *phy)
> +{
> +	struct tegra_xusb_padctl *padctl =3D phy_get_drvdata(phy);
> +	int port =3D hsic_phy_to_port(phy);
> +	int ret;
> +	u32 value;
> +
> +	ret =3D regulator_enable(padctl->vddio_hsic);
> +	if (ret)
> +		return ret;
> +
> +	value =3D padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL1(port));
> +	value &=3D ~(XUSB_PADCTL_HSIC_PAD_CTL1_RPD_STROBE |
> +		   XUSB_PADCTL_HSIC_PAD_CTL1_RPU_DATA |
> +		   XUSB_PADCTL_HSIC_PAD_CTL1_PD_RX |
> +		   XUSB_PADCTL_HSIC_PAD_CTL1_PD_ZI |
> +		   XUSB_PADCTL_HSIC_PAD_CTL1_PD_TRX |
> +		   XUSB_PADCTL_HSIC_PAD_CTL1_PD_TX);
> +	value |=3D XUSB_PADCTL_HSIC_PAD_CTL1_RPD_DATA |
> +		 XUSB_PADCTL_HSIC_PAD_CTL1_RPU_STROBE;
> +	padctl_writel(padctl, value, XUSB_PADCTL_HSIC_PADX_CTL1(port));
> +
> +	return 0;
> +}
> +
> +static int hsic_phy_power_off(struct phy *phy)
> +{
> +	struct tegra_xusb_padctl *padctl =3D phy_get_drvdata(phy);
> +	int port =3D hsic_phy_to_port(phy);
> +	u32 value;
> +
> +	regulator_disable(padctl->vddio_hsic);

It probably doesn't make much of a difference, but the sequence should
be the reverse of the power-on sequence, so regulator_disable() should
be last in this function.

> +static void hsic_phy_set_idle(struct tegra_xusb_padctl *padctl, int port,
> +			      bool set)

unsigned int for port. Also maybe rename to set to idle, which makes the
code below somewhat easier to read.

> +{
> +	u32 value;
> +
> +	value =3D padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL1(port));
> +	if (set)
> +		value |=3D XUSB_PADCTL_HSIC_PAD_CTL1_RPD_DATA |
> +			 XUSB_PADCTL_HSIC_PAD_CTL1_RPU_STROBE;
> +	else
> +		value &=3D ~(XUSB_PADCTL_HSIC_PAD_CTL1_RPD_DATA |
> +			   XUSB_PADCTL_HSIC_PAD_CTL1_RPU_STROBE);
> +	padctl_writel(padctl, value, XUSB_PADCTL_HSIC_PADX_CTL1(port));
> +}
> +
> +static bool is_phy_mbox_message(u32 cmd)
> +{
> +	switch (cmd) {
> +	case MBOX_CMD_SAVE_DFE_CTLE_CTX:
> +	case MBOX_CMD_START_HSIC_IDLE:
> +	case MBOX_CMD_STOP_HSIC_IDLE:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}

This is oddly placed. It's only called by tegra_xusb_phy_mbox_rx() below
so would be better placed right in front of it.

> +static void tegra_xusb_phy_mbox_work(struct work_struct *work)
> +{
> +	struct tegra_xusb_padctl *padctl =3D container_of(work,
> +				struct tegra_xusb_padctl, mbox_req_work);

Maybe wrap this into a static inline function for readability?

> +	struct tegra_xusb_mbox_msg *msg =3D &padctl->mbox_req;
> +	struct tegra_xusb_mbox_msg resp;
> +	u32 ports;
> +	int i;

unsigned. There are other occurrences where unsigned makes more sense,
even if I haven't explicitly mentioned them anymore.

> +	resp.cmd =3D 0;
> +	switch (msg->cmd) {
> +	case MBOX_CMD_SAVE_DFE_CTLE_CTX:
> +		resp.data =3D msg->data;
> +		if (msg->data > TEGRA_XUSB_USB3_PHYS) {
> +			resp.cmd =3D MBOX_CMD_NAK;
> +		} else {
> +			usb3_phy_save_context(padctl, msg->data);
> +			resp.cmd =3D MBOX_CMD_ACK;
> +		}
> +		break;

Perhaps let usb3_phy_save_context() determine validity of the parameter
and return an error otherwise (or for any other failure)? Then you can
set the command to ACK or NAK depending on the return value.

> -#define PIN_OTG_0   0
> -#define PIN_OTG_1   1
> -#define PIN_OTG_2   2
> -#define PIN_ULPI_0  3
> -#define PIN_HSIC_0  4
> -#define PIN_HSIC_1  5
> -#define PIN_PCIE_0  6
> -#define PIN_PCIE_1  7
> -#define PIN_PCIE_2  8
> -#define PIN_PCIE_3  9
> -#define PIN_PCIE_4 10
> -#define PIN_SATA_0 11

I really don't think we should export these, unless we can't make it
work otherwise.

>  static int tegra_xusb_padctl_probe(struct platform_device *pdev)
>  {
>  	struct tegra_xusb_padctl *padctl;
>  	const struct of_device_id *match;
>  	struct resource *res;
>  	struct phy *phy;
> -	int err;
> +	int err, i;
> =20
>  	padctl =3D devm_kzalloc(&pdev->dev, sizeof(*padctl), GFP_KERNEL);
>  	if (!padctl)
> @@ -888,6 +1980,10 @@ static int tegra_xusb_padctl_probe(struct platform_=
device *pdev)
>  	if (IS_ERR(padctl->regs))
>  		return PTR_ERR(padctl->regs);
> =20
> +	err =3D tegra_xusb_read_fuse_calibration(padctl);
> +	if (err < 0)
> +		return err;
> +
>  	padctl->rst =3D devm_reset_control_get(&pdev->dev, NULL);
>  	if (IS_ERR(padctl->rst))
>  		return PTR_ERR(padctl->rst);
> @@ -896,6 +1992,24 @@ static int tegra_xusb_padctl_probe(struct platform_=
device *pdev)
>  	if (err < 0)
>  		return err;
> =20
> +	for (i =3D 0; i < TEGRA_XUSB_USB3_PHYS; i++) {
> +		char prop[sizeof("nvidia,usb3-port-N-lane")];
> +		u32 lane;
> +
> +		sprintf(prop, "nvidia,usb3-port-%d-lane", i);

Like I mentioned while reviewing the binding changes, I think it'd be
better to reverse this and put a property to set this into the pinmux
nodes for the USB3 related pins, similar to the nvidia,usb2-port
property.

That should allow us to avoid these nasty dynamically generated property
names.

> @@ -936,6 +2098,18 @@ static int tegra_xusb_padctl_probe(struct platform_=
device *pdev)
>  		goto unregister;
>  	}
> =20
> +	INIT_WORK(&padctl->mbox_req_work, tegra_xusb_phy_mbox_work);
> +	padctl->mbox_client.dev =3D &pdev->dev;
> +	padctl->mbox_client.tx_block =3D true;
> +	padctl->mbox_client.tx_tout =3D 0;
> +	padctl->mbox_client.rx_callback =3D tegra_xusb_phy_mbox_rx;
> +	padctl->mbox_chan =3D mbox_request_channel(&padctl->mbox_client, 0);
> +	if (IS_ERR(padctl->mbox_chan)) {
> +		err =3D PTR_ERR(padctl->mbox_chan);
> +		dev_err(&pdev->dev, "failed to request mailbox: %d\n", err);
> +		goto unregister;
> +	}

I think this should be done before the registering the PHY provider so
that we don't expose one (even for only a very short time) before we
haven't made sure that it can be used.

Also, this effectively makes the mailbox mandatory, which means that the
above code is going to break on older DTBs. So I think we have no choice
but to make mailbox (and hence XUSB) support optional.

>  	return 0;
> =20
>  unregister:
> @@ -950,6 +2124,9 @@ static int tegra_xusb_padctl_remove(struct platform_=
device *pdev)
>  	struct tegra_xusb_padctl *padctl =3D platform_get_drvdata(pdev);
>  	int err;
> =20
> +	cancel_work_sync(&padctl->mbox_req_work);
> +	mbox_free_channel(padctl->mbox_chan);
> +
>  	pinctrl_unregister(padctl->pinctrl);
> =20
>  	err =3D reset_control_assert(padctl->rst);
> diff --git a/include/soc/tegra/xusb.h b/include/soc/tegra/xusb.h
> index cfe211d..149434f 100644
> --- a/include/soc/tegra/xusb.h
> +++ b/include/soc/tegra/xusb.h
> @@ -10,6 +10,13 @@
>  #ifndef __SOC_TEGRA_XUSB_H__
>  #define __SOC_TEGRA_XUSB_H__
> =20
> +#define TEGRA_XUSB_USB3_PHYS 2
> +#define TEGRA_XUSB_UTMI_PHYS 3
> +#define TEGRA_XUSB_HSIC_PHYS 2
> +#define TEGRA_XUSB_NUM_USB_PHYS (TEGRA_XUSB_USB3_PHYS + TEGRA_XUSB_UTMI_=
PHYS + \
> +				 TEGRA_XUSB_HSIC_PHYS)
> +#define TEGRA_XUSB_NUM_PHYS (TEGRA_XUSB_NUM_USB_PHYS + 2) /* + SATA & PC=
Ie */

These are really XUSB pad controller specific defines, why does anyone
else need to know this?

Thierry

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUN06AAoJEN0jrNd/PrOhsmkP/RUsSotD+bUT6OrlWnCEfxU+
qCs2zrKNF3q3fpgt1X6/n9pDZPs5ykaLtXF5OBwqg684xahXONU/0L7HpduQ7zzd
cz/UbRpPUgg9hFHT+v7DqOCkPsBu+wKS2GHOF0GQjvW3JblKGaGPFBzGfAmfLEKi
/iM1FbMPI2FhYqHtgwW39d2DRUMtqsb0G3gG0qCuvidNFQkXGm5GpFJaau5DZjA7
k9/j4y7fkdyaYnq83+2DQPY8+SiYRgvzkc0TP0rGORrStvZFNZsnWqd+ZLyFM3Jw
fk8WGSdTE/tu3XTLdTjrwnIqhbObjb1dHRW4W1XfEW6v0hdYMkEsreOvz/MPvZhX
P+H92jI42ZYlnCk+zfMOIgm+aShvniqXB1KgyvE7w/p3Qdvptrt4A+F1CyXza1Zd
h7b9qy5MxtjGdCQKSiLPqVd0IzEnaazlCJ5ahmBMs9tSBGFCjdxv+fCfRkrpETxE
njtkP9wTPAzoD1P7QSc5Isz4tbCQZDtj7YPWRj59nkvdXyCCjt72nRGc35QrxdWl
I80CYCELiz+0uBsTte0zsGphcUCyXqtf3rcFqf8mZsiI1HjjyUVJlwKMl3CoCHBs
hF5byzV22vHCIVakY4Wx7TzP5TppWBS+xm2l3UNxHrPymznaBUtOCaeNLrEUJkDj
7Vv18ll/U/Dfrc/tz1+y
=JMVV
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
