Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3CYK1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:27:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37644 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab3CYK1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:27:33 -0400
Message-ID: <5150268D.2060700@ti.com>
Date: Mon, 25 Mar 2013 15:57:25 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] ARM: davinci: dm365: add support for v4l2 video
 display
References: <1363939388-22412-1-git-send-email-prabhakar.csengg@gmail.com> <1363939388-22412-2-git-send-email-prabhakar.csengg@gmail.com> <514FEADE.7020603@ti.com> <CA+V-a8vkYHO8Hf=LceA=Z+Qx-XxXHOmN-4RV7+BBkzueuWhcLg@mail.gmail.com>
In-Reply-To: <CA+V-a8vkYHO8Hf=LceA=Z+Qx-XxXHOmN-4RV7+BBkzueuWhcLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2013 3:52 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> Thanks for the review!
> 
> On Mon, Mar 25, 2013 at 11:42 AM, Sekhar Nori <nsekhar@ti.com> wrote:
>> Prabhakar,
>>
>> On 3/22/2013 1:33 PM, Prabhakar lad wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> Create platform devices for various video modules like venc,osd,
>>> vpbe and v4l2 driver for dm365.
>>>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> ---
>>>  arch/arm/mach-davinci/board-dm365-evm.c |    4 +-
>>>  arch/arm/mach-davinci/davinci.h         |    2 +-
>>>  arch/arm/mach-davinci/dm365.c           |  194 +++++++++++++++++++++++++++++--
>>>  3 files changed, 188 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
>>> index c2d4958..cf77c46 100644
>>> --- a/arch/arm/mach-davinci/board-dm365-evm.c
>>> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
>>> @@ -564,8 +564,6 @@ static struct davinci_uart_config uart_config __initdata = {
>>>
>>>  static void __init dm365_evm_map_io(void)
>>>  {
>>> -     /* setup input configuration for VPFE input devices */
>>> -     dm365_set_vpfe_config(&vpfe_cfg);
>>>       dm365_init();
>>>  }
>>>
>>> @@ -597,6 +595,8 @@ static __init void dm365_evm_init(void)
>>>
>>>       davinci_setup_mmc(0, &dm365evm_mmc_config);
>>>
>>> +     dm365_init_video(&vpfe_cfg, NULL);
>>> +
>>>       /* maybe setup mmc1/etc ... _after_ mmc0 */
>>>       evm_init_cpld();
>>>
>>> diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
>>> index 12d544b..1c2670f 100644
>>> --- a/arch/arm/mach-davinci/davinci.h
>>> +++ b/arch/arm/mach-davinci/davinci.h
>>> @@ -84,7 +84,7 @@ void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
>>>  void __init dm365_init_rtc(void);
>>>  void dm365_init_spi0(unsigned chipselect_mask,
>>>                       const struct spi_board_info *info, unsigned len);
>>> -void dm365_set_vpfe_config(struct vpfe_config *cfg);
>>> +int __init dm365_init_video(struct vpfe_config *, struct vpbe_config *);
>>
>> No need of __init specifier in function declaration.
>>
> OK
> 
>>>
>>>  /* DM644x function declarations */
>>>  void __init dm644x_init(void);
>>> diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
>>> index f4c19f7..0a2dba2 100644
>>> --- a/arch/arm/mach-davinci/dm365.c
>>> +++ b/arch/arm/mach-davinci/dm365.c
>>> @@ -40,10 +40,16 @@
>>>
>>>  #define DM365_REF_FREQ               24000000        /* 24 MHz on the DM365 EVM */
>>>
>>> +#define DM365_VDAC_CONFIG            0x01c4002c
>>
>> Please define this in davinci.h as an offset from
>> DAVINCI_SYSTEM_MODULE_BASE.
>>
> OK
> 
>>> +
>>> +#define DM365_RTC_BASE                       0x01c69000
>>> +
>>>  /* Base of key scan register bank */
>>>  #define DM365_KEYSCAN_BASE           0x01c69400
>>>
>>> -#define DM365_RTC_BASE                       0x01c69000
>>> +#define DM365_OSD_BASE                       0x01c71c00
>>> +
>>> +#define DM365_VENC_BASE                      0x01c71e00
>>>
> Are you OK with this definitions or you want all of them in davinci.h ?

No please leave these here. The reason I asked you to use davinci.h for
SYSMOD is because I don't want those definitions to be strewn all over
the place - especially when there is already a consolidated place for them.

Thanks,
Sekhar
