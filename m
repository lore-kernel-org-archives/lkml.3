Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaIVCdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:33:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33409 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaIVCdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:33:44 -0400
Message-ID: <541F8A84.6070408@gmail.com>
Date: Sun, 21 Sep 2014 22:33:40 -0400
From: nick <yocto6@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Peter Chen <Peter.Chen@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "himangi774@gmail.com" <himangi774@gmail.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FIX ME in  oxu210p-hcd.c
References: <541DB6BF.7090909@gmail.com> <541DB8C1.2000101@gmail.com> <2d062bb368d94327b89cba3d547bff9d@BN1PR0301MB0772.namprd03.prod.outlook.com> <541F8370.4040705@gmail.com> <684d0564efd840b7a45164546425f849@BN1PR0301MB0772.namprd03.prod.outlook.com>
In-Reply-To: <684d0564efd840b7a45164546425f849@BN1PR0301MB0772.namprd03.prod.outlook.com>
Content-Type: multipart/mixed;
 boundary="------------040803070503090402010005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040803070503090402010005
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit



On 14-09-21 10:11 PM, Peter Chen wrote:
> 
>  
>>>> Subject: Re: FIX ME in oxu210p-hcd.c
>>>>
>>>>
>>>> I found a unfixed FIX ME in the file stated in my above message. I am
>>>> wondering what to set hcd->self.comtroller->dma_mask to as it's now
>>>> been defined to NULL and clearly even as a newbie this seem incorrect.
>>>> Regards Nick
>>>
>>> Usually, it is set at its controller driver or pass through through
>>> device tree or platform data.
>>>
>>> Peter
>>>
>> Sorry Peter,
>> I apologize for asking for more help here but I will paste the function below and
>> with my changes.
>> Please let me known if I am wrong and how to fix it as I new here.
>> Sorry for Wasting Your Time,
> 
> You are welcome
> 
>> Nick
>> static int oxu_reset(struct usb_hcd *hcd) {
>>  	struct oxu_hcd *oxu = hcd_to_oxu(hcd);
>>  	int ret;
>>
>>  	spin_lock_init(&oxu->mem_lock);
>>  	INIT_LIST_HEAD(&oxu->urb_list);
>> 	oxu->urb_len = 0;
>>
>> -	/* FIMXE */
>> + 	hcd->self.controller->dma_mask = hcd->regs;
>>
> 
> It is the dma mask, not the register.
> 
> Try below patch to see if it works for you:
> 
> diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
> index da5fb0e..5549851 100644
> --- a/drivers/usb/host/oxu210hp-hcd.c
> +++ b/drivers/usb/host/oxu210hp-hcd.c
> @@ -37,6 +37,7 @@
>  #include <linux/moduleparam.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
> +#include <linux/dma-mapping.h>
>  
>  #include <asm/irq.h>
>  #include <asm/unaligned.h>
> @@ -3841,6 +3842,12 @@ static int oxu_drv_probe(struct platform_device *pdev)
>                 goto error;
>         }
>  
> +       ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +       if (ret) {
> +               dev_err(&pdev->dev, "set dma mask error\n");
> +               goto error;
> +       }
> +
>         /* Allocate a driver data struct to hold useful info for both
>          * SPH & OTG devices
>          */
> 
> Peter
> 
> 
>>  	if (oxu->is_otg) {
>> 		oxu->caps = hcd->regs + OXU_OTG_CAP_OFFSET;
>> 		oxu->regs = hcd->regs + OXU_OTG_CAP_OFFSET + \
>> 			HC_LENGTH(readl(&oxu->caps->hc_capbase));
>>
>> 		oxu->mem = hcd->regs + OXU_SPH_MEM;
>> 	} else {
>> 		oxu->caps = hcd->regs + OXU_SPH_CAP_OFFSET;
>>  		oxu->regs = hcd->regs + OXU_SPH_CAP_OFFSET + \
>>  			HC_LENGTH(readl(&oxu->caps->hc_capbase));
>>
>>  		oxu->mem = hcd->regs + OXU_OTG_MEM;
>> 	}
>>
>>  	oxu->hcs_params = readl(&oxu->caps->hcs_params);
>>  	oxu->sbrn = 0x20;
>>
>> 	ret = oxu_hcd_init(hcd);
>> 	if (ret)
>>  		return ret;
>>
>>  	return 0;
>> }
Unfortunately I can't get it to apply with git apply and get the following message,
 Checking patch drivers/usb/host/oxu210hp-hcd.c...
error: while searching for:
               goto error;
       }

       /* Allocate a driver data struct to hold useful info for both
        * SPH & OTG devices
        */

error: patch failed: drivers/usb/host/oxu210hp-hcd.c:3841
error: drivers/usb/host/oxu210hp-hcd.c: patch does not apply
I will paste the version of my patch file for your troubles.
Regards Nick 

--------------040803070503090402010005
Content-Type: text/x-patch;
 name="oxu210hp-hcd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="oxu210hp-hcd.patch"

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index da5fb0e..5549851 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -37,6 +37,7 @@
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/irq.h>
 #include <asm/unaligned.h>
@@ -3841,6 +3842,12 @@ static int oxu_drv_probe(struct platform_device *pdev)
                goto error;
        }
 
+       ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+       if (ret) {
+               dev_err(&pdev->dev, "set dma mask error\n");
+               goto error;
+       }
+
        /* Allocate a driver data struct to hold useful info for both
         * SPH & OTG devices
         */

--------------040803070503090402010005--
