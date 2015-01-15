Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbbAOQ3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:29:41 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:35637 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754173AbbAOQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:29:39 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Thu, 15 Jan 2015 16:29:37 +0000
Message-ID: <54B7EAE6.8040503@imgtec.com>
Date: Thu, 15 Jan 2015 16:29:26 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
CC: Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        "Qais Yousef" <qais.yousef@imgtec.com>,
        Jonas Gorski <jogo@openwrt.org>, "John Crispin" <blogic@openwrt.org>,
        David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 18/24] irqchip: mips-gic: Stop using per-platform mapping
 tables
References: <1411076851-28242-1-git-send-email-abrestic@chromium.org> <1411076851-28242-19-git-send-email-abrestic@chromium.org> <54B7AB95.4080501@imgtec.com>
In-Reply-To: <54B7AB95.4080501@imgtec.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="FXUeguMGHW8j3p6lTKqSh4BuIhirVMKxl"
X-Originating-IP: [192.168.154.110]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FXUeguMGHW8j3p6lTKqSh4BuIhirVMKxl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 15/01/15 11:59, James Hogan wrote:
> Hi Andrew,
>=20
> On 18/09/14 22:47, Andrew Bresticker wrote:
>> Now that the GIC properly uses IRQ domains, kill off the per-platform
>> routing tables that were used to make the GIC appear transparent.
>>
>> This includes:
>>  - removing the mapping tables and the support for applying them,
>>  - moving GIC IPI support to the GIC driver,
>>  - properly routing the i8259 through the GIC on Malta, and
>>  - updating IRQ assignments on SEAD-3 when the GIC is present.
>>
>> Platforms no longer will pass an interrupt mapping table to gic_init.
>> Instead, they will pass the CPU interrupt vector (2 - 7) that they
>> expect the GIC to route interrupts to.  Note that in EIC mode this
>> value is ignored and all GIC interrupts are routed to EIC vector 1.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Acked-by: Jason Cooper <jason@lakedaemon.net>
>> Reviewed-by: Qais Yousef <qais.yousef@imgtec.com>
>> Tested-by: Qais Yousef <qais.yousef@imgtec.com>
>=20
> This commit (18743d2781d01d34d132f952a2e16353ccb4c3de) appears to break=

> boot of interAptiv, dual core, dual vpe per core, on malta with
> malta_defconfig.
>=20
> It gets to here:
> ...
> CPU1 revision is: 0001a120 (MIPS interAptiv (multi))
> FPU revision is: 0173a000
> Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
> Primary data cache 64kB, 4-way, PIPT, no aliases, linesize 32 bytes
> MIPS secondary cache 1024kB, 8-way, linesize 32 bytes.
> Synchronize counters for CPU 1: done.
> Brought up 2 CPUs
>=20
> and then appears to just hang. Passing nosmp works around it, allowing
> it to get to userland.
>=20
> Is that a problem you've already come across?
>=20
> I'll keep debugging.

Right, it appears the CPU IRQ line that the GIC is using doesn't get
unmasked (STATUSF_IP2) when a new VPE is brought up, so only the first
CPU will actually get any interrupts after your patch (including the
rather critical IPIs), i.e. hacking it in vsmp_init_secondary() in
smp-mt.c allows it to boot.

Hmm, I'll have a think about what the most generic fix is, since
arbitrary stuff may or may not have registered handlers for the raw CPU
interrupts (timer, performance counter, gic etc)...

Cheers
James


--FXUeguMGHW8j3p6lTKqSh4BuIhirVMKxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUt+rtAAoJEGwLaZPeOHZ6kRoP/0A+vQHTnpXTbFPmbCzf1qyL
/Dya2T5PUKcudDlr6Oso5oX3U+vG8g/6Lwbr77MhOnAC/eWZk/kwkzx1G7EcYr4/
F4srEAyGE7fS/ePAyJZKX8afFl51JTrzn/XW6JkW0oHxOsxybGJzh33x9xBX68+f
w3Ws764HeUMK+Q3enVHPJ92VmNaK790seVUOBNLSx/xoir7MHVgmleJyNmiEF7YH
oAZVXmSmuX81L5DsL0aziYNHbz0XbNQ2LkMSuATnLy6W4MfpFgDcateYLSAmJl8Z
EjjAObuQR60W93b3Q9HzjnH/YCxCEUoU0Yx77teHxAC7hrWD50yuS+VycqYE+N7U
xKu8plQ6c39SoSQnf+mByZl2Wm3s7t+4kwEMu4GkrkivOLWQHrK3h2NbLws9OTbm
nyv08y4D8s+SlNSgMoYVo7YPOqo+mihdeK9/59sFkt35Eux2kdzYSrW1WuE9N7bJ
J7vErk9MdXNpSwhmi31Fx6VX0Sx4WlK6RI44ZHNGhbiFmh7ocMIJyWs/pqc4kI9H
PrsGIc5gzz90BKOPrQvTs+6BMocT+I7Tg/sDd+N7YL9Dip9rQfZDJSv2FznifCP0
jZfKwdPjiV6cRQPrbAXvRPWOcp8k18w8IckeYlmltn/9BumiJe7Y/1pbB5briJS4
zKm9sqh973jTnjOnm6sH
=hJD8
-----END PGP SIGNATURE-----

--FXUeguMGHW8j3p6lTKqSh4BuIhirVMKxl--
