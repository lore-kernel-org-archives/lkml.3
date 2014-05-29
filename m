Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaE2VSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:18:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47016 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaE2VSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:18:39 -0400
Date: Thu, 29 May 2014 22:18:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Message-ID: <20140529211815.GP5099@sirena.org.uk>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1401211721-19712-4-git-send-email-bjorn.andersson@sonymobile.com>
 <20140528165529.GC5099@sirena.org.uk>
 <CAJAp7OgY-99jRqvBOPbkj=Nrt7vW=0Ae+Xvf3J7JrDS1eoigWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RtGa12sjXv8gVUZO"
Content-Disposition: inline
In-Reply-To: <CAJAp7OgY-99jRqvBOPbkj=Nrt7vW=0Ae+Xvf3J7JrDS1eoigWw@mail.gmail.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RtGa12sjXv8gVUZO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 29, 2014 at 02:03:40PM -0700, Bjorn Andersson wrote:

Please fix your mailer to word wrap at less than 80 columns so quoted
text is legible.

> The hardware in this case is a "pmic" shared by all cpus in the system, so when
> we set the voltage, state or load of a regulator we merely case a vote. For
> voltage and state this is not an issue, but for load the value that's
> interesting for the "pmic" is the sum of the votes; i.e. the sum of the loads
> from all systems on a single regulator.

> What the code does here is to follow the hack found at codeaurora, that upon
> get_optimum_mode we guess that the client will call get_optimum_mode followed
> my set_mode. We keep the track of what load was last requested and use that in
> our vote.

No, this is awful and there's no way in hell that stuff like this should
be implemented in a driver since there's clearly nothing at all hardware
specific about it.  The load tracking needs to be implemented in the
framework if it's going to be implemented, and passing it up through the
chain is obviously going to need some conversion and accounting for
hardware conversion losses which doesn't seem to be happening here.

I'm still unclear on what the summed current is going to be used for,
though...

> >> +     if (vreg->parts->ip.mask) {
> >> +             initdata->constraints.valid_ops_mask |= REGULATOR_CHANGE_DRMS;
> >> +             initdata->constraints.valid_ops_mask |= REGULATOR_CHANGE_MODE;
> >> +             initdata->constraints.valid_modes_mask |= REGULATOR_MODE_NORMAL;
> >> +             initdata->constraints.valid_modes_mask |= REGULATOR_MODE_IDLE;

> > No, this is just plain broken.  Constraints are set by the *board*, you
> > don't know if these settings are safe on any given board.

> I can see that these are coming from board files, but I didn't find any example
> of how these are supposed to be set when using DT only.

> What's happening here is that given what compatible you use, different "parts"
> will be selected and based on that this code will or will not be executed;
> hence this is defined by what compatible you're using.

> But this is of course not obvious, so unless I've missed something I can clean
> this up slightly and make the connection to compatible more obvious. Okay?

No, it's still just plain broken.  You've no idea if the settings you're
providing work or not on a given system (or set of drivers for that
matter) - mode configuration really is a part of the system integration
not an unchanging part of the PMIC.  This code appears to assume that
every client driver (plus passives) is going to accurately supply load
information which just isn't realistic except in very controlled cases
for a specific system.

The reason it's not supported in DT at the minute is that the definition
of modes is not at all clear in a generic fashion, plus of course the
fact that we have no users in mainline for dynamic mode setting.  Most
PMICs these days are smart enough to do this autonomously anyway so it's
not clear that this is something that it's worth spending time on.

Please look for the prior threads on this.

--RtGa12sjXv8gVUZO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTh6QUAAoJELSic+t+oim91QsP/A7+Rd2o0/RgjtqZ/kaC7tzb
cttNOdcvYwhIz3q+8X45Pz4AooMlp20RSwfWZoHs0doGSuoBCGWZXNZ0EpPKD2Tj
cZSBYNLqc33RXlTkX7EqbTXAArn6Ouwu0nUPqydAKcaHT0lTFwAxEM2UzaCRTOty
TJomy2kuP5JsV2qHMeTSdnbpRPFjp4ElFgztt4qxaMQcqeJmbavS7X+PnYrxThDI
SUdQdC6HZhWgldMyss0DYkWgBHhdrorl1yUutqMSWpt6+b/Sg8TBMbpqbZCIVgct
pG6ZFRqju5Ex36r9Kn+zWJcur+zPTH4siF/mMWl5y1i6jYWQuu0oYVTl8ggO6AQY
7QTgjn0oueTTUXB+f+CqheFdriD3bnMdii8oMnOjUOn3qSwZmYvgsqNrneDAEPVy
vy4L6yoUa+sop8q2I2ssroJmlwEHNEFSQ7cvEeMZKiDfnukHunsYevljX0mF8FAy
BdGL2rDc+2PmUOkqnk29ymY5u1qny2Lk7Kwdjsbnq8RgP21y+83fdXYyAHalMitN
IvnQi5XrsyL0Rl1aR6ig6YCXBl1Uj8Af9Z4wFRlUn7ianj1/qutZZKbeY6FAJ3DX
vNo4DOEC7d358htHXewXUx6N5ttliqVzBVU/p4yACvRiYigPlFkSRAvjOpfrAi6T
dhT8IeVzRDbIjJu6bzZv
=93kF
-----END PGP SIGNATURE-----

--RtGa12sjXv8gVUZO--
