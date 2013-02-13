Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab3BMBBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 20:01:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab3BMBBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 20:01:37 -0500
Date: Wed, 13 Feb 2013 12:01:21 +1100
From: NeilBrown <neilb@suse.de>
To: Kevin Hilman <khilman@linaro.org>
Cc: Igor Grinberg <grinberg@compulab.co.il>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] usb: musb: fix context save over suspend.
Message-ID: <20130213120121.3df7dd88@notabene.brown>
In-Reply-To: <87zjz9i6s7.fsf@linaro.org>
References: <20130121202831.40a09bbc@notabene.brown>
	<50FD28D3.5070107@compulab.co.il>
	<20130122083832.7a3026c9@notabene.brown>
	<87zjz9i6s7.fsf@linaro.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_cad8A9aYICGNl=/yv9jaE0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_cad8A9aYICGNl=/yv9jaE0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Feb 2013 13:03:36 -0800 Kevin Hilman <khilman@linaro.org> wrote:

> NeilBrown <neilb@suse.de> writes:
>=20
> > On Mon, 21 Jan 2013 13:38:59 +0200 Igor Grinberg <grinberg@compulab.co.=
il>
> > wrote:
> >
> >> -----BEGIN PGP SIGNED MESSAGE-----
> >> Hash: SHA1
> >>=20
> >> Hi Neil,
> >>=20
> >> On 01/21/13 11:28, NeilBrown wrote:
> >> >=20
> >> >=20
> >> > The standard suspend sequence involves runtime_resuming
> >> > devices before suspending the system.
> >> > So just saving context in runtime_suspend and restoring it
> >> > in runtime resume isn't enough.  We  must also save in "suspend"
> >> > and restore in "resume".
> >> >=20
> >> > Without this patch, and OMAP3 system with off_mode enabled will find
> >> > the musb port non-functional after suspend/resume.  With the patch it
> >> > works perfectly.
> >>=20
> >> Hmmm... Some time ago, this has been removed in
> >> 5d193ce8 (usb: musb: PM: fix context save/restore in suspend/resume pa=
th)
> >>=20
> >> Am I missing something? Or things changed and now this patch is correc=
t?
> >
> > Hi Igor,
> >  thanks for alerting me to that patch .... does anyone else get the fee=
ling
> >  that power management to too complex to be understood by a mere human?
>=20
> Yes.  ;)
>=20
> >  That commit (5d193ce8) suggests that the musb-hdrc device is an
> >  'omap_device', or maybe has a PM domain set to something else.
> >  However it isn't/doesn't.  dev->pm_domain is NULL.  So no PM domain la=
yer
> >  will ever call the musb_core musb_runtime_suspend/resume.
> >
> >  The parent device - musb-omap2430 - is an omap device, does have pm_do=
main
> >  set, and does have its omap2430_runtime_suspend/resume called for syst=
em
> >  suspend and so the context for that device is saved and restored.
> >  However that doesn't help the context for musb-hdrc.
> >
> >  Whether musb ever was an omap_device is beyond my archaeological skill=
s to
> >  determine.
> >
> >  Kevin:  Was musb-hdrc ever a device with a pm_domain? or was it only e=
ver
> >      the various possible parents that had domains?
> >      Are you able to defend your earlier patch in today's kernel?  It
> >      certainly causes my device not to work properly.
>=20
> Sorry for the delay here, I'm back to a place where I can test this on
> real hardware.
>=20
> My patch was fixing a real hang when musb was built-in (or loaded), in
> host-mode (mini-A cable attached) but no devices attached.  I just tried
> to reproduce this, and with your patch, the system hangs during suspend.
>=20

Odd.  I plug in a mini-A cable, note that the 'mode' file holds
'a_idle' (sometimes just plugging in the cable isn't enough to trigger that,
but sometimes it is....) and suspend/resume work perfectly.  Though after
resume it is back to b_idle.

unplug/replug and it is back to  a_idle.  suspend/resume and back to b_idle.

> That being said, your description makes sense why this context
> save/restore is needed.  Perhaps your patch needs to add a check whether
> the device is runtime suspended (I gather this is what Ruslan's patch is
> doing.)

I'm not sure it is possible for the device to be runtime suspended at this
point.  Certainly my device never is, even if it was just before the suspend
sequence started. Something is waking it up...
(instruments the code).

Ahh - usb_suspend() calls choose_wakeup() which might call
pm_runtime_resume() if the could be a need to reprogram the wakeup setting.
As that is a 'might', the device might not be runtime-awake when 'suspend'
runs.

Can you see if this, on top of my previous patch, does any better on your
hardware?

Thanks,
NeilBrown


diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 956db0e..00deb94 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2278,7 +2278,8 @@ static int musb_suspend(struct device *dev)
 	}
=20
 	spin_unlock_irqrestore(&musb->lock, flags);
-	musb_save_context(musb);
+	if (!pm_runtime_status_suspended(dev))
+		musb_save_context(musb);
 	return 0;
 }
=20
@@ -2289,7 +2290,8 @@ static int musb_resume_noirq(struct device *dev)
 	 * module got reset through the PSC (vs just being disabled).
 	 */
 	struct musb	*musb =3D dev_to_musb(dev);
-	musb_restore_context(musb);
+	if (!pm_runtime_status_suspended(dev))
+		musb_restore_context(musb);
 	return 0;
 }
=20

--Sig_/_cad8A9aYICGNl=/yv9jaE0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURrl4Tnsnt1WYoG5AQLP8xAAg+Bqokuf2QIx82w00cRyUmrrsASbPM0Y
LpU0sbx+JPwhxQa9lFLUTbDqv7eHVx6imxQ0crXPDTZhhxj5SoHgYLyqJX3/sz3g
V9QGNxpF0JbnnTzb+WixiIgN9lcNkAH9EuwYNKWmqSctzImnHXzq1UOqsUc7ih07
U6ElWsQ8+ggn9Kbg5uhh191yJ73Yw3GfMB7QANwtTcEv9fMZP9I+edO3MwdBUePr
W2qip22LBILp2lWWTolBZ4mNm8aOa2/qkdhAxZF4AyRNvikfrI5Lr4gcGf8SH2AR
iK1sGcFDCkYQDNk5OZOwWnVycvlv3rbW/v6wb18/otSAc7ugPnRGCz0nxEy9O0A6
Wr2iJnC8oVlemwWThs6TLSMx+FgXxZa91+dxs1zwzLi73BB7sDyfUQ/RK9BlU/Ui
3/3CyC4ey9TSLEYrJBzTIbIsUSKTSWOOKAXQJrQwNA4FpNyIUO6jpZZ7OnXZMMVP
1hXdIGuzX9vVAiXDRrkJ/7kxcynUVU+rYcHxymvLP7N7tBl6uL5gHJz//kM0y/CC
6dVDBU1tq/no8F71jKrTN/hU4wJd5nK0HGQn3FpMrBsDXttkQvIPFJ6q1ptiuefH
ur2OTaDAsZTWQL2c3ymuCZv3ZA/CO1ihJaBlCiQKzNebSwOE9U+H61w5lhPRdPT0
0rfIkYltiCU=
=LuT6
-----END PGP SIGNATURE-----

--Sig_/_cad8A9aYICGNl=/yv9jaE0--
