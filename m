Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbaJ3NCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:02:17 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61270 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759687AbaJ3NCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:02:14 -0400
Date: Thu, 30 Oct 2014 14:02:09 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Message-ID: <20141030130207.GB19386@ulmo>
References: <2287003.09eTeKUr1V@avalon>
 <20141027125819.GA12641@katana>
 <1718941.Qj8UzhsRTh@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <1718941.Qj8UzhsRTh@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 02:53:42PM +0200, Laurent Pinchart wrote:
> Hi Wolfram and Thierry,
>=20
> On Monday 27 October 2014 13:58:19 Wolfram Sang wrote:
> > > The i2c@e6520000 node is probed before the gpio@e6051000 node. The
> > > of_i2c_register_devices() function tries to register all children,
> > > including hdmi@39. It tries to parse and map the I2C client IRQ by
> > > calling irq_of_parse_and_map(), which returns 0 as the interrupt
> > > controller isn't probed yet. The adv7511 driver later probes the hdmi=
@39
> > > device and gets client->irq set to 0.
> >=20
> > I've got this strange feeling of deja vu... Ah, here: Thierry Reding
> > tackled this problem a year ago. His series:
>=20
> Thanks for the pointer.
>=20
> > https://lkml.org/lkml/2013/9/16/111 (of/irq: Defer interrupt reference
> > resolution)
> >=20
> > He did a V2 (which never made it to the i2c list). Seems like the first
> > two patches made it and the rest got stalled without discussion?
> >=20
> > https://lkml.org/lkml/2013/9/18/216
> >=20
> > Adding Thierry to the queue. Maybe he can bring some light to what
> > happened to his series.
>=20
> That's exactly what I need :-) Thierry, do you plan to respin the series ?

Not really. Like I said in my reply to Wolfram, a different set of
patches was merged subsequently to solve this issue for platform
devices, which makes my patchset mostly obsolete. But I think the
solution that you proposed would work well if you do:

-		int irq =3D irq_of_parse_and_map(dev->of_node, 0);
+		int irq =3D of_irq_get(dev->of_node, 0);

And then changing irq_create_of_mapping() should no longer be necessary.
I still think it's kind of lame to handle -EPROBE_DEFER specially as was
done in of_irq_get(), but given how worried people were about the more
invasive changes needed to propagate the correct error code all the way
up it seems like that's as good as it's going to get.

Thierry

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUjbPAAoJEN0jrNd/PrOhYEQP/1OV8S2O7LOs9k7dXH9aX260
9YfqKJh6rppVMNwfeJSPTmKCEe5WKtbExU1IsyGy1aIRSXYy77CJqtuZ9BIA+PGp
Gviz14pq93dEtlZeEIVsyQXxdktMOahpriFC+i4qKanKXKfeKeUTYkxHKZXz9g1s
H0jUJfU12rg3Hmq3YNtH1FtLYGrCX6en8iyQ7pqU4ute+fFMPeN8LRDQv7c89BvD
MJ+wCiZHEwnSe1uqKpqeEoj3whXC0IDf1z5x+STbvjAsf4Um1tcYNtDkmAdwDoub
40ZaAAflr+MSDSaVqTIMxOUQDAYFodLDYrTvRyY1FXONYS+rdzMXOsydtclPSx+n
VIuzT4T1ec6HdE8Aj7lgsr2Ju4eCANvabYNQYKU9bXzchVM5z0FqGKrc4Bt0V1P7
KxOjPPjfoNZwgj3Crli9qq3JDaA234wFqclwIPDIx6yCF3hBBfWerFubAtiUDQpt
tNXsrkupqIMZY27L/5S51FkFLpJDigMwqgyktT0yxo/wo6DbL3GU2wkk/EF5G2nH
ZLA9sEk3jJ0Cw8rmJ/7griuwtq9LjchwQihqDkln8NMrESWSyUgYVt1LguvGSYla
lIzTg29yAlhdkD3LtWqWteIM1VyJmwAy6qI7gTXNUm0IbRfgoG95mu85eqjUaGJ+
VpwOzCCPLsD9NsrZYXwq
=NXz+
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
