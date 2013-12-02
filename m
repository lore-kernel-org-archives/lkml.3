Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3LBVQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:16:42 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:52461 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab3LBVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:16:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131202202120.GA23611@roeck-us.net>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
	<20131202202120.GA23611@roeck-us.net>
Date: Mon, 2 Dec 2013 13:16:35 -0800
X-Google-Sender-Auth: edz7QVLRMXhol4F2hyFiSxfx454
Message-ID: <CAD=FV=U_ddOu447kCcOfcWS7RA6C7NCPx7CpiuEd-FXcO9dSGw@mail.gmail.com>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Report when the watchdog reset the system
From: Doug Anderson <dianders@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>, Olof Johansson <olof@lixom.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
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

Guenter and Olof,

On Mon, Dec 2, 2013 at 12:21 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Mon, Dec 02, 2013 at 10:14:41AM -0800, Doug Anderson wrote:
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
>>  #define WDT_DISABLE_REG_OFFSET               0x0408
>>  #define WDT_MASK_RESET_REG_OFFSET    0x040c
>>  #define QUIRK_NEEDS_PMU_CONFIG               (1 << 0)
>> +#define QUIRK_HAS_RST_STAT           (1 << 1)
>> +#define QUIRKS_NEED_PMUREG           (QUIRK_NEEDS_PMU_CONFIG | \
>> +                                      QUIRK_HAS_RST_STAT)
>>
> I am not really happy about the NEED (both of them, really) here.
> How about HAS instead ?

Are you suggesting also changing QUIRK_NEEDS_PMU_CONFIG, then?  That
would be a request for Leela Krishna on his patch?

...see below for more...

>
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
>
> Why not use QUIRKS_NEED_PMUREG ?
>
> Also, is there ever a chance that the two bits don't come together ?
> If not a single bit might be sufficient.

Here's my logic:

According to our 3.4 sources (exynos_get_bootstatus) there is a
RST_STAT register on exynos4. See
<https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.4/arch/arm/mach-exynos/pmu.c>.

According to Tomasz at
<http://www.spinics.net/lists/linux-watchdog/msg02942.html> the extra
PMU_CONFIG was needed on exynos5250/5420 and not needed on exynos4.

My patch doesn't actually add RST_STAT support for exynos4 but it
seems wise to pave the way for someone else to add it.


...so basically I was saying:

* On exynos5250 and exynos5420 we _need_ to configure the PMU to get
proper functioning

* On various devices we _have_ a reset status that register that we can query.

* If we need to use the PMU or we want to query the reset status we
need to have PMU registers specified.


Does any of that change your mind(s)?


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

Internally Olof requested to reverse this "if" and return 0 early
(avoid indentation).  I'll fix that up for the next patch.


>> +             unsigned int rst_stat;
>> +
>> +             ret = regmap_read(wdt->pmureg, wdt->drv_data->rst_stat_reg,
>> +                               &rst_stat);
>> +             if (ret)
>> +                     dev_warn(wdt->dev, "Couldn't get RST_STAT register\n");
>> +             else if (rst_stat & BIT(wdt->drv_data->rst_stat_bit))
>> +                     bootstatus |= WDIOF_CARDRESET;
>> +     }
>> +
>> +     return bootstatus;
>> +}
>> +
