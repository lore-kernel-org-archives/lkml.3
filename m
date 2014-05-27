Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaE0IgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:36:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50249 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaE0Ifz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:35:55 -0400
Message-ID: <538459E8.6010701@ti.com>
Date: Tue, 27 May 2014 12:24:56 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        "Zhu, Lejun" <lejun.zhu@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <jacob.jun.pan@linux.intel.com>, <bin.yang@intel.com>
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com> <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
In-Reply-To: <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lejun,

On 05/27/2014 08:38 AM, Alexandre Courbot wrote:
> On Fri, May 23, 2014 at 11:00 AM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:
>> Devices based on Intel SoC products such as Baytrail have a Power
>> Management IC. In the PMIC there are subsystems for voltage regulation,
>> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
>> Crystal Cove.
>>
>> This patch adds support for the GPIO function in Crystal Cove.
> 
> A few minor comments below in case you make another version, but
> overall looks pretty good to me.
> 
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> 
>>
>> v2:
>> - Use IRQ chip helper to provide irqdomain.
>> - Implement .remove and can now build as a module.
>> - Various fix for unreadable or ugly code pieces.
>> v3:
>> - More fix in irq_handler and probe.
>> v4:
>> - Minor fix of one return statement.
>>
>> Signed-off-by: Yang, Bin <bin.yang@intel.com>
>> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> ---

[...]

>> +}
>> +
>> +static int crystalcove_gpio_probe(struct platform_device *pdev)
>> +{
>> +       int irq = platform_get_irq(pdev, 0);

Pls note, that platform_get_irq() may return error code.

>> +       struct crystalcove_gpio *cg;
>> +       int retval;
>> +       struct device *dev = pdev->dev.parent;
>> +
>> +       cg = devm_kzalloc(&pdev->dev, sizeof(*cg), GFP_KERNEL);
>> +       if (!cg)
>> +               return -ENOMEM;
>> +
>> +       mutex_init(&cg->buslock);
>> +       cg->chip.label = KBUILD_MODNAME;
>> +       cg->chip.direction_input = crystalcove_gpio_direction_input;
>> +       cg->chip.direction_output = crystalcove_gpio_direction_output;
>> +       cg->chip.get = crystalcove_gpio_get;
>> +       cg->chip.set = crystalcove_gpio_set;
>> +       cg->chip.base = -1;
>> +       cg->chip.ngpio = NUM_GPIO;
>> +       cg->chip.can_sleep = true;
>> +       cg->chip.dev = dev;
>> +       cg->chip.dbg_show = crystalcove_gpio_dbg_show;
>> +
>> +       gpiochip_irqchip_add(&cg->chip, &crystalcove_irqchip, 0,
>> +                            handle_simple_irq, IRQ_TYPE_NONE);
>> +
>> +       retval = request_threaded_irq(irq, NULL, crystalcove_gpio_irq_handler,
>> +                                     IRQF_ONESHOT, KBUILD_MODNAME, cg);
> 
> Can't you use devm_request_threaded_irq() here?

devm_gpiochip_add? ;)

> 
>> +
>> +       if (retval) {
>> +               dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
>> +               goto out;
>> +       }
>> +
>> +       retval = gpiochip_add(&cg->chip);
>> +       if (retval) {
>> +               dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
>> +               goto out_free_irq;
>> +       }

As to my mind, It'll be better to setup IRQ as last probing step and
free it as the first step of driver removing.

>> +
>> +       platform_set_drvdata(pdev, cg);
>> +
>> +       return 0;
>> +
>> +out_free_irq:
>> +       free_irq(irq, cg);
>> +out:
>> +       return retval;
>> +}

Best regards,
-grygorii

