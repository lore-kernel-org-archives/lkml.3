Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaJGOHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:07:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60597 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaJGOHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:07:05 -0400
Date: Tue, 7 Oct 2014 09:06:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>, <k.opasiak@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
Message-ID: <20141007140656.GB24720@saruman>
Reply-To: <balbi@ti.com>
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
 <20141007022851.GA13956@saruman>
 <5433892C.80109@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <5433892C.80109@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 08:33:16AM +0200, Robert Baldyga wrote:
> On 10/07/2014 04:28 AM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Oct 06, 2014 at 01:25:14PM +0200, Robert Baldyga wrote:
> >> Since we can compose gadgets from many functions, there is the problem
> >> related to gadget breakage while FunctionFS daemon being closed. In so=
me
> >> cases it's strongly desired to keep gadget alive for a while, despite
> >> FunctionFS files are closed, to allow another functions to complete
> >> some presumably critical operations.
> >>
> >> For this purpose this patch introduces "zombie" mode. It can be enabled
> >> by setting mount option "zombie=3D1", and results with defering functi=
on
> >> closure to the moment of reopening ep0 file or filesystem umount.
> >>
> >> When ffs->state =3D=3D FFS_ZOMBIE:
> >> - function is still binded and visible to host,
> >> - setup requests are automatically stalled,
> >> - all another transfers are refused,
> >> - opening ep0 causes function close, and then FunctionFS is ready for
> >>   descriptors and string write,
> >> - umount of functionfs cause function close.
> >>
> >> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> >=20
> > Can you further explain how do you trigger this ? Do I understand
> > correctly that you composed a gadget using configfs and that gadget has
> > functionfs + another gadget ?
> >=20
>=20
> Yes, I compose configfs gadget from functionfs + another gadget, and
> when functionfs daemon closes ep files, entire gadget get disconnected
> from host. FFS function is userspace code so there is no way to know
> when it will close files (it doesn't matter what is the reason of this
> situation, it can be daemon logic, program breakage, process kill or any
> other). So when we have another function in gadget which, for example,
> sends some amount of data, does some software update or implements some
> real-time functionality, we may want to keep the gadget connected
> despite FFS function is no longer functional. We can't just remove one
> of functions from gadget since it has been enumerated, so the only way
> we can do that is to make broken FFS function "zombie". It will be still
> visible to host but it will no longer implement it's functionality.

now that's an explanation. Can you update commit log with some of this
info (once we agree on how to go about fixing this) ?

I'm not sure we should try to fix this. The only case where this could
trigger is if ffs daemon crashes and dies or somebody sends a bogus
signal to kill it.

A function cannot communicate with the host if it isn't functional
and ffs depends on its userland daemon. If daemon is crashing, why not
print a big WARN("closed %s while connected to host\n") ? That seems
like it's as much as we can do from the kernel. Userland should know
that they can't have a buggy ffs daemon.

> > Then what do you need to do the trigger the issue, and what really _is_
> > the issue ? Is gadget disconnecting from host too early ? Do you see a
> > crash ? Memory leak ? Any logs available ? Any steps to reproduce ?
> >=20
>=20
> You simply compose gadget from, for example, ethernet and functionfs.
> You try to send some huge file through ftp, and in meantime FFS function
> breaks. If FFS hasn't enabled "zombie" mode, entire gadget will be
> disconnected and data transmission will fail. If "zombie" mode is
> enabled, then FFS function after daemon breakage will become "zombie"
> and will be nonfunctional, but ethernet gadget will be still active and
> data transfer will be completed.

yeah, this is the problem I have with the feature. We can't expose a
non-working interface to USB host. If daemon crashes, we have to
disconnect.

> > Quite frankly, I don't really like this "zombie" mode. <joke> I know
> > there's a "The Walking Dead" hype right now, but this is too much.
> > </joke>
> >
>=20
> I see, but after all I couldn't find more descriptive name for this featu=
re.

That was a joke :)

--=20
balbi

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUM/OAAAoJEIaOsuA1yqREfMcP/igtj/O/+KkLydCAo8E2CgMn
/xFPXmCtkLOOI3z32bFC1mEc7RVVq/KewYvxh/5dvg/G+T0Yts0JQPBPXidvHQq2
LyXORrffeO+DtPO+TaRVr5JyPT9kRwqea7zLWSesezjlzaLcSDEjoKwulVOQ/wlC
EDsdeiZ5V1ExQXwYyVu697MMpv1G61fPwgb734CmWss14ejxbXgqsPE2ZfERrOlc
0/mkYSkY7PH+Frhv1gQBJJQT/F6DK07LRZdg4s+wYMdBOlIGBuZ+t/z4uMzUMIw8
IV0XeGcoTOhQhuMe0+BYsVqGnypQzvq6JTs0S3TA4v5aLK4J63BxH8oak4hWkKwR
0p55I8+a/poXToI9Hz1X8ymogLp23aUYhwhE/j+VQO4F3W9Xh0LeaYTmZzbFxZ1M
d9hDodgxvAtytjUmxPhJWaGmkp4J7E8fY247v2RAvM/VvWj7V9UzldBD3wtn/po0
vJPogDiaY4kfDXzWhDF5p5Udnne4OFc1EM6AUcCfi0PDY3hSOp9A58omyoEqP9oj
MJMA+vqFEBHuE5MVy1GydVqnp0ucfQP1QI7tYRoxR2UoNkI42cnQBvQYop1pxo0S
51wxAvxTArsPOe2axmispinWlTThzNhSMNyJs88qqOSWRGdGkEsR5Ts+TVUW0oJz
NiPUB3TZ7y7TMx4b9mOb
=JMOx
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
