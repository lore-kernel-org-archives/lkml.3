Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3FDMzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:55:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57381 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab3FDMzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:55:40 -0400
Message-ID: <51ADE3B6.2050709@ti.com>
Date: Tue, 4 Jun 2013 08:55:18 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>
CC: <jonghwa3.lee@samsung.com>, <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V4 22/30] thermal: exynos: Add support for exynos5440
 TMU sensor.
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com> <1368525540-15034-23-git-send-email-amit.daniel@samsung.com> <51971046.3080201@samsung.com> <CADGdYn5WEhoAEyt6p6HsiE2Mz3O7StFBbq_0CKXZ0Fn9qcv=uw@mail.gmail.com>
In-Reply-To: <CADGdYn5WEhoAEyt6p6HsiE2Mz3O7StFBbq_0CKXZ0Fn9qcv=uw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2RCXKTSLXKWQLJBGGTVTX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2RCXKTSLXKWQLJBGGTVTX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04-06-2013 00:44, amit daniel kachhap wrote:
> Hi Jonghwa,
>=20
> Sorry for the late reply as I was on leave.
>=20
> On Sat, May 18, 2013 at 10:53 AM,  <jonghwa3.lee@samsung.com> wrote:
>> On 2013=EB=85=84 05=EC=9B=94 14=EC=9D=BC 18:58, Amit Daniel Kachhap wr=
ote:
>>
>>> This patch modifies TMU controller to add changes needed to work with=

>>> exynos5440 platform. This sensor registers 3 instance of the tmu cont=
roller
>>> with the thermal zone and hence reports 3 temperature output. This co=
ntroller
>>> supports upto five trip points. For critical threshold the driver use=
s the
>>> core driver thermal framework for shutdown.
>>>
>>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>> ---
>>>  .../devicetree/bindings/thermal/exynos-thermal.txt |   28 ++++++++++=
++-
>>>  drivers/thermal/samsung/exynos_tmu.c               |   43 ++++++++++=
+++++++--
>>>  drivers/thermal/samsung/exynos_tmu.h               |    6 +++
>>>  drivers/thermal/samsung/exynos_tmu_data.h          |    2 +
>>>  4 files changed, 72 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal=
=2Etxt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>> index 535fd0e..970eeba 100644
>>> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>> @@ -6,13 +6,16 @@
>>>              "samsung,exynos4412-tmu"
>>>              "samsung,exynos4210-tmu"
>>>              "samsung,exynos5250-tmu"
>>> +            "samsung,exynos5440-tmu"
>>>  - interrupt-parent : The phandle for the interrupt controller
>>> -- reg : Address range of the thermal registers
>>> +- reg : Address range of the thermal registers. For exynos5440-tmu w=
hich has 3
>>> +     instances of TMU, 2 set of register has to supplied. First set =
belongs
>>> +     to each instance of TMU and second set belongs to common TMU re=
gisters.
>>>  - interrupts : Should contain interrupt for thermal system
>>>  - clocks : The main clock for TMU device
>>>  - clock-names : Thermal system clock name
>>>
>>> -Example:
>>> +Example 1):
>>>
>>>       tmu@100C0000 {
>>>               compatible =3D "samsung,exynos4412-tmu";
>>> @@ -23,3 +26,24 @@ Example:
>>>               clock-names =3D "tmu_apbif";
>>>               status =3D "disabled";
>>>       };
>>> +
>>> +Example 2):
>>> +
>>> +     tmuctrl_0: tmuctrl@160118 {
>>> +             compatible =3D "samsung,exynos5440-tmu";
>>> +             reg =3D <0x160118 0x230>, <0x160368 0x10>;
>>> +             interrupts =3D <0 58 0>;
>>> +             clocks =3D <&clock 21>;
>>> +             clock-names =3D "tmu_apbif";
>>> +     };
>>> +
>>> +Note: For multi-instance tmu each instance should have an alias corr=
ectly
>>> +numbered in "aliases" node.
>>> +
>>> +Example:
>>> +
>>> +aliases {
>>> +     tmuctrl0 =3D &tmuctrl_0;
>>> +     tmuctrl1 =3D &tmuctrl_1;
>>> +     tmuctrl2 =3D &tmuctrl_2;
>>> +};
>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/s=
amsung/exynos_tmu.c
>>> index 7f7b1cf..7ca9c4d 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>> @@ -185,9 +185,11 @@ static int exynos_tmu_initialize(struct platform=
_device *pdev)
>>>                       reg->threshold_th0 + i * sizeof(reg->threshold_=
th0));
>>>
>>>               writel(reg->inten_rise_mask, data->base + reg->tmu_intc=
lear);
>>> -     } else if (data->soc =3D=3D SOC_ARCH_EXYNOS) {
>>> +     } else if (data->soc =3D=3D SOC_ARCH_EXYNOS ||
>>> +                     data->soc =3D=3D SOC_ARCH_EXYNOS5440) {
>>>               /* Write temperature code for rising and falling thresh=
old */
>>> -             for (i =3D 0; i < trigger_levs; i++) {
>>> +             for (i =3D 0;
>>> +             i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++=
) {
>>>                       threshold_code =3D temp_to_code(data,
>>>                                               pdata->trigger_levels[i=
]);
>>>                       if (threshold_code < 0) {
>>> @@ -218,7 +220,30 @@ static int exynos_tmu_initialize(struct platform=
_device *pdev)
>>>               writel((reg->inten_rise_mask << reg->inten_rise_shift) =
|
>>>                       (reg->inten_fall_mask << reg->inten_fall_shift)=
,
>>>                               data->base + reg->tmu_intclear);
>>> +
>>> +             /* if 5th threshold limit is also present, use TH2 regi=
ster */
>>> +             i =3D EXYNOS_MAX_TRIGGER_PER_REG;
>>> +             if (pdata->trigger_levels[i]) {
>>> +                     threshold_code =3D temp_to_code(data,
>>> +                                             pdata->trigger_levels[i=
]);
>>> +                     if (threshold_code < 0) {
>>> +                             ret =3D threshold_code;
>>> +                             goto out;
>>> +                     }
>>> +                     rising_threshold =3D
>>> +                             threshold_code << reg->threshold_th3_l0=
_shift;
>>> +                     writel(rising_threshold,
>>> +                             data->base + reg->threshold_th2);
>>> +                     if (pdata->trigger_type[i] =3D=3D HW_TRIP) {
>>> +                             con =3D readl(data->base + reg->tmu_ctr=
l);
>>> +                             con |=3D (1 << reg->therm_trip_en_shift=
);
>>> +                             writel(con, data->base + reg->tmu_ctrl)=
;
>>> +                     }
>>> +             }
>>>       }
>>> +     /*Clear the PMIN in the common TMU register*/
>>> +     if (reg->tmu_pmin && !data->id)
>>> +             writel(0, data->base_common + reg->tmu_pmin);
>>>  out:
>>>       clk_disable(data->clk);
>>>       mutex_unlock(&data->lock);
>>> @@ -345,7 +370,14 @@ static void exynos_tmu_work(struct work_struct *=
work)
>>>                       struct exynos_tmu_data, irq_work);
>>>       struct exynos_tmu_platform_data *pdata =3D data->pdata;
>>>       const struct exynos_tmu_registers *reg =3D pdata->registers;
>>> -     unsigned int val_irq;
>>> +     unsigned int val_irq, val_type;
>>> +
>>> +     /* Find which sensor generated this interrupt */
>>> +     if (reg->tmu_irqstatus) {
>>> +             val_type =3D readl(data->base_common + reg->tmu_irqstat=
us);
>>> +             if (!((val_type >> data->id) & 0x1))
>>> +                     goto out;
>>
>>
>> I have a question about your implementation for supporting EXYNOS5440.=

>> I don't know exactly how EXYNO5440's tmu is working, but just guess it=
 would be
>> similar with other EXYNOS series's without number of thermal sensors. =
(exclusive
>> register map and threshold level). Due to the multiple number of therm=
al sensor
>> in EXYNOS5440, it have multiple thermal zone devices and that's why it=
 just
>> leave interrupt pin in pending if interrupt is not its, right?
> Yes in 5440 the interrupt line is shared so pending bit is left unclear=
ed.
>>
>> So, my curious is, why we make all platform devices for each of therma=
l zone
>> devices? Why don't you just handle all thermal zone devices with one p=
latform
>> device?
> Your doubt is genuine. Let me justify my design decision.
> Initially I also thought of making a single platform device but since
> there are 3 different TMU controllers and register maps for 4 more so
> I followed this design as the driver looks clean and can be scalable
> easily. Also I agree that some resources like IRQ line is shared but
> it is due to h/w limitation.
> Also it is easy to cleanly control each TMU instance with the device
> tree data similar to I2C/SPI/MMC instance based device driver. Say I
> do not want to use 2nd sensor then just pass device tree data for 1st
> and 3rd sensor.
>>
>> Yes, It's probably right to make multiple devices node to support them=
, because
>> it has different physical hardware(sensors). But we have one TMU , don=
't we?
>> (Maybe my assumption is wrong, I assume that it has one TMU because it=
 looks
>> like it has only one irq line.). If I'm right, I think it is better to=
 manage
>> all thermal zone devices with one platform device. Then, we don't need=
 to leave
>> irq handler with leaving it pendded like above and also we may not nee=
d other
>> your patches like adding base_common iomem variable.
> Agreed that base_common variables is extra and present to handle the
> common part. I will further analyse your suggestion.
>=20

What is the relation TMU <--> temperature sensor? Is it one to one or
one to many?

> Thanks,
> Amit Daniel
>>
>> I'd like to listen your opinion about this.
>>
>> Thanks,
>> Jonghwa
>>
>>> +     }
>>>
>>>       exynos_report_trigger(data->reg_conf);
>>>       mutex_lock(&data->lock);
>>> @@ -358,7 +390,7 @@ static void exynos_tmu_work(struct work_struct *w=
ork)
>>>
>>>       clk_disable(data->clk);
>>>       mutex_unlock(&data->lock);
>>> -
>>> +out:
>>>       enable_irq(data->irq);
>>>  }
>>>
>>> @@ -520,7 +552,8 @@ static int exynos_tmu_probe(struct platform_devic=
e *pdev)
>>>               return ret;
>>>
>>>       if (pdata->type =3D=3D SOC_ARCH_EXYNOS ||
>>> -                             pdata->type =3D=3D SOC_ARCH_EXYNOS4210)=

>>> +             pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
>>> +                             pdata->type =3D=3D SOC_ARCH_EXYNOS5440)=

>>>               data->soc =3D pdata->type;
>>>       else {
>>>               ret =3D -EINVAL;
>>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/s=
amsung/exynos_tmu.h
>>> index 65443d7..9151a30 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu.h
>>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>>> @@ -44,6 +44,7 @@ enum trigger_type {
>>>  enum soc_type {
>>>       SOC_ARCH_EXYNOS4210 =3D 1,
>>>       SOC_ARCH_EXYNOS,
>>> +     SOC_ARCH_EXYNOS5440,
>>>  };
>>>
>>>  /**
>>> @@ -132,6 +133,8 @@ enum soc_type {
>>>   * @emul_temp_shift: shift bits of emulation temperature.
>>>   * @emul_time_shift: shift bits of emulation time.
>>>   * @emul_time_mask: mask bits of emulation time.
>>> + * @tmu_irqstatus: register to find which TMU generated interrupts.
>>> + * @tmu_pmin: register to get/set the Pmin value.
>>>   */
>>>  struct exynos_tmu_registers {
>>>       u32     triminfo_data;
>>> @@ -199,6 +202,9 @@ struct exynos_tmu_registers {
>>>       u32     emul_temp_shift;
>>>       u32     emul_time_shift;
>>>       u32     emul_time_mask;
>>> +
>>> +     u32     tmu_irqstatus;
>>> +     u32     tmu_pmin;
>>>  };
>>>
>>>  /**
>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/ther=
mal/samsung/exynos_tmu_data.h
>>> index 0e2244f..4acf070 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>>> @@ -91,6 +91,8 @@
>>>  #define EXYNOS_EMUL_DATA_MASK        0xFF
>>>  #define EXYNOS_EMUL_ENABLE   0x1
>>>
>>> +#define EXYNOS_MAX_TRIGGER_PER_REG   4
>>> +
>>>  #if defined(CONFIG_CPU_EXYNOS4210)
>>>  extern struct exynos_tmu_platform_data const exynos4210_default_tmu_=
data;
>>>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>>
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2RCXKTSLXKWQLJBGGTVTX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGt47YACgkQCXcVR3XQvP31zwEAmSZgdu0X5xf6qTp8Rbu90RSn
3bpBVHkYHl3FMg2i/RIBAOI2xdVkf6HtfOolgW4rkco0lFT6/B1KliiHHyAFWL/I
=nwen
-----END PGP SIGNATURE-----

------enig2RCXKTSLXKWQLJBGGTVTX--
