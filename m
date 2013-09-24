Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3IXS23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:28:29 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64782 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3IXS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:28:26 -0400
Date: Tue, 24 Sep 2013 20:28:21 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/9] irqdomain: Introduce __irq_create_mapping()
Message-ID: <20130924182820.GA9911@mithrandir>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-3-git-send-email-treding@nvidia.com>
 <CACRpkdYo8knzZ+Z-tc7fyEGwX5bt4RvMU3TR3k3UrOj0KRJocw@mail.gmail.com>
 <20130923202935.GA5216@ulmo>
 <CACRpkdZMM9RUkRCWG0mYbF9PL-fOdDncpY05xG3F5BF55hn5ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <CACRpkdZMM9RUkRCWG0mYbF9PL-fOdDncpY05xG3F5BF55hn5ug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2013 at 02:20:44PM +0200, Linus Walleij wrote:
> On Mon, Sep 23, 2013 at 10:29 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Mon, Sep 23, 2013 at 09:14:30PM +0200, Linus Walleij wrote:
>=20
> >> I think it is better to first go over the call sites and make them
> >> all handle negative return numbers rather than pushing the
> >> obscure __interface.
> (...)
> >
> > Well, the problem is that the current patch changes the signature of the
> > function as well, therefore the call sites will have to be updated all
> > at once in a single patch to avoid build breakage.
>=20
> Hm yeah OK I see the problem, but can we atleast avoid the
> __thing? Like calling the new function irq_create_mapping_strict()
> or whatever.

_strict sort of implies that it does something more than the non-strict
irq_create_mapping() while it really doesn't. Perhaps the alternative
proposed below would indeed be a better solution.

> > Another alternative could be to change the signature in a way that does
> > not break compatibility. For instance I think it could work out if we
> > change this function to return int instead of unsigned int but keep the
> > same semantics to begin with (return 0 on failure). Then update all call
> > sites to handle potential negative errors and after that return negative
> > error codes.
>=20
> Hm that sounds like an attractive solution to me actually.

The only thing we'd loose is the additional bit, but given that most (if
not all) platforms that use DT are 32-bit (do we actually support any
platforms that don't have 32-bit integers?) that should not matter at
all. We're not very likely to get anywhere near that number of
interrupts in the system.

> > That still wouldn't catch any callers introduced between
> > the patch creation and application.
>=20
> Such things happen all the time, just have to be attentive in
> what goes into linux-next...

Given that linux-next might not be with us for much longer before the
3.12 release, I'm thinking of deferring the series until then. Or at
least trying to get it merged. Otherwise we'll probably have to deal
with a lot of fall out during the merge window.

In any case, it'd be nice to get some feedback on the general idea of
the patch series from other people involved. I'd hate to do all the
conversions just to have it NAKed at the last minute.

> Another minor thing:
>=20
> +static int __irq_create_mapping(struct irq_domain *domain,
> +                               irq_hw_number_t hwirq, unsigned int *virq=
p)
>=20
> Unless you can make a very good case for why there should
> be a "v" in the beginning of virqp, then remove it and call it
> "irqp" simply.
>=20
> All Linux IRQs are virtual and we're already clearly separating
> out those that are not by calling them "hwirq".

Yeah, I was just trying to adapt to what was already there. But with the
alternative proposal that'll go away anyway.

Thierry

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQdnEAAoJEN0jrNd/PrOhJn8P/3TBPXWjbLi5m7KaRXlga4UE
K3Ny6iA37CXlF+yLzqlpZz6UvKJvvTqXwv0Vt/nwMHvZ+/hnyWefdxDeAnGioz9Q
Xv35ArYyVpnXDLidl34Cer+KodQyfq9bNfBynn69ioEzSu3pa1iCzMsufoc7qYv2
iQoOFbSFHDIO7kWiX8IWnrObr7HWg6+64Za4tPQm+9tH2wHs3p5rG5QzY/qPtBUX
UqqE9WiC6olA8ANasEpO/LeP3+73vFF57q45dI2tTrrPYej5Ea/n87CIPGY4mj4P
MsqS1XwBXZR8hHP+kL6DruxTC3lXW5xs3xVW7Qp5ErazD7I5DAz7V35FqR70rlE6
LaCxaiwjGL3dMVVbH/3rExquKzLcp5Qb+9pguqz4hnZ2rDPEswLEZwJxRfhxN4hj
0l7NFVN2AfSD7RHdujXo5cqv6N/PHq/IbBX/ZGMqfj63E8oyong/d+Ejf34SWjID
qJmWcaPvxOq6/Wn5RYiPAf1ukqDQXQJPfOeMYhfMZCq5dwufxeI6kqHaUn5ngQ95
3Mad+lpjP2zvWsDCyevKJvZT6xOmiKDH8hoi9mk0t3YmLtQsPGU0M2wKpKhaxEkE
5RDuwDO2NnwIohRiNhBV5etxQ8DX+6AfOd6scZ0hJymX0sjgeTla5EWCXXaMKinZ
2h9exIOdxzKJAO1B8A+O
=0ZXR
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
