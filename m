Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935554Ab3FTCHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:07:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53605 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935237Ab3FTCHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:07:04 -0400
Message-ID: <51C263BB.6020700@ti.com>
Date: Wed, 19 Jun 2013 22:06:51 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 23/30] thermal: exynos: Add driver support for exynos5440
 TMU sensor
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-24-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-24-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2MTLQVKSWDNUAIPLAKNAO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2MTLQVKSWDNUAIPLAKNAO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch modifies TMU controller to add changes needed to work with
> exynos5440 platform. This sensor registers 3 instance of the tmu contro=
ller
> with the thermal zone and hence reports 3 temperature output. This cont=
roller
> supports upto five trip points. For critical threshold the driver uses =
the
> core driver thermal framework for shutdown.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   24 ++++++++-
>  drivers/thermal/samsung/exynos_thermal_common.h    |    2 +-
>  drivers/thermal/samsung/exynos_tmu.c               |   54 ++++++++++++=
+++++---
>  drivers/thermal/samsung/exynos_tmu.h               |    6 ++
>  drivers/thermal/samsung/exynos_tmu_data.h          |   36 ++++++++++++=
+
>  5 files changed, 112 insertions(+), 10 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 0ea33f7..e6386ea 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -6,6 +6,7 @@
>  	       "samsung,exynos4412-tmu"
>  	       "samsung,exynos4210-tmu"
>  	       "samsung,exynos5250-tmu"
> +	       "samsung,exynos5440-tmu"
>  - interrupt-parent : The phandle for the interrupt controller
>  - reg : Address range of the thermal registers. For soc's which has mu=
ltiple
>  	instances of TMU and some registers are shared across all TMU's like
> @@ -16,7 +17,7 @@
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> =20
> -Example:
> +Example 1):
> =20
>  	tmu@100C0000 {
>  		compatible =3D "samsung,exynos4412-tmu";
> @@ -27,3 +28,24 @@ Example:
>  		clock-names =3D "tmu_apbif";
>  		status =3D "disabled";
>  	};
> +
> +Example 2):
> +
> +	tmuctrl_0: tmuctrl@160118 {
> +		compatible =3D "samsung,exynos5440-tmu";
> +		reg =3D <0x160118 0x230>, <0x160368 0x10>;
> +		interrupts =3D <0 58 0>;
> +		clocks =3D <&clock 21>;
> +		clock-names =3D "tmu_apbif";
> +	};
> +
> +Note: For multi-instance tmu each instance should have an alias correc=
tly
> +numbered in "aliases" node.
> +
> +Example:
> +
> +aliases {
> +	tmuctrl0 =3D &tmuctrl_0;
> +	tmuctrl1 =3D &tmuctrl_1;
> +	tmuctrl2 =3D &tmuctrl_2;
> +};
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/=
thermal/samsung/exynos_thermal_common.h
> index 0c189d6..7d7c29a 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -27,7 +27,7 @@
>  #define SENSOR_NAME_LEN	16
>  #define MAX_TRIP_COUNT	8
>  #define MAX_COOLING_DEVICE 4
> -#define MAX_THRESHOLD_LEVS 4
> +#define MAX_THRESHOLD_LEVS 5
> =20
>  #define ACTIVE_INTERVAL 500
>  #define IDLE_INTERVAL 10000
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 150a869..db4035d 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -156,7 +156,26 @@ static int exynos_tmu_initialize(struct platform_d=
evice *pdev)
>  		__raw_writel(1, data->base + reg->triminfo_ctrl);
> =20
>  	/* Save trimming info in order to perform calibration */
> -	trim_info =3D readl(data->base + reg->triminfo_data);
> +	if (data->soc =3D=3D SOC_ARCH_EXYNOS5440) {

should this become some bit at your pdata->features? TMU_SUPPORTS(pdata,
TRIMINFO) for instance?

> +		/*
> +		 * For exynos5440 soc triminfo value is swapped between TMU0 and
> +		 * TMU2, so the below logic is needed.
> +		 */
> +		switch (data->id) {
> +		case 0:
> +			trim_info =3D readl(data->base +
> +			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
> +			break;
> +		case 1:
> +			trim_info =3D readl(data->base + reg->triminfo_data);
> +			break;
> +		case 2:
> +			trim_info =3D readl(data->base -
> +			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
> +		}
> +	} else {
> +		trim_info =3D readl(data->base + reg->triminfo_data);
> +	}
>  	data->temp_error1 =3D trim_info & EXYNOS_TMU_TEMP_MASK;
>  	data->temp_error2 =3D ((trim_info >> reg->triminfo_85_shift) &
>  				EXYNOS_TMU_TEMP_MASK);
> @@ -201,7 +220,8 @@ static int exynos_tmu_initialize(struct platform_de=
vice *pdev)
>  			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
> =20
>  		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
> -	} else if (data->soc =3D=3D SOC_ARCH_EXYNOS) {
> +	} else if (data->soc =3D=3D SOC_ARCH_EXYNOS ||
> +			data->soc =3D=3D SOC_ARCH_EXYNOS5440) {
>  		/* Write temperature code for rising and falling threshold */
>  		for (i =3D 0;
>  		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
> @@ -241,14 +261,24 @@ static int exynos_tmu_initialize(struct platform_=
device *pdev)
>  				ret =3D threshold_code;
>  				goto out;
>  			}
> -			rising_threshold |=3D threshold_code << 8 * i;
> -			writel(rising_threshold,
> -				data->base + reg->threshold_th0);
> +			if (data->soc =3D=3D SOC_ARCH_EXYNOS) {
> +				rising_threshold |=3D threshold_code << 8 * i;
> +				writel(rising_threshold,
> +					data->base + reg->threshold_th0);
> +			} else if (data->soc =3D=3D SOC_ARCH_EXYNOS5440) {

Can these ifs be translated to some TMU_SUPPORTS()?

Just wondering if it is possible to get rid of data->soc flags and use
only features or represent the shifts as fields inside your pdata.

> +				rising_threshold =3D
> +				threshold_code << reg->threshold_th3_l0_shift;
> +				writel(rising_threshold,
> +					data->base + reg->threshold_th2);
> +			}
>  			con =3D readl(data->base + reg->tmu_ctrl);
>  			con |=3D (1 << reg->therm_trip_en_shift);
>  			writel(con, data->base + reg->tmu_ctrl);
>  		}
>  	}
> +	/*Clear the PMIN in the common TMU register*/
> +	if (reg->tmu_pmin && !data->id)
> +		writel(0, data->base_common + reg->tmu_pmin);

What happens to other TMU instances when one of them performs this
operation? does it need to serialized?

>  out:
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> @@ -377,7 +407,14 @@ static void exynos_tmu_work(struct work_struct *wo=
rk)
>  			struct exynos_tmu_data, irq_work);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	const struct exynos_tmu_registers *reg =3D pdata->registers;
> -	unsigned int val_irq;
> +	unsigned int val_irq, val_type;
> +
> +	/* Find which sensor generated this interrupt */
> +	if (reg->tmu_irqstatus) {
> +		val_type =3D readl(data->base_common + reg->tmu_irqstatus);
> +		if (!((val_type >> data->id) & 0x1))
> +			goto out;
> +	}
> =20
>  	exynos_report_trigger(data->reg_conf);
>  	mutex_lock(&data->lock);
> @@ -390,7 +427,7 @@ static void exynos_tmu_work(struct work_struct *wor=
k)
> =20
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> -
> +out:
>  	enable_irq(data->irq);
>  }
> =20
> @@ -544,7 +581,8 @@ static int exynos_tmu_probe(struct platform_device =
*pdev)
>  		return ret;
> =20
>  	if (pdata->type =3D=3D SOC_ARCH_EXYNOS ||
> -				pdata->type =3D=3D SOC_ARCH_EXYNOS4210)
> +		pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
> +				pdata->type =3D=3D SOC_ARCH_EXYNOS5440)
>  		data->soc =3D pdata->type;
>  	else {
>  		ret =3D -EINVAL;
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index 6f55673..73aaed7 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -38,6 +38,7 @@ enum calibration_mode {
>  enum soc_type {
>  	SOC_ARCH_EXYNOS4210 =3D 1,
>  	SOC_ARCH_EXYNOS,
> +	SOC_ARCH_EXYNOS5440,
>  };
> =20
>  /**
> @@ -129,6 +130,8 @@ enum soc_type {
>   * @emul_temp_shift: shift bits of emulation temperature.
>   * @emul_time_shift: shift bits of emulation time.
>   * @emul_time_mask: mask bits of emulation time.
> + * @tmu_irqstatus: register to find which TMU generated interrupts.
> + * @tmu_pmin: register to get/set the Pmin value.
>   */
>  struct exynos_tmu_registers {
>  	u32	triminfo_data;
> @@ -196,6 +199,9 @@ struct exynos_tmu_registers {
>  	u32	emul_temp_shift;
>  	u32	emul_time_shift;
>  	u32	emul_time_mask;
> +
> +	u32	tmu_irqstatus;
> +	u32	tmu_pmin;
>  };
> =20
>  /**
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index 139dbbb..ad263e9 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -93,6 +93,42 @@
> =20
>  #define EXYNOS_MAX_TRIGGER_PER_REG	4
> =20
> +/*exynos5440 specific registers*/
> +#define EXYNOS5440_TMU_S0_7_TRIM		0x000
> +#define EXYNOS5440_TMU_S0_7_CTRL		0x020
> +#define EXYNOS5440_TMU_S0_7_DEBUG		0x040
> +#define EXYNOS5440_TMU_S0_7_STATUS		0x060
> +#define EXYNOS5440_TMU_S0_7_TEMP		0x0f0
> +#define EXYNOS5440_TMU_S0_7_TH0			0x110
> +#define EXYNOS5440_TMU_S0_7_TH1			0x130
> +#define EXYNOS5440_TMU_S0_7_TH2			0x150
> +#define EXYNOS5440_TMU_S0_7_EVTEN		0x1F0
> +#define EXYNOS5440_TMU_S0_7_IRQEN		0x210
> +#define EXYNOS5440_TMU_S0_7_IRQ			0x230
> +/* exynos5440 common registers */
> +#define EXYNOS5440_TMU_IRQ_STATUS		0x000
> +#define EXYNOS5440_TMU_PMIN			0x004
> +#define EXYNOS5440_TMU_TEMP			0x008
> +
> +#define EXYNOS5440_TMU_RISE_INT_MASK		0xf
> +#define EXYNOS5440_TMU_RISE_INT_SHIFT		0
> +#define EXYNOS5440_TMU_FALL_INT_MASK		0xf
> +#define EXYNOS5440_TMU_FALL_INT_SHIFT		4
> +#define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
> +#define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
> +#define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
> +#define EXYNOS5440_TMU_INTEN_RISE3_SHIFT	3
> +#define EXYNOS5440_TMU_INTEN_FALL0_SHIFT	4
> +#define EXYNOS5440_TMU_INTEN_FALL1_SHIFT	5
> +#define EXYNOS5440_TMU_INTEN_FALL2_SHIFT	6
> +#define EXYNOS5440_TMU_INTEN_FALL3_SHIFT	7
> +#define EXYNOS5440_TMU_TH_RISE0_SHIFT		0
> +#define EXYNOS5440_TMU_TH_RISE1_SHIFT		8
> +#define EXYNOS5440_TMU_TH_RISE2_SHIFT		16
> +#define EXYNOS5440_TMU_TH_RISE3_SHIFT		24
> +#define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
> +#define EXYNOS5440_EFUSE_SWAP_OFFSET		8
> +
>  #if defined(CONFIG_CPU_EXYNOS4210)
>  extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2MTLQVKSWDNUAIPLAKNAO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCY7sACgkQCXcVR3XQvP1kvwD7B0WwEMe/Hkuu+JXcLcGHSIX1
NLpcpR6tAI0pGvsG2hAA/icSzIjBsLmjc71KQngasTSfQOqEDJkEZx29fr3ln+n8
=WYGn
-----END PGP SIGNATURE-----

------enig2MTLQVKSWDNUAIPLAKNAO--
