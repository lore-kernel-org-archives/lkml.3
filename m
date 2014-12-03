Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaLCM0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:26:46 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:63481 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaLCM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAM4voam99ONvnov98fYk+8srJ27ySvsBKL4CAf-9gWUiWcpgwQ@mail.gmail.com>
References: <1416963070-5806-1-git-send-email-a.kesavan@samsung.com>
	<20141126144504.GA3808@developer>
	<CAM4voa=OidszVoxRCnXPTKTyGZn5QXv7YWgGRF+JyHmHi+SCPw@mail.gmail.com>
	<20141126151435.GB3925@developer>
	<CAM4voam99ONvnov98fYk+8srJ27ySvsBKL4CAf-9gWUiWcpgwQ@mail.gmail.com>
Date: Wed, 3 Dec 2014 17:56:43 +0530
Message-ID: <CAM4voakcd2ztCwEGHVPTXmpkK=J30YFxFe82HUHbuHr_KHw=Rg@mail.gmail.com>
Subject: Re: [PATCH v2] thermal: exynos: add special clock support
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Amit Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej and Lukasz,

On Wed, Nov 26, 2014 at 9:01 PM, Abhilash Kesavan
<kesavan.abhilash@gmail.com> wrote:
> Hi Eduardo,
>
> On Wed, Nov 26, 2014 at 8:44 PM, Eduardo Valentin <edubezval@gmail.com> wrote:
>> Abhilash,
>>
>> On Wed, Nov 26, 2014 at 08:34:19PM +0530, Abhilash Kesavan wrote:
>>> Hi Eduardo,
>>>
>>> On Wed, Nov 26, 2014 at 8:15 PM, Eduardo Valentin <edubezval@gmail.com> wrote:
>>> >
>>> > Abhilash,
>>> >
>>> > On Wed, Nov 26, 2014 at 06:21:10AM +0530, Abhilash Kesavan wrote:
>>> >> Exynos7 has a special clock required for the functional operation
>>> >> of the TMU that is not present in earlier SoCs. Add support for
>>> >> this clock and update the binding documentation.
>>> >>
>>> >> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
>>> >> ---
>>> >> Changes since v1:
>>> >>       - Added a per-soc flag to indicate the presence of special clock
>>> >>       - Changed the name of special clock from "tmu_sclk" to "sclk"
>>> >>       - Fixed the error handling for sclk
>>> >>
>>> >> Tested on 5420 and 5800 based chromebooks, no change in existing behavior.
>>> >>
>>> >>  .../devicetree/bindings/thermal/exynos-thermal.txt |    3 ++
>>> >>  drivers/thermal/samsung/exynos_tmu.c               |   31 ++++++++++++++++----
>>> >>  2 files changed, 29 insertions(+), 5 deletions(-)
>>> >>
>>> >> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>> >> index ae738f5..acf4705 100644
>>> >> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>> >> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>> >> @@ -32,10 +32,13 @@
>>> >>  - clocks : The main clocks for TMU device
>>> >>       -- 1. operational clock for TMU channel
>>> >>       -- 2. optional clock to access the shared registers of TMU channel
>>> >> +     -- 3. optional special clock for functional operation
>>> >>  - clock-names : Thermal system clock name
>>> >>       -- "tmu_apbif" operational clock for current TMU channel
>>> >>       -- "tmu_triminfo_apbif" clock to access the shared triminfo register
>>> >>               for current TMU channel
>>> >> +     -- "sclk" clock for functional operation of the current TMU
>>> >> +             channel
>>> >>  - vtmu-supply: This entry is optional and provides the regulator node supplying
>>> >>               voltage to TMU. If needed this entry can be placed inside
>>> >>               board/platform specific dts file.
>>> >> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>>> >> index d44d91d..8ed8409 100644
>>> >> --- a/drivers/thermal/samsung/exynos_tmu.c
>>> >> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>> >> @@ -123,11 +123,14 @@
>>> >>   * @base: base address of the single instance of the TMU controller.
>>> >>   * @base_second: base address of the common registers of the TMU controller.
>>> >>   * @irq: irq number of the TMU controller.
>>> >> + * @needs_sclk: SoC specific flag indicating that sclk is required for
>>> >> +     functional operation of the TMU controller.
>>> >>   * @soc: id of the SOC type.
>>> >>   * @irq_work: pointer to the irq work structure.
>>> >>   * @lock: lock to implement synchronization.
>>> >>   * @clk: pointer to the clock structure.
>>> >>   * @clk_sec: pointer to the clock structure for accessing the base_second.
>>> >> + * @sclk: pointer to the clock structure for accessing the tmu special clock.
>>> >>   * @temp_error1: fused value of the first point trim.
>>> >>   * @temp_error2: fused value of the second point trim.
>>> >>   * @regulator: pointer to the TMU regulator structure.
>>> >> @@ -144,10 +147,11 @@ struct exynos_tmu_data {
>>> >>       void __iomem *base;
>>> >>       void __iomem *base_second;
>>> >>       int irq;
>>> >> +     bool needs_sclk;
>>> >>       enum soc_type soc;
>>> >>       struct work_struct irq_work;
>>> >>       struct mutex lock;
>>> >> -     struct clk *clk, *clk_sec;
>>> >> +     struct clk *clk, *clk_sec, *sclk;
>>> >>       u8 temp_error1, temp_error2;
>>> >>       struct regulator *regulator;
>>> >>       struct thermal_sensor_conf *reg_conf;
>>> >> @@ -883,10 +887,24 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>> >>               goto err_clk_sec;
>>> >>       }
>>> >>
>>> >> +     if (data->needs_sclk) {
>>> >
>>> > Based on the trend we see from Bartlomiej's and Lukasz' works, you
>>> > should be asking for SoC version, not adding a flag. Can you please
>>> > crosscheck with them?
>>>
>>> I planned to populate this flag as true for Exynos7 in
>>> exynos_map_dt_data() where other soc specific methods are being setup.
>>
>> Well, that I wouldn't expect different, otherwise how your code is
>> supposed to work, right?
>
> yes :)
>
>>
>>>
>>> Bartlomiej/Lukasz can you kindly comment on if you would prefer the
>>> check to be based on the SoC version.
>>>
>>
>>
>> Have a look on how Bartz has removed the flag based code in my -linus
>> branch. Here is an example:
>> https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux-soc-thermal.git/commit/?h=linus&id=ef3f80fc7f79c32a1b015afcbffce2a2630011a4
>
> OK, I see what you mean. I'll wait for Bartlomiej and Lukasz to weigh
> in as well. If they are in favor of using the SoC version then I will
> fold this into the patch adding support for Exynos7 (to be posted
> after all of Lukasz' patches are in)

Can you comment on the preffered approach ?

Thanks,
Abhilash
>
> Thanks,
> Abhilash
>>
>>> Regards,
>>> Abhilash
>>> >
>>> > Cheers,
>>> >
>>> > Eduardo Valentin
>>> >
>>> >> +             data->sclk = devm_clk_get(&pdev->dev, "sclk");
>>> >> +             if (IS_ERR(data->sclk)) {
>>> >> +                     dev_err(&pdev->dev, "Failed to get sclk\n");
>>> >> +                     goto err_clk;
>>> >> +             } else {
>>> >> +                     ret = clk_prepare_enable(data->sclk);
>>> >> +                     if (ret) {
>>> >> +                             dev_err(&pdev->dev, "Failed to enable sclk\n");
>>> >> +                             goto err_clk;
>>> >> +                     }
>>> >> +             }
>>> >> +     }
>>> >> +
>>> >>       ret = exynos_tmu_initialize(pdev);
>>> >>       if (ret) {
>>> >>               dev_err(&pdev->dev, "Failed to initialize TMU\n");
>>> >> -             goto err_clk;
>>> >> +             goto err_sclk;
>>> >>       }
>>> >>
>>> >>       exynos_tmu_control(pdev, true);
>>> >> @@ -896,7 +914,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>> >>                               sizeof(struct thermal_sensor_conf), GFP_KERNEL);
>>> >>       if (!sensor_conf) {
>>> >>               ret = -ENOMEM;
>>> >> -             goto err_clk;
>>> >> +             goto err_sclk;
>>> >>       }
>>> >>       sprintf(sensor_conf->name, "therm_zone%d", data->id);
>>> >>       sensor_conf->read_temperature = (int (*)(void *))exynos_tmu_read;
>>> >> @@ -928,7 +946,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>> >>       ret = exynos_register_thermal(sensor_conf);
>>> >>       if (ret) {
>>> >>               dev_err(&pdev->dev, "Failed to register thermal interface\n");
>>> >> -             goto err_clk;
>>> >> +             goto err_sclk;
>>> >>       }
>>> >>       data->reg_conf = sensor_conf;
>>> >>
>>> >> @@ -936,10 +954,12 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>> >>               IRQF_TRIGGER_RISING | IRQF_SHARED, dev_name(&pdev->dev), data);
>>> >>       if (ret) {
>>> >>               dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
>>> >> -             goto err_clk;
>>> >> +             goto err_sclk;
>>> >>       }
>>> >>
>>> >>       return 0;
>>> >> +err_sclk:
>>> >> +     clk_disable_unprepare(data->sclk);
>>> >>  err_clk:
>>> >>       clk_unprepare(data->clk);
>>> >>  err_clk_sec:
>>> >> @@ -956,6 +976,7 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>>> >>
>>> >>       exynos_tmu_control(pdev, false);
>>> >>
>>> >> +     clk_disable_unprepare(data->sclk);
>>> >>       clk_unprepare(data->clk);
>>> >>       if (!IS_ERR(data->clk_sec))
>>> >>               clk_unprepare(data->clk_sec);
>>> >> --
>>> >> 1.7.9.5
>>> >>
