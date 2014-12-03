Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaLCPtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:49:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43899 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLCPtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:49:39 -0500
Date: Wed, 3 Dec 2014 09:49:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Kevin Hilman <khilman@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about patch "i2c: omap: resize fifos before each
 message"
Message-ID: <20141203154936.GF16138@saruman>
Reply-To: <balbi@ti.com>
References: <A20987D6-DEEC-488D-9655-36A4D186599B@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HB4mHL4PVvkpZAgW"
Content-Disposition: inline
In-Reply-To: <A20987D6-DEEC-488D-9655-36A4D186599B@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HB4mHL4PVvkpZAgW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 03, 2014 at 06:11:18PM +0300, Alexander Kochetkov wrote:
> Felipe,
>=20
> Question about the patch[1].
>=20
> I want to change the code in a way to not touch fifo thresholds for
> each message.  Because:
>
> 1. dev->threshold is valid only with checking of transfer direction.
> So, if last transfer was transmission and ISR get RRDY interrupt from
> slave receiver, then dev->threshold is invalid. We must read threshold
> value from BUF register, to process correctly.

What I noticed, however, is that threshold value from BUF wasn't very
reliable. My memory is now really fuzzy, but when I talked to the person
who maintained this IP RTL inside TI, there were some "interesting"
requirements wrt when BUF's threshold was valid and I had a hard time
ensuring that access time.

> 2. I want to avoid changing fifos before message submission, because
> IP can start receiving message in a slave mode (race).

I2C is not full-duplex. There's no way it will receive any data while
you're transmitting, right ?

> 3. dev->threshold is changed in range 1-fifo_size/2. So instead of RDR
> we get RRDY and for messages larger then fifo_size/2 we still get RRDY
> and RDR.

we will only get RDR if message_size % threshold > 0. If we have a 16
byte transfer and we program threshold to 8 bytes, we will get two RRDY
IRQs.

> Felipe, do you have in mind why do you want to avoid RDR and XDR events?
> Something about errata?

nothing about errata. As the commit log say (or tried to say), if the
entire message fits into the FIFO we save one interrupt. It's a
micro-optimization.

> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commi=
t/drivers/i2c/busses/i2c-omap.c?id=3Ddd74548ddece4b9d68e5528287a272fa552c81=
d0

--=20
balbi

--HB4mHL4PVvkpZAgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfzEQAAoJEIaOsuA1yqREsfkP/izCmgPzNtetgaQ+Iya813um
sV/GWUpISdkB3vxHJGZw92WhgdWtOQsFwV6Ed2YGqUPJiOyJFvqlJ4phh8QY6iXz
Boj1pwlbEfNKLsNTag+kmAb51w4h9+lYI+0TgiCCICcU4NUFtefns+FwP5gn83d0
B9yjbH5vv/hJzL8C+2h9jwG8pTB/hqkAxiN2Py7MWqF6YW53hIwxH3MTWb2ROfZO
QdQ2pHosIqo/di2RKwYJeXKiN93okS/EjVpcqsAf9Wdh7Hrj3T1afd6VJ0OUCJTb
UqAh6jUmKs7DqaB3uBr7iB7ZH4su15IOTd6pt3XwipoQ6m6yLMQV+fIf0F2mKXYb
EIR28biRYBmsLBlb6Io03U6o2e7zi+atq/hDVrlTY/LPg7RmRqEg90hECMVohhTw
0A7sZD6SwSLO+Mqs5A+acFNXy8OILAt+It4HK8+YQ0x5vrza9mtmwMNag6CpOfJW
OQSQQKoPLIKFxKfSvnMei3AP831YJhAgMD5YW9b4eZ5ypAfd3FwXMKsdjv6qPmAf
nGRvvJwBM1vQUwf0SYE1vMipBXIdPTwbI1wT1vjkuo3op4G2pbWl3zv8mcSifgxs
gslQzrNg+i0HPQ4LahWq5pKzUWWKsd14udP3SAluoVhnQF0sFWxlvbac1IRbah7+
BHcu5RWphXFxHUgZ1cB4
=ikW7
-----END PGP SIGNATURE-----

--HB4mHL4PVvkpZAgW--
