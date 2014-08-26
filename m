Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbaHZJIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:08:19 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:65313 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934214AbaHZJIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:08:16 -0400
Date: Tue, 26 Aug 2014 11:08:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Message-ID: <20140826090810.GH17263@ulmo>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
 <3804028.YQzQ4uAVsf@wuerfel>
 <20140826075023.GB17263@ulmo>
 <6589717.GOLq1GlTCJ@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xzXx3ruJf7hsAzo"
Content-Disposition: inline
In-Reply-To: <6589717.GOLq1GlTCJ@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2xzXx3ruJf7hsAzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 10:09:25AM +0200, Arnd Bergmann wrote:
> On Tuesday 26 August 2014 09:50:25 Thierry Reding wrote:
> > On Tue, Aug 26, 2014 at 09:43:50AM +0200, Arnd Bergmann wrote:
> > > On Tuesday 26 August 2014 08:57:31 Thierry Reding wrote:
> > > > On Mon, Aug 25, 2014 at 01:01:52PM -0600, Stephen Warren wrote:
> > > > > On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
> > > > [...]
> > > > > >+static int tegra_xusb_mbox_probe(struct platform_device *pdev)
> > > > >=20
> > > > > >+    res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > > >+    if (!res)
> > > > > >+            return -ENODEV;
> > > > >=20
> > > > > Should devm_request_mem_region() be called here to claim the regi=
on?
> > > > >=20
> > > > > >+    mbox->regs =3D devm_ioremap_nocache(&pdev->dev, res->start,
> > > > > >+                                      resource_size(res));
> > > > > >+    if (!mbox->regs)
> > > > > >+            return -ENOMEM;
> > > > >=20
> > > > > Is _nocache required? I don't see other drivers using it. I assum=
e there's
> > > > > nothing special about the mbox registers.
> > > >=20
> > > > Most drivers should be using devm_ioremap_resource() which will use=
 the
> > > > _nocache variant of devm_ioremap() when appropriate. Usually the re=
gion
> > > > will not be marked cacheable (IORESOURCE_CACHEABLE) and therefore be
> > > > remapped uncached.
> > > >=20
> > >=20
> > > Note that ioremap() and ioremap_nocache() are the same. We really sho=
uldn't
> > > ever call ioremap_nocache().
> >=20
> > Perhaps we should remove ioremap_nocache() in that case. Or ioremap(),
> > really, and keep only those variants that do what they claim to do.
>=20
> That would be good, but there are many instances of either one:
>=20
> arnd@wuerfel:/git/arm-soc$ git grep -w ioremap | wc
>    2156   13402  183732
> arnd@wuerfel:/git/arm-soc$ git grep -w ioremap_nocache | wc
>     485    2529   42955

Ugh... nothing that I currently have time for. Perhaps this is a good
one for the Janitors? I'm not sure if the kernelnewbies.org TODO list is
still frequented since many pages seem to be very old. Is there some
other place where I could add this?

> > > devm_ioremap_resource() and pci_iomap() checking for IORESOURCE_CACHE=
ABLE is
> > > rather silly, since it doesn't call ioremap_cache() in that case.
> >=20
> > Then that should be fixed.
>=20
> Yes. I'd suggest we just ignore that flag and always call ioremap here.
>=20
> When I checked this before, IORESOURCE_CACHEABLE only ever gets set for
> PCI ROM BARs, which we don't map into the kernel.

There's still a few users of ioremap_cache() around and they are
potential candidates for a conversion to devm_ioremap_resource(), so I
think it'd still make sense to keep the check.

Thierry

--2xzXx3ruJf7hsAzo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/E56AAoJEN0jrNd/PrOhjjsP/iihISc+TdGfwZRYLSx4hvsW
H2FTvyclQhdflRRHfiTNsCAzLS5DUIFunukZN2TCS/bYh9qauZ41CziSSJY78Q8K
9RJq8cdQINSVw4rf/BTfG+4vgTH7Nq2/woM4CTkLLXwjsp1YqG1+72OfH/kejb+x
4LGVqS2IL/A9NCsUFGu/xK9VK2cUW56V8VkRNsSsEDy//y5kJJcmVI4h8NZrIhwc
TtCase4zWThwNtc51SiODnX+z25sO5u4DDe+dX2fM3nGoBAwr3wu/dhv28grdxuJ
dDtilpVHJr5S+FccS+e+t836nYvewvbJizOmaUOUzWKYZhC9XYvPIAmsj9nN0aUW
/uatfJ/i47oRQWFqhCCkw9qME21dIW9qHfr4yW5qG8S6dnL5vL6TWSD5AUNePggE
B0MOaWYyOg0qtHY4Y/7nPrUHiSQIlwTVRcHgLE3zFmE1qEnwFjUcOcaeWMLz3DSQ
QznztJ8tVhDGvrL9eWdCVWR01uqRV5rm4cHX6E+zA04scBPE9EMEDhvRTURSXPKI
vj+DiW5aToCd0RFlgYpjT6Cpw5ZLyv0uB7MdJNDrST6SaKx9tKFqL25Q0v17AKpp
yWwI8Zlh1Ww5zziWp8bHhMVbxuhbXrKzh7r4ym4wYchK72IE5bIRx4eOU9vWuclE
Js9S1OJpXwnWULHvNU5C
=2Kba
-----END PGP SIGNATURE-----

--2xzXx3ruJf7hsAzo--
