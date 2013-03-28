Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3C1KGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:06:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61588 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3C1KGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <1650338.UonQ4LqB70@avalon>
References: <1364460632-21697-1-git-send-email-prabhakar.csengg@gmail.com> <1650338.UonQ4LqB70@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 28 Mar 2013 15:36:11 +0530
Message-ID: <CA+V-a8uMaNKBXF-tJRtOMaYpjA1PsMA9qhG6MgwORTU8YRvDbQ@mail.gmail.com>
Subject: Re: [PATCH] davinci: vpif: add pm_runtime support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the quick review!

On Thu, Mar 28, 2013 at 2:39 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thanks for the patch.
>
> On Thursday 28 March 2013 14:20:32 Prabhakar lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> Add pm_runtime support to the TI Davinci VPIF driver.
>> Along side this patch replaces clk_get() with devm_clk_get()
>> to simplify the error handling.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/davinci/vpif.c |   21 +++++++++++----------
>>  1 files changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif.c
>> b/drivers/media/platform/davinci/vpif.c index 28638a8..7d14625 100644
>> --- a/drivers/media/platform/davinci/vpif.c
>> +++ b/drivers/media/platform/davinci/vpif.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/io.h>
>>  #include <linux/clk.h>
>>  #include <linux/err.h>
>> +#include <linux/pm_runtime.h>
>>  #include <linux/v4l2-dv-timings.h>
>>
>>  #include <mach/hardware.h>
>> @@ -44,7 +45,6 @@ static struct resource      *res;
>>  spinlock_t vpif_lock;
>>
>>  void __iomem *vpif_base;
>> -struct clk *vpif_clk;
>>
>>  /**
>>   * ch_params: video standard configuration parameters for vpif
>> @@ -421,6 +421,7 @@ EXPORT_SYMBOL(vpif_channel_getfid);
>>
>>  static int vpif_probe(struct platform_device *pdev)
>>  {
>> +     struct clk *vpif_clk;
>>       int status = 0;
>>
>>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> @@ -439,12 +440,17 @@ static int vpif_probe(struct platform_device *pdev)
>>               goto fail;
>>       }
>>
>> -     vpif_clk = clk_get(&pdev->dev, "vpif");
>> +     vpif_clk = devm_clk_get(&pdev->dev, "vpif");
>>       if (IS_ERR(vpif_clk)) {
>>               status = PTR_ERR(vpif_clk);
>>               goto clk_fail;
>>       }
>> -     clk_prepare_enable(vpif_clk);
>> +     clk_put(vpif_clk);
>
> Why do you need to call clk_put() here ?
>
The above check is to see if the clock is provided, once done
we free it using clk_put().

>> +     pm_runtime_enable(&pdev->dev);
>> +     pm_runtime_resume(&pdev->dev);
>> +
>> +     pm_runtime_get(&pdev->dev);
>
> Does runtime PM automatically handle your clock ? If so can't you remove clock
> handling from the driver completely ?
>
Yes  pm runtime take care of enabling/disabling the clocks
so that we don't have to do it in drivers. I believe clock
handling is removed with this patch, with just  devm_clk_get() remaining ;)

Regards,
--Prabhakar

>>       spin_lock_init(&vpif_lock);
>>       dev_info(&pdev->dev, "vpif probe success\n");
>> @@ -459,11 +465,6 @@ fail:
>>
>>  static int vpif_remove(struct platform_device *pdev)
>>  {
>> -     if (vpif_clk) {
>> -             clk_disable_unprepare(vpif_clk);
>> -             clk_put(vpif_clk);
>> -     }
>> -
>>       iounmap(vpif_base);
>>       release_mem_region(res->start, res_len);
>>       return 0;
>> @@ -472,13 +473,13 @@ static int vpif_remove(struct platform_device *pdev)
>>  #ifdef CONFIG_PM
>>  static int vpif_suspend(struct device *dev)
>>  {
>> -     clk_disable_unprepare(vpif_clk);
>> +     pm_runtime_put(dev);
>>       return 0;
>>  }
>>
>>  static int vpif_resume(struct device *dev)
>>  {
>> -     clk_prepare_enable(vpif_clk);
>> +     pm_runtime_get(dev);
>>       return 0;
>>  }
> --
> Regards,
>
> Laurent Pinchart
>
