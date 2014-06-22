Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaFVLyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:54:47 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64376 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaFVLyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <53A6B658.6030709@pengutronix.de>
References: <1403265574-12923-1-git-send-email-prabhakar.csengg@gmail.com> <53A6B658.6030709@pengutronix.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 22 Jun 2014 12:54:13 +0100
Message-ID: <CA+V-a8tPjhVU2zWSTcyj+nLTvmTB6q8cTMaw3KriQwBqcVg_bg@mail.gmail.com>
Subject: Re: [PATCH] can: c_can: convert to use devm * api
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 11:56 AM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 06/20/2014 01:59 PM, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> this patch uses devm_* APIs as they are device managed
>> and make code simpler.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Thanks for the patch. Applied to can-next with minor change (see inline).
>
>> ---
>>  Note: This patch is compile tested only.
>>
>>  drivers/net/can/c_can/c_can_platform.c | 41 ++++++++--------------------------
>>  1 file changed, 9 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
>> index 1df0b32..e0dcbcf 100644
>> --- a/drivers/net/can/c_can/c_can_platform.c
>> +++ b/drivers/net/can/c_can/c_can_platform.c
>> @@ -157,40 +157,31 @@ static int c_can_plat_probe(struct platform_device *pdev)
>>       }
>>
>>       /* get the appropriate clk */
>> -     clk = clk_get(&pdev->dev, NULL);
>> +     clk = devm_clk_get(&pdev->dev, NULL);
>>       if (IS_ERR(clk)) {
>> -             dev_err(&pdev->dev, "no clock defined\n");
>> -             ret = -ENODEV;
>> +             ret = PTR_ERR(clk);
>>               goto exit;
>>       }
>>
>>       /* get the platform data */
>>       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>       irq = platform_get_irq(pdev, 0);
>> -     if (!mem || irq <= 0) {
>> -             ret = -ENODEV;
>> -             goto exit_free_clk;
>> -     }
>> -
>> -     if (!request_mem_region(mem->start, resource_size(mem),
>> -                             KBUILD_MODNAME)) {
>> -             dev_err(&pdev->dev, "resource unavailable\n");
>> +     if (irq <= 0) {
>>               ret = -ENODEV;
>> -             goto exit_free_clk;
>> +             goto exit;
>>       }
>>
>> -     addr = ioremap(mem->start, resource_size(mem));
>> -     if (!addr) {
>> -             dev_err(&pdev->dev, "failed to map can port\n");
>> -             ret = -ENOMEM;
>> -             goto exit_release_mem;
>
> I've moved the mem = platform_get_resource() for slightly better
> readability here....
>
Thanks makes sense.

Regards,
--Prabhakar Lad

>> +     addr = devm_ioremap_resource(&pdev->dev, mem);
>> +     if (IS_ERR(addr)) {
>> +             ret =  PTR_ERR(addr);
>> +             goto exit;
>>       }
>
> Thanks,
> Marc
>
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |
>
