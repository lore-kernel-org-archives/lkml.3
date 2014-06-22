Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaFVLNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:13:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53437 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaFVLNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:13:02 -0400
Date: Sun, 22 Jun 2014 12:12:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Yi Zhang <yizhang.mrvl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yi Zhang <yizhang@marvell.com>,
        zhangwm@marvell.com, shayp@marvell.com, zhouqiao@marvell.com
Message-ID: <20140622111244.GU24291@sirena.org.uk>
References: <CAK=oMXftjqjoM2gCrgyc+YkznCOz-V=McEx74xPbxZ2O-UFmFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tn/+KOyBVBGpvvUM"
Content-Disposition: inline
In-Reply-To: <CAK=oMXftjqjoM2gCrgyc+YkznCOz-V=McEx74xPbxZ2O-UFmFQ@mail.gmail.com>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Question] is it a race condition in acking PMIC sub-interrupt?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tn/+KOyBVBGpvvUM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 19, 2014 at 08:34:12PM +0800, Yi Zhang wrote:

> 2)  there are several interrupt ack registers in PMIC; in
> regmap_irq_thread(), we acked them one by one; but if before we finish
> acking all the registers, another interrupt on the "has-been-acked
> register" is triggered, the interrupt line will be pulled up or down,
> in the 1) case, because GPIO is edge triggered, it cannot "see" this
> interrupt, then GIC cannot know either; while in regmap_irq_thread(),
> the software thinks it has acked all the interrupt, then goes on; but
> actually the interrupt is missed and cannot be resumed in the 1)
> scenario;

You really shouldn't be using an edge triggered interrupt controller in
an application like this.

> So if this is true, what about using the following methods to fix it?
> a) disable all the interrupts just before ack, then enable them after
> ack finished; the cons are a) the interrupt is ignored in the process;
> b) we need to manipulate the registers more frequently, after all, I2C
> is a slow bus;
> b) polling until the interrupts are acked; but I think it's hard to
> guarantee that because the interrupt is asynchronous;

Right.  If the edge triggered controller is getting a level triggered
signal (which sounds like the case) then what you can probably do here
is wrap the main interrupt loop with code that checks the state of the
GPIO directly and re-calls the interrupt if it's still asserted when the
interrupt finishes.  wm8994 has some workaround code for a situation
that sounds very like yours.  If it's just getting a pulse you're in
trouble here and you have to poll but like you say it's hard to
guarantee.

> and one more question:
> Seems we shouldn't connect an interrupt controller as PMIC with an
> edge triggered interrupt controller? Could you please share your
> opinion? we can modify the hardware connection accordingly;

That's definitely the best option, muxing multiple interrupts is much
simpler and more reliable when everything is level triggered.

--tn/+KOyBVBGpvvUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpropAAoJELSic+t+oim9EzIP/2qlptPhNrP0hZGRiLENvfh5
FsQw79OllsGgklXh8mMb059APWSmpev2ZZ6BMDMNVQSVdtOYhKKOSXahKvlE3j21
+vZ16HXlHAc605rf3EtDYtNSlz6vcEHVWIjt2Qt0HcftLiNpYlKnEupKMkN+O2MX
CXBshSXV6+frP61qRrauL0N+jTq5ZS83VcGqCDCde5SSMBInjT9+D9Fg+1yd0pYu
YXXhS3C9K0wy23gjwYUHS/yfwgmFvr5EZa34fGSditfNIiCWC/MyS8MeJeDdnGOD
8aiGFQQhWPgXej36szJXgvzO4YMBd8MzQ17RLtjA8v8rY673S4c6ta+Vwo6b0b8M
T2TpsbaNj1F8A0735u1/PmP9OXEnWz8qkqIvHWD7RI6Tc5BCCCHPlD4ixEFEFib6
ybshpSFYwDdVan7FEbe3lZI9o1k+PpiPmhOMl/8/UERwlN5xIwwrcYSn8Mb4bGOo
UuVMSTNPsViRPo3fI0sX+J5gEc8TjSYmHsORUbwnaqKNZCUZQEdQuos6uRaYpuxf
LwCKOd6FAsiQSyJGj0HRvx/8c73JDVoRZzdtPQyUGbK1/JjPT25C3M+C4LCCx1KU
YIXn42BEr/lpDGPVF46TSX5NHZ2r8p1wbFF80KzzI29cneBm7tqgCxgC+uTMj0m5
4n3wAxQuVbkW1hX+bfLx
=edaD
-----END PGP SIGNATURE-----

--tn/+KOyBVBGpvvUM--
