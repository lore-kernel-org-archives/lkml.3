Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3KKOOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:14:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35069 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab3KKOOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:14:32 -0500
Message-ID: <5280E617.3000004@ti.com>
Date: Mon, 11 Nov 2013 16:13:43 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
CC: Belisko Marek <marek.belisko@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH 0/3] omapdss: venc: Add support for bypass and acbias.
References: <1381784555-18344-1-git-send-email-marek@goldelico.com> <CAAfyv34j+YhEjtHyf7zg5oBoCV5ROEXow8VV0PQNHLTF5uDZJg@mail.gmail.com> <5280DBA6.50303@ti.com> <FB10035C-B13C-4A03-BE9C-0576806F2577@goldelico.com>
In-Reply-To: <FB10035C-B13C-4A03-BE9C-0576806F2577@goldelico.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="qbuBx7Pg6dRNPQ3LBvJGWB0bpiwxvUm7M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qbuBx7Pg6dRNPQ3LBvJGWB0bpiwxvUm7M
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-11 15:57, Dr. H. Nikolaus Schaller wrote:
> Hi Tomi,
>=20
> Am 11.11.2013 um 14:29 schrieb Tomi Valkeinen:
>=20
>> Hi,
>>
>> On 2013-11-05 09:24, Belisko Marek wrote:
>>> Hi,
>>>
>>> ping.
>>>
>>> On Mon, Oct 14, 2013 at 11:02 PM, Marek Belisko <marek@goldelico.com>=
 wrote:
>>>> This patches is adding bypass and acbias functionality to omapdss ve=
nc driver.
>>>> In first patch we export updatin bypass and acbias in devconf1 regis=
ter. Next patch
>>>> add handling for updating in venc driver and last patch add driver f=
or opa362 which
>>>> is used on gta04 board and set bypass + acbias.
>>> Is there a chance to get this series to 3.13? Thanks.
>>
>> Sorry, I haven't had time to do much reviewing.
>>
>> The code in omap3-tvout.c should be included in the display.c file,
>> which already contains some things like muxing.
>=20
> Ok, that might be better - but we were not sure where to place code to
> modify the DEVCONF1 registers. It is not directly DSS related but a spe=
cial
> control of the OMAP3 SoC. Therefore we think it is better located in om=
ap3-tvout.c

The display.c file is not strictly DSS stuff, but DSS related "glue" for
the SoC. For example, the muxing of the DSI pads is also done on the
CONTROL module, and it's also in display.c.

The file is getting a bit large, so I'm not against splitting it. But I
don't think there's point to add omap3-tvout.c file, which most likely
will ever contain only that one function.

>> Also, func(bool, bool)
>> style functions are rather confusing to read. Maybe an enum would be
>> better, so you'd instead have something like:
>>
>> func(OMAP_VENC_TVOUTBYPASS | OMAP_VENC_TVACEN)
>=20
> We have no special preference on that.

It's just about readability. Which one tells you better what the code doe=
s:

func(true, true);

or

func(OMAP_VENC_TVOUTBYPASS | OMAP_VENC_TVACEN);

>> But the main issue is: while this series probably works well, I really=

>> don't like it that the OPA driver needs to pass bypass and acbias. It
>> shouldn't know anything about such things. I'm just not certain how to=

>> implement that with the current omapdss driver.
>=20
> Well, it must know bypass and acbias because it requires the OMAP
> CPU to be configured accordingly. I.e. it is the one who pushes the
> button. Or we get a problem that people might misconfigure it.

While the omapdss display drivers are currently OMAP specific, I want to
(or at least try to) keep them platform independent. Afaik, acbias and
bypass are OMAP VENC specific things, not something that every SoC with
an analog TV-out have. Thus, the OPA driver should not know about them,
and it should be something that only the DSS glue code in mach-omap2/
and the venc driver know about.

> I would see it similar as a driver must be able to control power. Here
> it must be able to control bypass and acbias in a special way that it w=
orks.

The difference is that on all possible SoCs where you could add OPA
chip, you'll need to manage the power for OPA, and it's done in a common
way. Whereas the bypass and acbias are OMAP specific things.

>> I'll try to find time to think about this more, but I don't think I ca=
n
>> merge this for 3.13.
>=20
> Please take your time.
>=20
> And please also consider the approach to merge it into 3.13 as it is
> and we can then fix it in the weeks while release candidates are pushed=
=2E

If it was purely omapdss code, I could possibly take it. But it contains
arch/arm code also, and I don't want to cause needless changes on code
that I do not maintain.

 Tomi



--qbuBx7Pg6dRNPQ3LBvJGWB0bpiwxvUm7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSgOYXAAoJEPo9qoy8lh71ABUP/2B7qJHM8Gvg9vqQB5o+panJ
ufDOOPj4U26Zj8sOzmkcxs7jQOKth3x9UFPRRy9vAzme5+dkEqAdNp2IfvrGBVul
Fg0XqTVDLYl3n5zr5qOWKyajc5/koIVLELMh5Jct2+12ooPwB88feKH9O+u+vGmU
WrL2R5t0J6lEYxmqpPMDbQ0Le++bquLbr5erfVPcTl+KOrhZ93SN7Kiee+G85UHQ
wxcIqas91KvbLqk1/6udfl5zdQlVBomqxPswN1bPgTNWuyIKSla1J9RMKXgRH0Lk
dWPlsKmjZKxMLV1ZXn/ClYw7cja9pYz+C1szurbuhV8yr5oG34m5XIjYLNsrAxyT
XZsisxZDb3JOsfmtjU8aoyuguzMkzu0QZCgD+m27SydNfDsLDBqqTFF1Tc5OHbNO
mh5GWL5AY5i6wSItrukH1QNL0FwHrczPFUvwbw08DW+oheHUVK6eNu0AgwC4vz3B
h96tegfheGm3p49uAMYZDWo71G0n+oz/BMXLkbm1a1VZor+Rc6BpDAeKIyiJzWsH
5RwUAUnpZJMXPakayxaPaOaVYeN3jqzo4gZkjrtxy1vW6rYbm6zrIJNF+bobjshP
l3hhdKyTGqb8EXXklWX0VwTnTcLIi4CNybEOA3q8UegA80KSucJjdMn4hp00lzCV
NV5hmwJLoMukMRnp75yR
=MPDN
-----END PGP SIGNATURE-----

--qbuBx7Pg6dRNPQ3LBvJGWB0bpiwxvUm7M--
