Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaB0SMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:12:13 -0500
Received: from 9.mo5.mail-out.ovh.net ([178.32.96.204]:33533 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751773AbaB0SMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:12:12 -0500
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 13:12:11 EST
MIME-Version: 1.0
In-Reply-To: <CACh+v5MPTx6nwVj1s3krntJqQ6DMTQ2hQ93Hc+rRNAuFa9+qPw@mail.gmail.com>
References: <20140220153042.DF053C4050F@trevor.secretlab.ca>
	<1392988720-20976-1-git-send-email-jjhiblot@traphandler.com>
	<902E09E6452B0E43903E4F2D568737AB0B9D2959@DFRE01.ent.ti.com>
	<CACh+v5MPTx6nwVj1s3krntJqQ6DMTQ2hQ93Hc+rRNAuFa9+qPw@mail.gmail.com>
Date: Thu, 27 Feb 2014 17:43:15 +0100
Message-ID: <CACh+v5N3Z=c1T3eGnjuudDkQH2YRW2knTunZtN=-64jHRT71OQ@mail.gmail.com>
Subject: Re: [PATCH v2] dt: platform driver: Fill the resources before probe
 and defer if needed
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 7720577136563607576
X-Ovh-Remote: 209.85.220.54 (mail-pa0-f54.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

2014-02-21 17:22 GMT+01:00 Jean-Jacques Hiblot <jjhiblot@traphandler.com>:
> Hi Grygorii,
>
> 2014-02-21 16:37 GMT+01:00 Strashko, Grygorii <grygorii.strashko@ti.com>:
>> Hi  Jean-Jacques,
>>
>> Sorry for top posting.
>>
>> As I know, there have been several attempts to solve the same problem already:)
>> [1] https://lkml.org/lkml/2013/9/18/216
>> [2] https://lkml.org/lkml/2013/11/22/520
>> [3] https://lkml.org/lkml/2014/1/8/240
>>
>> There are some questions related to your approach:
>> 1) How to distinguish between cases "IRQ domain not ready" and "wrong IRQ data in DT" or other IRQ parsing errors?
>> Otherwise, Driver's probe will be deffered wrongly and forever,
>> Thierry Reding has tried to solve this in [1].
>
> This approach doesn't really care about the cause of the problem.  I'm
> of the opinion that never-ending deferred probing is not a big issue,
> being not triggered so often after start-up (only when a new device is
> probed). But if we need to make it right, then we would have to change
> a bit the API of irq_create_of_mapping() and irq_of_parse_and_map()
> (or maybe duplicate this one to keep the patch small) to return a real
> error code instead a simple 0. Then would should be able to
> distinguish the different error causes.

What do you think of the 2nd version of the patch? Is it all right to
allways return EPROBE_DEFER or should we try to discriminate the error
cause?

Jean-Jacques

>
>>
>> 2) How will be handled driver reloading situation?
>> The worst case (sparse IRQ enabled):
>> - remove driver A
>> - remove driver B (irq-controller)
>> - load driver B <--- different set of Linux IRQ numbers can be assigned
>> - load driver A <--- oops. IRQ resources table contains invalid data
>>
>
> It's not handled in the current implementation. But if all interrupts
> entries are re-parsed (see my comment for Grant), it should be all
> right.
> Another problem would appear if the DT is dynamically updated and the
> number of resource is changed. In the 1st version of the patch, this
> was handled but it made the function more expensive.
>
> Jean-Jacques
>>
>>
>> Best regards,
>> Grygorii Strashko
>>
>> =============================================
>>
>> The goal of this patch is to allow drivers to be probed even if at the time of
>> the DT parsing some of their ressources are not available yet.
>>
>> In the current situation, the resource of a platform device are filled from the
>> DT at the time the device is created (of_device_alloc()). The drawbackof this
>> is that a device sitting close to the top of the DT (ahb for example) but
>> depending on ressources that are initialized later (IRQ domain dynamically
>> created for example)  will fail to probe because the ressources don't exist
>> at this time.
>>
>> This patch fills the resource structure only before the device is probed and
>> will defer the probe if the resource are not available yet.
>>
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>
>> Hi Grant,
>>
>> I reworked the patch as you proposed. To keep the overhead minimum, nirq and
>> nreg are computed only the first time.
>> In this implementation, only the missing IRQ ressources are re-tried for. It could
>> easily be changed to re-parse all the IRQs though (replace if (!res->flags)
>> with if ((!res->flags) || (res->flags & IORESOURCE_IRQ)).
>>
>> drivers/base/platform.c     |   5 +++
>>  drivers/of/platform.c       | 100 +++++++++++++++++++++++++++++++++-----------
>>  include/linux/of_platform.h |  10 +++++
>>  3 files changed, 90 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>> index bc78848..cee9b8d 100644
>> --- a/drivers/base/platform.c
>> +++ b/drivers/base/platform.c
>> @@ -481,6 +481,10 @@ static int platform_drv_probe(struct device *_dev)
>>         struct platform_device *dev = to_platform_device(_dev);
>>         int ret;
>>
>> +       ret = of_platform_device_prepare(dev);
>> +       if (ret)
>> +               goto error;
>> +
>>         if (ACPI_HANDLE(_dev))
>>                 acpi_dev_pm_attach(_dev, true);
>>
>> @@ -488,6 +492,7 @@ static int platform_drv_probe(struct device *_dev)
>>         if (ret && ACPI_HANDLE(_dev))
>>                 acpi_dev_pm_detach(_dev, true);
>>
>> +error:
>>         if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
>>                 dev_warn(_dev, "probe deferral not supported\n");
>>                 ret = -ENXIO;
>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> index 404d1da..a4e2602 100644
>> --- a/drivers/of/platform.c
>> +++ b/drivers/of/platform.c
>> @@ -141,36 +141,11 @@ struct platform_device *of_device_alloc(struct device_node *np,
>>                                   struct device *parent)
>>  {
>>         struct platform_device *dev;
>> -       int rc, i, num_reg = 0, num_irq;
>> -       struct resource *res, temp_res;
>>
>>         dev = platform_device_alloc("", -1);
>>         if (!dev)
>>                 return NULL;
>>
>> -       /* count the io and irq resources */
>> -       if (of_can_translate_address(np))
>> -               while (of_address_to_resource(np, num_reg, &temp_res) == 0)
>> -                       num_reg++;
>> -       num_irq = of_irq_count(np);
>> -
>> -       /* Populate the resource table */
>> -       if (num_irq || num_reg) {
>> -               res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
>> -               if (!res) {
>> -                       platform_device_put(dev);
>> -                       return NULL;
>> -               }
>> -
>> -               dev->num_resources = num_reg + num_irq;
>> -               dev->resource = res;
>> -               for (i = 0; i < num_reg; i++, res++) {
>> -                       rc = of_address_to_resource(np, i, res);
>> -                       WARN_ON(rc);
>> -               }
>> -               WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
>> -       }
>> -
>>         dev->dev.of_node = of_node_get(np);
>>  #if defined(CONFIG_MICROBLAZE)
>>         dev->dev.dma_mask = &dev->archdata.dma_mask;
>> @@ -233,6 +208,81 @@ static struct platform_device *of_platform_device_create_pdata(
>>         return dev;
>>  }
>>
>> +static int of_reg_count(struct device_node *np)
>> +{
>> +       int nreg = 0;
>> +       if (of_can_translate_address(np)) {
>> +               struct resource temp_res;
>> +               while (of_address_to_resource(np, nreg, &temp_res) == 0)
>> +                       nreg++;
>> +       }
>> +       return nreg;
>> +}
>> +
>> +int of_platform_device_prepare(struct platform_device *dev)
>> +{
>> +       struct device_node *np;
>> +       int i, irq_index;
>> +       struct resource *res;
>> +
>> +       /*
>> +        * This function applies only devices described in the DT.
>> +        * Other platform devices have their ressources already populated.
>> +        */
>> +       np = dev->dev.of_node;
>> +       if (!np)
>> +               return 0;
>> +
>> +       /* Populate the resource table */
>> +       if (!dev->resource) {
>> +               int rc, nreg = 0, nirq;
>> +               /* count the io and irq resources */
>> +               nreg = of_reg_count(np);
>> +               nirq = of_irq_count(np);
>> +
>> +               if (!nirq && !nreg)
>> +                       return 0;
>> +
>> +               res = kzalloc(sizeof(*res) * (nirq + nreg), GFP_KERNEL);
>> +               if (!res)
>> +                       return -ENOMEM;
>> +
>> +               dev->resource = res;
>> +               dev->num_resources = nreg + nirq;
>> +
>> +               for (i = 0; i < nreg; i++, res++) {
>> +                       rc = of_address_to_resource(np, i, res);
>> +                       if (WARN_ON(rc)) {
>> +                               /* THIS IS BAD; don't try to defer probing */
>> +                               dev->num_resources = 0;
>> +                               dev->resource = NULL;
>> +                               kfree(res);
>> +                               return rc;
>> +                       }
>> +               }
>> +
>> +               if (!rc && of_irq_to_resource_table(np, res, nirq) != nirq) {
>> +                       /* IRQ controller is yet available. defer probing */
>> +                       return -EPROBE_DEFER;
>> +               }
>> +
>> +               return 0;
>> +       }
>> +
>> +       /* See which IRQ resources need to be redone */
>> +       irq_index = 0;
>> +       for (i = 0, res = dev->resource; i < dev->num_resources; i++, res++) {
>> +               if (!res->flags) {
>> +                       if (!of_irq_to_resource(np, irq_index, res))
>> +                               return -EPROBE_DEFER;
>> +                       irq_index++;
>> +               } else if (res->flags & IORESOURCE_IRQ)
>> +                       irq_index++;
>> +       }
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(of_platform_device_prepare);
>> +
>>  /**
>>   * of_platform_device_create - Alloc, initialize and register an of_device
>>   * @np: pointer to node to create device for
>> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
>> index 05cb4a9..4e487ff 100644
>> --- a/include/linux/of_platform.h
>> +++ b/include/linux/of_platform.h
>> @@ -53,6 +53,16 @@ struct of_dev_auxdata {
>>
>>  extern const struct of_device_id of_default_bus_match_table[];
>>
>> +/* Populate the resource for a platform device */
>> +#ifdef CONFIG_OF
>> +int of_platform_device_prepare(struct platform_device *dev);
>> +#else
>> +static inline int of_platform_device_prepare(
>> +       struct platform_device *dev)
>> +{
>> +       return 0;
>> +}
>> +#endif
>>  /* Platform drivers register/unregister */
>>  extern struct platform_device *of_device_alloc(struct device_node *np,
>>                                          const char *bus_id,
>> --
>> 1.9.0
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
