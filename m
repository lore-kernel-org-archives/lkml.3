Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbbAORZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:25:11 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:59012 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754044AbbAORZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:25:09 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Thu, 15 Jan 2015 17:25:08 +0000
Message-ID: <54B7F7F2.5010202@imgtec.com>
Date: Thu, 15 Jan 2015 17:25:06 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Qais Yousef <qais.yousef@imgtec.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        "John Crispin" <blogic@openwrt.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 18/24] irqchip: mips-gic: Stop using per-platform mapping
 tables
References: <1411076851-28242-1-git-send-email-abrestic@chromium.org>	<1411076851-28242-19-git-send-email-abrestic@chromium.org>	<54B7AB95.4080501@imgtec.com>	<54B7EAE6.8040503@imgtec.com>	<54B7EC8D.5050505@imgtec.com> <CAL1qeaFZvtc1sv4HQ+PLHFjm4OgUiNcAhzcFtQeeGbB8Byhj3g@mail.gmail.com>
In-Reply-To: <CAL1qeaFZvtc1sv4HQ+PLHFjm4OgUiNcAhzcFtQeeGbB8Byhj3g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jj7Lnr5eIFttLpO8B4V5W22nw1uHPilTG"
X-Originating-IP: [192.168.154.110]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jj7Lnr5eIFttLpO8B4V5W22nw1uHPilTG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 15/01/15 16:58, Andrew Bresticker wrote:
> Hi James, Qais,
>=20
> On Thu, Jan 15, 2015 at 8:36 AM, Qais Yousef <qais.yousef@imgtec.com> w=
rote:
>> On 01/15/2015 04:29 PM, James Hogan wrote:
>>>
>>> On 15/01/15 11:59, James Hogan wrote:
>>>>
>>>> Hi Andrew,
>>>>
>>>> On 18/09/14 22:47, Andrew Bresticker wrote:
>>>>>
>>>>> Now that the GIC properly uses IRQ domains, kill off the per-platfo=
rm
>>>>> routing tables that were used to make the GIC appear transparent.
>>>>>
>>>>> This includes:
>>>>>   - removing the mapping tables and the support for applying them,
>>>>>   - moving GIC IPI support to the GIC driver,
>>>>>   - properly routing the i8259 through the GIC on Malta, and
>>>>>   - updating IRQ assignments on SEAD-3 when the GIC is present.
>>>>>
>>>>> Platforms no longer will pass an interrupt mapping table to gic_ini=
t.
>>>>> Instead, they will pass the CPU interrupt vector (2 - 7) that they
>>>>> expect the GIC to route interrupts to.  Note that in EIC mode this
>>>>> value is ignored and all GIC interrupts are routed to EIC vector 1.=

>>>>>
>>>>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>>>>> Acked-by: Jason Cooper <jason@lakedaemon.net>
>>>>> Reviewed-by: Qais Yousef <qais.yousef@imgtec.com>
>>>>> Tested-by: Qais Yousef <qais.yousef@imgtec.com>
>>>>
>>>> This commit (18743d2781d01d34d132f952a2e16353ccb4c3de) appears to br=
eak
>>>> boot of interAptiv, dual core, dual vpe per core, on malta with
>>>> malta_defconfig.
>>>>
>>>> It gets to here:
>>>> ...
>>>> CPU1 revision is: 0001a120 (MIPS interAptiv (multi))
>>>> FPU revision is: 0173a000
>>>> Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
>>>> Primary data cache 64kB, 4-way, PIPT, no aliases, linesize 32 bytes
>>>> MIPS secondary cache 1024kB, 8-way, linesize 32 bytes.
>>>> Synchronize counters for CPU 1: done.
>>>> Brought up 2 CPUs
>>>>
>>>> and then appears to just hang. Passing nosmp works around it, allowi=
ng
>>>> it to get to userland.
>>>>
>>>> Is that a problem you've already come across?
>>>>
>>>> I'll keep debugging.
>>>
>>> Right, it appears the CPU IRQ line that the GIC is using doesn't get
>>> unmasked (STATUSF_IP2) when a new VPE is brought up, so only the firs=
t
>>> CPU will actually get any interrupts after your patch (including the
>>> rather critical IPIs), i.e. hacking it in vsmp_init_secondary() in
>>> smp-mt.c allows it to boot.
>>>
>>> Hmm, I'll have a think about what the most generic fix is, since
>>> arbitrary stuff may or may not have registered handlers for the raw C=
PU
>>> interrupts (timer, performance counter, gic etc)...
>>>
>>> Cheers
>>> James
>>>
>>
>> Is this similar to the issue addressed by this (ff1e29ade4c6 MIPS: smp=
-cps:
>> Enable all hardware interrupts on secondary CPUs)?
>=20
> I believe so.
>=20
> James, I think you can apply a similar patch to smp-mt.c:vsmp_init_seco=
ndary.

Yes, I've come to the same conclusion. smp-cmp.c is also affected. I'll
post patches tomorrow.

Thanks
James


--jj7Lnr5eIFttLpO8B4V5W22nw1uHPilTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUt/fyAAoJEGwLaZPeOHZ6+PwQALTcKe4X2dNlZJ3hemf//pjb
XJsfR2VIFMOAYSMguptJ07J/A5GQXkfhj9gImk3RB8e9OzrmR2ZKgtz6ZaEraLW4
g2zWY0NulkH35n50wwn3S9ynP5m1r59sY2WhNn0UaPf4YwEb8vAq5qyT0Cj8AP7c
lx6c3vBZrFYqsk/xxEaCsS0wHNzZQbAZ0thnziMkDlov7N5OSc01FM998qJ3vbxs
kkQ8BPSJcarVW6i8w/7+G07g8drO2PAH0jOrmJ9rgO6MzK2O7Sk1Adsfo4ATE6ji
CPKoOBMML4Qu9m5uw0p8CoNnyG9/WF3mBXvqyeSiuedRux7R4TXgifH+U8HIi+ss
sruJxnIda8A9yNceTTCH6WQ6tyIgdf7oCIT2QzTQjBeVMEMs1lV8pbavxuArvs99
nmcYS9HWDCuus1ljIgfiBVH1XUw6HxPZCNBtNAM6ny9LfRO+JsZS9MXfabwgwvNw
UMCGiUr74Vh+XTFAimOvmEFTMcWmIPmgkEG0bk5f4YnuTOt9YrttKdNucVy79zMZ
jR0Xpnx3Uk+1+EqVxDz9MYRncFC5jOZ2o3OlxhjXCbiBC0WjHRP5ps4VCHLf14wU
Z0byDwWTwwtiJ8+BIguBk7a0h0x8mRkGoE6v2ePlGEwM1X/6945glFhvRw5Lc4dz
b33KR3KQeN4ZzUSXSudf
=D2P0
-----END PGP SIGNATURE-----

--jj7Lnr5eIFttLpO8B4V5W22nw1uHPilTG--
