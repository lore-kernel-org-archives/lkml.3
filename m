Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaB0TBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:01:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51858 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaB0TBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:01:09 -0500
Date: Thu, 27 Feb 2014 12:59:08 -0600
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [RFC PATCH 1/6] PM / Voltagedomain: Add generic clk notifier
 handler for regulator based dynamic voltage scaling
Message-ID: <20140227185907.GA4862@saruman.home>
Reply-To: <balbi@ti.com>
References: <1392755543-28335-1-git-send-email-nm@ti.com>
 <1392755543-28335-2-git-send-email-nm@ti.com>
 <20140225055142.22529.21814@quantum>
 <530D0394.4020208@ti.com>
 <20140227023455.GA15712@kahuna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20140227023455.GA15712@kahuna>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 26, 2014 at 08:34:55PM -0600, Nishanth Menon wrote:
> On 14:56-20140225, Nishanth Menon wrote:
> > On 02/24/2014 11:51 PM, Mike Turquette wrote:
> > > Quoting Nishanth Menon (2014-02-18 12:32:18)
> [...]
> > > I'm not sure about trying to capture the "voltdm" as a core concept. =
It
> > > feels a bit unwieldy to me.
> >=20
> > Considering it is a simple collation of regulators and SoC specific
> > "magic" which have to be operated in tandem to clock operation, Why
> > does it seem unwieldy? Usage of multiple voltage planes in a single
> > voltage domain concept does not seem unique to TI processors either:
> > For example, imx6q-cpufreq.c uses 3 regulators (arm, pu, soc),
> > s5pv210-cpufreq.c uses two regulators (vddarm, vddint), ideally OMAP
> > implementation would use two (vdd_mpu, vbb_mpu).
> >=20
> > > I have wondered about making an abstract
> > > "performance domain" which is the dvfs analogue to generic power
> > > domains. This a reasonable split since gpd are good for idle power
> > > savings (e.g. clock gate, power gate, sleep state, etc) and "perf
> > > domains" would be good for active power savings (dvfs).
> > >=20
> > > Having a generic container for performance domains might make a good
> > > place to stuff all of this glue logic that we keep running into (e.g.
> > > CPU and GPU max frequencies that are related), and it might make anot=
her
> > > nice knob for the thermal folks to use.
> >=20
> > This sounds like one level higher abstraction that we are speaking of
> > here? I was'nt intending to solve the bigger picture problem here -
> > just an abstraction level that might allow reusablity for multiple
> > SoCs. In fact, having an abstraction away for voltage domain(which may
> > consist of multiple regulators and any SoC specific magic) purely
> > allows us to move towards a direction you mention here.
> >=20
> > >=20
> > > For the case of the OMAP voltage domains, it would be a place to stuff
> > > all of the VC/VP -> ABB -> Smart Reflex AVS stuff.
> > >=20
> >=20
> > Unfortunately, I dont completely comprehend objection we have to this
> > approach (other than an higher level abstraction is needed) and if we
> > do have an objection, what is the alternate approach should be for
> > representing hardware which this series attempts to present.
>=20
> I think the following is around the lines of your thought direction -
> if Rafael or others have comments on the following approach, it'd be a
> good starting point for me to progress.
>=20
> -->8--
> From 62e50b9f920495db88e5594aa6bceb52e83a443d Mon Sep 17 00:00:00 2001
> From: Nishanth Menon <nm@ti.com>
> Date: Wed, 26 Feb 2014 10:59:59 -0600
> Subject: [PATCH] PM / Runtime: introduce active power management callbacks
>  for pm_domain
>=20
> dev_pm_domain currently handles just device idle power management
> using the generic pm_runtime_get|put and related family of functions.
>=20
> Logically with appropriate pm_domain hooks this can translate to
> hardware specific clock and related operations. Given that pm_domains
> may contain this information, this provides an opportunity to extend
> current pm_runtime do dynamic power operations as well.
>=20
> What this means for drivers is as follows:
>=20
> Today, drivers(with some level of complexity) do:
> pm_runtime_get_sync(dev);
> clk =3D clk_get(dev, "name");
> old_rate =3D clk_get_rate(clk);
> ...
> clk_set_rate(clk, new_rate);
> ...
> clk_put(clk);
> pm_runtime_get_sync(dev);
>=20
> Instead, on pm_domains that can handle this as part of
> pm_domain->active_ops functions, They can now do the following:
> pm_runtime_get_sync(dev);
> old_rate =3D pm_runtime_get_rate(dev);
> ...
> pm_runtime_set_rate(dev, new_rate);
> ...
> pm_runtime_put_sync(dev);
>=20
> Obviously, this'd work for devices that handle a single main
> functional clock, but this could reduce complexity of drivers having
> to deal with power management details to have pm_runtime as the main
> point of interface.
>=20
> CAVEAT: For power domains that are capable of handling multiple
> clocks (example on OMAP, where there are the concepts of interface,
> functional and optional clocks per block), appropriate handling will
> be necessary from pm_domain callbacks. So, the question about which
> clock rate is being controlled or returned to is entirely upto the
> pm_domain implementation.
>=20
> On the otherhand, we can debate about defining and querying ACPI style
> "Performance state" instead of frequencies and wrap P-states inside
> or the other way around.. but given that majority of drivers using
> pm_runtime would rather be interested in frequencies and my naieve
> belief that we can index P-states with frequencies, kind of influenced
> my choice here of proposing frequencies as base query parameter..
> ofcourse, debate is still open here.
>=20
> Yes, we can still debate if providing yet another wrapper on top of
> clock APIs makes sense at all as well.
>=20
> Nyet-signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/base/power/runtime.c |  101 ++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/pm.h           |   25 +++++++++--
>  include/linux/pm_runtime.h   |   21 +++++++++
>  3 files changed, 143 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 72e00e6..ef230b4 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -1401,3 +1401,104 @@ void pm_runtime_remove(struct device *dev)
>  	if (dev->power.irq_safe && dev->parent)
>  		pm_runtime_put(dev->parent);
>  }
> +
> +/**
> + * pm_runtime_get_rate() - Returns the device operational frequency
> + * @dev:	Device to handle
> + * @rate:	Returns rate in Hz.
> + *
> + * Returns appropriate error value in case of error conditions, else
> + * returns 0 and rate is updated. The pm_domain logic does all the neces=
sary
> + * operation (which may consider magic hardware stuff) to provide the ra=
te.
> + *
> + * NOTE: the rate returned is a snapshot and in many cases just a bypass
> + * to clk api to set the rate.
> + */
> +int pm_runtime_get_rate(struct device *dev, unsigned long *rate)
> +{
> +	unsigned long flags;
> +	int error =3D -ENOSYS;
> +
> +	if (!rate || !dev)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&dev->power.lock, flags);
> +	if (!pm_runtime_active(dev)) {
> +		error =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	if (dev->pm_domain && dev->pm_domain->active_ops.get_rate)
> +		error =3D dev->pm_domain->active_ops.get_rate(dev, rate);
> +out:
> +	spin_unlock_irqrestore(&dev->power.lock, flags);
> +
> +	return error;
> +}

IMHO coupling device drivers even more with pm_runtime is wrong, and
Kevin Hilman seems to agree [1].

I would much rather go with Nishanth's initial approach of subscribing
to clock notifiers. They are, after all, supposed to tell the kernel
about any clock changes. In just so happens that in the case discussed
in this thread, OMAP needs to change voltages to match clock frequency
and, IMHO, using clock notifiers for that is correct.

The sematics are well defined and it's something which has been in the
tree for quite some time.

[1] https://lkml.org/lkml/2014/1/30/469

--=20
balbi

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD4r7AAoJEIaOsuA1yqREMLAP/jJKtJnYVmNy5v/4YOGhqp0Y
iEeM0DvHyupQ/meX7KDemavbjfBmtnBfqOO/G+e/329Rr3cjRLgfs5xgaaOczEXq
Ydcij4fV/w/er/9vENL2Ym26KpxrdE9pVJkoabG8D0MZovCXWjzGSMXn93K0ezxq
gcSEg9WLz+MIW7P14dNRkpo7xpRj2taVjCpoZ14staMyscPzihj4ciipWzZ0Di6r
0WKaHkQwvQ7UuBe4cZBPzmCw4iP/0uuRFeeHbunyfOFpf0OnKzYQcrMuouY4Q29k
czen8wYRCRdvy0SSAR2qcdTxNw5ZiqfAiv+0l6s5/atL9ha4s+SrGWNBjSxhWqpl
5qq9GxDJSOM7KUTvYvE/CnNNGzz48Et+zimCVkNzRmcNXutKTNBiDHg2/jgIltTh
Cc1aKqX8aLPKPoCmzZPiYlnRPnymsYZsdq3EmX2J/B3ddrQ5DJEbRqSu+Wo7j1d4
iSosWqe9KA1YqhxnFrtWTuUqyjYHxfu35A0LTkuPtM/sHvSM89dL3rfzfX9Um5fR
pau0WB8W8ZL91ty7VMh4t/MBTWq3vB1EuqOvVAKyMXNLEmM6xLGrZU/9yYOme7w+
Pd4u9g9jnwMxb1KiOQsg8Am7zo0tPdeFKnizSsqMP+f87oeiVZZ7EK1wGV1TtCuy
IDqpVumW+N/2q2ZbKEwk
=39y6
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
