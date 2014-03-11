Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaCKObm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:31:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58357 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaCKObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:31:31 -0400
Message-ID: <531F1E30.4040203@pengutronix.de>
Date: Tue, 11 Mar 2014 15:31:12 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Michal Simek <michals@xilinx.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        Soren Brinkmann <sorenb@xilinx.com>
Subject: Re: [PATCH v5] can: xilinx CAN controller support.
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local> <531DD2C4.5060109@pengutronix.de> <f1e2f08f-05fc-40d3-8437-4c6817d631cb@AM1EHSMHS010.ehs.local> <531F0636.4050608@pengutronix.de> <a99feda0-7463-4781-bb73-90b99e65b014@CO9EHSMHS028.ehs.local>
In-Reply-To: <a99feda0-7463-4781-bb73-90b99e65b014@CO9EHSMHS028.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="s6hbhFM2k7JuRJMTdBPESiGGTKRN0GCnw"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s6hbhFM2k7JuRJMTdBPESiGGTKRN0GCnw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/11/2014 03:08 PM, Appana Durga Kedareswara Rao wrote:

>>>>> +   struct napi_struct napi;
>>>>> +   u32 (*read_reg)(const struct xcan_priv *priv, enum xcan_reg reg=
);
>>>>> +   void (*write_reg)(const struct xcan_priv *priv, enum xcan_reg r=
eg,
>>>>> +                   u32 val);
>>>>> +   struct net_device *dev;
>>>>> +   void __iomem *reg_base;
>>>>> +   unsigned long irq_flags;
>>>>> +   struct clk *aperclk;
>>>>> +   struct clk *devclk;
>>>>
>>>> Please rename the clock variables to match the names in the DT.
>>>>
>>> The clock names are different for axi CAN and CANPS case.
>>> So will make them as busclk and devclk Are you ok with this?
>>
>> Why not "ref_clk" and "aper_clk" as used in the DT?
>>
> One of the comments I got from the Soren(sorenb@xilinx.com)
> Is the  clock-names must match the data sheet.
> If I Modify the clock names then it is different names for AXI CAN
> and CANPS case.

Sorry, my faul, I thought the names are already these from the
datasheet. As S=C3=B6ren pointed out please use 's_axi_aclk' and
'can_clk' for the DT and for the the variable names in the private
struct, too.

The 'official' name of the ip core seems to be axi_can, should we rename
the driver? I suspect, that Michal wants to keep xilinx in the name for
marketing reasons :P

[...]

>>>>> +/**
>>>>> + * xcan_chip_start - This the drivers start routine
>>>>> + * @ndev:  Pointer to net_device structure
>>>>> + *
>>>>> + * This is the drivers start routine.
>>>>> + * Based on the State of the CAN device it puts
>>>>> + * the CAN device into a proper mode.
>>>>> + *
>>>>> + * Return: 0 on success and failure value on error  */ static int
>>>>> +xcan_chip_start(struct net_device *ndev) {
>>>>> +   struct xcan_priv *priv =3D netdev_priv(ndev);
>>>>> +   u32 err;
>>>>> +   unsigned long timeout;
>>>>> +
>>>>> +   /* Check if it is in reset mode */
>>>>> +   err =3D set_reset_mode(ndev);
>>>>> +   if (err < 0)
>>>>> +           return err;
>>>>> +
>>>>> +   err =3D xcan_set_bittiming(ndev);
>>>>> +   if (err < 0)
>>>>> +           return err;
>>>>> +
>>>>> +   /* Enable interrupts */
>>>>> +   priv->write_reg(priv, XCAN_IER_OFFSET, XCAN_INTR_ALL);
>>>>> +
>>>>> +   /* Check whether it is loopback mode or normal mode  */
>>>>> +   if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
>>>>> +           /* Put device into loopback mode */
>>>>> +           priv->write_reg(priv, XCAN_MSR_OFFSET,
>>>> XCAN_MSR_LBACK_MASK);
>>>>> +   else
>>>>> +           /* The device is in normal mode */
>>>>> +           priv->write_reg(priv, XCAN_MSR_OFFSET, 0);
>>>>> +
>>>>> +   if (priv->can.state =3D=3D CAN_STATE_STOPPED) {
>>>>
>>>> Your device is in stopped mode, add you go though set_reset_mode()
>>>> already.
>>>
>>> Will remove this if condition I putted this condition here because in=

>>> set_reset_mode we are putting the Device state in Stopped state.
>>
>> So the device is in CAN_STATE_STOPPED, as this code just went through
>> set_reset_mode() some lines ago. so it makes no sense to check if it
>> (still) is (the code runs serialized here).
>>
>=20
> After removing the if condition and the line(CAN_STATE_STOPPED from
> the set_reset_mode) the code for chip_start is below It is better to
> check whether it is really Configured in the loopback or normal mode=20
> That's why kept the loops as it is.
>=20
> static int xcan_chip_start(struct net_device *ndev)
> {
>         struct xcan_priv *priv =3D netdev_priv(ndev);
>         u32 err;
>         unsigned long timeout;
>=20
>         /* Check if it is in reset mode */
>         err =3D set_reset_mode(ndev);
>         if (err < 0)
>                 return err;
>=20
>         err =3D xcan_set_bittiming(ndev);
>         if (err < 0)
>                 return err;
>=20
>         /* Enable interrupts */
>         priv->write_reg(priv, XCAN_IER_OFFSET, XCAN_INTR_ALL);
>=20
>         /* Check whether it is loopback mode or normal mode  */
>         if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
>                 /* Put device into loopback mode */
>                 priv->write_reg(priv, XCAN_MSR_OFFSET, XCAN_MSR_LBACK_M=
ASK);
>         else
>                 /* The device is in normal mode */
>                 priv->write_reg(priv, XCAN_MSR_OFFSET, 0);

What about using two temp variables? Like this (untested, though):

	u32 reg_msg;
	u32 reg_sr_mask;

	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK) {
		reg_msr =3D XCAN_MSR_LBACK_MASK;
		reg_sr_mask =3D XCAN_SR_LBACK_MASK;
	} else {
		reg_msr =3D 0x0;
		reg_sr_mask =3D XCAN_SR_NORMAL_MASK;
	}

	priv->write_reg(priv, XCAN_MSR_OFFSET, reg_msr);
	priv->write_reg(priv, XCAN_SRR_OFFSET, XCAN_SRR_CEN_MASK);

	timeout =3D jiffies + XCAN_TIMEOUT;
	while (!(priv->read_reg(priv, XCAN_SR_OFFSET) & reg_sr_mask)) {
		if (time_after(jiffies, timeout)) {
			netdev_warn(ndev, "time out waiting for correct mode\n")
			return -ETIMEDOUT;
			}
		usleep_range(500, 10000);
	}

>=20
>         priv->write_reg(priv, XCAN_SRR_OFFSET, XCAN_SRR_CEN_MASK);
>         timeout =3D jiffies + XCAN_TIMEOUT;
>         if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK) {
>                 while ((priv->read_reg(priv, XCAN_SR_OFFSET)
>                                 & XCAN_SR_LBACK_MASK) =3D=3D 0) {
>                         if (time_after(jiffies, timeout)) {
>                                 netdev_warn(ndev,
>                                         "timedout for loopback mode\n")=
;
>                                 return -ETIMEDOUT;
>                         }
>                         usleep_range(500, 10000);
>                 }
>         } else {
>                 while ((priv->read_reg(priv, XCAN_SR_OFFSET)
>                                 & XCAN_SR_NORMAL_MASK) =3D=3D 0) {
>                         if (time_after(jiffies, timeout)) {
>                                 netdev_warn(ndev,
>                                         "timedout for normal mode\n");
>                                 return -ETIMEDOUT;
>                         }
>                         usleep_range(500, 10000);
>                 }
>         }
>         netdev_dbg(ndev, "status:#x%08x\n",
>                         priv->read_reg(priv, XCAN_SR_OFFSET));
>=20
>         priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
>         return 0;
> }

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--s6hbhFM2k7JuRJMTdBPESiGGTKRN0GCnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlMfHjAACgkQjTAFq1RaXHPucACgklJJ6wu+OQoyQs41gCD9WM/t
uW8AnAmGAiSzSZZftZT9G3wZ2KY0N4xg
=EpQl
-----END PGP SIGNATURE-----

--s6hbhFM2k7JuRJMTdBPESiGGTKRN0GCnw--
