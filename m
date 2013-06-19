Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab3FSTjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:39:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50725 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935094Ab3FSTjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:39:22 -0400
Date: Wed, 19 Jun 2013 22:39:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 2/5] i2c: omap: add runtime check in isr to be sure that
 i2c is enabled
Message-ID: <20130619193916.GE4779@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
 <1370630768-4077-3-git-send-email-grygorii.strashko@ti.com>
 <20130607190206.GC15295@arwen.pp.htv.fi>
 <51C1FB91.1000006@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="idY8LE8SD6/8DnRI"
Content-Disposition: inline
In-Reply-To: <51C1FB91.1000006@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--idY8LE8SD6/8DnRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 09:42:25PM +0300, Grygorii Strashko wrote:
> Hi Felipe,
> On 06/07/2013 10:02 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Fri, Jun 07, 2013 at 09:46:05PM +0300, Grygorii Strashko wrote:
> >>Add runtime check at the beginning of omap_i2c_isr/omap_i2c_isr_thread
> >>to be sure that i2c is enabled, before performing IRQ handling and acce=
ssing
> >>I2C IP registers:
> >>	if (pm_runtime_suspended(dev->dev)) {
> >>		WARN_ONCE(true, "We should never be here!\n");
> >>		return IRQ_NONE;
> >>	}
> >>
> >>Produce warning in case if ISR called when i2c is disabled
> >>
> >>CC: Kevin Hilman <khilman@linaro.org>
> >>Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >>---
> >>  drivers/i2c/busses/i2c-omap.c |   10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >>diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-oma=
p.c
> >>index 97844ff..2dac598 100644
> >>--- a/drivers/i2c/busses/i2c-omap.c
> >>+++ b/drivers/i2c/busses/i2c-omap.c
> >>@@ -885,6 +885,11 @@ omap_i2c_isr(int irq, void *dev_id)
> >>  	u16 stat;
> >>  	spin_lock(&dev->lock);
> >>+	if (pm_runtime_suspended(dev->dev)) {
> >>+		WARN_ONCE(true, "We should never be here!\n");
> >>+		return IRQ_NONE;
> >>+	}
> >returning IRQ_NONE is not what you want to do in this case. You want to
> >setup a flag so that your runtime_resume() knows that there are pending
> >events to be handled and you handle those in runtime_resume time.
> I don't want to handle this IRQ - we should never be here.
> Will be changed to  IRQ_HANDLED.

blindly returning IRQ_HANDLED won't do you any good either. Your line
will be re-enabled anyway and you'll get another IRQ even being fired.

If you have found a bug in the driver, fix it, don't try to mask it.

> >But to be frank, I don't see how this can trigger since we're calling
> >pm_runtime_get_sync() from omap_i2c_xfer() which means by the time
> >pm_runtime_get_sync() returns, assuming no errors, i2c module should be
> >fully resumed and ready to go. Perhaps you have found a bug somewhere
> >else ?
> May be it's better to revert this patch:
> e3a36b207f76364c281aeecaf14c1b22a7247278
> i2c: omap: remove unnecessary pm_runtime_suspended check
>=20
> which doesn't cover case when transfer is *finished*.

what happens when transfer is finished ? After we come out of the loop
in omap_i2c_xfer() we will mark last busy and
pm_runtime_put_autosuspend()

 633 static int
 634 omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 635 {
 636         struct omap_i2c_dev *dev =3D i2c_get_adapdata(adap);
 637         int i;
 638         int r;
 639=20
 640         r =3D pm_runtime_get_sync(dev->dev);
 641         if (IS_ERR_VALUE(r))
 642                 goto out;
 643=20
 644         r =3D omap_i2c_wait_for_bb(dev);
 645         if (r < 0)
 646                 goto out;
 647=20
 648         if (dev->set_mpu_wkup_lat !=3D NULL)
 649                 dev->set_mpu_wkup_lat(dev->dev, dev->latency);
 650=20
 651         for (i =3D 0; i < num; i++) {
 652                 r =3D omap_i2c_xfer_msg(adap, &msgs[i], (i =3D=3D (num=
 - 1)));
 653                 if (r !=3D 0)
 654                         break;
 655         }
 656=20
 657         if (r =3D=3D 0)
 658                 r =3D num;
 659=20
 660         omap_i2c_wait_for_bb(dev);
 661=20
 662         if (dev->set_mpu_wkup_lat !=3D NULL)
 663                 dev->set_mpu_wkup_lat(dev->dev, -1);
 664=20
 665 out:
 666         pm_runtime_mark_last_busy(dev->dev);
 667         pm_runtime_put_autosuspend(dev->dev);
 668         return r;
 669 }

When that timer expires, we will mask the controller's IRQs on our
->runtime_suspend().

Now, if another IRQ comes before we ->runtime_suspend(), then we need to
figure out what's generating that event, we don't want to be "fixing"
what's not broken in this driver.

> Please, see https://patchwork.kernel.org/patch/2689211/ and
> cover-latter.

that patch is fine, but doesn't seem like has nothing to do with what
you're talking about here.

> >Also, your 'We should never be here' message isn't helpfull at all.

nor is your explanation of the problem. It's not sufficient.

I'm telling you that we should never reach this case because that's the
assumption that the driver makes. It assumes that no IRQs will be fired
unless a transfer is started and by the time that for loop ends, no
transfer will be started.

> >>@@ -905,6 +910,11 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
> >>  	u16 stat;
> >>  	int err =3D 0, count =3D 0;
> >>+	if (pm_runtime_suspended(dev->dev)) {
> >>+		WARN_ONCE(true, "We should never be here!\n");
> >>+		return IRQ_NONE;
> >>+	}
> >because of IRQF_ONESHOT I can't see how this would *ever* be a valid
> >check.
> >
> Please, see https://patchwork.kernel.org/patch/2689211/ and
> cover-latter.

explain to me how would we get to this point, meaning the IRQ thread
handler, with the device disabled.

--=20
balbi

--idY8LE8SD6/8DnRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwgjkAAoJEIaOsuA1yqREh4IP/0UsXFMEWqaKt8g7OEV92aC4
MC0evJTGX7PC9Goxz7zNrb+pMS3gDaLIsDeKGqEuCbnrJ0G9CGapX67Zd00m9YnN
ylNgwUa6Sb7z6GFcJw6c26ERMyHOPNWnXeCu2pibjaWapefneYi4YN5H5KEbg3/Z
legcBZpwQmktQ9svv2so40+JxxiX0ar+0AImzNZgyXuCYqwS/2b5fGIwDPi2ebm4
bUq545dazPLQ/T28AV+W8iTfV0WnJ0/anl9MzyI32pnGWKu3rKgYgs5lbn+g4a2Q
R3EAIxXf0XX0MAEIXRPnREFFWv3sJF7Hm5G/e90QTcKaOk0cnrrihdAfnf+0kExT
ndOuu8OYULaB4VRFag6XH7oXf4xzv2AvKIugAB4ArZv3yOXv7CJIbA799888BVu0
lNjGceTcq6EWL2y8fV2Tg1/H9hgqrMSJ32oVqhu9FyiIl84Ur1cNYw62v5FDeqqG
NdBrACVt55h4s+yg2TJqqYvKKaXihCt2o4NLAz8ZvVyUQafz8xBLCQkASvTC9Npx
1xP6BT7hE+pFozVtWcIAvQMmYB574BPJqAAlmrgLgxxfNUwpMUgsB+Yd0SMCD+4D
6PoYvEPHp0EMuHzkiJxrA4gibpbtWuguxYVKf9NR+hxMd2B3TAicPf26K6a0Tasw
9Pu34fsg6sxycRJn8l6P
=Y3h1
-----END PGP SIGNATURE-----

--idY8LE8SD6/8DnRI--
