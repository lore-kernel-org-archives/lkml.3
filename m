Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3JZT25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 15:28:57 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42860 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3JZT2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 15:28:54 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Bluetooth: Add hci_h4p driver
Date: Sat, 26 Oct 2013 21:28:50 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com> <201310181230.45351@pali> <1382640113.22433.69.camel@joe-AO722>
In-Reply-To: <1382640113.22433.69.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart33731778.aAKNTaAav8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201310262128.50360@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart33731778.aAKNTaAav8
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 24 October 2013 20:41:53 Joe Perches wrote:
> On Fri, 2013-10-18 at 12:30 +0200, Pali Roh=C3=A1r wrote:
> > I rebased patch on top of
> > https://git.kernel.org/cgit/linux/kernel/git/bluetooth/blue
> > tooth-next.git branch master
>=20
> Hi Pali, just some trivial notes:
>=20
> []
>=20
> +static ssize_t hci_h4p_show_bdaddr(struct device *dev,
>=20
> > +                                  struct device_attribute
> > *attr, char *buf) +{
> > +       struct hci_h4p_info *info =3D dev_get_drvdata(dev);
> > +
> > +       return sprintf(buf,
> > "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n", +                    =20
> > info->bd_addr[0], info->bd_addr[1], info->bd_addr[2], +   =20
> >                  info->bd_addr[3], info->bd_addr[4],
> > info->bd_addr[5]);
>=20
> sprintf(buf, "%pM", info->bd_addr)
>=20

"%pM" modifier printing mac address?

> and if this is really bluetooth, does the output need to
> be emitted in reverse order?  ie: %pMR
>=20

I'm sure that actual order of above code is correct.
So what to use? "%pM" or "%pMR"?

> []
>=20
> > +#define NBT_DBG(fmt, arg...) \
> > +               pr_debug("%s: " fmt "" , __func__ , ## arg)
> > +
> > +#define NBT_DBG_FW(fmt, arg...) \
> > +               pr_debug("%s: " fmt "" , __func__ , ## arg)
> > +
> > +#define NBT_DBG_POWER(fmt, arg...) \
> > +               pr_debug("%s: " fmt "" , __func__ , ## arg)
> > +
> > +#define NBT_DBG_TRANSFER(fmt, arg...) \
> > +               pr_debug("%s: " fmt "" , __func__ , ## arg)
> > +
> > +#define NBT_DBG_TRANSFER_NF(fmt, arg...) \
> > +               pr_debug(fmt "" , ## arg)
> > +
> > +#define NBT_DBG_DMA(fmt, arg...) \
> > +               pr_debug("%s: " fmt "" , __func__ , ## arg)
>=20
> The "" isn't useful.
>=20
> dynamic_debugging can add __func__ to each message output
> with +f.
>=20
> I think all of these should be converted to pr_debug
> where used or consolidated into a single
> #define nbt_dbg(mask, fmt, ...)			\
> do {						\
> 	if (mask & debug)			\
> 		pr_debug(fmt, ##__VA_ARGS__);
> } while (0)
>=20
> and used like:
> 	nbt_dbg(TRANSFER, fmt, etc...);
> where debug is some static.
>=20
> Also there are many uses missing "\n" which can
> cause interleaving problems with other printks.
>=20
> []
>=20
> > +int hci_h4p_wait_for_cts(struct hci_h4p_info *info, int
> > active, +                        int timeout_ms)
> > +{
> > +       unsigned long timeout;
> > +       int state;
> > +
> > +       timeout =3D jiffies + msecs_to_jiffies(timeout_ms);
> > +       for (;;) {
>=20
> 	while (time_before(jiffies, timeout)) {
>=20
> > +               state =3D hci_h4p_inb(info, UART_MSR) &
> > UART_MSR_CTS; +               if (active) {
> > +                       if (state)
> > +                               return 0;
> > +               } else {
> > +                       if (!state)
> > +                               return 0;
> > +               }
> > +               if (time_after(jiffies, timeout))
> > +                       return -ETIMEDOUT;
> >=20
> > +               msleep(1);
> > +       }
>=20
> 	return -ETIMEDOUT;
>=20
> > +}

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart33731778.aAKNTaAav8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJsF/IACgkQi/DJPQPkQ1JgVACeLoPKw262+dAKnqaPPo0j0MLr
rmAAnikTfLWXxLWNMQF7Gbv2zibT/Ke+
=sQeY
-----END PGP SIGNATURE-----

--nextPart33731778.aAKNTaAav8--
