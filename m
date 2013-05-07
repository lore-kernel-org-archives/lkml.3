Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3EGFHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:07:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38363 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3EGFHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:07:19 -0400
Message-ID: <51888BE4.8090502@ti.com>
Date: Tue, 7 May 2013 10:36:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ruchika@ti.com" <ruchika@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1367846225-15685-1-git-send-email-kishon@ti.com> <5187BDAF.2040303@nvidia.com>
In-Reply-To: <5187BDAF.2040303@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 06 May 2013 07:56 PM, Laxman Dewangan wrote:
> On Monday 06 May 2013 06:47 PM, Kishon Vijay Abraham I wrote:
>> +
>> +static irqreturn_t palmas_vbus_wakeup_irq(int irq, void *_palmas_usb)
>
> Can we name the function to palams_vbus_irq_handler() for better
> understanding? Reserve the wakeup word for the suspend-wakeups.
>
>
>> +
>> +
>> +static irqreturn_t palmas_id_wakeup_irq(int irq, void *_palmas_usb)
>
> Same here for better name.
>
>
>> +
>> +static void palmas_set_vbus_work(struct work_struct *data)
>> +{
>> +       int ret;
>> +       struct palmas_usb *palmas_usb = container_of(data, struct
>> palmas_usb,
>> +
>> set_vbus_work);
>> +
>> +       if (IS_ERR_OR_NULL(palmas_usb->vbus_reg)) {
>> +               dev_err(palmas_usb->dev, "invalid regulator\n");
>> +               return;
>> +       }
>
> This error will keep coming if the vbus is not require as workqueue get
> scheduled always. I think we should remove it.
>
>
>> +
>
>> +static void palmas_dt_to_pdata(struct device_node *node,
>> +               struct palmas_usb_platform_data *pdata)
>> +{
>> +       pdata->no_control_vbus = of_property_read_bool(node,
>> +                                       "ti,no_control_vbus");
>
>
> Can we change the variable names to enable_control_bus and logic
> accordingly as it looks more appropriate and easy to understand?
>
>
>> +
>> +       palmas_usb->irq1 = regmap_irq_get_virq(palmas->irq_data,
>> +                                               PALMAS_ID_OTG_IRQ);
>> +       palmas_usb->irq2 = regmap_irq_get_virq(palmas->irq_data,
>> +                                               PALMAS_ID_IRQ);
>> +       palmas_usb->irq3 = regmap_irq_get_virq(palmas->irq_data,
>> +                                               PALMAS_VBUS_OTG_IRQ);
>> +       palmas_usb->irq4 = regmap_irq_get_virq(palmas->irq_data,
>> +                                               PALMAS_VBUS_IRQ);
>> +
>
> Better to name irq1, irq2 in more logical names for easy understanding.
>
>
>> +
>> +       if (device_create_file(&pdev->dev, &dev_attr_vbus))
>> +               dev_warn(&pdev->dev, "could not create sysfs file\n");
>> +
>> +       palmas_usb->edev.name = "palmas_usb";
>> +       palmas_usb->edev.supported_cable = palmas_extcon_cable;
>> +       palmas_usb->edev.mutually_exclusive = mutually_exclusive;
>> +
>> +       ret = extcon_dev_register(&palmas_usb->edev, palmas_usb->dev);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "failed to register extcon
>> device\n");
>> +               return ret;
>
> It need to destroy sysfs also.
>
>> +       }
>> +
>> +       /* init spinlock for workqueue */
>> +       spin_lock_init(&palmas_usb->lock);
>
> It is already done above.
>
>> +
>> +       INIT_WORK(&palmas_usb->set_vbus_work, palmas_set_vbus_work);
>
> Better to create the workqueu when control_vbus is require.
>
>
>> +
>> +
>> diff --git a/include/linux/extcon/extcon_palmas.h
>> b/include/linux/extcon/extcon_palmas.h
>> new file mode 100644
>> index 0000000..a5119c9
>> --- /dev/null
>> +++ b/include/linux/extcon/extcon_palmas.h
>
> I think it can be use palama.h only. No need to have one more header for
> this.
>
>> @@ -0,0 +1,26 @@
>>
>>
>> -       u8 linkstat;
>> +       int mailboxstat;
> Do we really require mailboxstat?

Will fix your comments.

Thanks
Kishon
