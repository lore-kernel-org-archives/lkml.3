Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaFRWJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:09:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57881 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaFRWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:09:11 -0400
Message-ID: <53A20E02.5050900@wwwdotorg.org>
Date: Wed, 18 Jun 2014 16:09:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com> <539F4D44.3070309@wwwdotorg.org> <53A03186.3040703@collabora.com> <53A069B6.6070902@wwwdotorg.org> <53A1CB23.5090307@collabora.com> <53A1D089.8010605@wwwdotorg.org> <20140618220343.GD26514@mithrandir>
In-Reply-To: <20140618220343.GD26514@mithrandir>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="G91TCQa2E3m61PKFvAhuOXbFiBTg0vvFk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G91TCQa2E3m61PKFvAhuOXbFiBTg0vvFk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/18/2014 04:03 PM, Thierry Reding wrote:
> On Wed, Jun 18, 2014 at 11:46:49AM -0600, Stephen Warren wrote:
>> On 06/18/2014 11:23 AM, Tomeu Vizoso wrote:
>>> On 06/17/2014 06:15 PM, Stephen Warren wrote:
>>>> On 06/17/2014 06:16 AM, Tomeu Vizoso wrote:
>>>>> On 06/16/2014 10:02 PM, Stephen Warren wrote:
>>>>>> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
>>>>>>> +#ifdef CONFIG_TEGRA124_EMC
>>>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsign=
ed
>>>>>>> long rate);
>>>>>>> +void tegra124_emc_set_floor(unsigned long freq);
>>>>>>> +void tegra124_emc_set_ceiling(unsigned long freq);
>>>>>>> +#else
>>>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsign=
ed
>>>>>>> long rate)
>>>>>>> +{ return -ENODEV; }
>>>>>>> +void tegra124_emc_set_floor(unsigned long freq)
>>>>>>> +{ return; }
>>>>>>> +void tegra124_emc_set_ceiling(unsigned long freq)
>>>>>>> +{ return; }
>>>>>>> +#endif
>>>>>>
>>>>>> I'll repeat what I said off-list so that we can have the whole
>>>>>> conversation on the list:
>>>>>>
>>>>>> That looks like a custom Tegra-specific API. I think it'd be much
>>>>>> better
>>>>>> to integrate this into the common clock framework as a standard cl=
ock
>>>>>> constraints API. There are other use-cases for clock constraints
>>>>>> besides
>>>>>> EMC scaling (e.g. some in audio on Tegra, and I'm sure many on oth=
er
>>>>>> SoCs too).
>>>>>
>>>>> Yes, I wrote a bit in the cover letter about our requirements and h=
ow
>>>>> they map to the CCF. Could you please comment on that?
>>>>
>>>> My comments remain the same. I believe this is something that belong=
s in
>>>> the clock driver, or at the least, some API that takes a struct cloc=
k as
>>>> its parameter, so that drivers can use the existing DT clock lookup
>>>> mechanism.
>>>
>>> Ok, let me put this strawman here to see if I have gotten close to wh=
at
>>> you have in mind:
>>>
>>> * add per-client accounting (Rabin's patches referenced before)
>>>
>>> * add clk_set_floor, to be used by cpufreq, load stats, etc.
>>>
>>> * add clk_set_ceiling, to be used by battery drivers, thermal, etc.
>>
>> Yes. I'd expect those to be maintained per-client, and so the clock co=
re
>> (or whatever higher level code implements clk_set_floor/ceiling)
>> performs the logic that "blends" together all the different requests
>> from different clients.
>>
>> As an aside, for audio usage, I would expect clk_set_rate to be a
>> per-client (rather than per HW clock) operation too, and to error out =
if
>> one client says it wants to set pll_a to the rate needed for
>> 44.1KHz-based audio and a different client wants the rate for
>> 48KHz-based audio.
>=20
> From what I remember, Mike was fairly strongly opposing the idea of
> virtual clocks, but what you're proposing here sounds like it would
> assume the existence of virtual clocks. clk_set_rate() per client
> doesn't work with the current API as I understand it.
>=20
> Or perhaps what you're proposing isn't about the individual clocks at
> all but rather about a mechanism to express constraints for a set of
> clocks?

This doesn't have anything to do with virtual clocks. As you mention,
it's just about constraints.

One user of clock "cpu" wants min rate 216MHz. Another wants max rate
1GHz. cpufreq will request some rate between the 2, or be capped to
those limits. These set of imposed constraints would need to be stored
per client of the clock, not per HW clock, since many clients could set
different max rates (e.g. thermal throttle 1.5GHz due to temperature,
CPU policy 1GHz due to the user selecting low CPU power, etc.)

Similarly for audio, of there are N clients of 1 clock/PLL, and they
each want the PLL to run at a different rate, something needs to detect
that and deny it.



--G91TCQa2E3m61PKFvAhuOXbFiBTg0vvFk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTog4CAAoJEJuNpwkmVCGczpwP/i8lg4zQIEVmJZAzXAwXdppJ
O4nVHujENRyD8gpP/pdoHcIcZWKTDMdZ8U3yxwk07jkrVkKptSp8WUPoGCjfB+I+
UOaEI8YbQltdqTO7qmM6oCgkvYHq18/elmJu1CaQeSOKDBmCAcmuvZxTZFt1ch9w
4YDsK8ebItDtty5kbAQ41tvxTLepXi6Abbh9S4NslUxh9jT2o8iIh2v1MsRXZrH3
4Y8BYw+siABzKDSmZasCcxZ70p6ZVGxyuOP8mGgkUMILjW4Bmmgicn2+6A3Z7x2L
1OVQUt1zmgizvcQFF/q3MylWFSo0hhIn9Q1lJN+bGf56kClqX1w/r2TsN9EJ0WA5
J1CfnDEYQ2hQybFta1TT1D91uAzBb2E3eTrUs27Y3BQWfpNqhhM2smaUyZMmsAeI
u7NhFvB/DtXjga7RyDaaKSrFNlJLcFlKQsPA1t+DMjiMQra+KjNVOYUQe/TNGrX9
onUKCYORighlu3NWLBiK/4qqxzB7F6UOftfAYdpfSw0R7zgbuOVv7Mx6diEvnUZz
NaUOxgDGpejxExlIwRSnDefHI2/5pMxLX7/1Bas12QfyJb6m94MFSh8Qyf4Lxkvc
qHGLY1um92nFVZl4T3X9R7+6i4ft+u2Cmhyl2vPgpfdDdXPTwiBpI3jMmdlMUvUQ
yxUkAI1RRHknxnO7qvJL
=7pLT
-----END PGP SIGNATURE-----

--G91TCQa2E3m61PKFvAhuOXbFiBTg0vvFk--
