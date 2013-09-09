Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3IIShV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:37:21 -0400
Received: from threespeedlogic.com ([75.98.167.93]:54979 "EHLO
	threespeedlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3IIShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:37:20 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 14:37:19 EDT
Message-ID: <522E1012.7060101@threespeedlogic.com>
Date: Mon, 09 Sep 2013 11:14:42 -0700
From: Graeme Smecher <gsmecher@threespeedlogic.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: pca953x: Don't flip bits on PCA957x GPIO expanders
 when probing them.
References: <1375478656-3577-1-git-send-email-gsmecher@threespeedlogic.com> <CAN1soZy98mM6aAyASDY8Ra+j-2Jsr8RDvuqU8vHBnVBNgjWx9w@mail.gmail.com>
In-Reply-To: <CAN1soZy98mM6aAyASDY8Ra+j-2Jsr8RDvuqU8vHBnVBNgjWx9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s63.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - threespeedlogic.com
X-Get-Message-Sender-Via: a2s63.a2hosting.com: authenticated_id: gsmecher+threespeedlogic.com/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 04/08/13 05:35 AM, Haojian Zhuang wrote:
> On Sat, Aug 3, 2013 at 5:24 AM, Graeme Smecher
> <gsmecher@threespeedlogic.com>  wrote:
>> The pca957x driver supports a handful of I2C GPIO expanders from NXP, Maxim,
>> and TI. For the PCA9574 and PCA9575 devices only, the driver resets the GPIO
>> level and direction in the pca957x_probe function. This seems like the wrong
>> thing to do, since it can cause hardware bit twiddles during warm reboots when
>> the chip state and reset values don't match.
>>
>> This kind of initialization is best left upstream (in a bootloader) or
>> downstream (in userspace). It's also an inconsistency across devices supported
>> by this driver.
>>
>> Signed-off-by: Graeme Smecher<gsmecher@threespeedlogic.com>
>> Cc: Grant Likely<grant.likely@linaro.org>
>> Cc: Haojian Zhuang<haojian.zhuang@marvell.com>
>> ---
>>   drivers/gpio/gpio-pca953x.c |   11 -----------
>>   1 file changed, 11 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
>> index 426c51d..47c08d8 100644
>> --- a/drivers/gpio/gpio-pca953x.c
>> +++ b/drivers/gpio/gpio-pca953x.c
>> @@ -683,17 +683,6 @@ static int device_pca957x_init(struct pca953x_chip *chip, u32 invert)
>>          int ret;
>>          u8 val[MAX_BANK];
>>
>> -       /* Let every port in proper state, that could save power */
>> -       memset(val, 0, NBANK(chip));
>> -       pca953x_write_regs(chip, PCA957X_PUPD, val);
>> -       memset(val, 0xFF, NBANK(chip));
>> -       pca953x_write_regs(chip, PCA957X_CFG, val);
>> -       memset(val, 0, NBANK(chip));
>> -       pca953x_write_regs(chip, PCA957X_OUT, val);
>> -
>> -       ret = pca953x_read_regs(chip, PCA957X_IN, val);
>> -       if (ret)
>> -               goto out;
>>          ret = pca953x_read_regs(chip, PCA957X_OUT, chip->reg_output);
>>          if (ret)
>>                  goto out;
>> --
>> 1.7.10.4
>>
> Acked-by: Haojian Zhuang<haojian.zhuang@gmail.com>

Just a quick ping: I think you're the responsible maintainer for this 
patch, and I haven't seen it show up on git.secretlab.ca. Do you want me 
to resubmit with Haojian's e-mail corrected?

I should also note that this patch is NOT boot-tested. My hardware 
containing this part is only supported by the vendor's aging 2.6.37 
branch. (It's a custom ARM board using the TI AM3874.) The pca953x 
driver has evolved enough that the patches for 2.6.37 and mainline 
aren't identical, but they still rhyme.

thanks,
Graeme
