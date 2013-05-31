Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3EaP3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:29:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38708 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab3EaP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:29:13 -0400
Message-ID: <51A8C1B6.5080105@ti.com>
Date: Fri, 31 May 2013 11:28:54 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: <jonghwa3.lee@samsung.com>
CC: Amit Daniel Kachhap <amit.daniel@samsung.com>, <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amit.kachhap@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V4 22/30] thermal: exynos: Add support for exynos5440
 TMU sensor.
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com> <1368525540-15034-23-git-send-email-amit.daniel@samsung.com> <51971046.3080201@samsung.com>
In-Reply-To: <51971046.3080201@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2DFNDCSAVEDWVRSFUUCTS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2DFNDCSAVEDWVRSFUUCTS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Amit and Jonghwa,

On 18-05-2013 01:23, jonghwa3.lee@samsung.com wrote:
> On 2013=EB=85=84 05=EC=9B=94 14=EC=9D=BC 18:58, Amit Daniel Kachhap wro=
te:
>=20
>> This patch modifies TMU controller to add changes needed to work with
>> exynos5440 platform. This sensor registers 3 instance of the tmu contr=
oller
>> with the thermal zone and hence reports 3 temperature output. This con=
troller
>> supports upto five trip points. For critical threshold the driver uses=
 the
>> core driver thermal framework for shutdown.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  .../devicetree/bindings/thermal/exynos-thermal.txt |   28 +++++++++++=
+-
>>  drivers/thermal/samsung/exynos_tmu.c               |   43 +++++++++++=
++++++--
>>  drivers/thermal/samsung/exynos_tmu.h               |    6 +++
>>  drivers/thermal/samsung/exynos_tmu_data.h          |    2 +
>>  4 files changed, 72 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.=
txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> index 535fd0e..970eeba 100644

<cut>

>> +			goto out;
>=20
>=20
> I have a question about your implementation for supporting EXYNOS5440.
> I don't know exactly how EXYNO5440's tmu is working, but just guess it =
would be
> similar with other EXYNOS series's without number of thermal sensors. (=
exclusive
> register map and threshold level). Due to the multiple number of therma=
l sensor
> in EXYNOS5440, it have multiple thermal zone devices and that's why it =
just
> leave interrupt pin in pending if interrupt is not its, right?
>=20
> So, my curious is, why we make all platform devices for each of thermal=
 zone
> devices? Why don't you just handle all thermal zone devices with one pl=
atform
> device?
>=20
> Yes, It's probably right to make multiple devices node to support them,=
 because
> it has different physical hardware(sensors). But we have one TMU , don'=
t we?
> (Maybe my assumption is wrong, I assume that it has one TMU because it =
looks
> like it has only one irq line.). If I'm right, I think it is better to =
manage
> all thermal zone devices with one platform device. Then, we don't need =
to leave
> irq handler with leaving it pendded like above and also we may not need=
 other
> your patches like adding base_common iomem variable.
>=20
> I'd like to listen your opinion about this.
>=20


I understand the concern risen by Jonghwa. In fact, this is a bit
confusing. The way I have decided to design the driver for TI
(drivers/thermal/ti-soc-thermal under thermal tree next branch) is to
have one platform device for the bandgap IP (that would be probably
equivalent of  your TMU).

Reasoning is to have a exact match between platform device and real HW
device interface. Thus its device resources are belonging to one single
device node. In TIs case, the resources, regarding IRQs, IO map area,
registers, etc, are belonging to the bandgap IP not to sensors. That
alone convinced me to use one single device node, instead of several,
per sensor. In fact, for OMAP devices it is a bit more complicated as
the bandgap is actually behind the control module, which holds the
interface. But that is another story.

So, in this case I decided to have 1 single platform device representing
the bandgap IP, which exposes and handles several thermal zones (one per
sensor). And of course, owns and manages all related resources (IRQ,
gpio and IO mem area).

To what I have understood of your case, I believe it is the very same
case, so I would recommend reusing the proposed design.

Keep in mind that this obviously does not stop you of having different
policies or trip setups per sensor. The framework is flexible in this sen=
se.

I hope this helps.

> Thanks,
> Jonghwa
>=20
>> +	}
>> =20
>>  	exynos_report_trigger(data->reg_conf);
>>  	mutex_lock(&data->lock);
>> @@ -358,7 +390,7 @@ static void exynos_tmu_work(struct work_struct *wo=
rk)
>> =20
>>  	clk_disable(data->clk);
>>  	mutex_unlock(&data->lock);
>> -
>> +out:
>>  	enable_irq(data->irq);
>>  }
>> =20
>> @@ -520,7 +552,8 @@ static int exynos_tmu_probe(struct platform_device=
 *pdev)
>>  		return ret;
>> =20
>>  	if (pdata->type =3D=3D SOC_ARCH_EXYNOS ||
>> -				pdata->type =3D=3D SOC_ARCH_EXYNOS4210)
>> +		pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
>> +				pdata->type =3D=3D SOC_ARCH_EXYNOS5440)
>>  		data->soc =3D pdata->type;
>>  	else {
>>  		ret =3D -EINVAL;
>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sa=
msung/exynos_tmu.h
>> index 65443d7..9151a30 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -44,6 +44,7 @@ enum trigger_type {
>>  enum soc_type {
>>  	SOC_ARCH_EXYNOS4210 =3D 1,
>>  	SOC_ARCH_EXYNOS,
>> +	SOC_ARCH_EXYNOS5440,
>>  };
>> =20
>>  /**
>> @@ -132,6 +133,8 @@ enum soc_type {
>>   * @emul_temp_shift: shift bits of emulation temperature.
>>   * @emul_time_shift: shift bits of emulation time.
>>   * @emul_time_mask: mask bits of emulation time.
>> + * @tmu_irqstatus: register to find which TMU generated interrupts.
>> + * @tmu_pmin: register to get/set the Pmin value.
>>   */
>>  struct exynos_tmu_registers {
>>  	u32	triminfo_data;
>> @@ -199,6 +202,9 @@ struct exynos_tmu_registers {
>>  	u32	emul_temp_shift;
>>  	u32	emul_time_shift;
>>  	u32	emul_time_mask;
>> +
>> +	u32	tmu_irqstatus;
>> +	u32	tmu_pmin;
>>  };
>> =20
>>  /**
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therm=
al/samsung/exynos_tmu_data.h
>> index 0e2244f..4acf070 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>> @@ -91,6 +91,8 @@
>>  #define EXYNOS_EMUL_DATA_MASK	0xFF
>>  #define EXYNOS_EMUL_ENABLE	0x1
>> =20
>> +#define EXYNOS_MAX_TRIGGER_PER_REG	4
>> +
>>  #if defined(CONFIG_CPU_EXYNOS4210)
>>  extern struct exynos_tmu_platform_data const exynos4210_default_tmu_d=
ata;
>>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2DFNDCSAVEDWVRSFUUCTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGowbYACgkQCXcVR3XQvP18ewEA6b9ZjnckaGlWNKqB3LQ8SKqc
TtMquyg+DVWw6Ibrm9kBALa6Gjk8/r93fy8qBm5NXTYFUOnACKduT3Ae8BvDIcWE
=ysO8
-----END PGP SIGNATURE-----

------enig2DFNDCSAVEDWVRSFUUCTS--
