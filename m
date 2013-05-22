Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3EVIgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:36:20 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58013 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3EVIgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:36:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130522080529.GW11878@intel.com>
References: <1369208859-16514-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369208859-16514-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130522080529.GW11878@intel.com>
Date: Wed, 22 May 2013 11:36:15 +0300
Message-ID: <CAHp75Vdyb4ynf-XQrcaCrKSPkbzN9_PP6txpvsYnYWXdZpWrEQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] gpio-langwell: use managed functions pcim_* and devm_*
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 11:05 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Wed, May 22, 2013 at 10:47:38AM +0300, Andy Shevchenko wrote:
>> This makes the error handling much more simpler than open-coding everything and
>> in addition makes the probe function smaller an tidier.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> In general this change looks good. Getting rid of 61 lines is certainly an
> improvement!
>
> David, are you able to check that this still works on your hardware? (I'm
> pretty sure that Andy has tested this already on Medfield)

I also wonder if it still okay on other platforms where this IP block
is embedded.

> I have few minor comments, though. See below.

Thank you for the review. See my answers below.

>> ---
>>  drivers/gpio/gpio-langwell.c | 82 ++++++++++++--------------------------------
>>  1 file changed, 21 insertions(+), 61 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
>> index 8203084..8672282 100644
>> --- a/drivers/gpio/gpio-langwell.c
>> +++ b/drivers/gpio/gpio-langwell.c
>> @@ -320,56 +320,35 @@ static const struct dev_pm_ops lnw_gpio_pm_ops = {
>>  static int lnw_gpio_probe(struct pci_dev *pdev,
>>                         const struct pci_device_id *id)
>>  {
>> -     void __iomem *base;
>> -     resource_size_t start, len;
>>       struct lnw_gpio *lnw;
>>       u32 gpio_base;
>>       u32 irq_base;
>>       int retval;
>>       int ngpio = id->driver_data;
>>
>> -     retval = pci_enable_device(pdev);
>> +     retval = pcim_enable_device(pdev);
>>       if (retval)
>>               return retval;
>>
>> -     retval = pci_request_regions(pdev, "langwell_gpio");
>> +     retval = pcim_iomap_regions(pdev, 1 << 0 | 1 << 1, pci_name(pdev));
>
> I wonder if "langwell_gpio" is still a better name compared to
> pci_name(pdev)?

This is used as an internal name for certain resource.

It could be seen in case of using printk("%pR") for example. But even
in that case I prefer to see the actual device as well to which
the resource belongs to.

My general opinion is better to use pci_name(pdev) in the pci drivers instead
of hardcoded pseudo-unique strings.

>>       if (retval) {
>> -             dev_err(&pdev->dev, "error requesting resources\n");
>> -             goto err_pci_req_region;
>> -     }
>> -     /* get the gpio_base from bar1 */
>> -     start = pci_resource_start(pdev, 1);
>> -     len = pci_resource_len(pdev, 1);
>> -     base = ioremap_nocache(start, len);
>> -     if (!base) {
>> -             dev_err(&pdev->dev, "error mapping bar1\n");
>> -             retval = -EFAULT;
>> -             goto err_ioremap;
>> +             dev_err(&pdev->dev, "I/O memory mapping error\n");
>> +             return retval;
>>       }
>>
>> -     irq_base = readl(base);
>> -     gpio_base = readl(sizeof(u32) + base);
>> +     irq_base = readl(pcim_iomap_table(pdev)[1]);
>> +     gpio_base = readl(sizeof(u32) + pcim_iomap_table(pdev)[1]);
>
> Using pcim_iomap_table(pdev)[] is a bit confusing, at least for me. Can you
> add a variable where you store that pointer and use that instead?

[Hmm... It returns pointer to an array of pointers.
Okay,  I will relive base variable for this as we discussed privately.

--
With Best Regards,
Andy Shevchenko
