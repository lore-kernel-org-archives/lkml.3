Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbbAZNHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:07:25 -0500
Received: from exprod5og124.obsmtp.com ([64.18.0.212]:47758 "EHLO
	exprod5og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbAZNHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:07:21 -0500
MIME-Version: 1.0
Reply-To: semen.protsenko@globallogic.com
In-Reply-To: <54C60DF1.9070300@ti.com>
References: <1422131320-1018-1-git-send-email-semen.protsenko@globallogic.com>
	<1422131320-1018-3-git-send-email-semen.protsenko@globallogic.com>
	<54C60DF1.9070300@ti.com>
Date: Mon, 26 Jan 2015 15:07:19 +0200
Message-ID: <CAJOTznVwfMO7EmxcSEAx_v8cBe8apE_buAy2dLORxa-w+nQPLQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: OMAP2+: gpmc: Do not modify LIMITEDADDRESS on
 new architectures
From: Sam Protsenko <semen.protsenko@globallogic.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 11:50 AM, Roger Quadros <rogerq@ti.com> wrote:
> Hi,
>
> On 24/01/15 22:28, Semen Protsenko wrote:
>> New OMAP-based architectures (like OMAP5, DRA7XX, AM572X) don't have
>> LIMITEDADDRESS bit in GPMC_CONFIG register (this bit marked as
>> RESERVED). Seems like these SoCs have new revision of GPMC IP-core
>> (despite of same GPMC_REVISION value as for earlier SoCs).
>>
>> According to OMAP5 TRM: "Nonmultiplexed NOR flash devices are
>> supported by the GPMC, but their use is highly limited. Because only
>> 10 address pins are available on the GPMC interface, the maximum device
>> size supported is 2KiB."
>>
>> From [1]:
>>  - OMAP4 GPMC_CONFIG has LIMITEDADDRESS bit, hence supports both
>>    limited and full address mode.
>>  - OMAP5 GPMC_CONFIG doesn't have LIMITEDDADDRESS bit.
>
> According to OMAP5432 TRM SWPU249AC, I can see LIMITEDADDRESS bit in GPMC_CONFIG.
> Which TRM version are you referring to?
>

Wow, it seems I mixed it with OMAP57xx TRM. Good catch!

>>    OMAP5 supports only limited address mode for nonmultiplexed flashes
>>    In this mode only A1-A10 lines are being modified by GPMC, which
>>    leaves us (on flash devices with 1 word = 2 bytes) only
>>    2^10 * 2 = 2KiB memory that we can access.
>>  - DRA7XX GPMC_CONFIG doesn't have LIMITEDADDRESS bit.
>>    DRA7XX supports only full address mode for nonmultiplexed flashes
>>    (current TRM says contrary, but according to [1] it's typo and
>>    gonna be fixed in new DRA7XX TRMs). In full address mode all
>>    A1-A26 lines are modified by GPMC, so one can address up to 128 MiB.
>>
>> This patch ensures that GPMC driver doesn't try to modify LIMITEDADDRESS
>> bit on new OMAP-based devices, because such an action could possibly
>> lead to undefined behavior in GPMC state-machine (this bit is marked as
>> RESERVED now).
>>
>> [1] http://e2e.ti.com/support/omap/f/885/t/396939
>>
>> Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>
>> ---
>>  drivers/memory/omap-gpmc.c |   32 ++++++++++++++++++++++++--------
>>  1 file changed, 24 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
>> index db77adb..477d0ba 100644
>> --- a/drivers/memory/omap-gpmc.c
>> +++ b/drivers/memory/omap-gpmc.c
>> @@ -108,6 +108,7 @@
>>  #define      GPMC_HAS_WR_ACCESS              0x1
>>  #define      GPMC_HAS_WR_DATA_MUX_BUS        0x2
>>  #define      GPMC_HAS_MUX_AAD                0x4
>> +#define      GPMC_HAS_LIMITEDADDRESS         0x8
>>
>>  #define GPMC_NR_WAITPINS             4
>>
>> @@ -1709,6 +1710,18 @@ static int gpmc_probe_onenand_child(struct platform_device *pdev,
>>  }
>>  #endif
>>
>> +static void gpmc_disable_limited(void)
>> +{
>> +     if (gpmc_capability & GPMC_HAS_LIMITEDADDRESS) {
>> +             u32 val;
>> +
>> +             /* Clear limited address i.e. enable A26-A11 */
>> +             val = gpmc_read_reg(GPMC_CONFIG);
>> +             val &= ~GPMC_CONFIG_LIMITEDADDRESS;
>> +             gpmc_write_reg(GPMC_CONFIG, val);
>> +     }
>> +}
>> +
>>  /**
>>   * gpmc_probe_generic_child - configures the gpmc for a child device
>>   * @pdev:    pointer to gpmc platform device
>> @@ -1726,7 +1739,6 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
>>       unsigned long base;
>>       const char *name;
>>       int ret, cs;
>> -     u32 val;
>>
>>       if (of_property_read_u32(child, "reg", &cs) < 0) {
>>               dev_err(&pdev->dev, "%s has no 'reg' property\n",
>> @@ -1805,10 +1817,7 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
>>               goto err;
>>       }
>>
>> -     /* Clear limited address i.e. enable A26-A11 */
>> -     val = gpmc_read_reg(GPMC_CONFIG);
>> -     val &= ~GPMC_CONFIG_LIMITEDADDRESS;
>> -     gpmc_write_reg(GPMC_CONFIG, val);
>> +     gpmc_disable_limited();
>>
>>       /* Enable CS region */
>>       gpmc_cs_enable_mem(cs);
>> @@ -1935,14 +1944,21 @@ static int gpmc_probe(struct platform_device *pdev)
>>        * devices support the addr-addr-data multiplex protocol.
>>        *
>>        * GPMC IP revisions:
>> -      * - OMAP24xx                   = 2.0
>> -      * - OMAP3xxx                   = 5.0
>> -      * - OMAP44xx/54xx/AM335x       = 6.0
>> +      * - OMAP24xx                           = 2.0
>> +      * - OMAP3xxx                           = 5.0
>> +      * - OMAP44xx/54xx/AM335x/DRA7XX        = 6.0
>>        */
>>       if (GPMC_REVISION_MAJOR(l) > 0x4)
>>               gpmc_capability = GPMC_HAS_WR_ACCESS | GPMC_HAS_WR_DATA_MUX_BUS;
>>       if (GPMC_REVISION_MAJOR(l) > 0x5)
>>               gpmc_capability |= GPMC_HAS_MUX_AAD;
>> +     if (GPMC_REVISION_MAJOR(l) < 0x6)
>> +             gpmc_capability |= GPMC_HAS_LIMITEDADDRESS;
>> +#if !defined(CONFIG_SOC_OMAP5) && !defined(CONFIG_SOC_DRA7XX)
>> +     if (GPMC_REVISION_MAJOR(l) == 0x6)
>> +             gpmc_capability |= GPMC_HAS_LIMITEDADDRESS;
>> +#endif
>> +
>
> This logic will prevent GPMC_HAS_LIMITEDADDRESS to be set on OMAP4 if we have
> either SOC_OMAP5 or SOC_DRA7XX enabled. So it is not good.
>

Why? OMAP4 devices have 0x6 revision of GPMC, and as I remember they don't
define SOC_OMAP5. So this logic enables limited address capability for OMAP4.
Am I missing something?

> I think this patch is unnecessary as we are only setting the reserved bit to 0.
> It is safe to set RESERVED bit to 0. We are not modifying it as RESERVED bit is
> meant to be 0. If bootloader is setting the reserved bit to 1, it is a bug in
> the bootloader.
>

Ok, let's drop this patch then. Anyway, I'm gonna reuse it next week
for another patch
(I want to make it possible to enable/disable limited address mode via
dts bool option).
Also, can you point me out where I can read about RESERVED bit should
be always 0?

>>       dev_info(gpmc_dev, "GPMC revision %d.%d\n", GPMC_REVISION_MAJOR(l),
>>                GPMC_REVISION_MINOR(l));
>>
>>
>
> cheers,
> -roger
