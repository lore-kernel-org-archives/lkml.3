Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbbABVgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:36:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbbABVgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:36:23 -0500
Date: Sat, 3 Jan 2015 10:33:57 +1300
From: NeilBrown <neilb@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
Message-ID: <20150103103357.2406fc23@notabene.brown>
In-Reply-To: <20141228142010.GA3922@amd>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215943.4127.24792.stgit@notabene.brown>
 <20141228142010.GA3922@amd>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=KJcYShUfD=bzjiCpEP2ocb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=KJcYShUfD=bzjiCpEP2ocb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Dec 2014 15:20:10 +0100 Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
>=20
> > index 8c4fd0332028..b59501ee2f21 100644
> > --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> > +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> > @@ -39,6 +39,10 @@ Optional properties:
> >    driver is allowed to detect support for the capability even without =
this
> >    property.
> > =20
> > +Optional child node:
> > +- a platform device listed as a child node will be probed and
> > +  powered-on whenever the tty is in use (open).
> > +
> >  Example:
> > =20
> >  	uart@80230000 {
>=20
> Hmm. Other devices may want it the other way around: probe the device
> behind the uart, make it control power and open/close of the uart, and
> hide the /dev/ttyXX from userspace...
> 								Pavel
> 							=09

I've been thinking a bit about this.

The current "tty" seems to be a combination of two things:
 - a line discipline
 - a char_dev

But some line disciplines don't really want the char_dev.
N_MOUSE wants a serio device.
N_HCI wants an HCI device
N_GSM07010 wants 63 different tty char_devs.
N_IRDA and N_PPP ultimately want a net_dev.
etc.

It would be really nice if the uart would register the line disciple as a
child device, then the line discipline would register whatever it wants.

Then if a uart had no children, it would register the 'N_TTY' line discipli=
ne
and get a tty char_dev.  If it had a child, it would probe the child device
and leave it to register and appropriate line discipline.

The child device could interpose itself in the control flow somehow so my
driver could add power control at open/close.

But that isn't how it works.  The line discipline doesn't talk to the uart.
Rather the tty layer talks to the uart (through tty_operations) and to the
line discipline (through tty_ldisc_ops) and also registers the char_dev.

One of the several difficulties with allowing a child device to select a li=
ne
discipline is the different line disciplines activate differently.

N_HCI activates (registers the hci dev) on HCIUARTSETPROTO ioctl.  A child
  device would need a way to specify the protocol I resume.
N_MOUSE activates on a 'read' on the tty - and deactivates when the read
  completes.
N_GSM0710 activates immediately that the ldisc is activated, as does N_IRDA
N_PPP seems to want a PPPIOCNEWUNIT ioctl to fully register.

Doing any of these in a driver for a uart slave device would certainly be
possible.  I wonder if it is something we really want to do in the kernel
though.  What is the gain over providing sufficient information in the
KOBJ_ADD uevent so that udev can do the required work in user-space?

I'm not against the idea, I am just finding it hard to justify.

However I do like the idea of having the UART probe the child instead of
registering a tty.  It could pass the tty_operations structure to the child,
and the child could then register a tty with a slightly different
tty_operations structure, allowing it to capture any operations that it wan=
ts
to capture (such as open/close).
I might try coding that and see what it looks like...

Thanks,
NeilBrown

--Sig_/=KJcYShUfD=bzjiCpEP2ocb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVKcOzDnsnt1WYoG5AQIAVg/9E/l1EHik+sHxcMgzTbXJvOYGeAVQrAQX
opbo9CPFmjUARlVKP7SAEi7URCJ7mUmLWlZ2HY9EltCxYXUfedUsCFK8BGaJ/mfX
bxReJkGQfIBmMcDUcbrIJZ1yiEY3CHAETNQzxygXb2Hztbd1kXc1bcIr35FnQ5+F
KygtxfHBsh6RlP2eYtxQk6zsokWKOxayEx56G9IefQwYPNnbZpi6UWuxN/Djk+m9
ftAWNoKgg9Y+w4EMSyOmCNVu5RrzZnBT0OzoXAhLoIMghaBwX8ykRhEsJLg8rofE
Q6ZO0ojXStzOF/d+VobXhpPltbBdlX0JqFMncgAD7rjxxMdUScqLInC8lAPuzpl9
TLlk/6R3/Br1rg4+MulUl9P/CkAkwR0mHso4ouZg0HCcDH6nbjgy4nhRyVNp7fFe
W4JGc3dNe+rHMnIz5eQV6PgMwxg2TkHruMOQxJ4WZG8xkgsAMst8GVKR1tvzp7yK
g3yyLnPuljBtprHNt3HVUlgtkwk/LuorVDoAe8qPdwAC33TRlUezZ4lZzIpgTVqR
/mFqQDkeYaPukNcWavhrIGBM8ekm7BAhuNDr7R08QHIcnpkltPfJBv6DRnN2hRk+
Ptn5CHbz/J558oAlsAeHW4O/QXpoDE6lZotN7NksT8NI3kzL/Ts3wGMAa8PSYK/l
1T2YgklM27Q=
=PfUb
-----END PGP SIGNATURE-----

--Sig_/=KJcYShUfD=bzjiCpEP2ocb--
