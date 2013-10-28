Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3J1LKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:10:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab3J1LKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:10:20 -0400
Date: Mon, 28 Oct 2013 22:10:04 +1100
From: NeilBrown <neilb@suse.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Any news on Runtime Interpreted Power Sequences
Message-ID: <20131028221004.3294c1ea@notabene.brown>
In-Reply-To: <526E3605.9080002@nvidia.com>
References: <20131025112224.6e5265e6@notabene.brown>
	<526A0E71.100@nvidia.com>
	<20131025183345.2b963e13@notabene.brown>
	<526E3605.9080002@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WkqylS7DfS.rMpOrYx=YYJR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WkqylS7DfS.rMpOrYx=YYJR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Oct 2013 19:01:41 +0900 Alex Courbot <acourbot@nvidia.com> wrote:

> On 10/25/2013 04:33 PM, NeilBrown wrote:
> > * PGP Signed by an unknown key
> >
> > On Fri, 25 Oct 2013 15:23:45 +0900 Alex Courbot <acourbot@nvidia.com> w=
rote:
> >
> >> Hi Neil,
> >>
> >> On 10/25/2013 09:22 AM, NeilBrown wrote:
> >>>    I'm wondering if there was any news on the Runtime Interpreted Pow=
er
> >>> Sequences?
> >>> The most recent news I can find is
> >>>     https://lkml.org/lkml/2013/4/27/73
> >>> where you say they might be ready for 3.11.  Clearly that didn't work
> >>> (predictions being hard, especially about the future).
> >>>
> >>> I'm really keen to see them turning into a reality and I gather other=
s are
> >>> too. So ... can we hope?
> >>
> >> A prerequisite of power sequences was to merge the gpiod interface, and
> >> this is finally happening. It took much longer than I wanted, sorry
> >> about that.
> >>
> >> Logically speaking nothing should now stand in the way of a new version
> >> of the power sequences. Expected maybe my own skepticism about them.
> >>
> >> The first version of the power seqs is mainly the result of my
> >> misunderstanding of the device tree. Reconsidering it now, if we strip
> >> the DT support away power seqs would just become a simplified way to
> >> describe how to power a device up and down. In other words, it would be
> >> another way to express what can be expressed with C code and would not
> >> bring any additional flexibility that DT-described power seqs would ha=
ve
> >> (and I say this totally convinced now that power sequences in the devi=
ce
> >> tree were a bad idea).
> >>
> >> The advantage I could see is that using power sequences we could get r=
id
> >> of the cumbersome and mistake-prone error checking code which is
> >> basically the same for most devices. You would just need to describe
> >> what you want to activate, and in which order, and the power seqs
> >> framework would catch and report any error.
> >>
> >> I'm not sure if this is a sufficient reason to introduce another
> >> framework into the kernel, but if this is deemed a good reason by more
> >> experienced people then I'm ok to give it a shot. If you have other
> >> motivations for this, please also state them so I can get the whole
> >> picture. Maybe I just need to be a little bit more motivated about this
> >> idea myself. :)
> >>
> >> Thanks,
> >> Alex.
> >
> > Hmmm... I'm not encouraged that you don't see them as belonging in
> > device-tree, as that is exactly where I want them.
> >
> > Let me explain what I'm thinking.
> >
> > I have two (or three) use-cases on my board ("GTA04" replacement mother=
board
> > for Openmoko Phone).
> >
> > Firstly the wifi chip is very fussy about being reset properly before b=
eing
> > accessed.  However it shares the same power regulator as the bluetooth =
chip.
> > So if the bluetooth is in use when you "ifconfig down; ifconfig up" the
> > wifi, it won't get powered down, so it won't get reset, so it won't wor=
k.
> >
> > What I need to do is to tell the 'mmc/sdio' driver that when it wants to
> > power-on the wifi, it must
> >     pull a reset-gpio low
> >     turn-on the regulator (which might already be on)
> >     pull the reset-gpio high again
> >
> > I currently have that hacked into the omap-hsmmc driver but I don't thi=
nk the
> > code really belongs there.
>=20
> I'd argue that it probably belongs here, on the contrary - unless this=20
> power-on sequence breaks other use-cases (which I don't think it does),=20
> it could simply be considered a safer way to power your device on.=20
> Shared regulators are quite common in the kernel, so you cannot simply=20
> rely on them solely to power a device down and expect it to be back to=20
> its reset set the next time you switch the regulator on.
>=20
> > I would much rather that the omap-hsmmc could be given a 'RIPS' instead
> > of (or as well as) the regulator and be told to just turn that RIPS on =
or off.
> > The RIPS would do the appropriate timed fiddling with GPIO and Regulato=
r.
> > The only place I can think of the describe the RIPS would be in device-=
tree.
>=20
> The problem I have with this is that the power sequence of a device is=20
> something that should be device-specific (as opposed to board-specific),=
=20
> and thus should be handled by the device driver. If you need to come=20
> with a board-specific way to power a device up, this most most certainly=
=20
> means something is wrong with the device's powerup sequence to start=20
> with. In the current case, it definitely seems to be the issue. Is there=
=20
> any problem introduced by asserting reset on your device when you power=20
> it up?

I agree that this power-up sequence should be a property of the device.
However until the device has been powered up, Linux doesn't know about it.
Neither a board file or a devicetree can (as far as I can tell), tell the
MMC port that a particular card is attached.  Rather the host probes the ca=
rd
to see what it is.
So there isn't any way for the device driver to get control at the
appropriate time to effect the proper sequencing.



>=20
> > Secondly I have two devices that are behind serial ports - a GPS and the
> > bluetooth.
> > It makes perfect sense to tie the  power-on/off of these to the serial-=
port
> > concept of "DTR".  The omap-serial doesn't have a physical DTR, but is =
can be
> > configured with a GPIO to use as the DTR (it gets asserted on 'open' and
> > de-asserted on 'close').
> >
> > I currently have a "gpio-to-regulator" converting driver plugged betwee=
n the
> > serial port and the blue-tooth's regulator.  When I open the serial por=
t for
> > bluetooth it asserts the gpio line which is routed through gpiolib to my
> > driver which enables the appropriate regulator.  I have something simil=
ar for
> > the GPS.
> >
> > I think the gpio-to-regulator driver is a kludge.  I would much rather =
tell
> > the omap-serial to activate/de-activate a RIPS as the DTR action.  That=
 RIPS
> > could then control GPIO for a "real" dtr line, or control a regulator to
> > support my bluetooth.
>=20
> What you describe here sounds pretty much like the hotplug GPIO of e.g.=20
> HDMI drivers, which activates the display controller when a plug event=20
> occurs. I'd say that you need a similar mechanism, either at the driver=20
> or framework level, that powers-up the device (not a single regulator=20
> which might once again be shared).

I'm not following here.  This 'hotplug GPIO' sounds like an input GPIO, whi=
ch
signals the CPU when a cable in plugged in.
I'm thinking of an output GPIO which signals some hardware when a /dev/ttyO1
device is opened.  Only I capture the signal in software and redirect it to
switch a regulator.

>=20
> Power sequences would be of little help here, since instead of having a=20
> gpio-to-regulator driver you would need a gpio-to-powerseq one. Instead=20
> of relying on power sequences for this, maybe you could leverage the=20
> runtime_pm framework and invoke pm_runtime_get() on your device when the=
=20
> GPIO is asserted, and pm_runtime_put() once it goes down. This could be=20
> done at your GPS driver level, but it might be interesting to see if=20
> this could not be generalized for a larger group of devices. This kind=20
> of 'device active when a GPIO gets high' should be rather common.

The benefit I see to using power sequences is that it adds a level of
abstraction.  Instead of the serial driver toggling a GPIO, it could just
activate or deactivate a power sequence.  That could toggle a real GPIO or
enable a real regulator, or do whatever is needed to tell the device attach=
ed
to the serial port that someone is ready to talk to it (that the Data
Terminal is Ready).  i.e. a more general solution.

I cannot leverage runtime_pm of the device as there is no driver for the
device.
I'm actually talking about bluetooth here (not GPS, that comes next).  The
kernel doesn't know that there is a bluetooth device behind the serial port.
User-space does and so it runs hciattach.
The question is: how do I arrange that the bluetooth module gets power
exactly when hciattach is run.  The most obvious answer to me is signalling
through the DTR concept.  DTR is perfectly well defined within the serial
layer.  All I need is some sort of interconnect to carry that signalling fr=
om
the serial port through to the particular regulator.
This is unquestionably a function of the board, not of any particular devic=
e.


>=20
> > For the GPS, power on/off is really messy.  There is a toggle connected=
 to a
> > GPIO so you need to know what the current state is before you can know =
how to
> > "turn off".  So you need to either plug into the serial driver and watc=
h for
> > input, or use pinctrl to grab the RX pin and treat it like a GPIO.
> > This is admittedly quite horrible and it makes sense to have a dedicated
> > driver for it, but as the purpose of the driver would be to power
> > something up or down it would be nice if the interface it presented was=
 a
> > power-up-down interface which is exactly what RIPS promised.
>=20
> I'm not sure I understand all the actors involved here, but since you=20
> mention GPIOs powering devices up and down again, wouldn't it somehow=20
> fit within the runtime_pm leverage I suggested earlier? Here it seems=20
> like you need a "power conditions" framework more than "power sequences".=
 :)

It is a bit complicated I agree.

But again, the kernel has no driver for the GPS.  It just has a serial port.
User-space knows this and runs 'gpsd'.  But I need to power-on the GPS when
gpsd opens /dev/ttyO0.  And power it off when the device is closed.

>=20
> > I imagine a device-tree interface a bit like GPIO but with more details.
> > We would have #defines for
> > #define RIPS_REG_ON <0>,
> > #define RIPS_REG_OFF <1>,
> > #define RIPS_GPIO_ASSERT <2>,
> > #define RIPS_GPIO_DEASSERT <3>,
> > #define RIPS_DELAY <4>,
> > #define RIPS_NATIVE_ON <5>,
> > #define RIPS_NATIVE_OFF <6>,
> >
> > Then
> >
> >   rips-on =3D RIPS_GPIO_ASSERT  "wifi-reset",
> >             RIPS_DELAY         <10>,
> >             RIPS_REG_ON       "wifi",
> >             RIPS_DELAY         <10>,
> >             RIPS_GPIO_DEASSERT "wifi-reset";
> >   wifi-reset-gpio =3D <&gpio1 0 GPIO_ACTIVE_HIGH>;
> >   wifi-supply =3D <&vaux4>;
> >
> > would would power-on my wifi-chip.  It's probably a bit ugly, but it is
> > simple and does follow an established pattern to some extent.
>=20
> But this most likely belongs to your wifi driver. Maybe not every board=20
> embedding your wifi chip will require e.g. active regulator, but that's=20
> what dummy regulators are for, and using them results in much less=20
> complexity (and much less controversy :)) that having interpreted code=20
> all over the device tree.
>=20
> So far I don't see any hard requirement for power seqs in your use=20
> cases, but feel free to challenge my arguments. I'm adding the linux-pm=20
> list to the discussion since I feel we might get interesting comments=20
> from there - especially since what you want to do does not seem so uncomm=
on.

Thanks

NeilBrown


>=20
> Alex.


--Sig_/WkqylS7DfS.rMpOrYx=YYJR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUm5GDDnsnt1WYoG5AQLMKBAAsiQ2dAlvel9BPpg0S7CAxVmUiR/kTUfc
vJ6O1zAkenxovDVtY1nEj6YdOiWoJis087C+B18bscf5vvHiBpnP54U46U80lp1H
Y4s9Zdmh+CKNG8qb5YjEeUZxRbV3yp/CmKoLwA9xo9VOVopiDfXYQaYmkggpZyF/
RWXR27gMXoN8I95FdH/O+lz6rKWG/z5OJYsvh+Jo3+EGAhoyso9y20g4rA0+GVyo
QCjq+BCeww7diBWC/+pD3AQ0VRGgv2VSsIXuzCQJvdiD9I3ffzgrDzEHb1Reuycj
1yk3nxK17tBlAK2p2LTgonwDv07Qr/FG2XPpFwV9Vv7ROGu0CRmPQdT921GVyejh
Ad8nV9vQMidKSwcSivjl/xMIk4aMPkBFDR9Z5pGrXe7pyj/VM5oKT2HM3LxbIPTM
PPy2aHRr1U842t5O26Mr55I6Q/dmMNTwDI+lxiWa5smxfLhOOm0C3qQSUVe5fT9O
z0pyfFkser1Nj3YeMvOg7B8CnHQMbfy4Y23V6ZVYhFdKcLaQ9yR/Ny5EyhbFYOq8
5GZRlZ6/8f7pMaSuYeGrDkApouYiM0MCd9q0QAwCiAP4WKuJGKmVQVyTaJf+dmER
P8gcdGXufcVpnPtm7MkPSx78O/J8EN3iJDMx0YJ0epjY9Tpp6kvZBm743WVUQ6g0
ZxWg2ewC50Q=
=m3im
-----END PGP SIGNATURE-----

--Sig_/WkqylS7DfS.rMpOrYx=YYJR--
