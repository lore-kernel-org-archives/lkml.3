Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaJGP2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:28:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36954 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaJGP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:28:32 -0400
Date: Tue, 7 Oct 2014 10:28:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Krzysztof Opasiak <k.opasiak@samsung.com>
CC: <balbi@ti.com>, "'Robert Baldyga'" <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
Message-ID: <20141007152822.GO24720@saruman>
Reply-To: <balbi@ti.com>
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
 <20141007022851.GA13956@saruman>
 <5433892C.80109@samsung.com>
 <20141007140656.GB24720@saruman>
 <0a2301cfe23f$8b4a40b0$a1dec210$%opasiak@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eQyCKlb8USywWNtC"
Content-Disposition: inline
In-Reply-To: <0a2301cfe23f$8b4a40b0$a1dec210$%opasiak@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eQyCKlb8USywWNtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 05:01:15PM +0200, Krzysztof Opasiak wrote:
> > > > Hi,
> > > >
> > > > On Mon, Oct 06, 2014 at 01:25:14PM +0200, Robert Baldyga wrote:
> > > >> Since we can compose gadgets from many functions, there is the
> > > >> problem related to gadget breakage while FunctionFS daemon
> > being
> > > >> closed. In some cases it's strongly desired to keep gadget
> > alive
> > > >> for a while, despite FunctionFS files are closed, to allow
> > another
> > > >> functions to complete some presumably critical operations.
> > > >>
> > > >> For this purpose this patch introduces "zombie" mode. It can
> > be
> > > >> enabled by setting mount option "zombie=3D1", and results with
> > > >> defering function closure to the moment of reopening ep0 file
> > or filesystem umount.
> > > >>
> > > >> When ffs->state =3D=3D FFS_ZOMBIE:
> > > >> - function is still binded and visible to host,
> > > >> - setup requests are automatically stalled,
> > > >> - all another transfers are refused,
> > > >> - opening ep0 causes function close, and then FunctionFS is
> > ready for
> > > >>   descriptors and string write,
> > > >> - umount of functionfs cause function close.
> > > >>
> > > >> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > > >
> > > > Can you further explain how do you trigger this ? Do I
> > understand
> > > > correctly that you composed a gadget using configfs and that
> > gadget
> > > > has functionfs + another gadget ?
> > > >
> > >
> > > Yes, I compose configfs gadget from functionfs + another gadget,
> > and
> > > when functionfs daemon closes ep files, entire gadget get
> > disconnected
> > > from host. FFS function is userspace code so there is no way to
> > know
> > > when it will close files (it doesn't matter what is the reason of
> > this
> > > situation, it can be daemon logic, program breakage, process kill
> > or
> > > any other). So when we have another function in gadget which, for
> > > example, sends some amount of data, does some software update or
> > > implements some real-time functionality, we may want to keep the
> > > gadget connected despite FFS function is no longer functional. We
> > > can't just remove one of functions from gadget since it has been
> > > enumerated, so the only way we can do that is to make broken FFS
> > > function "zombie". It will be still visible to host but it will
> > no longer implement it's functionality.
> >=20
> > now that's an explanation. Can you update commit log with some of
> > this info (once we agree on how to go about fixing this) ?
> >=20
> > I'm not sure we should try to fix this. The only case where this
> > could trigger is if ffs daemon crashes and dies or somebody sends a
> > bogus signal to kill it.
> >=20
> > A function cannot communicate with the host if it isn't functional
> > and ffs depends on its userland daemon. If daemon is crashing, why
> > not print a big WARN("closed %s while connected to host\n") ? That
> > seems like it's as much as we can do from the kernel. Userland
> > should know that they can't have a buggy ffs daemon.
>=20
> It's not a problem of buggy ffs daemon. The problem is that there are
> some non deterministic mechanisms in userspace like OOM killer. FFS
> daemon can be written very well but if we are out of memory it may
> become a victim. In this case reliability of whole gadget hurts a lot.
>=20
> If it's going about WARN(). I'm not enthusiastic about it. Userspace
> process dies all the time, that's quite normal;) I don't think that it
> is good idea to generate a warning on kernel level when some process
> dies. Kernel should be resistant for such situations and know how to
> deal with them (maybe user could select exact behavior, but it should be
> done on kernel site)

yeah, and the way to deal with that is disconnecting from the host
because that USB function, can't be functional anymore. I mean, imagine
you try to e.g. unload pictures from your nice DSLR and that DSLR runs
Linux and implements MTP or PTP using FFS. Then ptpd dies and you're
still connected to the host so you can't know that something went wrong,
the camera just stoped sending you data. So you figure: well, it must
just be slow, I'll leave it here and go have a nap. Hours later and
nothing has changed, because ptpd is still missing.

If you disconnect from the host, however, user knows instantaneously
that something went wrong.

I don't think maintaining a "zombie" function is very nice. In fact, the
very reason for adding usb_function_activate/deactivate was exactly to
prevent us from ever connecting to a host with a non-working function.

--=20
balbi

--eQyCKlb8USywWNtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNAaWAAoJEIaOsuA1yqREpKAQAJlb5KsagFmTXsjBONPZ10KG
wnKr1AeTGsjCyzefkoLDS9kdSgobqWcwzk+aScDZdo6ONw+cyFAMyxazeY3TO+Wi
bQCMz1zJXcT7vrrmOVuVtKbu7sFGxDt7pQ4Auos6MBygPsrYjUkSiEPC23YeLD08
zPFV/duXqGqPdiuC1GD1o5u0SolipjlXG6G/cxC/WfMmbebVI2wRm2aQFmm7NzSy
gCBGS9zoiL7FjkQJZCTg7UdY0Jda1GY9PSeU85PL/G+KhJ9s6evNhosIPQL3nSjP
ZLMUNnU6p8vl3bhz/Z+e5wwU/nxf7SXk1Wv9RuQQHiBmd3fwj6lk2nlzaZVdws3+
fNpx5oH1Iqs0gfpmVi3txL9AxTpzdEmo7VeNyJaOtynH7MPddmpptvPmOtj4EgSc
LHc8v9R36AjbvWkD9eVN/lmtHXiAiWrits74b/9cNdtThlGuWuxWYa5yOYGtfBu/
bVqrIZyAU62ZoP0Y1A8yIoEUWRno9hxINy6sjmsnH3s87WrvMSwsIDlf9VkVRBT8
e4rzp+MGgBkCcc5jOn1yEJcrLx4zQUDLZfxJkC+1aELHEBwCFCaPS2kk4qoaBZz+
s4AkDgCRLRJiQd+dXOEi0wfTZ8yr2844Ah9T/6RfRysM4gJ5JTSVSmiXKVtVm2pg
WaeF8ly28oFD3c8p+4dU
=s69G
-----END PGP SIGNATURE-----

--eQyCKlb8USywWNtC--
