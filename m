Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaKHABL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:01:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaKHABJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:01:09 -0500
Date: Sat, 8 Nov 2014 11:00:58 +1100
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] Input: gpio_keys: Make sure wake-up buttons work.
Message-ID: <20141108110058.6c5217e3@notabene.brown>
In-Reply-To: <20141107234507.GB4439@dtor-ws>
References: <20141108103707.45bcc7e3@notabene.brown>
	<20141107234507.GB4439@dtor-ws>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/lB738CxvWC0oepSqmDfFR+b"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
X-Spam-Warning: HELO: vger.kernel.org not a valid domain

--Sig_/lB738CxvWC0oepSqmDfFR+b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Nov 2014 15:45:07 -0800 Dmitry Torokhov <dmitry.torokhov@gmail.co=
m>
wrote:

> Hi Neil,
>=20
> On Sat, Nov 08, 2014 at 10:37:07AM +1100, NeilBrown wrote:
> >=20
> >=20
> > If a key is to be used for wake-up, we must not disable
> > the interrupt during suspend.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboar=
d/gpio_keys.c
> > index 8c98e97f8e41..0b5e54ae343e 100644
> > --- a/drivers/input/keyboard/gpio_keys.c
> > +++ b/drivers/input/keyboard/gpio_keys.c
> > @@ -526,6 +526,8 @@ static int gpio_keys_setup_key(struct platform_devi=
ce *pdev,
> >  	 */
> >  	if (!button->can_disable)
> >  		irqflags |=3D IRQF_SHARED;
> > +	if (button->wakeup)
> > +		irqflags |=3D IRQF_NO_SUSPEND;
>=20
> No, enable_irq_wake() should be enough. I believe Rafael has fixed that
> in the core, right?
>=20

Interesting...  you seem to be right, but I was having wakeup problems until
I added that patch.
I didn't test exhaustively, but the first time my device entered suspend, t=
he
gpio-key didn't wake it up.  Subsequent suspends did...

After I applied this patch, it would reliably wake up even on the first
suspend.

So there seems to be something wrong, but maybe it is more subtle.

Is there a good reason why enable_irq_wake() is only called just as the
device is being suspended, and why disable_irq_wake() is called on resume?
To me it would make more sense to just enable it once (if required) and lea=
ve
it enabled....

I'll see what I can find.

Thanks,
NeilBrown

--Sig_/lB738CxvWC0oepSqmDfFR+b
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF1dOjnsnt1WYoG5AQKb6g//V1dsoXOR6jzBnohyumaSxHGY1VS4jF91
EzS0aM9M5m06NsxuZPC1htCgIosxiA5HgO/39zWB3eUzinH9j60nSucZEPgbmIeb
sMXdb/TQhAlWgy/yEvIHJLm5jMUo/qNWi5u3iifQCwkKVtUEeJ/Dc7kNMGecW3qT
f4ZGVMcChsIZlkIg+caX+r3LujDwTaEr+n1w5S/uxmExHn7Z2rOCZe8CFL/9tBOm
IL50G+2veJQlwlQ/AQdXYiTu8REk1SWyv2ftcyWkXjT2H/GOtQ3/vFXpjEDzV5df
ndEwsxWJRA3akhugx6Umlhqdt+ugo1pYgpZV+nd0aDdE1z3sq0pu54ggkZWMHVAy
deRXkO0BGWQmHILf7LPMCfWPCTn1Ym8287uSU39JPUVBIHZlkkpkEAIcrBhqzCab
4eik/JhDNuoXjPliNRqgFxcS7asZ6m4Fkv75Spa0OYA77fx3Q9MW3N7aoG9xFtwK
mlXBsexUss3zIXPpK+YqQ2smXuE1iGCWbpQNig70KKlqwQrTboirBL6a3aUCsH7P
/oqLua4k7qbaBDVaaXBYKzhSN2b2cKaqSPyldbzJqCKSurxomyYqgeP2egsmWBx0
AYuHuWp6mqiydkyNABaz18+UwNMRU6jPqGVCWeceGArjo7tjUc4LlbVsBFat7k7s
xP9GlD0bS5M=
=glg5
-----END PGP SIGNATURE-----

--Sig_/lB738CxvWC0oepSqmDfFR+b--
