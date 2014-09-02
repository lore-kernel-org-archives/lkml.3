Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaIBPMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:12:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57992 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaIBPMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:12:44 -0400
Date: Tue, 2 Sep 2014 10:12:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <devicetree@vger.kernel.org>, <lee.jones@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <peppe.cavallaro@st.com>
Subject: Re: [PATCH v4 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140902151211.GG16872@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406734091-16202-1-git-send-email-peter.griffin@linaro.org>
 <1406734091-16202-2-git-send-email-peter.griffin@linaro.org>
 <20140820180850.GV24500@saruman.home>
 <20140902111812.GA28857@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JkW1gnuWHDypiMFO"
Content-Disposition: inline
In-Reply-To: <20140902111812.GA28857@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JkW1gnuWHDypiMFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 02, 2014 at 12:18:12PM +0100, Peter Griffin wrote:
> Hi Felipe,
>=20
> Sorry for the delay in replying to this mail, I've been trying to get
> answers to the suspend/resume questions you had.

np

> > > +config USB_DWC3_ST
> > > +	tristate "STMicroelectronics Platforms"
> > > +	depends on ARCH_STI && OF
> > > +	default USB_DWC3_HOST
> >=20
> > this seems wrong as USB_DWC3_{HOST,GADGET,DUAL_ROLE} are booleans and
> > USB_DWC3_ST is a tristate. Better to stick with defaulting to USB_DWC3
> > instead like all the others.
>=20
> Ok will fix.

tks

> > > +static inline void st_dwc3_writel(void __iomem *base, u32 offset, u3=
2 value)
> > > +{
> > > +	writel_relaxed(value, base + offset);
> >=20
> > why relaxed ?
>=20
> The writel and readl implementations on ARM are quite expensive.
>=20
> The writel, does a memory barrier, and also a outer_sync(), which
> involves taking a spinlock, and draining the cache store buffers.
> The readl also does a memory barrier.
>=20
> These barriers / cache operations are unnecessary here as the
> peripheral memory has been ioremap'ed as device memory, and it is only
> one device we are writing to, so the writel/readl_relaxed variants are
> good enough as the ARM arch guarentees they will arrive in program
> order.

good point :-)

> There is some more info about this here
> http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117658
>=20
> Note: It's only possible when we know the driver is not being used on
> other architectures which may have different constraints.
> However for this driver, we know this IP (st glue logic) has only been
> used on ARM based SoC's.

alright :-)

> > > +}
> > > +
> > > +/**
> > > + * st_dwc3_drd_init: program the port
> > > + * @dwc3_data: driver private structure
> > > + * Description: this function is to program the port as either host =
or device
> > > + * according to the static configuration passed from devicetree.
> > > + * OTG and dual role are not yet supported!
> > > + */
> > > +static int st_dwc3_drd_init(struct st_dwc3 *dwc3_data)
> > > +{
> > > +	u32 val;
> > > +	int err;
> > > +
> > > +	err =3D regmap_read(dwc3_data->regmap, dwc3_data->syscfg_reg_off, &=
val);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	switch (dwc3_data->dr_mode) {
> > > +	case USB_DR_MODE_PERIPHERAL:
> > > +		val |=3D USB_SET_PORT_DEVICE;
> > > +		dev_dbg(dwc3_data->dev, "Configuring as Device\n");
> > > +		break;
> > > +
> > > +	case USB_DR_MODE_HOST:
> > > +		val &=3D USB_HOST_DEFAULT_MASK;
> >=20
> > are you missing a ~ here ? Also, shouldn't you mask off the bits before
> > this switch ?
>=20
> Yes your right, good spot! In the next iteration I've defined macros
> for the bits in this control register and explitcitly set/clear them
> for both cases, also adding a comment regarding the
> USB3_DELAY_VBUSVALID bit.

ok, cool.

> By chance host mode still worked with this bug present as the reset
> value of the register on this SoC is OK to have working host mode.

heh :-)

> > > +		dev_dbg(dwc3_data->dev, "Configuring as Host\n");
> > > +		break;
> > > +
> > > +	default:
> > > +		dev_err(dwc3_data->dev, "Unsupported mode of operation %d\n",
> > > +			dwc3_data->dr_mode);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	return regmap_write(dwc3_data->regmap, dwc3_data->syscfg_reg_off, v=
al);
> > > +}
> > > +
> > > +/**
> > > + * st_dwc3_init: init the controller via glue logic
> > > + * @dwc3_data: driver private structure
> > > + */
> > > +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> > > +{
> > > +
> >=20
> > this blank line isn't necessary.
>=20
> Ok, removed in next iteration
>=20
> <snip>
>=20
> > > +
> > > +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-=
reg");
> > > +	if (!res) {
> > > +		ret =3D -ENXIO;
> > > +		goto undo_platform_dev_alloc;
> > > +	}
> > > +
> > > +	dwc3_data->syscfg_reg_off =3D res->start;
> > > +
> > > +	dev_dbg(&pdev->dev, "glue-logic addr 0x%p, syscfg-reg offset 0x%x\n=
",
> > > +		dwc3_data->glue_base, dwc3_data->syscfg_reg_off);
> >=20
> > looks like this message would be more of a dev_vdbg().
>=20
> Ok, changed to dev_vdbg in next iteration
>=20
> <snip>
>=20
> > > +
> > > +#ifdef CONFIG_PM_SLEEP
> > > +static int st_dwc3_suspend(struct device *dev)
> > > +{
> > > +	struct st_dwc3 *dwc3_data =3D dev_get_drvdata(dev);
> > > +
> > > +	reset_control_assert(dwc3_data->rstc_pwrdn);
> > > +	reset_control_assert(dwc3_data->rstc_rst);
> >=20
> > Two questions:
> >=20
> > 1) how would you handle the case when this device is a wakeup source ?
>=20
> I've confirmed with ST the usb3 IP can't be a wakeup source on this SoC.
>=20
> > 2) when resuming, wouldn't you have to reinitialize the entire core ?
>=20
> I asked ST to test this, as a full working suspend / resume setup
> involves some firmware for the standby controller which I don't
> currently have access to (and it is only with the SBC running that all
> power will be removed from this part of the SoC). They have confirmed
> that the usb3 port works after a suspend / resume and devices are
> correctly enumerated etc after a resume with the code as it was
> submitted.
>=20
> What I did notice though after re-reading it, is that we are not
> re-configuring the ST glue logic registers on a resume. So the
> controller could end up with the vbus mux configured differently. So
> in the next iteration I've fixed this, and call st_dwc3_drd_init and
> st_dwc3_init in the resume path.
>=20
> Although ST confirmed that suspend / resume works with or without this
> change applied.

alright, thanks a lot for confirming.

--=20
balbi

--JkW1gnuWHDypiMFO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBd5LAAoJEIaOsuA1yqRE4xgQALXNvkeO2+e/FtRB37LfOfqt
vQnEuIEKIYHjG+MuFP4B7bF4l6aP1TH8CHpMEQVc/4iupc5P6hu+IsgN1FtXwW8p
apyt4MGkCpYhkW/Nk+UplNWHQSpz7DAo1RhCQBjri9+HOAVc1Qda6TmvB/L9A1hU
skohs+WoBJXxw5SZV2m472em6dXra990c/KlcnMemDTrJY/ZD2oxA5hOcEj3tSdQ
p2+x04aM7YOOEF+vs+apZR80K9Dm00wyUgWXAzdBUrZi47N6XWPRdsmmgAs+GEyA
rJVK09oiNihWapm7826ck7TROsPDOJyV3lynR9BYwbZ/vh9Wp9iYuZ0lK+OkEPd3
p2KeHNw5bpJEbZaMBEywR0vABZJhrBi9XLXVOuBILXNvGEplk8YT3aOeHv/bJ6wI
qdBXYQJhLsagW5Wn3Pz7/57MF2tWTUI2LxYTXeRKteQ7FxVeEN1g0RwkVPYaaUj0
pgSsY5PEBChJMZziIOnMtvb6dFYNEEAjueeOcc7VSsh8o8tYgnYfAhd7G94KdCJ2
cXAsHTmGl1UYYaMP8ES5Ql5Y3H9Fk+76eSw4C432KRuloEtPKgCh+5DBFEJD63ft
G1YYyBFKBKHRKBgHfPOb29HH/XemDodP9w1wXy9G9WrIdN9ccMuwE0Fv7okbXwV1
2E9JbXtH4El6SD0IqRaI
=ifqe
-----END PGP SIGNATURE-----

--JkW1gnuWHDypiMFO--
