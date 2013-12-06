Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab3LFVIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:08:19 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58555 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3LFVIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:08:16 -0500
MIME-Version: 1.0
In-Reply-To: <20131206195419.GD14464@roeck-us.net>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
	<1386267329-9941-1-git-send-email-dianders@chromium.org>
	<1386267329-9941-2-git-send-email-dianders@chromium.org>
	<20131206195419.GD14464@roeck-us.net>
Date: Fri, 6 Dec 2013 13:08:15 -0800
X-Google-Sender-Auth: UMbIynHRHSFagUR9nDwQj_-SXFE
Message-ID: <CAD=FV=W8S5FFBcAq=4enA0zbBUwbomr62eYeMyYtc+SAKXpqPg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] watchdog: s3c2410_wdt: Report when the watchdog
 reset the system
From: Doug Anderson <dianders@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,

On Fri, Dec 6, 2013 at 11:54 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Thu, Dec 05, 2013 at 10:15:29AM -0800, Doug Anderson wrote:
>> A good watchdog driver is supposed to report when it was responsible
>> for resetting the system.  Implement this for the s3c2410, at least on
>> exynos5250 and exynos5420 where we already have a pointer to the PMU
>> registers to read the information.
>>
>> Note that exynos4 SoCs also provide the reset status, but providing
>> that is left as an exercise for future changes and is not plumbed up
>> in this patch series.  Also note the exynos4 SoCs don't appear to need
>> any PMU config, which is why this patch separates the concepts of
>> having PMU Registers vs. needing PMU Config.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> Changes in v2:
>> - Explained QUIRK organization in patch descritpion.
>> - Reduced indentation as per Olof and Tomasz suggestion.
>> - Now atop proposed v12 of Leela Krishna's patches.
>
> Hi Doug,
>
> The patch doesn't apply on top of v12, unfortunately.

OK, I'll re-send shortly.


>> - NEEDS => HAS, EXYNOS5 prefix
>>
>>  drivers/watchdog/s3c2410_wdt.c | 42 +++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
>> index 6a00299..45a9503 100644
>> --- a/drivers/watchdog/s3c2410_wdt.c
>> +++ b/drivers/watchdog/s3c2410_wdt.c
>> @@ -62,9 +62,15 @@
>>  #define CONFIG_S3C2410_WATCHDOG_ATBOOT               (0)
>>  #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME (15)
>>
>> +#define EXYNOS5_RST_STAT_REG_OFFSET          0x0404
>>  #define EXYNOS5_WDT_DISABLE_REG_OFFSET               0x0408
>>  #define EXYNOS5_WDT_MASK_RESET_REG_OFFSET    0x040c
>>  #define QUIRK_HAS_PMU_CONFIG                 (1 << 0)
>> +#define QUIRK_HAS_RST_STAT                   (1 << 1)
>> +
>> +/* These quirks require that we have a PMU register map */
>> +#define QUIRKS_HAVE_PMUREG                   (QUIRK_HAS_PMU_CONFIG | \
>> +                                              QUIRK_HAS_RST_STAT)
>>
>>  static bool nowayout = WATCHDOG_NOWAYOUT;
>>  static int tmr_margin;
>> @@ -98,6 +104,9 @@ MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
>>   * timer reset functionality.
>>   * @mask_bit: Bit number for the watchdog timer in the disable register and the
>>   * mask reset register.
>> + * @rst_stat_reg: Offset in pmureg for the register that has the reset status.
>> + * @rst_stat_bit: Bit number in the rst_stat register indicating a watchdog
>> + * reset.
>>   * @quirks: A bitfield of quirks.
>>   */
>>
>> @@ -105,6 +114,8 @@ struct s3c2410_wdt_variant {
>>       int disable_reg;
>>       int mask_reset_reg;
>>       int mask_bit;
>> +     int rst_stat_reg;
>> +     int rst_stat_bit;
>>       u32 quirks;
>>  };
>>
>> @@ -131,14 +142,20 @@ static const struct s3c2410_wdt_variant drv_data_exynos5250  = {
>>       .disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
>>       .mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
>>       .mask_bit = 20,
>> -     .quirks = QUIRK_HAS_PMU_CONFIG
>> +     .rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
>> +     .rst_stat_bit = 20,
>> +     .quirks = QUIRK_HAS_PMU_CONFIG |
>> +             QUIRK_HAS_RST_STAT,
>
> Any reason not to use QUIRKS_HAVE_PMUREG ?

My intent was that the QUIRKS_HAVE_PMUREG is a list of quirks that
require a PMU register and is used for testing, not for setting.  When
someone adds another quirk that requires the PMU Registers I don't
want that to automatically apply to old hardware.


>>  };
>>
>>  static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
>>       .disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
>>       .mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
>>       .mask_bit = 0,
>> -     .quirks = QUIRK_HAS_PMU_CONFIG
>> +     .rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
>> +     .rst_stat_bit = 9,
>> +     .quirks = QUIRK_HAS_PMU_CONFIG |
>> +             QUIRK_HAS_RST_STAT,
>
> Same here. Even if you don't use QUIRKS_HAVE_PMUREG, the continuation line is not needed.

I will spin.


Thanks!

-Doug
