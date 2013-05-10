Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3EJPlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:41:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43489 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab3EJPlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:41:13 -0400
Message-ID: <518D1509.5070801@ti.com>
Date: Fri, 10 May 2013 11:40:57 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH V3 10/21] thermal: exynos: Fix to clear only the generated
 interrupts
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com> <1367931671-3906-11-git-send-email-amit.daniel@samsung.com> <518BB3D7.3010205@ti.com> <CADGdYn7Hm6EXvgK_ih_T8eE1oxzeiHimpZJ2LvQvCvC=ycmddg@mail.gmail.com>
In-Reply-To: <CADGdYn7Hm6EXvgK_ih_T8eE1oxzeiHimpZJ2LvQvCvC=ycmddg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2TCTJLLKIIAIQSTMKGQKR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2TCTJLLKIIAIQSTMKGQKR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09-05-2013 22:22, amit daniel kachhap wrote:
> Hi,
>=20
> On Thu, May 9, 2013 at 8:03 PM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>> On 07-05-2013 09:01, Amit Daniel Kachhap wrote:
>>> This patch uses the TMU status register to know the generated interru=
pts
>>> and only clear them in the interrupt handler.
>>>
>>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>> ---
>>>  drivers/thermal/samsung/exynos_tmu.c      |   10 ++++------
>>>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/s=
amsung/exynos_tmu.c
>>> index 97b87aa..082d5a2 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>> @@ -325,17 +325,15 @@ static void exynos_tmu_work(struct work_struct =
*work)
>>>                       struct exynos_tmu_data, irq_work);
>>>       struct exynos_tmu_platform_data *pdata =3D data->pdata;
>>>       struct exynos_tmu_registers *reg =3D pdata->registers;
>>> +     unsigned int val_irq;
>>>
>>>       exynos_report_trigger();
>>>       mutex_lock(&data->lock);
>>>       clk_enable(data->clk);
>>>
>>> -     if (data->soc =3D=3D SOC_ARCH_EXYNOS)
>>> -             writel((reg->inten_rise_mask << reg->inten_rise_shift) =
|
>>> -                     (reg->inten_fall_mask << reg->inten_fall_shift)=
,
>>> -                             data->base + reg->tmu_intclear);
>>> -     else
>>> -             writel(reg->inten_rise_mask, data->base + reg->tmu_intc=
lear);
>>> +     val_irq =3D readl(data->base + reg->tmu_intstat);
>>> +     /* clear the interrupts */
>>> +     writel(val_irq, data->base + reg->tmu_intclear);
>>>
>>
>> hmmm.. Don t you need to act accordingly depending on what is in your
>> int status?
>=20
> Earlier also it is done like this way. Basically core thermal layer
> checks temp for each trip so even if I check for which threshold
> interrupt is raised it is of no use. Anyway this is a TODO for me.
>=20

Please add  a /* TODO: */ entry then.

> Thanks,
> Amit Daniel
>>
>>>       clk_disable(data->clk);
>>>       mutex_unlock(&data->lock);
>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/ther=
mal/samsung/exynos_tmu_data.c
>>> index 3a1ded1..7322597 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>>> @@ -45,6 +45,7 @@ static struct exynos_tmu_registers exynos4210_tmu_r=
egisters =3D {
>>>       .inten_rise1_shift =3D EXYNOS_TMU_INTEN_RISE1_SHIFT,
>>>       .inten_rise2_shift =3D EXYNOS_TMU_INTEN_RISE2_SHIFT,
>>>       .inten_rise3_shift =3D EXYNOS_TMU_INTEN_RISE3_SHIFT,
>>> +     .tmu_intstat =3D EXYNOS_TMU_REG_INTSTAT,
>>>       .tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
>>>  };
>>>  struct exynos_tmu_platform_data const exynos4210_default_tmu_data =3D=
 {
>>> @@ -111,6 +112,7 @@ static struct exynos_tmu_registers exynos5250_tmu=
_registers =3D {
>>>       .inten_rise2_shift =3D EXYNOS_TMU_INTEN_RISE2_SHIFT,
>>>       .inten_rise3_shift =3D EXYNOS_TMU_INTEN_RISE3_SHIFT,
>>>       .inten_fall0_shift =3D EXYNOS_TMU_INTEN_FALL0_SHIFT,
>>> +     .tmu_intstat =3D EXYNOS_TMU_REG_INTSTAT,
>>>       .tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
>>>       .emul_con =3D EXYNOS_EMUL_CON,
>>>       .emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
>>>
>>
>>
>=20
>=20



------enig2TCTJLLKIIAIQSTMKGQKR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGNFQkACgkQCXcVR3XQvP3JhQD+LVEih4n5kDlucpm4mF4s5+/d
fIkGjA+THtXDaMrYKaoA/2nESwD1+UTDA1YgEyKDqsGhiIDby0YfzswAAfrcju2l
=oMc8
-----END PGP SIGNATURE-----

------enig2TCTJLLKIIAIQSTMKGQKR--
