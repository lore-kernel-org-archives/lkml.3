Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaFRXOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:14:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53292 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaFRXOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:14:15 -0400
Date: Thu, 19 Jun 2014 01:14:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
Message-ID: <20140618231410.GG26514@mithrandir>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com>
 <539F4D44.3070309@wwwdotorg.org>
 <53A03186.3040703@collabora.com>
 <53A069B6.6070902@wwwdotorg.org>
 <53A1CB23.5090307@collabora.com>
 <53A1D089.8010605@wwwdotorg.org>
 <20140618220343.GD26514@mithrandir>
 <53A20E02.5050900@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
Content-Disposition: inline
In-Reply-To: <53A20E02.5050900@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 04:09:06PM -0600, Stephen Warren wrote:
> On 06/18/2014 04:03 PM, Thierry Reding wrote:
> > On Wed, Jun 18, 2014 at 11:46:49AM -0600, Stephen Warren wrote:
> >> On 06/18/2014 11:23 AM, Tomeu Vizoso wrote:
> >>> On 06/17/2014 06:15 PM, Stephen Warren wrote:
> >>>> On 06/17/2014 06:16 AM, Tomeu Vizoso wrote:
> >>>>> On 06/16/2014 10:02 PM, Stephen Warren wrote:
> >>>>>> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
> >>>>>>> +#ifdef CONFIG_TEGRA124_EMC
> >>>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsign=
ed
> >>>>>>> long rate);
> >>>>>>> +void tegra124_emc_set_floor(unsigned long freq);
> >>>>>>> +void tegra124_emc_set_ceiling(unsigned long freq);
> >>>>>>> +#else
> >>>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsign=
ed
> >>>>>>> long rate)
> >>>>>>> +{ return -ENODEV; }
> >>>>>>> +void tegra124_emc_set_floor(unsigned long freq)
> >>>>>>> +{ return; }
> >>>>>>> +void tegra124_emc_set_ceiling(unsigned long freq)
> >>>>>>> +{ return; }
> >>>>>>> +#endif
> >>>>>>
> >>>>>> I'll repeat what I said off-list so that we can have the whole
> >>>>>> conversation on the list:
> >>>>>>
> >>>>>> That looks like a custom Tegra-specific API. I think it'd be much
> >>>>>> better
> >>>>>> to integrate this into the common clock framework as a standard cl=
ock
> >>>>>> constraints API. There are other use-cases for clock constraints
> >>>>>> besides
> >>>>>> EMC scaling (e.g. some in audio on Tegra, and I'm sure many on oth=
er
> >>>>>> SoCs too).
> >>>>>
> >>>>> Yes, I wrote a bit in the cover letter about our requirements and h=
ow
> >>>>> they map to the CCF. Could you please comment on that?
> >>>>
> >>>> My comments remain the same. I believe this is something that belong=
s in
> >>>> the clock driver, or at the least, some API that takes a struct cloc=
k as
> >>>> its parameter, so that drivers can use the existing DT clock lookup
> >>>> mechanism.
> >>>
> >>> Ok, let me put this strawman here to see if I have gotten close to wh=
at
> >>> you have in mind:
> >>>
> >>> * add per-client accounting (Rabin's patches referenced before)
> >>>
> >>> * add clk_set_floor, to be used by cpufreq, load stats, etc.
> >>>
> >>> * add clk_set_ceiling, to be used by battery drivers, thermal, etc.
> >>
> >> Yes. I'd expect those to be maintained per-client, and so the clock co=
re
> >> (or whatever higher level code implements clk_set_floor/ceiling)
> >> performs the logic that "blends" together all the different requests
> >> from different clients.
> >>
> >> As an aside, for audio usage, I would expect clk_set_rate to be a
> >> per-client (rather than per HW clock) operation too, and to error out =
if
> >> one client says it wants to set pll_a to the rate needed for
> >> 44.1KHz-based audio and a different client wants the rate for
> >> 48KHz-based audio.
> >=20
> > From what I remember, Mike was fairly strongly opposing the idea of
> > virtual clocks, but what you're proposing here sounds like it would
> > assume the existence of virtual clocks. clk_set_rate() per client
> > doesn't work with the current API as I understand it.
> >=20
> > Or perhaps what you're proposing isn't about the individual clocks at
> > all but rather about a mechanism to express constraints for a set of
> > clocks?
>=20
> This doesn't have anything to do with virtual clocks. As you mention,
> it's just about constraints.
>=20
> One user of clock "cpu" wants min rate 216MHz. Another wants max rate
> 1GHz. cpufreq will request some rate between the 2, or be capped to
> those limits. These set of imposed constraints would need to be stored
> per client of the clock, not per HW clock, since many clients could set
> different max rates (e.g. thermal throttle 1.5GHz due to temperature,
> CPU policy 1GHz due to the user selecting low CPU power, etc.)
>=20
> Similarly for audio, of there are N clients of 1 clock/PLL, and they
> each want the PLL to run at a different rate, something needs to detect
> that and deny it.

I'm wondering how this should work with the current API. Could the clock
core be modified to return a per-client struct clk * that references the
hardware clock internally? Or do we need to add a new API?

Thierry

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToh1CAAoJEN0jrNd/PrOhIVsQAMAZzYrgchipD42HZT5DLZAG
M5sBFjsa5qU+mcbdMVT1kCO7wuMDjd0gr8YlJgjwxqk8ZidAAnkwfL6M1+SAuVKp
OvSDinhea6C0WEEFUpyl0GH6gQnIbBATU68S0PG7h/1Sw61jvfPdI0dcXPj3UwGo
lkUvXh5jy8C+Vt+N6Y3q3uv+DFUtcSHmk8rQtGtHH4qQe7uTcCxxJ9gz5kH4paUC
t0uHdeaASgnBCKKVnqmirVDdTiFUsQZFIqxe4jFh0LwG6Gd1TunuW67aEhoKBxmI
41GTBOvEKcRE91D4geKMQ2JrlGjD08dAKVE70sFnnRNG6JES3z0QIbMSlJ8AWUN9
OcfbaP6pHc4f9ezpuW5X6TbDiB64RqTOs1pwA0ujXsy6pDHjxMyHpip3lSE+Mn+0
pizcs8x79dpnP+K7oObhgT1mSIOyqt3+ySrTHUscASWwzG9/iK6jDJsAOgQfWF5Z
u10Domphd395ECi8tGcRbrCAgiJNZRjFCLxldMi2LLtUhjjATAClBCG/NrcnKL1Y
NQdg1q+JAr5tAszMKTo8CMz3CnPcJBWT8gCVIrt6JMkGW+CxMRVoAIduzbjEEgGK
oUgkqYaiEjxYga5GX4yZ1yiMVQQj1L9o0MgmZM/4EFjZYscgmJMebKZx9R79YlYu
jOQaRhGWAz8unXFfH+/g
=rRC/
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
