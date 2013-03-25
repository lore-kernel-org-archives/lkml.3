Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3CYKYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:24:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52162 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab3CYKYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:24:53 -0400
Message-ID: <515025E3.40905@ti.com>
Date: Mon, 25 Mar 2013 15:54:35 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] media: davinci: vpss: enable vpss clocks
References: <1363938793-22246-1-git-send-email-prabhakar.csengg@gmail.com> <1363938793-22246-2-git-send-email-prabhakar.csengg@gmail.com> <514FE152.4070300@ti.com> <CA+V-a8tZGh8y_eC52XC-7J41inARjrq9KD2bHCfZ+j1npo+VYw@mail.gmail.com>
In-Reply-To: <CA+V-a8tZGh8y_eC52XC-7J41inARjrq9KD2bHCfZ+j1npo+VYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2013 3:44 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> Thanks for the review!
> 
> On Mon, Mar 25, 2013 at 11:02 AM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 3/22/2013 1:23 PM, Prabhakar lad wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> By default the VPSS clocks are only enabled in capture driver
>>> for davinci family which creates duplicates. This
>>> patch adds support to enable the VPSS clocks in VPSS driver.
>>> This avoids duplication of code and also adding clock aliases.
>>> This patch cleanups the VPSS clock enabling in the capture driver,
>>> and also removes the clock alias in machine file. Along side adds
>>> a vpss slave clock for DM365 as mentioned by Sekhar
>>> (https://patchwork.kernel.org/patch/1221261/).
>>>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> ---
>>>  arch/arm/mach-davinci/dm355.c                |    3 -
>>>  arch/arm/mach-davinci/dm365.c                |    9 +++-
>>>  arch/arm/mach-davinci/dm644x.c               |    5 --
>>>  drivers/media/platform/davinci/dm355_ccdc.c  |   39 +----------------
>>>  drivers/media/platform/davinci/dm644x_ccdc.c |   44 -------------------
>>>  drivers/media/platform/davinci/isif.c        |   28 ++----------
>>>  drivers/media/platform/davinci/vpss.c        |   60 ++++++++++++++++++++++++++
>>>  7 files changed, 72 insertions(+), 116 deletions(-)
>>>
>>>  static struct clk arm_clk = {
>>>       .name           = "arm_clk",
>>>       .parent         = &pll2_sysclk2,
>>> @@ -450,6 +456,7 @@ static struct clk_lookup dm365_clks[] = {
>>>       CLK(NULL, "pll2_sysclk9", &pll2_sysclk9),
>>>       CLK(NULL, "vpss_dac", &vpss_dac_clk),
>>>       CLK(NULL, "vpss_master", &vpss_master_clk),
>>> +     CLK(NULL, "vpss_slave", &vpss_slave_clk),
>>
>> These should use device name for look-up instead of relying just on
>> con_id. So the entry should look like:
>>
>> CLK("vpss", "slave", &vpss_slave_clk),
>>
> OK
> 
>>>       CLK(NULL, "arm", &arm_clk),
>>>       CLK(NULL, "uart0", &uart0_clk),
>>>       CLK(NULL, "uart1", &uart1_clk),
>>> @@ -1239,8 +1246,6 @@ static int __init dm365_init_devices(void)
>>>       clk_add_alias(NULL, dev_name(&dm365_mdio_device.dev),
>>>                     NULL, &dm365_emac_device.dev);
>>>
>>> -     /* Add isif clock alias */
>>> -     clk_add_alias("master", dm365_isif_dev.name, "vpss_master", NULL);
>>>       platform_device_register(&dm365_vpss_device);
>>>       platform_device_register(&dm365_isif_dev);
>>>       platform_device_register(&vpfe_capture_dev);
>>> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
>>> index ee0e994..026e7e3 100644
>>> --- a/arch/arm/mach-davinci/dm644x.c
>>> +++ b/arch/arm/mach-davinci/dm644x.c
>>> @@ -901,11 +901,6 @@ int __init dm644x_init_video(struct vpfe_config *vpfe_cfg,
>>>               dm644x_vpfe_dev.dev.platform_data = vpfe_cfg;
>>>               platform_device_register(&dm644x_ccdc_dev);
>>>               platform_device_register(&dm644x_vpfe_dev);
>>> -             /* Add ccdc clock aliases */
>>> -             clk_add_alias("master", dm644x_ccdc_dev.name,
>>> -                           "vpss_master", NULL);
>>> -             clk_add_alias("slave", dm644x_ccdc_dev.name,
>>> -                           "vpss_slave", NULL);
>>>       }
>>>
>>>       if (vpbe_cfg) {
>>> diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
>>> index 2364dba..05f8fb7 100644
>>> --- a/drivers/media/platform/davinci/dm355_ccdc.c
>>> +++ b/drivers/media/platform/davinci/dm355_ccdc.c
>>> @@ -37,7 +37,6 @@
>>>  #include <linux/platform_device.h>
>>>  #include <linux/uaccess.h>
>>>  #include <linux/videodev2.h>
>>> -#include <linux/clk.h>
>>>  #include <linux/err.h>
>>>  #include <linux/module.h>
>>>
>>> @@ -59,10 +58,6 @@ static struct ccdc_oper_config {
>>>       struct ccdc_params_raw bayer;
>>>       /* YCbCr configuration */
>>>       struct ccdc_params_ycbcr ycbcr;
>>> -     /* Master clock */
>>> -     struct clk *mclk;
>>> -     /* slave clock */
>>> -     struct clk *sclk;
>>>       /* ccdc base address */
>>>       void __iomem *base_addr;
>>>  } ccdc_cfg = {
>>> @@ -997,32 +992,10 @@ static int dm355_ccdc_probe(struct platform_device *pdev)
>>>               goto fail_nomem;
>>>       }
>>>
>>> -     /* Get and enable Master clock */
>>> -     ccdc_cfg.mclk = clk_get(&pdev->dev, "master");
>>> -     if (IS_ERR(ccdc_cfg.mclk)) {
>>> -             status = PTR_ERR(ccdc_cfg.mclk);
>>> -             goto fail_nomap;
>>> -     }
>>> -     if (clk_prepare_enable(ccdc_cfg.mclk)) {
>>> -             status = -ENODEV;
>>> -             goto fail_mclk;
>>> -     }
>>> -
>>> -     /* Get and enable Slave clock */
>>> -     ccdc_cfg.sclk = clk_get(&pdev->dev, "slave");
>>> -     if (IS_ERR(ccdc_cfg.sclk)) {
>>> -             status = PTR_ERR(ccdc_cfg.sclk);
>>> -             goto fail_mclk;
>>> -     }
>>> -     if (clk_prepare_enable(ccdc_cfg.sclk)) {
>>> -             status = -ENODEV;
>>> -             goto fail_sclk;
>>> -     }
>>> -
>>>       /* Platform data holds setup_pinmux function ptr */
>>>       if (NULL == pdev->dev.platform_data) {
>>>               status = -ENODEV;
>>> -             goto fail_sclk;
>>> +             goto fail_nomap;
>>>       }
>>>       setup_pinmux = pdev->dev.platform_data;
>>>       /*
>>> @@ -1033,12 +1006,6 @@ static int dm355_ccdc_probe(struct platform_device *pdev)
>>>       ccdc_cfg.dev = &pdev->dev;
>>>       printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
>>>       return 0;
>>> -fail_sclk:
>>> -     clk_disable_unprepare(ccdc_cfg.sclk);
>>> -     clk_put(ccdc_cfg.sclk);
>>> -fail_mclk:
>>> -     clk_disable_unprepare(ccdc_cfg.mclk);
>>> -     clk_put(ccdc_cfg.mclk);
>>>  fail_nomap:
>>>       iounmap(ccdc_cfg.base_addr);
>>>  fail_nomem:
>>> @@ -1052,10 +1019,6 @@ static int dm355_ccdc_remove(struct platform_device *pdev)
>>>  {
>>>       struct resource *res;
>>>
>>> -     clk_disable_unprepare(ccdc_cfg.sclk);
>>> -     clk_disable_unprepare(ccdc_cfg.mclk);
>>> -     clk_put(ccdc_cfg.mclk);
>>> -     clk_put(ccdc_cfg.sclk);
>>>       iounmap(ccdc_cfg.base_addr);
>>>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>       if (res)
>>> diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
>>> index 971d639..30fa084 100644
>>> --- a/drivers/media/platform/davinci/dm644x_ccdc.c
>>> +++ b/drivers/media/platform/davinci/dm644x_ccdc.c
>>> @@ -38,7 +38,6 @@
>>>  #include <linux/uaccess.h>
>>>  #include <linux/videodev2.h>
>>>  #include <linux/gfp.h>
>>> -#include <linux/clk.h>
>>>  #include <linux/err.h>
>>>  #include <linux/module.h>
>>>
>>> @@ -60,10 +59,6 @@ static struct ccdc_oper_config {
>>>       struct ccdc_params_raw bayer;
>>>       /* YCbCr configuration */
>>>       struct ccdc_params_ycbcr ycbcr;
>>> -     /* Master clock */
>>> -     struct clk *mclk;
>>> -     /* slave clock */
>>> -     struct clk *sclk;
>>>       /* ccdc base address */
>>>       void __iomem *base_addr;
>>>  } ccdc_cfg = {
>>> @@ -991,38 +986,9 @@ static int dm644x_ccdc_probe(struct platform_device *pdev)
>>>               goto fail_nomem;
>>>       }
>>>
>>> -     /* Get and enable Master clock */
>>> -     ccdc_cfg.mclk = clk_get(&pdev->dev, "master");
>>> -     if (IS_ERR(ccdc_cfg.mclk)) {
>>> -             status = PTR_ERR(ccdc_cfg.mclk);
>>> -             goto fail_nomap;
>>> -     }
>>> -     if (clk_prepare_enable(ccdc_cfg.mclk)) {
>>> -             status = -ENODEV;
>>> -             goto fail_mclk;
>>> -     }
>>> -
>>> -     /* Get and enable Slave clock */
>>> -     ccdc_cfg.sclk = clk_get(&pdev->dev, "slave");
>>> -     if (IS_ERR(ccdc_cfg.sclk)) {
>>> -             status = PTR_ERR(ccdc_cfg.sclk);
>>> -             goto fail_mclk;
>>> -     }
>>> -     if (clk_prepare_enable(ccdc_cfg.sclk)) {
>>> -             status = -ENODEV;
>>> -             goto fail_sclk;
>>> -     }
>>>       ccdc_cfg.dev = &pdev->dev;
>>>       printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
>>>       return 0;
>>> -fail_sclk:
>>> -     clk_disable_unprepare(ccdc_cfg.sclk);
>>> -     clk_put(ccdc_cfg.sclk);
>>> -fail_mclk:
>>> -     clk_disable_unprepare(ccdc_cfg.mclk);
>>> -     clk_put(ccdc_cfg.mclk);
>>> -fail_nomap:
>>> -     iounmap(ccdc_cfg.base_addr);
>>>  fail_nomem:
>>>       release_mem_region(res->start, resource_size(res));
>>>  fail_nores:
>>> @@ -1034,10 +1000,6 @@ static int dm644x_ccdc_remove(struct platform_device *pdev)
>>>  {
>>>       struct resource *res;
>>>
>>> -     clk_disable_unprepare(ccdc_cfg.mclk);
>>> -     clk_disable_unprepare(ccdc_cfg.sclk);
>>> -     clk_put(ccdc_cfg.mclk);
>>> -     clk_put(ccdc_cfg.sclk);
>>>       iounmap(ccdc_cfg.base_addr);
>>>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>       if (res)
>>> @@ -1052,18 +1014,12 @@ static int dm644x_ccdc_suspend(struct device *dev)
>>>       ccdc_save_context();
>>>       /* Disable CCDC */
>>>       ccdc_enable(0);
>>> -     /* Disable both master and slave clock */
>>> -     clk_disable_unprepare(ccdc_cfg.mclk);
>>> -     clk_disable_unprepare(ccdc_cfg.sclk);
>>>
>>>       return 0;
>>>  }
>>>
>>>  static int dm644x_ccdc_resume(struct device *dev)
>>>  {
>>> -     /* Enable both master and slave clock */
>>> -     clk_prepare_enable(ccdc_cfg.mclk);
>>> -     clk_prepare_enable(ccdc_cfg.sclk);
>>>       /* Restore CCDC context */
>>>       ccdc_restore_context();
>>>
>>> diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
>>> index abc3ae3..3332cca 100644
>>> --- a/drivers/media/platform/davinci/isif.c
>>> +++ b/drivers/media/platform/davinci/isif.c
>>> @@ -32,7 +32,6 @@
>>>  #include <linux/uaccess.h>
>>>  #include <linux/io.h>
>>>  #include <linux/videodev2.h>
>>> -#include <linux/clk.h>
>>>  #include <linux/err.h>
>>>  #include <linux/module.h>
>>>
>>> @@ -88,8 +87,6 @@ static struct isif_oper_config {
>>>       struct isif_ycbcr_config ycbcr;
>>>       struct isif_params_raw bayer;
>>>       enum isif_data_pack data_pack;
>>> -     /* Master clock */
>>> -     struct clk *mclk;
>>>       /* ISIF base address */
>>>       void __iomem *base_addr;
>>>       /* ISIF Linear Table 0 */
>>> @@ -1039,6 +1036,10 @@ static int isif_probe(struct platform_device *pdev)
>>>       void *__iomem addr;
>>>       int status = 0, i;
>>>
>>> +     /* Platform data holds setup_pinmux function ptr */
>>> +     if (!pdev->dev.platform_data)
>>> +             return -ENODEV;
>>> +
>>
>> This change seems unrelated. I suggest moving it to a different patch or
>> atleast note it in the description.
>>
> Its just a movement, while fixing the cleanups. I'll add some
> description about it.

This is fine as is. I failed to notice the movement.

> 
>>>       /*
>>>        * first try to register with vpfe. If not correct platform, then we
>>>        * don't have to iomap
>>> @@ -1047,22 +1048,6 @@ static int isif_probe(struct platform_device *pdev)
>>>       if (status < 0)
>>>               return status;
>>>
>>> -     /* Get and enable Master clock */
>>> -     isif_cfg.mclk = clk_get(&pdev->dev, "master");
>>> -     if (IS_ERR(isif_cfg.mclk)) {
>>> -             status = PTR_ERR(isif_cfg.mclk);
>>> -             goto fail_mclk;
>>> -     }
>>> -     if (clk_prepare_enable(isif_cfg.mclk)) {
>>> -             status = -ENODEV;
>>> -             goto fail_mclk;
>>> -     }
>>> -
>>> -     /* Platform data holds setup_pinmux function ptr */
>>> -     if (NULL == pdev->dev.platform_data) {
>>> -             status = -ENODEV;
>>> -             goto fail_mclk;
>>> -     }
>>>       setup_pinmux = pdev->dev.platform_data;
>>>       /*
>>>        * setup Mux configuration for ccdc which may be different for
>>> @@ -1124,9 +1109,6 @@ fail_nobase_res:
>>>               release_mem_region(res->start, resource_size(res));
>>>               i--;
>>>       }
>>> -fail_mclk:
>>> -     clk_disable_unprepare(isif_cfg.mclk);
>>> -     clk_put(isif_cfg.mclk);
>>>       vpfe_unregister_ccdc_device(&isif_hw_dev);
>>>       return status;
>>>  }
>>> @@ -1146,8 +1128,6 @@ static int isif_remove(struct platform_device *pdev)
>>>               i++;
>>>       }
>>>       vpfe_unregister_ccdc_device(&isif_hw_dev);
>>> -     clk_disable_unprepare(isif_cfg.mclk);
>>> -     clk_put(isif_cfg.mclk);
>>>       return 0;
>>>  }
>>>
>>> diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
>>> index a19c552..db69317 100644
>>> --- a/drivers/media/platform/davinci/vpss.c
>>> +++ b/drivers/media/platform/davinci/vpss.c
>>> @@ -17,6 +17,7 @@
>>>   *
>>>   * common vpss system module platform driver for all video drivers.
>>>   */
>>> +#include <linux/clk.h>
>>>  #include <linux/kernel.h>
>>>  #include <linux/sched.h>
>>>  #include <linux/init.h>
>>> @@ -126,6 +127,10 @@ struct vpss_oper_config {
>>>       enum vpss_platform_type platform;
>>>       spinlock_t vpss_lock;
>>>       struct vpss_hw_ops hw_ops;
>>> +     /* Master clock */
>>> +     struct clk *mclk;
>>> +     /* slave clock */
>>> +     struct clk *sclk;
>>>  };
>>>
>>>  static struct vpss_oper_config oper_cfg;
>>> @@ -429,6 +434,26 @@ static int vpss_probe(struct platform_device *pdev)
>>>               return -ENODEV;
>>>       }
>>>
>>> +     /* Get and enable Master clock */
>>> +     oper_cfg.mclk = clk_get(&pdev->dev, "vpss_master");
>>
>> use devm_clk_get() here to simplify the error handling.
>>
> OK
> 
>>> +     if (IS_ERR(oper_cfg.mclk)) {
>>> +             status = PTR_ERR(oper_cfg.mclk);
>>> +             goto fail_getclk;
>>> +     }
>>> +     status = clk_prepare_enable(oper_cfg.mclk);
>>> +     if (status)
>>> +             goto fail_mclk;
>>> +
>>> +     /* Get and enable Slave clock */
>>> +     oper_cfg.sclk = clk_get(&pdev->dev, "vpss_slave");
>>> +     if (IS_ERR(oper_cfg.sclk)) {
>>> +             status = PTR_ERR(oper_cfg.sclk);
>>> +             goto fail_mclk;
>>> +     }
>>> +     status = clk_prepare_enable(oper_cfg.sclk);
>>> +     if (status)
>>> +             goto fail_sclk;
>>> +
>>>       dev_info(&pdev->dev, "%s vpss probed\n", platform_name);
>>>       r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>       if (!r1)
>>> @@ -500,6 +525,13 @@ fail2:
>>>       iounmap(oper_cfg.vpss_regs_base0);
>>>  fail1:
>>>       release_mem_region(r1->start, resource_size(r1));
>>> +fail_sclk:
>>> +     clk_disable_unprepare(oper_cfg.sclk);
>>> +     clk_put(oper_cfg.sclk);
>>> +fail_mclk:
>>> +     clk_disable_unprepare(oper_cfg.mclk);
>>> +     clk_put(oper_cfg.mclk);
>>> +fail_getclk:
>>>       return status;
>>>  }
>>>
>>> @@ -510,6 +542,10 @@ static int vpss_remove(struct platform_device *pdev)
>>>       iounmap(oper_cfg.vpss_regs_base0);
>>>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>       release_mem_region(res->start, resource_size(res));
>>> +     clk_disable_unprepare(oper_cfg.mclk);
>>> +     clk_disable_unprepare(oper_cfg.sclk);
>>> +     clk_put(oper_cfg.mclk);
>>> +     clk_put(oper_cfg.sclk);
>>>       if (oper_cfg.platform == DM355 || oper_cfg.platform == DM365) {
>>>               iounmap(oper_cfg.vpss_regs_base1);
>>>               res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>>> @@ -518,10 +554,34 @@ static int vpss_remove(struct platform_device *pdev)
>>>       return 0;
>>>  }
>>>
>>
>>> +static int vpss_suspend(struct device *dev)
>>> +{
>>> +     /* Disable both master and slave clock */
>>> +     clk_disable_unprepare(oper_cfg.mclk);
>>> +     clk_disable_unprepare(oper_cfg.sclk);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int vpss_resume(struct device *dev)
>>> +{
>>> +     /* Enable both master and slave clock */
>>> +     clk_prepare_enable(oper_cfg.mclk);
>>> +     clk_prepare_enable(oper_cfg.sclk);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static const struct dev_pm_ops vpss_pm_ops = {
>>> +     .suspend = vpss_suspend,
>>> +     .resume = vpss_resume,
>>> +};
>>
>> Addition of suspend support seems unrelated to this patch. May be make a
>> seperate patch for it and while at it, please use PM runtime instead of
>> direct clock enable/disable. Have a look at the davinci_emac driver
>> which was converted to use PM runtime recently.
>>
> I felt having in same patch would be a good idea, since the clock
> enabling/disabling
> where removed from dm644x_ccdc.c for suspend/resume and add it in
> vpss. If you still
> feel it needs to be separate patch let me know.

Okay, please add some description for this. Its not terribly obvious.

> 
>> Let me know how you want to handle this patch. I suppose you intend this
>> should go through my tree because of other dependent platform changes?
>>
> I want this series to go through the media tree because of few dependencies
> (dependency on ths7353 video amplifier driver which recently got
> merged into media tree)

Hmm, this patch does not touch ths7353 so are you sure there is a merge
dependency? There are a lot of platform changes you are doing in some of
the recent patches you submitted based on this patch and ideally those
go through my tree to ease merging for upstream. That said, if there is
a good reason for this and the other platform changes to go through
media tree, I am okay with that too.

Thanks,
Sekhar
