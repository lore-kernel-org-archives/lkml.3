Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaAHNWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:22:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48715 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbaAHNWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:22:01 -0500
Date: Wed, 8 Jan 2014 13:21:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, richard.genoud@gmail.com,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140108132147.GF31886@sirena.org.uk>
References: <1389160188-4030-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tpk2fHXvUN/GnVDH"
Content-Disposition: inline
In-Reply-To: <1389160188-4030-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: atmel: Refactor spi-atmel to use SPI framework queue
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tpk2fHXvUN/GnVDH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 08, 2014 at 01:49:48PM +0800, Wenyou Yang wrote:

> The patch is based on for-next branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git

Sorry, there was a patch from Richard which got applied but not pushed
out - I've pushed it now but it conflicts with this.  Can you please
rebase?  It should be a simple update from the looks of things.

> -		tasklet_schedule(&as->tasklet);
> +		atmel_spi_lock(as);
> +		complete(&as->xfer_completion);
> +		atmel_spi_unlock(as);

Why do you need to hold the lock to complete the transfer?  That seems
very odd.

> +	/*
> +	 * DMA map early, for performance (empties dcache ASAP) and
> +	 * better fault reporting.
> +	 */
> +	if ((!msg->is_dma_mapped)
> +		&& (atmel_spi_use_dma(as, xfer)	|| as->use_pdc)) {
> +		if (atmel_spi_dma_map_xfer(as, xfer) < 0)
> +			return -ENOMEM;
> +	}

Just a heads up at this point but this is most likely going to be moved
into the core soon.

> +	if (xfer->delay_usecs)
> +		udelay(xfer->delay_usecs);

If you convert to transfer_one() instead of transfer_one_message() then
this will be handled for you.  What you're doing at the minute is still
an improvement so it should be OK but it'd be worth a look.  There will
be further changes in this to factor out the DMA and message push code.

> +	if (xfer->cs_change) {
> +		cs_deactivate(as, msg->spi);
> +		udelay(1);
> +		cs_activate(as, msg->spi);
> +	}

This is buggy, cs_change should flip the polarity of /CS rather than
bounce it on and off except if set on the last transfer in a message in
which case it should cause /CS to remain asserted after the message is
finished.  Again, transfer_one() factors this out - you can at least
look at this to see what should be done.

> +	if (as->stopping)
> +		return -ESHUTDOWN;

You shouldn't need to worry about this, the core should handle this.

--Tpk2fHXvUN/GnVDH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzVDoAAoJELSic+t+oim9e6QQAJeAZCShweZDAhVWO6bGXQP6
1fwxE4++Zd+puAMvO042zMLwmYwXHNo3IAV4Z4H8UZNVRn98F9+M2IW9Jvc9vFQr
avgrK+CVE92NNmSatnyYwdAjoeokRpBtvBpns/XduFfwhoVjiOFKmsk7c56wBNOP
aFzoxkJl/ql4iaZRjFew4MAXaBDdjqURnzlxf7WQVrzd8YVsYY7/6qqm5kD6t8Do
kUc9xnDm6e9TwQrFBBjyDDjgGShlO4ajq4r/b+EFutwg++FQNMynnlD2fGAEY6Gv
+7/ze/ZsE9CmUVpEZd5ebF6HwvWPKaGoHUEsUhShxbULyObDM5S9x5niHoBL+P+o
y6fK5MP7y3Gu/xFQqfU4LgePnVwGmFIEJ33ankvs3KfUvKYNo/A4Nl/rcntbBKWr
443JNvi4vbrIRANbeZrotlKqWWWJ0Fnp9TBOUXsAa3EQ73VrmhTI38Xv1tImhGjm
olERKF/MLD91SZhlp7a3DNuv/rQS98iXVYF16nO7FxlMn5gfHzaw07PFpWEmJwAs
LI0fxNGLZ+rSfYudHdlxG8Q67IE5QPJw8y6xFuoCiEaCpkZFEvt5fFipHGoNVxAs
PjO1WWZKvMsgwf/ITX6X5HI8xD/VWa0jW4afxq+LqjNav11qqmpAnaVl55rrNp8d
+OMOFpauKekLtOQkHNzB
=Zig6
-----END PGP SIGNATURE-----

--Tpk2fHXvUN/GnVDH--
