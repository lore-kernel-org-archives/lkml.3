Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab3APKS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:18:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251Ab3APKS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:18:56 -0500
Date: Wed, 16 Jan 2013 11:18:22 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130116101822.GA17706@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130109231758.GA27065@obsidianresearch.com>
 <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
 <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
 <20130110182007.GA28004@obsidianresearch.com>
 <20130110185505.GA22944@avionic-0098.adnet.avionic-design.de>
 <20130110190327.GA23110@avionic-0098.adnet.avionic-design.de>
 <20130110192417.GA18478@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20130110192417.GA18478@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:vJviqzrfEGgbNFM2eTO8KwiZSKtTzBnqH7qJDoL7p79
 o0GPK+V5NHKmmCO0rBWo33cNtKJZrs3g32no9AyrOHP+AXLk1r
 vL4JdnglvDHEUgIwqkLFgsxkceJQaEKeNN8k+oxbBDyDhgWQIh
 7w9mayCqfViuE+y/8nsMVL7ZHmrrbUtlTSM+YOYe4Suq0l7LMH
 5j+Nw+P9peXWOb4kcB3RMN7TqePrx24Fw9vXUDdi2GnBHsxfuY
 yHDhson+H56L0ThNUze3UmLtkNEpa5yvWgbq31s4mfEgA47LOg
 tebfGgKy9xtmq2jQqmZg7QsWasTfLpVlMS5TnUfX93tXb1l6g9
 Zx8GhJ24FDQtYaH74KPy46KY10jg1XDku95VckLPZROzBgwRbu
 DZ0jqh95HXayoe5lBidZaFmVGez8WVU8I5HV7ZWKJAnV1ThNN1
 35iAo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 12:24:17PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 10, 2013 at 08:03:27PM +0100, Thierry Reding wrote:
>=20
> > > > You'd piece a mapping together, each bus requires 16 64k mappings, a
> > > > simple 2d array of busnr*16 of pointers would do the trick. A more
> > > > clever solution would be to allocate contiguous virtual memory and
> > > > split that up..
> =20
> > > Oh, I see. I'm not very familiar with the internals of remapping, so
> > > I'll need to do some more reading. Thanks for the hints.
> >=20
> > I forgot to ask. What's the advantage of having a contiguous virtual
> > memory area and splitting it up versus remapping each chunk separately?
>=20
> Not alot, really, but it saves you from the pointer array and
> associated overhead. IIRC it is fairly easy to do in the kernel.
>=20
> Arnd's version is good too, but you would be restricted to aligned
> powers of two for the bus number range in the DT, which is probably
> not that big a deal either?

I've been trying to make this work, but this implementation always
triggers a BUG_ON() in lib/ioremap.c, line 27:

	27 		BUG_ON(!pte_none(*pte));

which seems to indicate that the page is already mapped, right?

Below is the relevant code:

struct tegra_pcie_bus {
	struct vm_struct *area;
	struct list_head list;
	unsigned int nr;
};

static struct tegra_pcie_bus *tegra_pcie_bus_alloc(struct tegra_pcie *pcie,
						   unsigned int busnr)
{
	unsigned long flags =3D VM_READ | VM_WRITE | VM_IO | VM_PFNMAP |
			      VM_DONTEXPAND | VM_DONTDUMP;
	phys_addr_t cs =3D pcie->cs->start;
	struct tegra_pcie_bus *bus;
	struct vm_struct *vm;
	unsigned int i;
	int err;

	bus =3D devm_kzalloc(pcie->dev, sizeof(*bus), GFP_KERNEL);
	if (!bus)
		return ERR_PTR(-ENOMEM);

	INIT_LIST_HEAD(&bus->list);
	bus->nr =3D busnr;

	bus->area =3D get_vm_area(SZ_1M, VM_IOREMAP);
	if (!bus->area) {
		err =3D -ENOMEM;
		goto free;
	}

	for (i =3D 0; i < 16; i++) {
		unsigned long virt =3D (unsigned long)bus->area->addr +
				     i * SZ_64K;
		phys_addr_t phys =3D cs + busnr * SZ_64K + i * SZ_1M;

		err =3D ioremap_page_range(virt, virt + SZ_64K - 1, phys,
					 vm_get_page_prot(flags));
		if (err < 0) {
			dev_err(pcie->dev, "ioremap_page_range() failed: %d\n",
				err);
			goto unmap;
		}
	}

	return bus;

unmap:
	vunmap(bus->area->addr);
	free_vm_area(bus->area);
free:
	devm_kfree(pcie->dev, bus);
	return ERR_PTR(err);
}

Anybody see what's wrong with that?

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9n5tAAoJEN0jrNd/PrOhUlQP/RUVN/UfOSvzFvZTgmNnopVr
uBS3wbP1GjJT+aMYih9UQyZMuyKfuiZrivc3pdcADdzxyrnNJ4nrHX/Ovsvbu274
na483q/qLqwUCuU7oDg+0ntFC7XxPJadt2/vITq/MzhMRMy9V3cNBQAk+ga4NK/U
WbZ4iX2sMsnJ6wQfFuLavOnXHivdGfgLZ2DaofoTb++TjlzO1bm5zh2rJ9Tc8VyM
Umo93ebyGERRv/IsNGEfb3ZZ7QhyLcHsBDoow1XFfvja4poCumKNMHFz8bbiLK5w
MOvEBoy/q+vwo7ZL3i3/YCxKxUoLQ/+dq6SbmXjDjVTjjiLWXH3t0lhkODoHsrWH
YsiqBIK4bnDS6qNUGWYM8HlTzOHmhhIobkeT+Do/gA0P1gvsoKsh+YpfBiqVof27
M9YDteY1M4pypSw6GctkDPwPTkSM1qCUpFXidvpya7jyrlMpncEG/NiYgEcGsNJP
eyYJ+ky0CznzcuNukcGMa+NOt5eCZzBJnBmNoOU41M1kljZ06/AJKKOI8jsddf3q
nZVDhxnavMXi7uagRpiQjc48oLdEVV2SdBtpVdLIQiHplme8EJj2sQ5c7/XY8WTd
yVDcA3WWkdezFGWxya6C5sbsd2PI/G7qvg19h8GLQgC+CGS1ctRdYr/soLYBrMMT
xIWtdPiPzIl1NqC6TT/S
=z/1p
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
