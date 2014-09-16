Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaIPFQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 01:16:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57740 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaIPFP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 01:15:58 -0400
Date: Tue, 16 Sep 2014 00:15:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <peter.chen@freescale.com>
CC: Andreas Larsson <andreas@gaisler.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH] usb: gadget: udc_core: Use right kobj when calling
 sysfs_notify
Message-ID: <20140916051529.GB10498@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410777748-28090-1-git-send-email-andreas@gaisler.com>
 <20140916020223.GD3379@peterchendt>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <20140916020223.GD3379@peterchendt>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 16, 2014 at 10:02:25AM +0800, Peter Chen wrote:
> On Mon, Sep 15, 2014 at 12:42:27PM +0200, Andreas Larsson wrote:
> > The state attribute is connected to the kobj of the udc, not the gadget.
> >=20
> > Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> > ---
> >  drivers/usb/gadget/udc/udc-core.c |   14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc=
/udc-core.c
> > index b0d9817..37c129a 100644
> > --- a/drivers/usb/gadget/udc/udc-core.c
> > +++ b/drivers/usb/gadget/udc/udc-core.c
> > @@ -109,8 +109,20 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
> >  static void usb_gadget_state_work(struct work_struct *work)
> >  {
> >  	struct usb_gadget	*gadget =3D work_to_gadget(work);
> > +	struct usb_udc		*udc =3D NULL;
> > +
> > +	mutex_lock(&udc_lock);
> > +	list_for_each_entry(udc, &udc_list, list)
> > +		if (udc->gadget =3D=3D gadget)
> > +			goto found;
> > +	mutex_unlock(&udc_lock);
> > +
> > +	return;
> > +
> > +found:
> > +	mutex_unlock(&udc_lock);
> > =20
> > -	sysfs_notify(&gadget->dev.kobj, NULL, "state");
> > +	sysfs_notify(&udc->dev.kobj, NULL, "state");
> >  }
> > =20
> >  void usb_gadget_set_state(struct usb_gadget *gadget,
>=20
> What's the user mode difference with and without this patch?

poll() will actually wakeup ?

--=20
balbi

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUF8dxAAoJEIaOsuA1yqRE2IAP/20MORsp3qKO0XO6dkjfDUTz
H7EDYGpkeHZFUViqkbDJHnhtXWuPHU0VWA1SUriDOls13ApwLDVEMnyWJJ50oKgc
FkwO2UlUUjjdp12WEncxU8f/KyecTzWAxsnWOB024khPeICMj9qZfRQyNz6t8cez
iFSxKMCZsji5f1CSSeXijA+Z8JyeQKaLNK/xlz09E6Ho6/JhEWKkPJcKDKrvqkpE
TXxLE5FcUqCUSuyJmtMgV8QAFC2FDm+XXrIWY8hjHxxIKndQOKgqnzK3bh20naGB
/lN7m/ReQ0cVrUw4CqRznYl8U68I8SytLq03pxJQErd9EjjWBxufGdEAulZz2MO8
kMU3ZA/M4XLSLSqkyznQsZR7J1pwfVx3Iy7FalrLorhLE4f0HLVsODV4pYgWKsEn
PzVDbOc9RTh067obplzk2TKhTCPPQj9xVoS1WWfENirzfxmuX2hqu4sIN+s2FvG5
CXMLjs/NNCKl2iqr+ZKioqNhOoHWvQZ9SVLSK1VAhdlqud4q8QJqKdv3rpOuDdIm
SPufALKFK10BonTVwtpvx9yAu0MHNux+vCsLvX5uexXTkHLg4J3eBEc9l5i0NOox
0iN1+M2O1qbM9wcq7NvgctCmkZLow3RbVNC7A+1BeVWOsr4TaYG0XV+ULo09WLcU
4acNMz4F40vURkjo+WrN
=78WJ
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
