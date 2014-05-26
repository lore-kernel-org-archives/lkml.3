Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaEZNKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:10:00 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:35522 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaEZNJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:09:58 -0400
Date: Mon, 26 May 2014 15:07:26 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
Message-ID: <20140526130725.GA1594@ulmo>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
 <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
 <53725FED.7050303@wwwdotorg.org>
 <20140514142739.GA8612@ulmo>
 <20140514193518.19795.64334@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20140514193518.19795.64334@quantum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 12:35:18PM -0700, Mike Turquette wrote:
> Quoting Thierry Reding (2014-05-14 07:27:40)
[...]
> > As for shared clocks I'm only aware of one use-case, namely EMC scaling.
> > Using clocks for that doesn't seem like the best option to me. While it
> > can probably fix the immediate issue of choosing an appropriate
> > frequency for the EMC clock it isn't a complete solution for the problem
> > that we're trying to solve. From what I understand EMC scaling is one
> > part of ensuring quality of service. The current implementations of that
> > seems to abuse clocks (essentially one X.emc clock per X clock) to
> > signal the amount of memory bandwidth required by any given device. But
> > there are other parts to the puzzle. Latency allowance is one. The value
> > programmed to the latency allowance registers for example depends on the
> > EMC frequency.
> >=20
> > Has anyone ever looked into using a different framework to model all of
> > these requirements? PM QoS looks like it might fit, but if none of the
> > existing frameworks have what we need, perhaps something new can be
> > created.
>=20
> It has been discussed. Using a QoS throughput constraint could help
> scale frequency. But this deserves a wider discussion and starts to
> stray into both PM QoS territory and also into "should we have a DVFS
> framework" territory.

I've looked into this for a bit and it doesn't look like PM QoS is going
to be a good match after all. One of the issues I found was that PM QoS
deals with individual devices and there's no builtin way to collect the
requests from multiple devices to produce a global constraint. So if we
want to add something like that either the API would need to be extended
or it would need to be tacked on using the notifier mechanism and some
way of tracking (and filtering) the individual devices.

Looking at devfreq it seems to be the DVFS framework that you mentioned,
but from what I can tell it suffers from mostly the same problems. The
governor applies some frequency scaling policy to a single device and
does not allow multiple devices to register constraints against a single
(global) constraint so that the result can be accumulated.

For Tegra EMC scaling what we need is something more along the lines of
this: we have a resource (external memory) that is shared by multiple
devices in the system. Each of those devices requires a certain amount
of that resource (memory bandwidth). The resource driver will need to
accumulate all requests for the resource and apply the resulting
constraint so that all requests can be satisfied.

One solution I could imagine to make this work with PM QoS would be to
add the concept of a pm_qos_group to manage a set of pm_qos_requests,
but that will require a bunch of extra checks to make sure that requests
are of the correct type and so on. In other words it would still be
tacked on.

Adding the linux-pm mailing list for more visibility. Perhaps somebody
has some ideas on how to extend any of the existing frameworks to make
it work for Tegra's EMC scaling (or how to implement the requirements of
Tegra's EMC scaling within the existing frameworks).

Thierry

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTgzyNAAoJEN0jrNd/PrOhqn4QAJClN4TDk5AvQhE3QqZ9U+BW
V2/Qs4dICKGGroOsaVqLtk0SEu2uIJjqKPi4nsoRGxOtm4rCQHkyD5p4Rs1qFRX5
5LBKazX3mNeCpjbaTqprU7SYpd1bs+c9+S82M3Pe9SgrCpJDGpJNjKZgEvcqdWnV
sKmsvLxdhAvX5UKyWBDGMBppWwoRo3GiY7qnQ6iOmS7aMMgjbJ6tNcW8Ih0DrUBJ
iJBmK6NhPxa8b2prgBiLSiGApw5Qr9DobZ1MClNBYfWt1PfO0dudE0BqlX+vtN4B
rrxpF0ZQxgjcSMQlJR8FFUKg40J60+2wKgv7EWGrhv+zOkZxbAAfnjnkIyBaXEIh
ogK/RQugZIs36g+fI0dVnCwCOj8oe3ydWlVoz40uOqU8iqD8HuJWOiDij6sBQ9W0
Szz4cn9AzmE9WjuH+p1tyila3OC6tl4ox7vIr6pdyZIANXAUfQzC+AXuw6GZuAJK
cogGrgPPzlbvMC+nXzcp7u1SJSBSimIbIaW9VTFhIa7cZZcbMj6c08WUPu17+DWG
fAycae5C+M/nJ37BIRGlv1boJ7nx81BXI+s3DiD6sxMd3YIjK9fWclZz3kAaqbS4
NlFmoHZtSLFDjdaaC4v2zhmYotzCLQhhLfk0DgAmOtwuvT9Aip30qSQ+D2bx/N68
NuP5kVd0B6oIPaJg8HJV
=PQnT
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
