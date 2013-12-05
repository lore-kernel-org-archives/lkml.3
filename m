Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab3LESRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:17:19 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:62955 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab3LESQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:16:15 -0500
MIME-Version: 1.0
In-Reply-To: <42011482.56GYn1upCz@amdc1227>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
	<42011482.56GYn1upCz@amdc1227>
Date: Thu, 5 Dec 2013 10:16:14 -0800
X-Google-Sender-Auth: PYb-Qy2SeAOWEddBuatQE27vgQw
Message-ID: <CAD=FV=U_ntCJWgb7qcRve8JqcFVSo5vyuPTabLGGdNUGg56P-Q@mail.gmail.com>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Report when the watchdog reset the system
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, Dec 5, 2013 at 8:21 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Doug,
>
> Please see my comments inline.
>
> On Monday 02 of December 2013 10:14:41 Doug Anderson wrote:
>> A good watchdog driver is supposed to report when it was responsible
>> for resetting the system.  Implement this for the s3c2410, at least on
>> exynos5250 and exynos5420 where we already have a pointer to the PMU
>> registers to read the information.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> This patch is based atop Leela Krishna's recent series that ends with
>> (ARM: dts: update watchdog device nodes for Exynos5250 and Exynos5420)
>> AKA <https://patchwork.kernel.org/patch/3251861/>.
>>
>>  drivers/watchdog/s3c2410_wdt.c | 42 +++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
>> index 47f4dcf..2c87d37 100644
>> --- a/drivers/watchdog/s3c2410_wdt.c
>> +++ b/drivers/watchdog/s3c2410_wdt.c
>> @@ -62,9 +62,13 @@
>>  #define CONFIG_S3C2410_WATCHDOG_ATBOOT               (0)
>>  #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME (15)
>>
>> +#define RST_STAT_REG_OFFSET          0x0404
>
> IMHO this should be namespaced, at least with EXYNOS5 prefix. The two
> registers below should be as well, but I missed this in the patch adding
> them.

Done in v2 (plus fixup of Leela Krishna's).


>>  #define WDT_DISABLE_REG_OFFSET               0x0408
>>  #define WDT_MASK_RESET_REG_OFFSET    0x040c
>>  #define QUIRK_NEEDS_PMU_CONFIG               (1 << 0)
>> +#define QUIRK_HAS_RST_STAT           (1 << 1)
>> +#define QUIRKS_NEED_PMUREG           (QUIRK_NEEDS_PMU_CONFIG | \
>> +                                      QUIRK_HAS_RST_STAT)
>>
>>  static bool nowayout = WATCHDOG_NOWAYOUT;
>>  static int tmr_margin;
>> @@ -98,6 +102,9 @@ MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
>>   * timer reset functionality.
>>   * @mask_bit: Bit number for the watchdog timer in the disable register and the
>>   * mask reset register.
>> + * @rst_stat_reg: Offset in pmureg for the register that has the reset status.
>> + * @rst_stat_bit: Bit number in the rst_stat register indicating a watchdog
>> + * reset.
>>   * @quirks: A bitfield of quirks.
>>   */
>>
>> @@ -105,6 +112,8 @@ struct s3c2410_wdt_variant {
>>       int disable_reg;
>>       int mask_reset_reg;
>>       int mask_bit;
>> +     int rst_stat_reg;
>> +     int rst_stat_bit;
>>       u32 quirks;
>>  };
>>
>> @@ -131,14 +140,20 @@ static const struct s3c2410_wdt_variant drv_data_exynos5250  = {
>>       .disable_reg = WDT_DISABLE_REG_OFFSET,
>>       .mask_reset_reg = WDT_MASK_RESET_REG_OFFSET,
>>       .mask_bit = 20,
>> -     .quirks = QUIRK_NEEDS_PMU_CONFIG
>> +     .rst_stat_reg = RST_STAT_REG_OFFSET,
>> +     .rst_stat_bit = 20,
>> +     .quirks = QUIRK_NEEDS_PMU_CONFIG |
>> +             QUIRK_HAS_RST_STAT,
>>  };
>>
>>  static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
>>       .disable_reg = WDT_DISABLE_REG_OFFSET,
>>       .mask_reset_reg = WDT_MASK_RESET_REG_OFFSET,
>>       .mask_bit = 0,
>> -     .quirks = QUIRK_NEEDS_PMU_CONFIG
>> +     .rst_stat_reg = RST_STAT_REG_OFFSET,
>> +     .rst_stat_bit = 9,
>> +     .quirks = QUIRK_NEEDS_PMU_CONFIG |
>> +             QUIRK_HAS_RST_STAT,
>>  };
>>
>>  static const struct of_device_id s3c2410_wdt_match[] = {
>> @@ -423,6 +438,25 @@ static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
>>  }
>>  #endif
>>
>> +static inline unsigned int s3c2410wdt_get_bootstatus(struct s3c2410_wdt *wdt)
>> +{
>> +     unsigned int bootstatus = 0;
>> +     int ret;
>> +
>> +     if (wdt->drv_data->quirks & QUIRK_HAS_RST_STAT) {
>
> nit: I guess it's just a matter of taste, but to reduce code indentation
> you could inverse the check and simply return 0 here.

Done in v2.  This is the same suggestion Olof made.

-Doug
