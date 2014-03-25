Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaCYQRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:17:43 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:50230 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaCYQRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:17:41 -0400
Date: Tue, 25 Mar 2014 17:17:24 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20140325161722.GA23842@ulmo>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131212144210.GA1527@ulmo.nvidia.com>
 <20131213020258.GC13333@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20131213020258.GC13333@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 06:02:58PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 12, 2013 at 03:42:12PM +0100, Thierry Reding wrote:
> > On Thu, Dec 12, 2013 at 03:36:29PM +0100, Thierry Reding wrote:
> > > This is a simple test module that can be used to allocate, export and
> > > delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> > > systems that lack a real second driver.
> > >=20
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > >  drivers/base/Kconfig        |   4 +
> > >  drivers/base/Makefile       |   1 +
> > >  drivers/base/dma-buf-test.c | 308 ++++++++++++++++++++++++++++++++++=
++++++++++
> > >  3 files changed, 313 insertions(+)
> > >  create mode 100644 drivers/base/dma-buf-test.c
> >=20
> > And attached is a small test program that I've been using to test this
> > new module. It can be built with:
> >=20
> > 	$ gcc -O2 -g -Wall -Werror -I/usr/include/libdrm -o dma-buf-test dma-b=
uf-test.c -ldrm
>=20
> Please put this in the patch as well (scripts/tests/ ?)

Sorry for taking so long to get back on this. I've tried various ways to
make this work, but always ended up with something that didn't quite
work.

What I attempted was to put the test program into the samples/dma-buf
subdirectory and use something along these lines:

diff --git a/samples/dma-buf/Makefile b/samples/dma-buf/Makefile
new file mode 100644
index 000000000000..bcaa117474d7
--- /dev/null
+++ b/samples/dma-buf/Makefile
@@ -0,0 +1,8 @@
+obj- :=3D dummy.o
+
+HOSTCFLAGS_dma-buf-test.o +=3D $(shell pkg-config --cflags libdrm)
+HOSTLOADLIBES_dma-buf-test +=3D $(shell pkg-config --libs libdrm)
+
+hostprogs-y :=3D dma-buf-test
+
+always :=3D $(hostprogs-y)

There are two things that don't work too well with this. First this
causes the build to break if the build machine doesn't have the new
public header (include/uapi/linux/dma-buf.h) installed yet. So the only
way to make this work would be by building the kernel once with SAMPLES
disabled, install the headers and then build again with SAMPLES enabled.
Which really isn't very nice.

One other option that I've tried is to modify the include path so that
the test program would get the in-tree copy of the public header file,
but that didn't build properly either because the header files aren't
properly sanitized and therefore the compiler complains about it
(include/uapi/linux/types.h).

One other disadvantage of carrying the sample program in the tree is
that there's only infrastructure to build programs natively on the build
machine. That's somewhat unfortunate because if you want to run the test
program on a different architecture you have to either compile the
kernel natively on that architecture (which isn't very practical on many
embedded devices) or cross-compile manually.

I think a much nicer solution would be to add infrastructure to cross-
compile these test programs, so that they end up being built for the
same architecture as the kernel image (i.e. using CROSS_COMPILE).

Adding Michal and the linux-kbuild mailing list, perhaps this has been
discussed before, or maybe somebody has a better idea on how to solve
this.

Thierry

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMawSAAoJEN0jrNd/PrOhfpIQAJetrRsLDxpZ8wt7cz5uzjyV
E/DY6fRW6+OovJuxfvF8n0kFe3cwFzOP1DS9rNlpPqIt3e5FvjwzS+ecpNqJp2We
e3VBitw9NFmzNawgSI7rOPHl9omszp4grO8TH4SHu4ZKCMntj4hc785hzLWEm+HR
xavP1CF6GqaEnOgxESQkrzAIf2QczVsYcbF5YfNA2tsbyFWGUK6ZMLjKLxs/LGDH
UsdkQcDMs3eSy/XwzfaqRfZM+txHRpnr9pMdlWkrmrghNQnKL+kw/8pftr5mpo38
z3tjitcSMNCekYSWTbihk4pfdocmRyf1iG0UVNky0zYBNy7l+/qv+fIxCtOYCK2K
xvxpd8wcfTlNb3hGRQQaH0YIldSSI7bDE/I08DOwKQwZdoinf/dpZAeBvgRYRL8v
+xD+JY6+8LZ5DbXVmciUA/MZ6qd/1ogKIEf5gyaZRpJZw4wwnsx9h6rrkCDwjjBX
8BccTiPtTVGrRx6U6hxmJjPqseIJFOkePf39adOLTiGe53NAlyCp2/Mj+bP6p4LV
oq06NFBPoPuQqLjO8ysaIZN3GH3eZLpc0FoaR6I0G629xWkBD/+L84pUKsv2lRkJ
TWu1BrkNxvbBW9IzEAStdIQQUmGaeJ5jk6hHKfYhy4y9xQTnnp81dtVjtejpVhhP
RRbOQNx0G3N2Gyaz13zW
=lJnG
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
