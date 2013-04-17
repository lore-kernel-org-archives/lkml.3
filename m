Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966042Ab3DQLGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:06:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24331 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965813Ab3DQLGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:06:50 -0400
X-AuditID: cbfee61a-b7fa86d0000045ae-88-516e8248308c
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linus.walleij@linaro.org, grant.likely@secretlab.ca
Cc: kyungmin.park@samsung.com, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH RFC 2/2] gpio: samsung: Remove OF support for Exynos4/5
Date: Wed, 17 Apr 2013 13:06:08 +0200
Message-id: <1366196768-19015-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1366134094-23140-1-git-send-email-s.nawrocki@samsung.com>
References: <1366134094-23140-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t9jAV2PprxAg/mdQhYHZj9ktXh1ZiOb
	Re+Cq2wWZ5vesFtM+bOcyeLyrjlsFqeuf2azOPymndXi2IwljA6cHneu7WHzOD9jIaPHlRNN
	rB59W1Yxevx8qePxeZNcAFsUl01Kak5mWWqRvl0CV0b/9QNsBeeNKzob7zM1MDZqdTFyckgI
	mEisXt7CBGGLSVy4t56ti5GLQ0hgEaPE1Dc7WUESQgIdTBILV5iC2GwChhK9R/sYQWwRAXOJ
	nmuLGEEamAW+M0q8vtMIlhAWcJc49ewemM0ioCrx5m8rkM3BwSvgJnH9lAGIKSGgIDFnkg1I
	BSdQ9ZOnB5kgVrlJ3D3+nGUCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHh9kxq
	B+PKBotDjAIcjEo8vBcKcgOFWBPLiitzDzFKcDArifAKN+YFCvGmJFZWpRblxxeV5qQWH2KU
	5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamDst/5QK75/klziNxu2gz/sHrIeLWjVmqmb
	XuVm23WuwtNo6tr/toUu54Um3Dgs+lrEJ+fhUcG5gSdsVPUd/T7wzAjZcYWtRCR9fsOvxvro
	Y9c4+478zre8am2Uvoq96HKL9kKOzvNT3JIvf1p/zuyaaPKGbxYrV3zem15gvIDz4PHiD4Y3
	r4YosRRnJBpqMRcVJwIAvQqO0DMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now when Exynos4 and Exynos5 SoC DT platforms use the pinctrl API
we can remove the interim OF support from this GPIO driver. There
should be no need any more to check the compatible property and to
find out if initialization of the GPIO driver should be skipped
we just check if OF tree is available.

Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpio/gpio-samsung.c |  106 +++----------------------------------------
 1 file changed, 6 insertions(+), 100 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 4fecfb8..e1c59c0 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2658,70 +2658,6 @@ static struct samsung_gpio_chip exynos5_gpios_4[] = {
 };
 #endif

-
-#if defined(CONFIG_ARCH_EXYNOS) && defined(CONFIG_OF)
-static int exynos_gpio_xlate(struct gpio_chip *gc,
-			const struct of_phandle_args *gpiospec, u32 *flags)
-{
-	unsigned int pin;
-
-	if (WARN_ON(gc->of_gpio_n_cells < 4))
-		return -EINVAL;
-
-	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
-		return -EINVAL;
-
-	if (gpiospec->args[0] > gc->ngpio)
-		return -EINVAL;
-
-	pin = gc->base + gpiospec->args[0];
-
-	if (s3c_gpio_cfgpin(pin, S3C_GPIO_SFN(gpiospec->args[1])))
-		pr_warn("gpio_xlate: failed to set pin function\n");
-	if (s3c_gpio_setpull(pin, gpiospec->args[2] & 0xffff))
-		pr_warn("gpio_xlate: failed to set pin pull up/down\n");
-	if (s5p_gpio_set_drvstr(pin, gpiospec->args[3]))
-		pr_warn("gpio_xlate: failed to set pin drive strength\n");
-
-	if (flags)
-		*flags = gpiospec->args[2] >> 16;
-
-	return gpiospec->args[0];
-}
-
-static const struct of_device_id exynos_gpio_dt_match[] __initdata = {
-	{ .compatible = "samsung,exynos4-gpio", },
-	{}
-};
-
-static __init void exynos_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
-						u64 base, u64 offset)
-{
-	struct gpio_chip *gc =  &chip->chip;
-	u64 address;
-
-	if (!of_have_populated_dt())
-		return;
-
-	address = chip->base ? base + ((u32)chip->base & 0xfff) : base + offset;
-	gc->of_node = of_find_matching_node_by_address(NULL,
-			exynos_gpio_dt_match, address);
-	if (!gc->of_node) {
-		pr_info("gpio: device tree node not found for gpio controller"
-			" with base address %08llx\n", address);
-		return;
-	}
-	gc->of_gpio_n_cells = 4;
-	gc->of_xlate = exynos_gpio_xlate;
-}
-#elif defined(CONFIG_ARCH_EXYNOS)
-static __init void exynos_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
-						u64 base, u64 offset)
-{
-	return;
-}
-#endif /* defined(CONFIG_ARCH_EXYNOS) && defined(CONFIG_OF) */
-
 static __init void exynos4_gpiolib_init(void)
 {
 #ifdef CONFIG_CPU_EXYNOS4210
@@ -2746,8 +2682,6 @@ static __init void exynos4_gpiolib_init(void)
 			chip->config = &exynos_gpio_cfg;
 			chip->group = group++;
 		}
-		exynos_gpiolib_attach_ofnode(chip,
-				EXYNOS4_PA_GPIO1, i * 0x20);
 	}
 	samsung_gpiolib_add_4bit_chips(exynos4_gpios_1,
 				       nr_chips, gpio_base1);
@@ -2773,8 +2707,6 @@ static __init void exynos4_gpiolib_init(void)
 			chip->config = &exynos_gpio_cfg;
 			chip->group = group++;
 		}
-		exynos_gpiolib_attach_ofnode(chip,
-				EXYNOS4_PA_GPIO2, i * 0x20);
 	}
 	samsung_gpiolib_add_4bit_chips(exynos4_gpios_2,
 				       nr_chips, gpio_base2);
@@ -2794,8 +2726,6 @@ static __init void exynos4_gpiolib_init(void)
 			chip->config = &exynos_gpio_cfg;
 			chip->group = group++;
 		}
-		exynos_gpiolib_attach_ofnode(chip,
-				EXYNOS4_PA_GPIO3, i * 0x20);
 	}
 	samsung_gpiolib_add_4bit_chips(exynos4_gpios_3,
 				       nr_chips, gpio_base3);
@@ -2849,8 +2779,6 @@ static __init void exynos5_gpiolib_init(void)
 			chip->config = &exynos_gpio_cfg;
 			chip->group = group++;
 		}
-		exynos_gpiolib_attach_ofnode(chip,
-				EXYNOS5_PA_GPIO1, i * 0x20);
 	}
 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_1,
 				       nr_chips, gpio_base1);
@@ -2870,8 +2798,6 @@ static __init void exynos5_gpiolib_init(void)
 			chip->config = &exynos_gpio_cfg;
 			chip->group = group++;
 		}
-		exynos_gpiolib_attach_ofnode(chip,
-				EXYNOS5_PA_GPIO2, i * 0x20);
 	}
 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_2,
 				       nr_chips, gpio_base2);
@@ -2898,8 +2824,6 @@ static __init void exynos5_gpiolib_init(void)
 			chip->config = &exynos_gpio_cfg;
 			chip->group = group++;
 		}
-		exynos_gpiolib_attach_ofnode(chip,
-				EXYNOS5_PA_GPIO3, i * 0x20);
 	}
 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_3,
 				       nr_chips, gpio_base3);
@@ -2919,8 +2843,6 @@ static __init void exynos5_gpiolib_init(void)
 			chip->config = &exynos_gpio_cfg;
 			chip->group = group++;
 		}
-		exynos_gpiolib_attach_ofnode(chip,
-				EXYNOS5_PA_GPIO4, i * 0x20);
 	}
 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_4,
 				       nr_chips, gpio_base4);
@@ -2945,29 +2867,13 @@ static __init int samsung_gpiolib_init(void)
 	int i, nr_chips;
 	int group = 0;

-#if defined(CONFIG_PINCTRL_EXYNOS) || defined(CONFIG_PINCTRL_EXYNOS5440)
 	/*
-	* This gpio driver includes support for device tree support and there
-	* are platforms using it. In order to maintain compatibility with those
-	* platforms, and to allow non-dt Exynos4210 platforms to use this
-	* gpiolib support, a check is added to find out if there is a active
-	* pin-controller driver support available. If it is available, this
-	* gpiolib support is ignored and the gpiolib support available in
-	* pin-controller driver is used. This is a temporary check and will go
-	* away when all of the Exynos4210 platforms have switched to using
-	* device tree and the pin-ctrl driver.
-	*/
-	struct device_node *pctrl_np;
-	static const struct of_device_id exynos_pinctrl_ids[] = {
-		{ .compatible = "samsung,exynos4210-pinctrl", },
-		{ .compatible = "samsung,exynos4x12-pinctrl", },
-		{ .compatible = "samsung,exynos5440-pinctrl", },
-		{ }
-	};
-	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
-		if (pctrl_np && of_device_is_available(pctrl_np))
-			return -ENODEV;
-#endif
+	 * All Samsung platforms that support device tree will use the pinctrl
+	 * driver, hence we skip initialization of this driver if the OF tree
+	 * is available.
+	 */
+	if (of_have_populated_dt())
+		return -ENODEV;

 	samsung_gpiolib_set_cfg(samsung_gpio_cfgs, ARRAY_SIZE(samsung_gpio_cfgs));

--
1.7.9.5

