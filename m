Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaKKOZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:25:40 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:36051 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKKOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:25:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAM4voam9jEuYvwDUnAZzU4Q-aZdF-P+KUuSm=x-9beobpyeR1w@mail.gmail.com>
References: <1411967817-8423-1-git-send-email-a.kesavan@samsung.com>
	<5429DF69.8000201@gmail.com>
	<CAM4voam9jEuYvwDUnAZzU4Q-aZdF-P+KUuSm=x-9beobpyeR1w@mail.gmail.com>
Date: Tue, 11 Nov 2014 19:55:37 +0530
Message-ID: <CAM4voakuXfeBNKVjEiLrAg5LmQg=adQ8yB36atAzoPVczwhRnA@mail.gmail.com>
Subject: Re: [PATCH] serial: samsung: Fix serial config dependencies for exynos7
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, jslaby@suse.cz,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Sep 30, 2014 at 8:02 PM, Abhilash Kesavan
<kesavan.abhilash@gmail.com> wrote:
> Hi Tomasz,
>
> On Tue, Sep 30, 2014 at 4:08 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> Hi Abhilash,
>>
>> The patch itself seems fine, but I wonder if those config options aren't
>> really just leftovers from the past and couldn't be completely removed.
>>
>> On 29.09.2014 07:16, Abhilash Kesavan wrote:
>>> From: Pankaj Dubey <pankaj.dubey@samsung.com>
>>>
>>> Exynos7 has a similar serial controller to that present in older Samsung
>>> SoCs. To re-use the existing serial driver on Exynos7 we need to have
>>> SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS selected. This is not
>>> possible because these symbols are dependent on PLAT_SAMSUNG which is
>>> not present for the ARMv8 based exynos7.
>>>
>>> Change the dependency of these symbols from PLAT_SAMSUNG to the serial
>>> driver thus making it available on exynos7. As the existing platform
>>> specific code making use of these symbols is related to uart driver this
>>> change in dependency should not cause any issues.
>>>
>>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>> Build tested with s3c6400_defconfig, exynos_defconfig and arm64's defconfig
>>> with and without the serial driver enabled.
>>>
>>>  drivers/tty/serial/Kconfig |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>>> index 81f6ee7..e6c0bcb 100644
>>> --- a/drivers/tty/serial/Kconfig
>>> +++ b/drivers/tty/serial/Kconfig
>>> @@ -249,14 +249,14 @@ config SERIAL_SAMSUNG
>>>
>>>  config SERIAL_SAMSUNG_UARTS_4
>>>       bool
>>> -     depends on PLAT_SAMSUNG
>>> +     depends on SERIAL_SAMSUNG
>>>       default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
>>>       help
>>>         Internal node for the common case of 4 Samsung compatible UARTs
>>
>> The only place where this symbol is used is below.
>>
>>>
>>>  config SERIAL_SAMSUNG_UARTS
>>>       int
>>> -     depends on PLAT_SAMSUNG
>>> +     depends on SERIAL_SAMSUNG
>>>       default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
>>>       default 3
>>>       help
>>>
>>
>> With this symbol the situation isn't that easy, but still should be
>> manageable.
>>
>> Looking at the serial-samsung driver, all occurrences of
>> CONFIG_SERIAL_SAMSUNG_UARTS could be simply replaced with a locally
>> defined number equal to the maximum value - in this case 4.
>>
>> There are also two places in arch/arm where this symbol is used:
>>
>> 1) In arch/arm/mach-s3c64xx/irq-pm.c it's used as the number of serial
>> ports which need suspend/resume handling. Since on s3c64xx the number is
>> always 4, it can be simply defined locally as a constant.
>>
>> 2) In arch/arm/plat-samsung/init.c it is used to determine size of a
>> static array of UART ports and to check whether the UART driver is
>> enabled. In former case I believe it should be safe to hardcode it to 4
>> as well, in latter CONFIG_SERIAL_SAMSUNG can be used.
>
> I will post patches removing these two symbols.

I posted a couple of patches handling Tomasz' comments but Kukjin
prefers the approach in this patch (Discussion here:
http://www.spinics.net/lists/linux-samsung-soc/msg38742.html).
Can you please review the patch.

Regards,
Abhilash
>
> Regards,
> Abhilash
>>
>> Best regards,
>> Tomasz
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
