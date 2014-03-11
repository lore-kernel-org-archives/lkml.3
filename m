Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaCKTuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:50:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39149 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaCKTuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:50:12 -0400
Date: Tue, 11 Mar 2014 19:49:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20140311194959.GB28112@sirena.org.uk>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
 <1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tdmc70C6TklGKgyg"
Content-Disposition: inline
In-Reply-To: <1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: add xtfpga SPI controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tdmc70C6TklGKgyg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 04:44:49PM +0400, Max Filippov wrote:

> +static inline int xtfpga_spi_wait_busy(struct xtfpga_spi *xspi)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(100);
> +	while (xtfpga_spi_read32(xspi, XTFPGA_SPI_BUSY)) {
> +		if (!time_before(jiffies, timeout))
> +			return -EBUSY;
> +		else
> +			cpu_relax();
> +	}
> +	return 0;
> +}

So we'll busy wait for up to 100ms - that seems like an awfully long
time.  Perhaps fall back to msleep() if the delay is non-trivial (or
just reduce the timeout)?  If there are large enough FIFOs dead
reckoning a sleep for the expected transfer time might be helpful but it
seems like there's no meaningful FIFO.

> +/* Unused: this device controls its only CS automatically,
> + * deactivating it after every 16 bit transfer completion.
> + */

This is too limited to use with most SPI clients, they'll want to be
able to transmit more than one word (and the fact that only 16 bit words
are supported is also an issue, though that's easy enough to handle for
a bitbanging driver - I'd really strongly suggest supporting 8 bits per
word as well).  Clients are pretty much going to need to use GPIO based
chip select, you should make sure that's supported and covered in the
binding.

> +static void xtfpga_spi_chipselect(struct spi_device *spi, int is_on)
> +{
> +}

Omit this since it's empty.

--Tdmc70C6TklGKgyg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH2jjAAoJELSic+t+oim95Y4P/3qAvXHC1Be5ufU34cmYeMwQ
1QULypLbsN0LPf67sySX2/RmzSdEnxzLIADD/zz33vjVAz2FZNtIdEuvUDfhPbcm
HJs64FQjLLrLcxQplN/ja9Fn4jnKpWoL+UB7OSBwqsZqVUhv1Yj8bUWTJYBJwhX/
+KSTtyvXzexWfKGbSSEfUbuTM/FXZ4RG2jLnxS2x4i/WeXkHI3g8zgTrtTUWJpvV
kNSByKs9jCLK4u649QiTmOJ/8WKokijHJB7i2IPZ1GPhU+vtIAL+PIxfYnz9QQU0
qFrxtVguPrHnABYDsovx81s3f0+IUKZECr0YzZEJ5tGgG+Qe1PWiaEmVrFCYu4bv
VFfXEOA5+Y2B6cJow576qsqi/qG6enlnDhocbV1FFq5NdhMSFSScp0pK9wp3KhaH
M5FLpdR8lw4/s5Nbt0SAFIF29Ul1KJrqZOjJvUww4kGHRLSBKUhoNJ6sYR+hkchj
S7ooqB8DyHIibfX0K+E+oabtKVg3b9b/gd6+Hp+d8Mk2bj/lo41ElrdDmLHL23u/
t7TcSmrRCyPWLtiFlTP9KcrBdgsiCy6Et7hFp0dvirjM0KicP6hsbGtrB6Aygs7u
LrumrLmdYfXQnKZCHywyhcrJj78LM3TZJDPEZiPE+09UXlpzkzv7mfH2qfC0GNUy
tCT9YEMBDhQvxIZo//fX
=dWNJ
-----END PGP SIGNATURE-----

--Tdmc70C6TklGKgyg--
