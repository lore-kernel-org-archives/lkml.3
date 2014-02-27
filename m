Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaB0OeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:34:23 -0500
Received: from mail-de.keymile.com ([195.8.104.250]:49371 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaB0OeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:34:22 -0500
Message-ID: <530F4CDE.7010205@keymile.com>
Date: Thu, 27 Feb 2014 15:34:06 +0100
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Austin Boyle <Austin.Boyle@aviatnet.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: m25p80: Flash protection support for STmicro chips
References: <1357257748.31023.12.camel@pc786-ubu.GNET.GLOBAL.VPN> <528D15B6.2030800@keymile.com>
In-Reply-To: <528D15B6.2030800@keymile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it's me again.
In my opinion (and experience) this introduces a pretty serious bug (not 
to mention the compatibility issues), yet I haven't heard a single word 
or found a patch applied about it in three months.
Am I the only one having this issue? Or maybe I'm just "seeing things"?

Thank you,
Gerlando

P.S. FWIW, the original author of the patch seem to have disappeared.

On 11/20/2013 09:04 PM, Gerlando Falauto wrote:
> Hi,
>
> On 01/04/2013 01:02 AM, Austin Boyle wrote:
>> This patch adds generic support for flash protection on STmicro chips.
>> On chips with less than 3 protection bits, the unused bits are don't
>> cares
>> and so can be written anyway.
>
> I have two remarks:
>
> 1) I believe this introduces incompatibilities with existing bootloaders
> which do not support this feature.
> Namely, u-boot is not able (to the best of my knowledge) to treat these
> bits properly. So as soon as you write something to your SPI nor flash
> from within linux, u-boot is not able to erase/rewrite those blocks
> anymore.
>
> Wouldn't it make more sense to selectively enable this feature, only if
> explicity configured to do so (e.g. through its device tree node)?
> Like what was used for the Spansion's PPB, see:
>
> http://lists.infradead.org/pipermail/linux-mtd/2013-January/045536.html
>
>  > The lock function will only change the
>> protection bits if it would not unlock other areas. Similarly, the unlock
>> function will not lock currently unlocked areas. Tested on the m25p64.
>  >
>> From: Austin Boyle <Austin.Boyle@aviatnet.com>
>> Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
>> ---
>> diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
>> index 4eeeb2d..069e34f 100644
>> --- a/drivers/mtd/devices/m25p80.c
>> +++ b/drivers/mtd/devices/m25p80.c
>> @@ -565,6 +565,96 @@ time_out:
>>       return ret;
>>   }
>>
>> +static int m25p80_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>> +{
>> +    struct m25p *flash = mtd_to_m25p(mtd);
>> +    uint32_t offset = ofs;
>> +    uint8_t status_old, status_new;
>> +    int res = 0;
>> +
>> +    mutex_lock(&flash->lock);
>> +    /* Wait until finished previous command */
>> +    if (wait_till_ready(flash)) {
>> +        res = 1;
>> +        goto err;
>> +    }
>> +
>> +    status_old = read_sr(flash);
>> +
>> +    if (offset < flash->mtd.size-(flash->mtd.size/2))
>> +        status_new = status_old | SR_BP2 | SR_BP1 | SR_BP0;
>> +    else if (offset < flash->mtd.size-(flash->mtd.size/4))
>> +        status_new = (status_old & ~SR_BP0) | SR_BP2 | SR_BP1;
>> +    else if (offset < flash->mtd.size-(flash->mtd.size/8))
>> +        status_new = (status_old & ~SR_BP1) | SR_BP2 | SR_BP0;
>> +    else if (offset < flash->mtd.size-(flash->mtd.size/16))
>> +        status_new = (status_old & ~(SR_BP0|SR_BP1)) | SR_BP2;
>> +    else if (offset < flash->mtd.size-(flash->mtd.size/32))
>> +        status_new = (status_old & ~SR_BP2) | SR_BP1 | SR_BP0;
>> +    else if (offset < flash->mtd.size-(flash->mtd.size/64))
>> +        status_new = (status_old & ~(SR_BP2|SR_BP0)) | SR_BP1;
>> +    else
>> +        status_new = (status_old & ~(SR_BP2|SR_BP1)) | SR_BP0;
>
> 2) While I believe this might work on m25p32, m25p64 and m25p128 (i.e.
> flashes with 64 blocks or more), it looks incorrect for smaller chips
> (namely our m25p80, with just 16 blocks). There, the 1/64 logic scales
> down to 1/16, e.g.
> - 000 means protect nothing
> - 001 means protect 1/16th (=1 blocks)    [m25p64 => 1/64th]
> - 010 means protect 1/8th  (=2 blocks)    [m25p64 => 1/32th]
> - ...
> - 100 means protect 1/2nd  (=8 blocks)
> - 101,110, 111 mean protect everything
>
> and I assume the same goes for chips with fewer sectors.
>
> Any comments?
>
> Thanks,
> Gerlando
>
>> +
>> +    /* Only modify protection if it will not unlock other areas */
>> +    if ((status_new&(SR_BP2|SR_BP1|SR_BP0)) >
>> +                    (status_old&(SR_BP2|SR_BP1|SR_BP0))) {
>> +        write_enable(flash);
>> +        if (write_sr(flash, status_new) < 0) {
>> +            res = 1;
>> +            goto err;
>> +        }
>> +    }
>> +
>> +err:    mutex_unlock(&flash->lock);
>> +    return res;
>> +}
>> +
>> +static int m25p80_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>> +{
>> +    struct m25p *flash = mtd_to_m25p(mtd);
>> +    uint32_t offset = ofs;
>> +    uint8_t status_old, status_new;
>> +    int res = 0;
>> +
>> +    mutex_lock(&flash->lock);
>> +    /* Wait until finished previous command */
>> +    if (wait_till_ready(flash)) {
>> +        res = 1;
>> +        goto err;
>> +    }
>> +
>> +    status_old = read_sr(flash);
>> +
>> +    if (offset+len > flash->mtd.size-(flash->mtd.size/64))
>> +        status_new = status_old & ~(SR_BP2|SR_BP1|SR_BP0);
>> +    else if (offset+len > flash->mtd.size-(flash->mtd.size/32))
>> +        status_new = (status_old & ~(SR_BP2|SR_BP1)) | SR_BP0;
>> +    else if (offset+len > flash->mtd.size-(flash->mtd.size/16))
>> +        status_new = (status_old & ~(SR_BP2|SR_BP0)) | SR_BP1;
>> +    else if (offset+len > flash->mtd.size-(flash->mtd.size/8))
>> +        status_new = (status_old & ~SR_BP2) | SR_BP1 | SR_BP0;
>> +    else if (offset+len > flash->mtd.size-(flash->mtd.size/4))
>> +        status_new = (status_old & ~(SR_BP0|SR_BP1)) | SR_BP2;
>> +    else if (offset+len > flash->mtd.size-(flash->mtd.size/2))
>> +        status_new = (status_old & ~SR_BP1) | SR_BP2 | SR_BP0;
>> +    else
>> +        status_new = (status_old & ~SR_BP0) | SR_BP2 | SR_BP1;
>> +
>> +    /* Only modify protection if it will not lock other areas */
>> +    if ((status_new&(SR_BP2|SR_BP1|SR_BP0)) <
>> +                    (status_old&(SR_BP2|SR_BP1|SR_BP0))) {
>> +        write_enable(flash);
>> +        if (write_sr(flash, status_new) < 0) {
>> +            res = 1;
>> +            goto err;
>> +        }
>> +    }
>> +
>> +err:    mutex_unlock(&flash->lock);
>> +    return res;
>> +}
>> +
>>
>> /****************************************************************************/
>>
>>
>>   /*
>> @@ -899,6 +989,12 @@ static int m25p_probe(struct spi_device *spi)
>>       flash->mtd._erase = m25p80_erase;
>>       flash->mtd._read = m25p80_read;
>>
>> +    /* flash protection support for STmicro chips */
>> +    if (JEDEC_MFR(info->jedec_id) == CFI_MFR_ST) {
>> +        flash->mtd._lock = m25p80_lock;
>> +        flash->mtd._unlock = m25p80_unlock;
>> +    }
>> +
>>       /* sst flash chips use AAI word program */
>>       if (JEDEC_MFR(info->jedec_id) == CFI_MFR_SST)
>>           flash->mtd._write = sst_write;
>>
>>
>> ______________________________________________________
>> Linux MTD discussion mailing list
>> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>>
>
>

