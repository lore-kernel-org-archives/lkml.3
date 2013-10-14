Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3JNNrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:47:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47572 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3JNNrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:47:22 -0400
Message-ID: <525BF5DA.5020807@ti.com>
Date: Mon, 14 Oct 2013 09:47:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: <linux-pm@vger.kernel.org>, <naveenkrishna.ch@gmail.com>,
        <rui.zhang@intel.com>, <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.daniel@samsung.com>, <kgene.kim@samsung.com>,
        <devicetree@vger.kernel.org>, <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 2/3 v4] thermal: samsung: change base_common to more meaningful
 base_second
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com> <1381320509-23967-1-git-send-email-ch.naveen@samsung.com> <1381320509-23967-2-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1381320509-23967-2-git-send-email-ch.naveen@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="pwosi7DSjgeBCI6xsC10EiQpfMCgP5iXK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pwosi7DSjgeBCI6xsC10EiQpfMCgP5iXK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09-10-2013 08:08, Naveen Krishna Chatradhi wrote:
> On Exynos5440 and Exynos5420 there are registers common
> across the TMU channels.
>=20
> To support that, we introduced a ADDRESS_MULTIPLE flag in the
> driver and the 2nd set of register base and size are provided
> in the "reg" property of the node.
>=20
> As per Amit's suggestion, this patch changes the base_common
> to base_second and SHARED_MEMORY to ADDRESS_MULTIPLE.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v1:
>  None
> Changes since v2:
>  Changed the flag name from SHARED_MEMORY to ADDRESS_MULTIPLE.
>  https://lkml.org/lkml/2013/8/1/38
> Changes since v3:
>  None

 This patch generates build error:
 CC [M]  drivers/thermal/samsung/exynos_tmu.o
 drivers/thermal/samsung/exynos_tmu.c: In function 'exynos_map_dt_data':
 drivers/thermal/samsung/exynos_tmu.c:592:11: error: 'struct
exynos_tmu_data' has no member named 'base_common'
 make[3]: *** [drivers/thermal/samsung/exynos_tmu.o] Error 1
 make[2]: *** [drivers/thermal/samsung] Error 2
 make[1]: *** [drivers/thermal] Error 2
 make[1]: *** Waiting for unfinished jobs....


You've missed one occurrence while renaming the symbol:
diff --git a/drivers/thermal/samsung/exynos_tmu.c
b/drivers/thermal/samsung/exynos_tmu.c
index cd8dc12..ae80a87 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -589,7 +589,7 @@ static int exynos_map_dt_data(struct platform_device
*pdev)

        data->base_second =3D devm_ioremap(&pdev->dev, res.start,
                                        resource_size(&res));
-       if (!data->base_common) {
+       if (!data->base_second) {
                dev_err(&pdev->dev, "Failed to ioremap memory\n");
                return -ENOMEM;
        }

Please compile test your patch before submitting!

>=20
>  .../devicetree/bindings/thermal/exynos-thermal.txt         |    4 ++--=

>  drivers/thermal/samsung/exynos_tmu.c                       |   12 ++++=
++------
>  drivers/thermal/samsung/exynos_tmu.h                       |    4 ++--=

>  drivers/thermal/samsung/exynos_tmu_data.c                  |    2 +-
>  4 files changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 284f530..116cca0 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -11,8 +11,8 @@
>  - reg : Address range of the thermal registers. For soc's which has mu=
ltiple
>  	instances of TMU and some registers are shared across all TMU's like
>  	interrupt related then 2 set of register has to supplied. First set
> -	belongs	to each instance of TMU and second set belongs to common TMU
> -	registers.
> +	belongs	to each instance of TMU and second set belongs to second set
> +	of common TMU registers.
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index af69209..40c4243 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -41,7 +41,7 @@
>   * @id: identifier of the one instance of the TMU controller.
>   * @pdata: pointer to the tmu platform/configuration data
>   * @base: base address of the single instance of the TMU controller.
> - * @base_common: base address of the common registers of the TMU contr=
oller.
> + * @base_second: base address of the common registers of the TMU contr=
oller.
>   * @irq: irq number of the TMU controller.
>   * @soc: id of the SOC type.
>   * @irq_work: pointer to the irq work structure.
> @@ -56,7 +56,7 @@ struct exynos_tmu_data {
>  	int id;
>  	struct exynos_tmu_platform_data *pdata;
>  	void __iomem *base;
> -	void __iomem *base_common;
> +	void __iomem *base_second;
>  	int irq;
>  	enum soc_type soc;
>  	struct work_struct irq_work;
> @@ -297,7 +297,7 @@ skip_calib_data:
>  	}
>  	/*Clear the PMIN in the common TMU register*/
>  	if (reg->tmu_pmin && !data->id)
> -		writel(0, data->base_common + reg->tmu_pmin);
> +		writel(0, data->base_second + reg->tmu_pmin);
>  out:
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> @@ -451,7 +451,7 @@ static void exynos_tmu_work(struct work_struct *wor=
k)
> =20
>  	/* Find which sensor generated this interrupt */
>  	if (reg->tmu_irqstatus) {
> -		val_type =3D readl(data->base_common + reg->tmu_irqstatus);
> +		val_type =3D readl(data->base_second + reg->tmu_irqstatus);
>  		if (!((val_type >> data->id) & 0x1))
>  			goto out;
>  	}
> @@ -576,7 +576,7 @@ static int exynos_map_dt_data(struct platform_devic=
e *pdev)
>  	 * Check if the TMU shares some registers and then try to map the
>  	 * memory of common registers.
>  	 */
> -	if (!TMU_SUPPORTS(pdata, SHARED_MEMORY))
> +	if (!TMU_SUPPORTS(pdata, ADDRESS_MULTIPLE))
>  		return 0;
> =20
>  	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
> @@ -584,7 +584,7 @@ static int exynos_map_dt_data(struct platform_devic=
e *pdev)
>  		return -ENODEV;
>  	}
> =20
> -	data->base_common =3D devm_ioremap(&pdev->dev, res.start,
> +	data->base_second =3D devm_ioremap(&pdev->dev, res.start,
>  					resource_size(&res));
>  	if (!data->base_common) {
>  		dev_err(&pdev->dev, "Failed to ioremap memory\n");
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index 7c6c34a..ebd2ec1 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -59,7 +59,7 @@ enum soc_type {
>   *			state(active/idle) can be checked.
>   * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emula=
tion
>   *			sample time.
> - * TMU_SUPPORT_SHARED_MEMORY - This feature tells that the different T=
MU
> + * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the differen=
t TMU
>   *			sensors shares some common registers.
>   * TMU_SUPPORT - macro to compare the above features with the supplied=
=2E
>   */
> @@ -69,7 +69,7 @@ enum soc_type {
>  #define TMU_SUPPORT_FALLING_TRIP		BIT(3)
>  #define TMU_SUPPORT_READY_STATUS		BIT(4)
>  #define TMU_SUPPORT_EMUL_TIME			BIT(5)
> -#define TMU_SUPPORT_SHARED_MEMORY		BIT(6)
> +#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(6)
> =20
>  #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
> =20
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 23fea23..58570d0 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -239,7 +239,7 @@ static const struct exynos_tmu_registers exynos5440=
_tmu_registers =3D {
>  	.type =3D SOC_ARCH_EXYNOS5440, \
>  	.registers =3D &exynos5440_tmu_registers, \
>  	.features =3D (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
> -			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_SHARED_MEMORY),
> +			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
> =20
>  struct exynos_tmu_init_data const exynos5440_default_tmu_data =3D {
>  	.tmu_data =3D {
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--pwosi7DSjgeBCI6xsC10EiQpfMCgP5iXK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJb9d0ACgkQCXcVR3XQvP1IZAD+MfG4mhfhQyz41+aM79bZ0jE3
aeai9ar+Z4ME36Y1I0sA/3pRw3yqWqtKfwymNXv7TwOvR1GwDsLpmtJbl33zpuYf
=t6/A
-----END PGP SIGNATURE-----

--pwosi7DSjgeBCI6xsC10EiQpfMCgP5iXK--
