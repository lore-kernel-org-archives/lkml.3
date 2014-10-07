Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaJGReB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:34:01 -0400
Received: from sauhun.de ([89.238.76.85]:50155 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbaJGRd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:33:59 -0400
Date: Tue, 7 Oct 2014 19:34:39 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: fix a potential kmemleak of adapter device
Message-ID: <20141007173439.GE1577@katana>
References: <52B0F7D0.2020506@cn.fujitsu.com>
 <20131220173144.GA9997@katana>
 <52B7961D.2050505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GxcwvYAGnODwn7V8"
Content-Disposition: inline
In-Reply-To: <52B7961D.2050505@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GxcwvYAGnODwn7V8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2013 at 09:47:09AM +0800, Gu Zheng wrote:
> Hi Wolfram,
> On 12/21/2013 01:31 AM, Wolfram Sang wrote:
>=20
> > On Wed, Dec 18, 2013 at 09:18:08AM +0800, Gu Zheng wrote:
> >> When running with the latest kernel, we get the following kmemleak mes=
sage:
> >> unreferenced object 0xffff8800c2a36100 (size 256):
> >>   comm "modprobe", pid 629, jiffies 4294676002 (age 1531.115s)
> >>   hex dump (first 32 bytes):
> >>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
> >>     ff ff ff ff ff ff ff ff 78 21 85 82 ff ff ff ff  ........x!......
> >>   backtrace:
> >>     [<ffffffff815449ce>] kmemleak_alloc+0x73/0x98
> >>     [<ffffffff8113fa2b>] slab_post_alloc_hook+0x28/0x2a
> >>     [<ffffffff81142004>] __kmalloc+0x12c/0x158
> >>     [<ffffffff8134c60b>] kzalloc.constprop.6+0xe/0x10
> >>     [<ffffffff8134cb71>] device_private_init+0x18/0x66
> >>     [<ffffffff8134f1e8>] dev_set_drvdata+0x1e/0x34
> >>     [<ffffffffa01e643e>] i801_probe+0x5d/0x447 [i2c_i801]
> >>     [<ffffffff812a78be>] local_pci_probe+0x41/0x84
> >>     [<ffffffff812a7feb>] pci_device_probe+0xdf/0x10c
> >>     [<ffffffff8134f90d>] driver_probe_device+0x12f/0x2ee
> >>     [<ffffffff8134fb2b>] __driver_attach+0x5f/0x83
> >>     [<ffffffff8134de28>] bus_for_each_dev+0x64/0x90
> >>     [<ffffffff8134f36b>] driver_attach+0x1e/0x20
> >>     [<ffffffff8134ef34>] bus_add_driver+0xf2/0x1f0
> >>     [<ffffffff8135013e>] driver_register+0x8c/0xc3
> >>     [<ffffffff812a7bb4>] __pci_register_driver+0x62/0x67
> >> According to the backtrace, it seems that we do not release the
> >> device_private field of adapter device in the fail path of i801_probe
> >> or the flow of i2c_del_adapter, so add the cleanup step to fix it.
> >>
> >> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> >=20
> > ? Why should we free something we don't have allocated? The fix must be
> > somewhere else probably...
>=20
> We do allocate the device_private in device_private_init() when calling
> dev_set_drvdata()

dev_set_drvdata only does the following and doesn't call anything:

	dev->driver_data =3D data;

> to set adapter data in probe flow, and the calltrace
> also shows this. Am I missing something?

It should be freed by the driver core in device_release() again. Dunno
why it does not happen and you are seeing the leak, but the fix is not
correct.


--GxcwvYAGnODwn7V8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNCQvAAoJEBQN5MwUoCm2T9oP/1KD9KgltT+wziX+DDAXeU2Q
mJfbi9rSQTRrkEA5sU2vkm6/1SOsCLPZo9ji7FPTO15tPNsjWd1Oo58MmPDXo6jT
ugV7W7MxhuRQqH5BBdXo4vVonXdFMbeaQAauucm9An+rOn4f5L8dMKXWo1gTiOg9
SiyqTh3HBsaczhI3p2hzA412XpMi5/3wMxTkXG+Z7N9FQBjRjsZgqXIyhfgPGA9i
cuofeXsBT3XciCymCIT32vm6LEeDxwaLYEc+yet3ahc8jTsYncIE2yQTf+fsFXcg
xVdnZhbiJ5Flmbr4NxZewiLUl3le2zZBPsr8O/hVWX1I5V1ir2okqNEEYCznfeyi
CL1aD3t0wdszsg8d1/JSIcup/8hzo3Blax7EbUfYaJUYQVIpTgfeYIULHH78fhka
i6PSv3ynlL6UqNezFM7V2toWWYVa62UdhdPfrNy7TESqRKENsgXCukhS0ZyZIiry
/FgFGGzXJwJoh7mlS5KZ5k91DSt8YMSbhODlIryMSqQoT9yPI32rCXNauyHDxQzM
OHoz8KepfYYoFMTofIpPAp96qF7beUPKLQoQblN4hkDkb9Gqq8xsCiQrW9am4r8O
43t6oIB9RX4/DzJM6qm/RyGKNy24jxwR4CwjBSE1IX4UxljSOxUDqPyRgwmWlOsi
c29xonqPEoJr89YaayCC
=7nIH
-----END PGP SIGNATURE-----

--GxcwvYAGnODwn7V8--
