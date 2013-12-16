Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3LPMou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:44:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab3LPMos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:44:48 -0500
Message-ID: <52AEF5AD.5000506@ti.com>
Date: Mon, 16 Dec 2013 08:44:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Kucheria <amit.kucheria@verdurent.com>
CC: Zoran Markovic <zoran.markovic@linaro.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Christian Daudt <bcm@fixthebug.org>,
        James King <james.king@linaro.org>
Subject: Re: [RFC PATCH] thermal: add generic cpu hotplug cooling device
References: <1379715336-22620-1-git-send-email-zoran.markovic@linaro.org> <CAME+o4myuSVwc=8mpk9x6tKZoskG6i2djrHSBGmVhKqaHqYwMA@mail.gmail.com> <CAME+o4m+1O4pMYa8jNoSuVtmtbkRC2H-9YZj+hnDwsd=Ex0wmw@mail.gmail.com> <52989FCA.2010107@ti.com> <CAME+o4mbtbDV+tZ6itEBqGp5Xy=6a0CsAZ+Kuvu3+oa-TR=_dw@mail.gmail.com> <52A5D3F1.9040301@ti.com> <CAME+o4=GESy7jseDXKx6f_DykRYP72kCdM5D3RMkKkybMDzmmg@mail.gmail.com> <CAHLCerMCjtXNDRceG2u6kuyTrjV=j6S3mUViVMQJyDAwp_6pgA@mail.gmail.com>
In-Reply-To: <CAHLCerMCjtXNDRceG2u6kuyTrjV=j6S3mUViVMQJyDAwp_6pgA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="StCI2RcTTb807oeEmjA0S3HjfeuuGpVTn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--StCI2RcTTb807oeEmjA0S3HjfeuuGpVTn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Zoran,

On 16-12-2013 07:26, Amit Kucheria wrote:
> On Fri, Dec 13, 2013 at 5:31 AM, Zoran Markovic
> <zoran.markovic@linaro.org <mailto:zoran.markovic@linaro.org>> wrote:
>=20
>     Hi Eduardo,
>=20
>     > Yeah, I would like to see it. But what I was more interested in s=
eeing
>     > is how long does it take to offline a CPU?
>     >
>     I profiled this over 70 shutdown/startup cycles of CPU1 on Capri-AP=

>     (Cortex-A9x2) board and I get:
>     shutdown:  1445usec (average), 3159usec (maximum), 834usec (minimum=
)
>     startup:  707usec (average), 3159usec (maximum), 327usec (minimum)
>=20
>     It's using a 32KHz clock so time resolution is ~30usec.
>=20
>     Regards, Zoran

Thanks for the data points. Based only on the data above, numbers sounds
promising, from thermal perspective. Provided that  3.1ms is the maximum
 transition time, and you stated that cooling effectiveness is around
8C/s (?).

However, I still would like to challenge the data.

>=20
>=20
> What is the workload you're running besides the proprietary heater code=
?

Agreed with Amit here, can you please provide better description of your
testing environment? We know, based on your emails the following:
- Homogeneous dual core Cortex-A9 environment.
- They go up to 48C when fully loaded. Can you explain where is your
sensor location? Gradient to hotspot, etc? 48C at A9s or board temperatur=
e?
- Hotplug provides you cooling effectiveness  of ~8C/s.
- Shutdown / startup delay:
     shutdown:  1445usec (average), 3159usec (maximum), 834usec(minimum)
     startup:  707usec (average), 3159usec (maximum), 327usec(minimum)
  Can you please explain the work load here? Is it full cpuburn? both
CPUs 100% loaded?
  Might be interesting to have either plots or logs of these experiments.=


There are two major points we need to be careful:

- This code looks promising on embedded dual core system. However, it
does not necessarily mean it works fine on, say server side. How about a
system with 8/16/32 cores? How about a more heterogeneous workload? Not
to talk about heterogeneous cores. I think in more complicated scenarios
the data you provided above might even change. The difference between
your minimum and maximum shutdown/startup times are quite considerable,
so I am assuming your variance is not negligible, imaging if we scale
this up, what happens?

- The other point is that this type of cooling device must be taken in
very sensible way. Shutting down circuitry may not be the best strategy
for thermal. In fact, if you think about it, given you have a workload
well balanced between, say, two cores, as same of your environment,
turning one off it means you need to deal the very same load in only one
CPU. In other words, turning of circuitry means, from thermal standpoint
that you are increasing you heat/area ratio. Sometimes, you actually
want to increase this ratio in order to properly cool down your system.

I am not saying I am against the cooling device, I am simply stating
that this needs to be taken with careful consideration. We need to
properly document this. And building and validating thermal policies on
top of this is even harder.

> Something similar to what Vincent did[1] when benchmarking hotplug woul=
d
> be nice to see. Due to the kthread work and other optimisations, we
> shouldn't see drastic increases in hotplug latency as the number of
> threads increase any more.
>=20
> Regards,
> Amit
>=20
> [1] https://wiki.linaro.org/WorkingGroups/PowerManagement/Archives/Hotp=
lug
> =20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--StCI2RcTTb807oeEmjA0S3HjfeuuGpVTn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKu9bEACgkQCXcVR3XQvP1ewAEAgvcY4wiXycoiMZJlD5EIjzQx
MKiEwCH94nWlsC3FbzUBAKlcw/kEfjwahhFsFZR1aOlHpTrspthWmklmJfii2+/y
=NYmP
-----END PGP SIGNATURE-----

--StCI2RcTTb807oeEmjA0S3HjfeuuGpVTn--
