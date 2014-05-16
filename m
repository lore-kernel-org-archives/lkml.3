Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbaEPPcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:32:31 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:51396 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbaEPPc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:32:27 -0400
Message-ID: <1400254108.3540.5.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Fri, 16 May 2014 11:28:28 -0400
In-Reply-To: <20140516140607.GA23902@ubuntu-hedt>
References: <20140515013245.GA1764@kroah.com>
	 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
	 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	 <20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	 <20140515221551.GB13306@kroah.com> <20140516014959.GD22591@ubuntumail>
	 <20140516043532.GA14149@kroah.com> <20140516140607.GA23902@ubuntu-hedt>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FN9APUG09pL9O+4Ohd8Z"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4GFSjtL003657
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-SpamScore: s
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1400858935.1872@9f56eSIZtvmIO1j9nDM63w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FN9APUG09pL9O+4Ohd8Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-05-16 at 09:06 -0500, Seth Forshee wrote:
> On Thu, May 15, 2014 at 09:35:32PM -0700, Greg Kroah-Hartman wrote:
> > On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
> > > > I think having to pick and choose what device nodes you want in a
> > > > container is a good thing.  Becides, you would have to do the same =
thing
> > > > in the kernel anyway, what's wrong with userspace making the decisi=
on
> > > > here, especially as it knows exactly what it wants to do much more =
so
> > > > than the kernel ever can.
> > >=20
> > > For 'real' devices that sounds sensible.  The thing about loop device=
s
> > > is that we simply want to allow a container to say "give me a loop
> > > device to use" and have it receive a unique loop device (or 3), witho=
ut
> > > having to pre-assign them.  I think that would be cleaner to do using
> > > a pseudofs and loop-control device, rather than having to have a
> > > daemon in userspace on the host farming those out in response to
> > > some, I don't know, dbus request?
> >=20
> > I agree that loop devices would be nice to have in a container, and tha=
t
> > the existing loop interface doesn't really lend itself to that.  So
> > create a new type of thing that acts like a loop device in a container.
> > But don't try to mess with the whole driver core just for a single type
> > of device.

> No matter what I don't think we get out of this without driver core
> changes, whether this was done in loop or by creating something new.
> Not unless the whole thing is punted to userspace, anyway.

> The first problem is that many block device ioctls check for
> CAP_SYS_ADMIN. Most of these might not ever be used on loop devices, I'm
> not really sure. But loop does at minimum support partitions, and to get
> that functionality in an unprivileged container at least the block layer
> needs to know the namespace which has privileges for that device.

Woa!  Time out...  Sorry, this will be an off topic aside.

Loop devices support partitions?  I'd love to know how that works.  I've
tried several times in the past to do that but it's failed every time.
I haven't been able to find any how-to in the past.  This article was
just a couple of years ago (after the last time I tried this):

http://madduck.net/blog/2006.10.20:loop-mounting-partitions-from-a-disk-ima=
ge/

This guy didn't use partitions directly but used the offset to the
mount, which is what I had to use.  Everything I found always referred
to using mount offsets in order to mount partitions within a loop
device.

Regards,
Mike

> The second is that all block devices automatically appear in devtmpfs.
> The scenario I'm concerned about is that the host could unknowingly use
> a loop device exposed to a container, then the container could see data
> from the host. So we either need a flag to tell the driver core not to
> create a node in devtmpfs, or we need a privileged manager in userspace
> to remove them (which kind of defeats the purpose). And it gets more
> complicated when partition block devs are mixed in, because they can be
> created without involvement from the driver - they would need to inherit
> the "no devtmpfs node" property from their parent, and if the driver
> uses a psuedo fs to create device nodes for userspace then it needs to
> be informed about the partitions too so it can create those nodes.
>=20
> So maybe we could get by without the privileged ioctls, as long as it
> was understood that unprivileged containers can't do partitioning. But I
> do think the devtmpfs problem would need to be addressed.
>=20
> Thanks,
> Seth
> _______________________________________________
> lxc-devel mailing list
> lxc-devel@lists.linuxcontainers.org
> http://lists.linuxcontainers.org/listinfo/lxc-devel
>=20

--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-FN9APUG09pL9O+4Ohd8Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU3Yuq8DrlnVnRif/AQgXnQf+KNO2+ZBP7GCoAL3muquGMZbka9J/cNfp
1I8EhRk4lfpmRptN9CL/nVHAs/fK75bGF6IhyRb3Ntx4ttcFnSRs4MWxs3ulcUkc
5FLbDOYFzjbDhKl0LkMZ/rXZcsuWu9p2syb+iR1tQ9h70E2F2RKx2TiKB+XYiZlo
jG4SF0DPYPzLtJC6ow0WgLs2oGrAiG6pDHAAqoU0r2HOqgqL8V/iDFBz8/W29Cu3
vQhp05eWtuJfwhTpZ4SfpVGWwgQyhjiXN4+7cxdBR4YuYlpOjQJnCV+4J0vHfLGq
v2XDmD7YPEpzM08zwarUyUZqeYRB03Ip0U6i9xdZPAPtPErh1Fnatw==
=ukYW
-----END PGP SIGNATURE-----

--=-FN9APUG09pL9O+4Ohd8Z--

