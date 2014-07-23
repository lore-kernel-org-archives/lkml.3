Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaGWHYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:24:51 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57538 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaGWHYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:24:48 -0400
Date: Wed, 23 Jul 2014 09:24:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
Message-ID: <20140723072442.GC15759@ulmo.nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
 <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
 <CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
 <20140723065412.GA15759@ulmo.nvidia.com>
 <CAKohponmg24pvnX2Jhfg5LHKKHx3VEm-6a_JXTGhVXY-aj3EOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <CAKohponmg24pvnX2Jhfg5LHKKHx3VEm-6a_JXTGhVXY-aj3EOw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 12:28:21PM +0530, Viresh Kumar wrote:
> On 23 July 2014 12:24, Thierry Reding <thierry.reding@gmail.com> wrote:
> > On Wed, Jul 23, 2014 at 10:14:44AM +0530, Viresh Kumar wrote:
> >> On 21 July 2014 21:09, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> >>
> >> > diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.a=
rm
> >> > index 7364a53..df3c73e 100644
> >> > --- a/drivers/cpufreq/Kconfig.arm
> >> > +++ b/drivers/cpufreq/Kconfig.arm
> >> > @@ -244,6 +244,7 @@ config ARM_SPEAR_CPUFREQ
> >> >  config ARM_TEGRA_CPUFREQ
> >> >         bool "TEGRA CPUFreq support"
> >> >         depends on ARCH_TEGRA
> >> > +       depends on GENERIC_CPUFREQ_CPU0
> >>
> >> Wouldn't this also disturb the existing cpufreq driver for earlier
> >> tegra platforms? i.e. we don't need cpufreq-cpu0 for them
> >> atleast as of now.
> >
> > Perhaps this should be "select" rather than "depends on"?
>=20
> Don't know, its not optionaly for tegra124 and so a "depends on"
> might fit better ?

ARM_TEGRA_CPUFREQ is still optional, so the select only applies when the
Tegra cpufreq driver is enabled. This is mostly just out of convenience,
though. The Tegra cpufreq driver uses the generic CPU0 cpufreq driver so
a select will automatically pull in the necessary dependency. With a
"depends on" the Tegra cpufreq driver only becomes available after
you've selected GENERIC_CPUFREQ_CPU0, which is somewhat unintuitive.

To illustrate with an example: as a user, I want to enable CPU frequency
scaling on Tegra. So I use menuconfig to navigate to the "CPU Frequency
scaling" menu (enable it if not available yet) and look for an entry
that says "Tegra". But I can't find it because it's hidden due to the
lack of GENERIC_CPUFREQ_CPU0. That the Tegra CPU frequency driver uses a
generic driver is an implementation detail that users shouldn't have to
be aware of.

> >> > +static int tegra124_cpufreq_probe(struct platform_device *pdev)
> >> > +{
> >> > +       int ret;
> >> > +
> >> > +       cpu_dev =3D get_cpu_device(0);
> >> > +       if (!cpu_dev)
> >> > +               return -ENODEV;
> >> > +
> >>
> >> Shouldn't we do a of_node_get() here?
> >
> > I think this would need to be get_device() since it's the struct device
> > that's being used subsequently.
>=20
> Probably I didn't write it well..
>=20
> What I meant was after doing a get_cpu_device() we might also need
> to do  of_node_get(cpu_dev->of_node) as we would be using of_node
> in further code.

But we're using cpu_dev->of_node, so we need to make sure cpu_dev
doesn't go away suddenly. Simply keeping a reference to ->of_node
won't ensure that.

I guess technically it would be better if get_cpu_device() already
incremented the reference count on the returned struct device. Currently
it would theoretically still be possible for the device to disappear
between the call to get_cpu_device() and a call to get_device().

Thierry

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTz2M6AAoJEN0jrNd/PrOhQgEP/R2ER7bRQ3snOETkSshpLJxq
EWO42Cm9FIvxOazNLQE1cswq7Gz9lUkT6RFsi5faAQcjCpRxWYeU8u+XhHiGd+rI
IgXIC5fhQJm175hOwgXwvPwNF/agyPHzLXCH8M7v5Qykur/70Xdm8Qc5yiGslhTD
qHEVTeeiDxlD2TnmMhDSTIb3HsGmEXcoQIFFI0pzrMnUzwdIkutuNs88IGblzBE3
NrD0O9/C6QGW0ohqnKzNAZv6SrRIxNjPPNvBBGDXJA+NgldxOY41Zd/F1iyEbG1f
COsTcn49Xtx0NpS8G1z34AePCp7BY6Uq1eOH3LxAR6UKTa83sS54hPi2u4T2RSjW
5CBlfxt+HYJhTEQViVkojix01JJEr4l1hR68AgsljLxJa6W7w+v37nNIGyunEs2z
MLConmrVLxFxiy39TYpJ07oVtRI4/AHMdRTqXbCsS36O59oBB19S7qQYFN9SMxwH
03qDhsICLnlZTPSVd5ExYImbw8mviKBM9h2AQs5SlE3AjznIkfB2bFr7VFL7pcbz
JSjGPa0xEFDaz1YJdag8MKcLZp3ybvuUo8mNK48ucN9QsAm6x8lBhnNca4qr4r+f
FkxixllgxqPa8CoZMx8LprgH+PZ0xjxLNaXe8m6RLwH5CgfCNAqZXBuohoS+cTpX
iiJGRUVCNjm/jHaHkGWF
=BqM+
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
