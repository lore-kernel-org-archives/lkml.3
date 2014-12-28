Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaL1IWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 03:22:37 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52424 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaL1IWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 03:22:34 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Sun, 28 Dec 2014 09:22:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <4129190.SoIGvoiPho@xps13> <3062099.E3gUtAKvky@xps13>
In-Reply-To: <3062099.E3gUtAKvky@xps13>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8990276.JG5J1BH5h7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412280922.30389@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8990276.JG5J1BH5h7
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 27 December 2014 15:13:28 Gabriele Mazzotta wrote:
> On Thursday 25 December 2014 22:54:34 Gabriele Mazzotta wrote:
> > On Thursday 18 December 2014 12:08:58 Pali Roh=C3=A1r wrote:
> > > On Wednesday 10 December 2014 14:32:16 Gabriele Mazzotta=20
wrote:
> > > > On Wednesday 10 December 2014 12:51:30 Pali Roh=C3=A1r wrote:
> > > > > On Tuesday 09 December 2014 21:07:01 Pali Roh=C3=A1r wrote:
> > > > > > Now we have autodetection code for fan multiplier
> > > > > > and maximal fan speed so we do not need to have
> > > > > > those constants for each laptop in kernel driver
> > > > > > code.
> > > > > >=20
> > > > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > > > ---
> > > > > > !!!Please do not apply this patch until all affected
> > > > > > machines will be tested!!!
> > > > > >=20
> > > > > > I tested autodetection code only on Dell Latitude
> > > > > > E6440 (where it worked). Other machines which needs
> > > > > > to be tested:
> > > > > >=20
> > > > > > Dell Latitude D520
> > > > > > Dell Latitude E6540
> > > > > > Dell Precision WorkStation 490
> > > > > > Dell Studio
> > > > > > Dell XPS M140 (MXC051)
> > > > > > ---
> > > > >=20
> > > > > Can somebody else with dell laptops test this patch
> > > > > series?
> > > >=20
> > > > i8k_get_fan_nominal_rpm() returns -22 on my XPS13, so
> > > > nothing changed with this patch series applied.
> > > >=20
> > > > Gabriele
> > >=20
> > > So your BIOS cannot report nominal_rpm and because your
> > > machine is not in dmi list, all 3 patches do nothing for
> > > your machine.
> > >=20
> > > But you need to set multiplier to 1, right?
> > >=20
> > > What about this patch? (on top of 3/3)
> > >=20
> > > --- a/drivers/char/i8k.c
> > > +++ b/drivers/char/i8k.c
> > > @@ -850,6 +850,10 @@ static int __init i8k_probe(void)
> > >=20
> > >  		 */
> > >  	=09
> > >  		for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan) {
> > >  	=09
> > >  			i8k_fan_mult[fan] =3D I8K_FAN_DEFAULT_MULT;
> > >=20
> > > +			if (i8k_get_fan_rpm(fan) > I8K_FAN_MAX_RPM) {
> > > +				i8k_fan_mult[fan] =3D 1;
> > > +				continue;
> > > +			}
> > >=20
> > >  			for (val =3D 0; val < 256; ++val) {
> > >  		=09
> > >  				ret =3D i8k_get_fan_nominal_rpm(fan, val);
> > >  				if (ret > I8K_FAN_MAX_RPM) {
> >=20
> > Hi,
> >=20
> > I'm sorry for replying only now, but I couldn't follow this
> > thread closely and I'm a bit lost now. I haven't tested the
> > suggested change, but I don't think it would work in a
> > reliable way. It's not rare for the fan to be completely
> > stopped, especially on boot. You are right though, 1 is the
> > right multiplier.
>=20
> I took a better look at the code and my laptop is indeed able
> to report the nominal speed. The problem with the original
> patch was that the first call of i8k_get_fan_nominal_rpm()
> correctly returned -22 (the fan doesn't exist) and the loop
> was terminated because of that. I tested the following patch
> http://www.spinics.net/lists/kernel/msg1892101.html and the
> fan multiplier auto detection worked.
>=20
> I confirm that the suggested change in case the nominal speed
> can't be retrieved is not OK as its outcome depends on the
> current state of the fans.
>=20
> > Guenter, while I was trying to catch up, I noticed that the
> > support for the XPS 13 [1] will be added. May I ask you
> > which revision of the laptop was tested? I own the 9333 one
> > and I'm not sure that having i8k automatically loaded is a
> > good idea. The reason is that reading and setting the speed
> > of the right (and only) fan causes a freeze of the laptop
> > of some milliseconds, enough to be annoying and noticeable.
> > I'm worried of the effect this might have in the everyday
> > use, users might start noticing random freezes because of
> > one application that all the sudden is able to read the
> > speed of the fan. I don't if the same happens on all the
> > other Dell systems, this is the first and only Dell laptop
> > I owned.
> >=20
> > If the tested laptop wasn't the XPS13 9333 and this problem
> > does not exists, would it be possible to make the
> > DMI_PRODUCT_NAME string such that it matches only the
> > tested revision? The string that identifies my laptop is
> > "XPS13 9333".
> >=20
> > Gabriele
> >=20
> > [1] http://www.spinics.net/lists/kernel/msg1878801.html
>=20
> I modified i8k so that it prints the time required to execute
> the assembly code in i8k_smm(). Here what I got:
>=20
> [ 4697.485130] i8k_smm asm: 1965800 ns    #pwm1
> [ 4697.487383] i8k_smm asm: 1375057 ns    #temp3_input
> [ 4697.489477] i8k_smm asm: 1112493 ns    #temp3_label
> [ 4697.991687] i8k_smm asm: 500796086 ns  #fan1_input
> [ 4697.998245] i8k_smm asm: 1957365 ns    #fan1_label
> [ 4698.009190] i8k_smm asm: 1770247 ns    #temp1_input
> [ 4698.014416] i8k_smm asm: 749734 ns     #temp1_label
> [ 4698.019103] i8k_smm asm: 2503962 ns    #temp2_input
> [ 4698.023490] i8k_smm asm: 1738982 ns    #temp2_label
>=20
> As you can see, the time required to read the speed of the fan
> is substantially higher than the combined time of all the
> other reads.
>=20
> Is the difference so big for the other systems that have been
> tested?

It looks like we should not read fan rpm at startup for=20
multiplier autodetection... and only fan nominal speed.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart8990276.JG5J1BH5h7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSfvcYACgkQi/DJPQPkQ1IelgCgtmzj6RwtUc/9pgpT5b7/DKa2
VKIAn0UOdcQAl2wvs6V9v94RpmQc0mfv
=wwZR
-----END PGP SIGNATURE-----

--nextPart8990276.JG5J1BH5h7--
