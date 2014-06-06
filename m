Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaFFWnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:43:20 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36376 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaFFWnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1406061831310.25775@knanqh.ubzr>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org>
	<alpine.LFD.2.11.1406061831310.25775@knanqh.ubzr>
Date: Fri, 6 Jun 2014 15:43:17 -0700
X-Google-Sender-Auth: IjMIxq6XAQwMjdn_wVkZIExHnqw
Message-ID: <CAD=FV=U6cUNd4tZ1q3WUMkNpU-O-1yEbnEPuGkctwi_8UkBEkA@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: mcpm: Don't rely on firmware's secondary_cpu_start
From: Doug Anderson <dianders@chromium.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Inderpal Singh <inderpal.s@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas,

On Fri, Jun 6, 2014 at 3:35 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Fri, 6 Jun 2014, Doug Anderson wrote:
>
>> On exynos mcpm systems the firmware is hardcoded to jump to an address
>> in SRAM (0x02073000) when secondary CPUs come up.  By default the
>> firmware puts a bunch of code at that location.  That code expects the
>> kernel to fill in a few slots with addresses that it uses to jump back
>> to the kernel's entry point for secondary CPUs.
>>
>> Originally (on prerelease hardware) this firmware code contained a
>> bunch of workarounds to deal with boot ROM bugs.  However on all
>> shipped hardware we simply use this code to redirect to a kernel
>> function for bringing up the CPUs.
>>
>> Let's stop relying on the code provided by the bootloader and just
>> plumb in our own (simple) code jump to the kernel.  This has the nice
>> benefit of fixing problems due to the fact that older bootloaders
>> (like the one shipped on the Samsung Chromebook 2) might have put
>> slightly different code into this location.
>>
>> Once suspend/resume is implemented for systems using exynos-mcpm we'll
>> need to make sure we reinstall our fixed up code after resume.  ...but
>> that's not anything new since IRAM (and thus the address of the
>> mcpm_entry_point) is lost across suspend/resume anyway.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  arch/arm/mach-exynos/mcpm-exynos.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
>> index 0498d0b..3a7fad0 100644
>> --- a/arch/arm/mach-exynos/mcpm-exynos.c
>> +++ b/arch/arm/mach-exynos/mcpm-exynos.c
>> @@ -343,11 +343,13 @@ static int __init exynos_mcpm_init(void)
>>       pr_info("Exynos MCPM support installed\n");
>>
>>       /*
>> -      * Future entries into the kernel can now go
>> -      * through the cluster entry vectors.
>> +      * U-Boot SPL is hardcoded to jump to the start of ns_sram_base_addr
>> +      * as part of secondary_cpu_start().  Let's redirect it to the
>> +      * mcpm_entry_point().
>>        */
>> -     __raw_writel(virt_to_phys(mcpm_entry_point),
>> -                     ns_sram_base_addr + MCPM_BOOT_ADDR_OFFSET);
>> +     __raw_writel(0xe59f0000, ns_sram_base_addr);     /* ldr r0, [pc, #0] */
>> +     __raw_writel(0xe12fff10, ns_sram_base_addr + 4); /* bx  r0 */
>> +     __raw_writel(virt_to_phys(mcpm_entry_point), ns_sram_base_addr + 8);
>
> Is this valid for all exynos systems, or is this particular to
> Chromebooks?

I will have to let others comment on that since I can't be certain of
anything other than the firmware branch I've seen.

...but given that the code before my patch was putting the resume
address at the magic 0x0207301C and that matches the code I've seen,
I'm going to say that they all behave the same.


> If this is all that is needed to solve the problem being discussed in
> the other thread I have absolutely no issue with such a workaround going
> into mainline.

This plus the CCI fix that Andrew is planning to post.
