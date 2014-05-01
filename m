Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbaEAQJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:09:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54034 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaEAQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:09:39 -0400
Date: Thu, 1 May 2014 09:09:21 -0700
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140501160921.GB3245@sirena.org.uk>
References: <1398932115-11646-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XoSOsMJQ8mz74oyx"
Content-Disposition: inline
In-Reply-To: <1398932115-11646-1-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Fix hung task timeout when initialization fails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XoSOsMJQ8mz74oyx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2014 at 10:15:15AM +0200, Ricardo Ribalda Delgado wrote:

> If kthread_run on spi_init_queue() fails, spi_destroy_queue can lead to
> hang timeout.

...

> When this happens, spi_destroy_queue() leads to a hung process that
> outputs a error message and avoids the computer to be halted/rebooted.

Why is the fix for this not to avoid running spi_destroy_queue() in the
first place?  I would not in general expect it to be robust to call the
destructor function if the init function failed (and indeed this looks
like what's happening with the kthread code here) - even if it works now
it seems like it will be a source of bugs in the future.

> -	flush_kthread_worker(&master->kworker);
> -	kthread_stop(master->kworker_task);
> +	if (!IS_ERR(master->kworker_task)) {
> +		flush_kthread_worker(&master->kworker);
> +		kthread_stop(master->kworker_task);
> +	}

This still just looks like a race condition.

--XoSOsMJQ8mz74oyx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYnGuAAoJELSic+t+oim9FZoQAI2KyjLFaH8IBaptkuI/EK6s
/wr/8FyjEe+igVVnrGlZPNuJ92aJlKqOck/KaQocDfS+5CigXLwsgDUSi7R2tjXl
OjXCdbgzlQyQDJHTxk9v4UNHAZEeH0MVq9znvAag4f2/xj2Tws8I3hcovvJ3Iev7
pIAHWrBTvxQW6+fM2nh8BdbwpM63KC36EiovOItDXT/2Iurk6WFbnK9s1WdfFTyb
T0RUSyrXGiknRqB9deeYyPSMJHdlHIIIaeH/thoYtoWrUpJ+fJrFUZpAHHKbSEwb
ruBFrSucVdrCMVV5+tVI+6YtpZyvfYnB0zNdZw6q6BXL2M9DvjGYUR3Ulz+cPrKh
jVqNVEZzDlba06YwfxWmXweEdJZNC/d8Yte3KTFyXsOIlnCvuOgM+qlxEOgOQDl8
dJnhRJqZDAQ8bDCGguvpzEkHkTYvGBpxXL8dZnNRnPacfNE8bIJDX2vNQVjeLAw5
txO3nU1uX4HWqctepx9LtD6CZlkl2yRgMaUUnIws7IrTske2jq3lneCwjqpyuA3K
X+y9MbvpwIRmXYwTs0kwwK3LybZzoAN4QVA4MfV9cgzgHZyDaZ/wT6LXHOsZtVFh
v+RZ/aedV+33zlcUPn/+tRDEq3gJHHeRro+sYNs2MdbUVGX5pVklib3zdEWlzPtr
uqvNj/78mOfP9k9/h/yF
=FuJj
-----END PGP SIGNATURE-----

--XoSOsMJQ8mz74oyx--
