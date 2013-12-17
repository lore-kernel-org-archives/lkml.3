Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3LQNAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:00:15 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34332 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3LQNAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:00:11 -0500
Date: Tue, 17 Dec 2013 13:00:07 +0000
From: Mark Brown <broonie@kernel.org>
To: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131217130007.GZ3185@sirena.org.uk>
References: <1387228827-933-1-git-send-email-b20788@freescale.com>
 <20131216185753.GN3185@sirena.org.uk>
 <c9e35710598c4a66823e67fd4f81c0d7@BY2PR03MB315.namprd03.prod.outlook.com>
 <20131217122923.GT3185@sirena.org.uk>
 <A9C48E12-97A7-4A66-98EB-BA7BC23F27B3@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AMgu92tiTAjHNJcM"
Content-Disposition: inline
In-Reply-To: <A9C48E12-97A7-4A66-98EB-BA7BC23F27B3@freescale.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: anatop: add is_enabled interface
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AMgu92tiTAjHNJcM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 12:38:33PM +0000, Anson.Huang@freescale.com wrote:

> > better to add the error checking there wouldn't it?

> Okay, than what about other functions? there is such condition check
> there is other functions too, that is why I add it here. if you think
> it is no necessary, I will remove this check in my patch?

It shouldn't be in the other functions either.

> > This sounds like you need to have some higher level synchronisation
> > between whatever is managing this supply and your cpufreq driver - if
> > you rely on reading back the current status from the hardware there will
> > always be races between reading the state and the other thing doing the
> > enable or disable.

> yes, you are right. but I think we have handled that, all the
> operations of this LDO will via regulator interface, and regulator
> framework already has mutex lock. so there should be no such race in
> kernel as long as we all use regulator interface to access anatop LDO.

No, that's not going to work.  Consider this sequence:

	cpufreq		other driver
			disable()
	is_enabled()
			enable()

The locking the regulator core does won't help you here, nothing stops
the state of the regulator changing after it's read.  Your cpufreq
driver should just change the voltage and not worry if the regulator is
enabled, the voltage change won't have any effect while the regulator is
off and presumably if it does get enabled then it needs to be enabled at
whatever voltage cpufreq set anyway.

In any case I'd be much happier with this patch if it implemented the
enable and disable operations as well.

--AMgu92tiTAjHNJcM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsErUAAoJELSic+t+oim94Z4QAJfq0Hnrt1sVDNxJKOlh87vC
aJa/4HHE4yDmEI0klo3gBme+H1LXYhispir502UyyDCF+wySwH8BOtUZ7QG8k85i
3z7k6ZZ+6MoTF1eiWHsTwvWFoYv6E22q2ODVqNwWnLKbpcMMY6DmYeuUS6UNx3/5
loP2lktb0P5TG1Qy0ft21l1PmxPZaNaanz/eskvERO8L/VMTO4KLkqs7RozxedLQ
WR2qrdxcJSin1MOOaTZ4ifSigHFptAEojkoXA5p18PcD9lIa7sC69EWg6M8WTnYO
ad3FRe/5+hytBTvqF8ds7e3rQpyJUD7R/L4xWJaKpaOUi7BZmYtgQTAqTZblE5n1
EPrrmTUa9vUHXBw1J/EiS8Qn5mhjhYY+PtjmxSE8s/DPCi7whYcy6tmpk2qSxkC/
z5AjfiOjThBcYXgTL6nsxLfa8YP7sq3AqzE6CQ3YvVUb98lsEebH8S2Uw/4dJje/
c0gFpXfXOl5wJyNvKgETeYwWOrzonlf4XTCM/cxqSdj5OiRdll7DDinFnApOEPsP
yW1W5qXm6oz0Kjv6PoBwbiFsgqFQm0mHZkUZ0sj9KiVQj0Ua2+szNSNxNJy97X/Y
onlNrKxmDT471xizmnor09hUmeyBD7G0wYfQRLjWqjHo0AnQTYAT/4bTfnn40sep
CcMqJA5NKCAjGSNgiTWb
=3qpD
-----END PGP SIGNATURE-----

--AMgu92tiTAjHNJcM--
