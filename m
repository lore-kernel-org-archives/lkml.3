Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3IPNvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:51:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33556 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3IPNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:51:23 -0400
Date: Mon, 16 Sep 2013 14:51:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wang Shilong <wangshilong1991@gmail.com>
Message-ID: <20130916135118.GD29403@sirena.org.uk>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
 <20130916091956.GF3999@lee--X1>
 <20130916104009.GA29403@sirena.org.uk>
 <CACRpkdatiELF3WK9qE_Mgcq3iCgv5w3X22xp1=232JJq9sWggQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eP6YdU8NUFVXzKcy"
Content-Disposition: inline
In-Reply-To: <CACRpkdatiELF3WK9qE_Mgcq3iCgv5w3X22xp1=232JJq9sWggQ@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eP6YdU8NUFVXzKcy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2013 at 02:44:35PM +0200, Linus Walleij wrote:

> I've tried to fix this for DT-only I2C devices
> and this very driver was the reason.

> But a tiresome regression due to drivers relying on this
> i2c_device_id not being NULL and inability to remove it from the I2C
> core without refactoring the world ensued, see:
> commit c80f52847c50109ca248c22efbf71ff10553dca4

Oh, that was the change...

> Reverted in:
> commit 661f6c1cd926c6c973e03c6b5151d161f3a666ed

> For this reason I think:
> http://marc.info/?l=3Dlinux-next&m=3D137148411231784&w=3D2

> I have tentatively given up getting pure DT I2C drivers
> to probe, I don't think I have the whole picture, but
> Wolfram has serious doubts about this and say we have
> to be careful ....

> Wolfram, do you have some ideas on how we should
> proceed or ar you happy with merging this as-is?

I'd have expected that it should be possible to change things such that
the change in the core doesn't produce any change in behaviour for
existing drivers.  Can we not change the patch so that i2c_match_id()
copes with getting a NULL id_table?  Something like this:

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 29d3f04..61087ea 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -67,6 +67,9 @@ static int i2c_detect(struct i2c_adapter *adapter, struct=
 i2c_driver *driver);
 static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id=
 *id,
 						const struct i2c_client *client)
 {
+	if (!id)
+		return NULL;
+
 	while (id->name[0]) {
 		if (strcmp(client->name, id->name) =3D=3D 0)
 			return id;
@@ -92,11 +95,8 @@ static int i2c_device_match(struct device *dev, struct d=
evice_driver *drv)
 		return 1;
=20
 	driver =3D to_i2c_driver(drv);
-	/* match on an id table if there is one */
-	if (driver->id_table)
-		return i2c_match_id(driver->id_table, client) !=3D NULL;
=20
-	return 0;
+	return i2c_match_id(driver->id_table, client) !=3D NULL;
 }
=20
=20
@@ -246,7 +246,7 @@ static int i2c_device_probe(struct device *dev)
 		return 0;
=20
 	driver =3D to_i2c_driver(dev->driver);
-	if (!driver->probe || !driver->id_table)
+	if (!driver->probe)
 		return -ENODEV;
 	client->driver =3D driver;
 	if (!device_can_wakeup(&client->dev))

--eP6YdU8NUFVXzKcy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNwzSAAoJELSic+t+oim9JOkP/Rw+NIi7cnDuEwgMLwTdAF/k
T3x550C7QWn9oZ8HTo1L0Q/QRSN6uP9L1h+w/f4VnDY2EhFwYGGb1bAY7yGynCCW
IkMYDP8hF2l2FVjbySrnOZbPNI2ckmabZbaaTLR8akTHZ0AfthlVqma1n3zboCAd
lIgCwtE+3rSTuxhhQx2vYrJWJMhZ5BVGqXaxZxmleyRSR4XxMfhuMCeSyjzyoSdw
5ufXpeoruShTgy3IDlTWkQAv0+G1prSKCLdGjgNLzsgr8DTjTFTO3eoYPSJpjH30
xM1DbUiIpJpVaRveSxtMeuNkISBu8gk6md7rgpqWqK0iD2nEX9RjG8xbl9CI26pk
zlIVNQLznihAdmvC6CYLBzWaaUgMvQnawatp/uB7yh2ZnvnpFygkm/nF19wa4ghS
RQ4BDuRfNloGKY0NOHpRMZEvti+lr39qKZJiKqE2UPUf+MnD/v4YqhydgLUkbRzD
7QHbhkuMLF1XgAm8K1VCkiXEDdqDpzrK0PlMjUgkfF9C3io+icbh3FtdqKgtMS+7
OsnTfO8lTa8IJZ3GuPWlDO5Vz4AGcaMY2KBNRnF8b8mVx8KfOdmjvw7UfQ7evDxr
akt9Y5H8Yfkb7AVDFbxn8WQXlFKfRLSgn+6lONnlSK/oGy/WB5n65hqozKHI7ubR
uHh67nkQeAwX0df5q0G1
=fdfI
-----END PGP SIGNATURE-----

--eP6YdU8NUFVXzKcy--
