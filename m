Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaCXJpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:45:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36583 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751493AbaCXJpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:45:04 -0400
Date: Mon, 24 Mar 2014 10:41:37 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>, LKML <linux-kernel@vger.kernel.org>,
        zhuzhenhua@allwinnertech.com,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Message-ID: <20140324094137.GB5416@lukather>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
 <CAP=VYLqCmG6fRmPPABoW4xg_tFgGh2pji=f5ML=cBgCu4zZocg@mail.gmail.com>
 <20140321191739.GT27873@lukather>
 <4177769.XedaQsoUgV@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <4177769.XedaQsoUgV@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 22, 2014 at 12:11:24PM +0100, Arnd Bergmann wrote:
> On Friday 21 March 2014 20:17:39 Maxime Ripard wrote:
> > On Fri, Mar 21, 2014 at 11:49:59AM -0400, Paul Gortmaker wrote:
> > > On Mon, Mar 10, 2014 at 7:29 AM, Russell King - ARM Linux
> > > <linux@arm.linux.org.uk> wrote:
> > > > On Mon, Mar 10, 2014 at 11:58:08AM +0100, Maxime Ripard wrote:
> > > >> On Fri, Mar 07, 2014 at 04:08:36PM +0000, Russell King - ARM Linux=
 wrote:
> > > >> > On Fri, Mar 07, 2014 at 03:59:30PM +0100, Maxime Ripard wrote:
> > > >> > > @@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *=
pd)
> > > >> > >  exit_free_irq:
> > > >> > >   free_irq(drv_data->irq, drv_data);
> > > >> > >  exit_reset:
> > > >> > > - if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
> > > >> > > + if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
> > > >> > > +     !IS_ERR(drv_data->rstc))
> > > >> > >           reset_control_assert(drv_data->rstc);
> > > >> >
> > > >> > Another question is... why do we need to check pd->dev.of_node h=
ere?
> > > >> > If CONFIG_RESET_CONTROLLER is set, we always try to get the reset
> > > >> > controller node, so drv_data->rstc is either going to be a valid
> > > >> > pointer, or it's going to be an error pointer - neither
> > > >> > reset_control_get() nor devm_reset_control_get return NULL.
> > > >>
> > > >> Following back on this as I was doing the patch, actually,
> > > >> drv_data->rstc will be NULL if we're not probed by DT, and hence n=
ever
> > > >> call reset_control_get, that would set an error pointer.
> > > >>
> > > >> But then, we can use IS_ERR_OR_NULL on drv_data->rstc.
> > > >
> > > > I think you can also move the devm_reset_control_get() into the main
> > > > probe function: you're only checking for -EPROBE_DEFER from it to f=
ail,
> > > > allowing other errors to continue with the driver init.  This means
> > > > that on non-OF, devm_reset_control_get() will fail with -ENOENT.
> > >=20
> > > Looping linux-next into the CC since this is the cause of the failure
> > > in orion5x_defconfig there, and no point in anyone else re-doing the
> > > same bisect.
> >=20
> > I sent a fix for this that hasn't been picked up yet:
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/239069=
=2Ehtml
> >=20
> > IIRC, Wolfram's away until Monday, so I guess it will be merged some
> > time next week.
>=20
> I think there is something wrong with an interface that makes you use
> IS_ERR_OR_NULL(). If you are calling reset_control_get_optional(), that'
> should not return an error when there is no reset controller listed
> in the device tree. We should still have a way to propagate -EPROBE_DEFER,
> or bail out if there is a reset controller but there is something wrong
> with it, but otherwise I'd suggest just leaving NULL as a valid pointer
> in drv_data->rstc and making sure that the reset controller functions
> can just deal with a NULL argument, so you never have to check it again.

Actually, it's not the reset framework but the driver itself that
needs this. The framework will always return an error pointer here,
but we won't ever call reset_control_get_optional if we are not probed
with DT, and in that case, we will have NULL is data->rstc, hence why
we need to use IS_ERR_OR_NULL.

We should probably fix the reset functions, but maybe that can come
later so that we have marvell's defconfig fixed?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTL/3QAAoJEBx+YmzsjxAgY6AP/1uVSOM5/sF088hQkuuMLrjh
dV8Vh5aqe2PuOk7tm/HT+f2lMzmyPs9YC5loLKdd+z+klbLV83wVU+74U8WTc9Fw
AiQ5jI6v7pvAnaFHPiHf5xW1EylL+sHji2iI5wcpFvJbcRHZjU2Gmy8pBssc+xLd
9tWysgAhTBpyZZKvWPFvWjJu+f74LrbKWkWW4cuXBBXcdGssQi93e1irIN3vuPRw
4SP3FupRI5GrpRc3JvG3XTi6j2xqgyW5SFtPzUwW712supAzheRXM75G6gomLsgK
hxtRp+1pO6zhzGVrxRWm2HdMSd6YJZ4iSeGVopn0uBLkrYai+eXUR929eaUOidIR
9pJ2j4l1zS4L7f0ddURsk4NL5Tyxq+tCYHicaW7ri/14LNRZmJz4EQ0Z3ViVstHp
NEdm1YNQRCtBFenDpZ+LlCPdL9ZfR4N28BfwvOsQqTbQmJeVnClAAvqKgyXat8EX
7SyKZyj62k/N7B2qcVE/E+VQRDaFNnqdheRE3yEgtFy0f/OH/brDaZTBfxlUS944
lMtyhQ3wBaPG+EgpY4KUSJhQwbv9+2ZHxV7QiY6BIQWDRNGF0vMQcvqxMNYiHvc1
oF2okBLecmXeUUX7Tek42GUDho47I7+YojdBiTJMzJztKrK2AQwgr97q/ecnkxJe
Il438A3MLIo/pcaxDHw2
=EADx
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
