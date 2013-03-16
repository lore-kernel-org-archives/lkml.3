Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3CPMhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 08:37:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45777 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab3CPMhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 08:37:03 -0400
Message-ID: <51446763.5010606@ti.com>
Date: Sat, 16 Mar 2013 08:36:51 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 07/50] staging: omap-thermal: introduce RMW_BITS macro
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com> <1363352438-15935-8-git-send-email-eduardo.valentin@ti.com> <20130315210946.GK9138@mwanda>
In-Reply-To: <20130315210946.GK9138@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,

On 15-03-2013 17:09, Dan Carpenter wrote:
> On Fri, Mar 15, 2013 at 08:59:55AM -0400, Eduardo Valentin wrote:
>> This patch introduce a macro to read, update, write bitfields.
>> It will be specific to bandgap data structures.
>>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>   drivers/staging/omap-thermal/omap-bandgap.c |  178 +++++++--------------------
>>   1 files changed, 46 insertions(+), 132 deletions(-)
>>
>> diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
>> index 9f2d7cc..1c1b905 100644
>> --- a/drivers/staging/omap-thermal/omap-bandgap.c
>> +++ b/drivers/staging/omap-thermal/omap-bandgap.c
>> @@ -52,25 +52,29 @@ static void omap_bandgap_writel(struct omap_bandgap *bg_ptr, u32 val, u32 reg)
>>   	writel(val, bg_ptr->base + reg);
>>   }
>>
>> +/* update bits, value will be shifted */
>> +#define RMW_BITS(bg_ptr, id, reg, mask, val)			\
>> +do {								\
>> +	struct temp_sensor_registers *t;			\
>> +	u32 r;							\
>> +								\
>> +	t = bg_ptr->conf->sensors[(id)].registers;		\
>> +	r = omap_bandgap_readl(bg_ptr, t->reg);			\
>> +	r &= ~t->mask;						\
>> +	r |= (val) << __ffs(t->mask);				\
>> +	omap_bandgap_writel(bg_ptr, r, t->reg);			\
>> +} while (0)
>> +
>>   static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
>>   {
>> -	struct temp_sensor_registers *tsr;
>>   	int i;
>> -	u32 ctrl;
>>
>>   	if (!OMAP_BANDGAP_HAS(bg_ptr, POWER_SWITCH))
>>   		return 0;
>>
>> -	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
>> -		tsr = bg_ptr->conf->sensors[i].registers;
>> -		ctrl = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
>> -		ctrl &= ~tsr->bgap_tempsoff_mask;
>> +	for (i = 0; i < bg_ptr->conf->sensor_count; i++)
>>   		/* active on 0 */
>> -		ctrl |= !on << __ffs(tsr->bgap_tempsoff_mask);
>> -
>> -		/* write BGAP_TEMPSOFF should be reset to 0 */
>> -		omap_bandgap_writel(bg_ptr, ctrl, tsr->temp_sensor_ctrl);
>> -	}
>> +		RMW_BITS(bg_ptr, i, temp_sensor_ctrl, bgap_tempsoff_mask, !on);
>>
>>   	return 0;
>>   }
>> @@ -78,15 +82,13 @@ static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
>>   static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
>>   {
>
> This patch is fine and it makes it cleaner than before.
>
> But that said, I don't care for the RMW_BITS() very much as a long
> term thing.  If we just used pointers instead of passing the offset
> into the bg_ptr->conf->sensors[] array then everything would be a
> lot cleaner.
>
> In other words, instead of this:
>
> static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
>
> We would have:
>
> static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr,
> 				  struct temp_sensor_registers *tsr)

I see. That will require a change in the whole driver though. If you 
see, the driver as of today uses the former approach, not only for 
read_temp or rmw_bits.

>
> If you have the pointer then it's easy write RMW_BITS() as a
> function.
>
> static void rmw_bits(struct omap_bandgap *bg_ptr, u32 reg, u32 mask, u32 val)
> {
> 	u32 r;
>
> 	r = omap_bandgap_readl(bg_ptr, reg);
> 	r &= ~mask;
> 	r |= val << __ffs(mask);
> 	omap_bandgap_writel(bg_ptr, r, reg);
> }
>
> It's called like:
>
> 	rmw_bits(bg_ptr, tsr->bgap_mask_ctrl, tsr->mask_freeze_mask, 1);

This is nice, but it will require fetching tsr from .conf before every 
call o rmw_bits. And for that you need the sensor index.

>
> regards,
> dan carpenter

Thanks for your time reviewing this patch and suggesting improvements.

>
>
>
>

