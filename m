Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3BEJQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:16:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3BEJQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:16:04 -0500
Date: Tue, 5 Feb 2013 10:15:56 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 4/8] gpu: host1x: Add debug support
Message-ID: <20130205091555.GC20437@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-5-git-send-email-tbergstrom@nvidia.com>
 <20130204110339.GA28134@avionic-0098.mockup.avionic-design.de>
 <51108D75.9030302@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="raC6veAxrt5nqIoY"
Content-Disposition: inline
In-Reply-To: <51108D75.9030302@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:kCr4onstDq/JaAWDhPJ5S8FjJIAJvx/EGXe78ezA0gn
 P45Z9LNR3mUgw522PqzZ/YX2iqH1pAXDs2zJmxNXcHdit4n4II
 ScQN9taX/euFVrGVBmfHhruukFpjJm6hc6HanRBG2iBBXVRRv0
 8GMjsLwdQFrmDNnEnTSgA7CqPF2ujwLeJZAKHbWjQ424SpoFlT
 Z5s9Uo1oJk2t2Wb3i8UuBeZ3j/Tdeoko87GfbSAA4Y8Fr3pvlw
 Ejw0ve0P6Ac2DVuivmrnw3RI5ioN2TvBQwlDYiuhRETLhQQbB6
 xYMOHNID6DCZUBON+KoCYs1en7d9x5EZYayrO9qjGhHTz3jWmg
 R5Rs4ASg5emvPPdDMKBGQH2XlAHi3R/py+HWfXCMt1EyX+X72V
 AzDEhHYuWooY5+IebRspSxeFcyBEHZq5Fc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--raC6veAxrt5nqIoY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 08:41:25PM -0800, Terje Bergstr=C3=B6m wrote:
> On 04.02.2013 03:03, Thierry Reding wrote:
> > On Tue, Jan 15, 2013 at 01:44:00PM +0200, Terje Bergstrom wrote:
> >> diff --git a/drivers/gpu/host1x/debug.h b/drivers/gpu/host1x/debug.h
> > [...]
> >> +struct output {
> >> +	void (*fn)(void *ctx, const char *str, size_t len);
> >> +	void *ctx;
> >> +	char buf[256];
> >> +};
> >=20
> > Do we really need this kind of abstraction? There really should be only
> > one location where debug information is obtained, so I don't see a need
> > for this.
>=20
> This is used by debugfs code to direct to debugfs, and
> nvhost_debug_dump() to send via printk.

Yes, that was precisely my point. Why bother providing the same data via
several output methods. debugfs is good for showing large amounts of
data such as register dumps or a tabular representation of syncpoints
for instance.

If, however, you want to interactively show debug information using
printk the same format isn't very useful and something more reduced is
often better.

> >> diff --git a/drivers/gpu/host1x/hw/debug_hw.c b/drivers/gpu/host1x/hw/=
debug_hw.c
> >=20
> >> +static int show_channel_command(struct output *o, u32 addr, u32 val, =
int *count)
> >> +{
> >> +	unsigned mask;
> >> +	unsigned subop;
> >> +
> >> +	switch (val >> 28) {
> >> +	case 0x0:
> >=20
> > These can easily be derived by looking at the debug output, but it may
> > still make sense to assign symbolic names to them.
>=20
> I have another suggestion. In downstream I removed the decoding part and
> I just print out a string of hex. That removes quite a bit bunch of code
> from kernel. It makes the debug output also more compact.
>=20
> It's much easier to write a user space program to decode than maintain
> it in kernel.

I don't know. I think if you use in-kernel debugging facilities such as
debugfs or printk, then the output should be self-explanatory. However I
do see the usefulness of having a binary dump that can be decoded in
userspace. But I think if we want to go that way we should make that a
separate interface. USB provides something like that, which can then be
fed to libpcap or wireshark to capture and analyze USB traffic. If done
properly you get replay functionality for free. I don't know what infra-
structure exists to help with implementing something similar.

So I think having debugfs output some data about syncpoints or the state
of channels might be useful to quickly diagnose a certain set of
problems but for anything more involved maybe a complete binary dump may
be better.

I'm not sure whether doing this would be acceptable though. Maybe Dave
or somebody else on the lists can answer that. An alternative way to
achieve the same would be to hook ioctl() from userspace and not do any
of it in kernel space.

> >> +static void show_channel_word(struct output *o, int *state, int *coun=
t,
> >> +		u32 addr, u32 val, struct host1x_cdma *cdma)
> >> +{
> >> +	static int start_count, dont_print;
> >=20
> > What if two processes read debug information at the same time?
>=20
> show_channels() acquires cdma.lock, so that shouldn't happen.

Okay. Another solution would be to pass around a debug context which
keeps track of the variables. But if we opt for a more involved dump
interface as discussed above this will no longer be relevant.

> >> +static void do_show_channel_gather(struct output *o,
> >> +		phys_addr_t phys_addr,
> >> +		u32 words, struct host1x_cdma *cdma,
> >> +		phys_addr_t pin_addr, u32 *map_addr)
> >> +{
> >> +	/* Map dmaget cursor to corresponding mem handle */
> >> +	u32 offset;
> >> +	int state, count, i;
> >> +
> >> +	offset =3D phys_addr - pin_addr;
> >> +	/*
> >> +	 * Sometimes we're given different hardware address to the same
> >> +	 * page - in these cases the offset will get an invalid number and
> >> +	 * we just have to bail out.
> >> +	 */
> >=20
> > Why's that?
>=20
> Because of a race - memory might've been unpinned and unmapped from
> IOMMU and when we re-map (pin), we are given a new address.
>=20
> But, I think this comment is a bit stale - we used to dump also old
> gathers. The latest code only dumps jobs in sync queue, so the race
> shouldn't happen.

Okay. In the context of a channel dump interface this may not be
relevant anymore. Can you think of any issue that wouldn't be detectable
or debuggable by analyzing a binary dump of the data within a channel?
I'm asking because at that point we wouldn't be able to access any of
the in-kernel data structures but would have to rely on the data itself
for diagnostics. IOMMU virtual addresses won't be available and so on.

> >> +static void host1x_debug_show_channel_cdma(struct host1x *m,
> >> +	struct host1x_channel *ch, struct output *o, int chid)
> >> +{
> > [...]
> >> +	switch (cbstat) {
> >> +	case 0x00010008:
> >=20
> > Again, symbolic names would be nice.
>=20
> I propose I remove the decoding from kernel, and save 200 lines.

I think it could be more than 200 lines. If all we provide in the kernel
is some statistics about syncpoint usage or channel state that should be
a lot less code than we have now.

However that would make it necessary to provide userspace tools that can
provide the same quality of diagnostics, so I'm not sure if it's doable
without access to the in-kernel data structures.

Thierry

--raC6veAxrt5nqIoY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJREM3LAAoJEN0jrNd/PrOhxUoP/ixZUIGbbE68gg+Vq295E/Sb
Gy7vUt/y/QCd19CJJ7FKBJZs+Wo1HJ3sBm04+t7a52fnjyvyabAgSmcskt0EJqh4
jSFso5IcmI0rgc6HBYaN3vp8TyQs2yEaSAJO26K0F7oZL+6YUR7qLBW2LAKAn6c2
Hd8LBCF6q4wtLkS4s/KNu90w4dbTeLVlKXdoJrkg+Q6DSUgoSm7vkid+/ZNmn7ZP
Rcij+qrIXfdbXlj3OE6uNzQ5lRhrIVvPTmWXoqXzkxxaD6ZO9qrrZe5Mrmdb0CYf
mK+sX3OTkctKZqAygBrrLIQv0tpnOWtZaGhsSRJ/pVm0NOsIfJ6cG1hTLqOz4bQ4
mxYqBT86Pkh5iF61MA+RlImh/gnNUVH/up3/NbM2wgjtxR/fKk8SHWldelKG7M69
gVpB5hj+SyyG4HJfhQXf3r7aki8x+RxBvaSVLKCyEHYGfdTPkymI6ihNx1zwNgOm
36S2QfAdWzXbCmMIh0YHCrf3ZClZY+er/j5/RgrIGpWX94+Ub/MKFbX0vqCl8JH7
b37AiLxKFgEQiSXTsUJA96TvBhNk2nYt5l568yMDF+M1dYAxgHSELm91qwsZZqkg
rw9A/3969kkkm5LWwGIVaUUIyAGq1mzkN68B1ykOifYdUFi5s2s4tRkiehyeLUJI
C1aceWMdx8AsfKAVzhQq
=hsgL
-----END PGP SIGNATURE-----

--raC6veAxrt5nqIoY--
