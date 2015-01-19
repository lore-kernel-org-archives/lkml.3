Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbbAST0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:26:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52820 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbAST0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:26:12 -0500
Date: Mon, 19 Jan 2015 19:25:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20150119192557.GI2809@sirena.org.uk>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
 <1421419194-1849-2-git-send-email-p.osmialowsk@samsung.com>
 <20150116162314.GB3856@sirena.org.uk>
 <alpine.DEB.2.10.1501161811280.21618@AMDC1262.digital.local>
 <20150116183635.GH3856@sirena.org.uk>
 <alpine.DEB.2.10.1501191031080.13777@AMDC1262.digital.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7IgncvKP0CVPV/ZZ"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1501191031080.13777@AMDC1262.digital.local>
X-Cookie: MERYL STREEP is my obstetrician!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 2/3] regmap: Use the enhancement of i2c API to address
 circular dependency problem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7IgncvKP0CVPV/ZZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 19, 2015 at 10:31:22AM +0100, Paul Osmialowski wrote:
> On Fri, 16 Jan 2015, Mark Brown wrote:

> >What I'm saying is that I want to understand this change from a point of
> >view that isn't tied to I2C - at the regmap level what is this doing,

> From the regmap point of view, it allows its functions to have a chance to
> prepare transfer medium for (synchronous) transfer (no matter what bus
> handles it) before it actually start to happen (then unprepare it when it's
> done) and crucially before any lock is obtained in functions like
> regmap_write(), regmap_read() or regmap_update_bits.

OK, so that's what should go in the changelog (along with an explanation
of why this preparation is required at all) - but I still don't see the
async bit of this I'm afraid.

> Maybe adding a pair of callbacks (map->reg_write_sync_prepared(),
> map->reg_read_sync_prepared()) would make situation clearer.

No, I don't think so - it'd just complicate the callers.

> >I2C is a bus that has some properties which you're saying needs some
> >changes, what are those properties and those changes?

> I'm not saying I2C as a bus requires changes. What I'm saying is that I2C
> API can be extended to allow more detailed control on what happens with the
> transfer.

My point here is that your explanation is in terms of I2C specifics and
not really at a generic regmap level.

> >Can you be more specific please?  If something needs preparing it seems
> >like it'd need preparing over an async transaction just as much as over
> >a synchronous one.

> Even with those preparation and unpreparation stages, this transfer is still
> synchronous. For example, it starts when regmap_read() starts and ends when
> regmap_read() ends. Nothing is queued or deferred. Namely, when
> max_gen_clk_unprepare() function calls regmap_update_bits() it expects that
> when regmap_update_bits() returned, no outstanding transfer are happening
> nor waiting to proceed. Everything must be completed before returning to
> max_gen_clk_unprepare().

That doesn't address my question - all you're saying is that in a
synchronous call path things are synchronous which is fine but obviously
regmap supports async I/O too.

> >Not in this pattern where the caller needs to check too.

> I don't persist on that. Apparently, you're the author of this file, though
> regmap_init() function was later expanded by other guys. They never assigned
> bus callback function pointers directly to map operation callbacks. It is
> possible to replace 'map->reg_prepare_sync_io = regmap_bus_prepare_sync_io'
> with 'map->reg_prepare_sync_io = map->bus->prepare_sync_io' - this will
> compile and this will work properly. But IMHO it wouldn't match with what
> the others did.

If you look at the other callbacks they're doing other things beyond
simply forwarding the functions on.  That's the problem here, the
functions just add a layer of indirection and nothing else.

--7IgncvKP0CVPV/ZZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUvVpFAAoJECTWi3JdVIfQ6NIH/0425/3zjySHkW9YBh834jXA
nw0QdjmOho7GTprP9b2F028GlgR4YxoMWp5XT4Nf13q35PdhKoIA7bxaeiJxMyqj
jL9C350dvBLXbjvWpQa9lEOim7DWW/r3SM5AO0c6Qw0uCDkaIuZe3oaFOmRrNdGa
pL3Q5PZ8Nv8oBG296V79lFZeD7T+gcCozxZdRw/Ay9/DHgvl7Dn60GWzlqmLJysm
iGHn5hbtA1xq9XCTwXd/NUDQNUjWzv6oPlshA3zl4Lrm/Zp3wVUhdFZycC0K4mok
pUG0xL92DgWfwonuiUC65WrTY78UpbDw4lV/SEpr0TK4gJtWgYdQFr43FGZxc3g=
=6/ek
-----END PGP SIGNATURE-----

--7IgncvKP0CVPV/ZZ--
