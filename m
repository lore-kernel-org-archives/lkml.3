Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3ALMhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 07:37:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3ALMhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 07:37:15 -0500
Date: Sat, 12 Jan 2013 13:36:40 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130112123640.GA22505@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <50EF54B6.6010100@wwwdotorg.org>
 <20130111034015.GA28094@avionic-0098.adnet.avionic-design.de>
 <201301111536.14799.arnd@arndb.de>
 <20130111154516.GA25335@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20130111154516.GA25335@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:HDjWO7sXtSujm2ddyN27s+R3XF4DALW/l3m9OFLBT3L
 Ggjb489JC7wQlgU4c8K7P2H2przfBU4GkT1VC5sUtZZtEtN3gh
 np6CP7tz2eaxRf/PcRDr2JpF9XoLfKUXawr/K5OyD2SSEEkNPu
 NKgrI/oeaKm2k/a9NCD4j3N81mIKXqeFYZWSVoaNlamvLK/yP+
 GAX3aX1Q20NFC7gmir1XPKSsmYuvESTUc1gIaW4cABrqfTtXDY
 O7XAvctJGcrFD9xavOn+IcjzGiQiKGEvUMsZ/ytBKR1eDBtQX7
 ftRe5/oYZwfgWi9McDMjYXXDnF+teZjFuykrtjOJ0kt7Z8mhyx
 gPAVOo04XxpZdUF4MaF/GI8rqcow2KtVarTbR65eKDYOdUXUjG
 RobrRGYzJJbN5Y124/B+29Yq2HujUwuV/BQO1WGkJ4JtcX3RF/
 EP+Ny
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 11, 2013 at 04:45:16PM +0100, Thierry Reding wrote:
> On Fri, Jan 11, 2013 at 03:36:14PM +0000, Arnd Bergmann wrote:
> > On Friday 11 January 2013, Thierry Reding wrote:
> > > Right, it'll need #ifdefs around the arch_{setup,teardown}_msi_irq().=
 Or
> > > select PCI_MSI unconditionally. Once this is merged I was going to po=
st
> > > a patch that enables PCI_MSI in tegra_defconfig anyway. But it might =
be
> > > better to keep it optional anyway since the remainder of the code cop=
es
> > > with it properly.
> > >=20
> > Actually, we need something better than that. You cannot define
> > arch_setup_msi_irq in a tegra specific pci host driver, because that
> > will seriously mess up other platforms in multiplatform configurations
> > by giving a link error when they also define this function, or with a
> > run-time error when they don't support it.
> >=20
> > I think what we should do here is fix it the right way by adding
> > a pci host specific callback rather than an architecture specific
> > callback in drivers/pci/msi.c. There is already a default version
> > of arch_setup_msi_irqs (with s), and we can probably do the
> > same for arch_setup_msi_irq (without s) to fall back to the
> > arch version for most architectures.
> > Most architectures (at least powerpc, sparc, ia64 and x86) already
> > multiplex the msi handlers internally, but ARM does not because
> > there is only one implementation (iop33x) at the moment.
> >=20
> > We can add a generix multiplex and then move architectures over to
> > use it.
>=20
> I already hinted at that in one of the other subthreads. Having such a
> multiplex would also allow the driver to be built as a module. I had
> already thought about this when I was working on an earlier version of
> these patches. Basically these would be two ops attached to the host
> bridge, and the generic arch_setup_msi_irq() could then look that up
> given the struct pci_dev that is passed to it and call this new per-
> host bridge .setup_msi_irq().

struct pci_ops looks like a good place to put these. They'll be
available from each struct pci_bus, so should be easy to call from
arch_setup_msi_irq().

Any objections?

Thierry

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8VjXAAoJEN0jrNd/PrOhFWsQAIIvLUhTrpqlNwFmzOoZiyRc
pZzCDmOrad/vwXbThJuzn9752yAoN3YAE9tnGGlnCrc4YcptmrHZYfItYMUYZPe5
lcLaj9M5v6lOpLZMBlUiRcKftPK/5DK3xd+wZsFUVKSewY+Pu1Jbd58AIpmPSZpA
yOaIbme9ugbDO+TsJDQ70TLHX3wAmC+gyoSwT5JW21K4I0Ch7Ga7DpPl8XzpgGv5
N7lNCT7fe+qkvmg8/5ONL34FPYP/qgE7mX+uxSrd2aop0PNDU9YDNmeZ4TmgLX5s
aqFLMEivpJ/ALNbKlDqvCb2DesXKnT3fZpLFuZG4P6I881hxkU1a14ddB52zc3jH
CJ/BLkX2r8lYUR7Z0H3FoR8/q1J/zbmEfVTobF5aC0XGUZnibs4j9YlZRUmgj7jw
ZAHpba8/1uUt3VicgQawNF5xG2ct2qGKDj3XONHWwlpZzfvCcCVav73Uqbko8rVg
7wkIxdEgNKeP9O9f1Z1uH6Ypg3dxWKnN4A3uq5GRUT8sORWBYytbopdO096AuCXA
wmAYwHPLjCExTYI2M1jQuA+9WEuMJa2dF+/ofTqqUakhMERHVyjNvJNxYeC43+Jv
8ezg3JzlLohRQ9gQJRQKQfbL0KJbEfFvzGb/9CAc9zTJPvWKmlqn5ruCouAQFyyl
dxpC/IfYKv7nMfybBxN5
=9Fax
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
