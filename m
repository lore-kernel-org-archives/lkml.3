Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbaDJPmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:42:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53683 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569AbaDJPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:42:29 -0400
Message-ID: <5346BBDF.4050901@wwwdotorg.org>
Date: Thu, 10 Apr 2014 09:42:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3 4/5] mfd: palmas: support IRQ inversion at the board
 level
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org> <1393876300-3061-4-git-send-email-swarren@wwwdotorg.org> <CAAVeFuJY67zdoHiZufxDbkaw=xt8YwxyDAwHW_T7UZeSOt35NA@mail.gmail.com>
In-Reply-To: <CAAVeFuJY67zdoHiZufxDbkaw=xt8YwxyDAwHW_T7UZeSOt35NA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 01:04 AM, Alexandre Courbot wrote:
> Stephen, any news about this patch? I'm waiting for it to be merged in
> order to resend some Tegra DTs, but still cannot see it in -next.

To be honest, this became too painful to work on just to fix a warning
at boot which has no practical side-effect in our case. The best thing
to do is just merge your DTs for 3.16, and keep ignoring the warning
just like we always have on Dalmore. Hopefully at some point I (or
someone) will run out of higher priority work items and get back to this.

> Thanks,
> Alex.
> 
> On Tue, Mar 4, 2014 at 4:51 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Implement the new DT property ti,irq-externally-inverted, and add an
>> equivalent platform data field to match. This allows the driver to
>> correctly automatically configure the IRQ output polarity when the board
>> or SoC contains an inverter between the Palmas IRQ output and IRQ
>> controller input.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> v3:
>> * Use an IRQD flag to represent the data, rather than a custom DT property.
>> v2:
>> * Split V1's patch 1/2 into separate patches 1/3 and 2/3.
>> ---
>>  drivers/mfd/palmas.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
>> index d280d789e55a..3281d4103e9d 100644
>> --- a/drivers/mfd/palmas.c
>> +++ b/drivers/mfd/palmas.c
>> @@ -292,7 +292,8 @@ static int palmas_set_pdata_irq_flag(struct i2c_client *i2c,
>>                 return -EINVAL;
>>         }
>>
>> -       pdata->irq_flags = irqd_get_trigger_type(irq_data);
>> +       pdata->irq_flags = irqd_get_trigger_type(irq_data) |
>> +                          irqd_get_src_dst_inverted(irq_data);
>>         dev_info(&i2c->dev, "Irq flag is 0x%08x\n", pdata->irq_flags);
>>         return 0;
>>  }
>> @@ -447,6 +448,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>>                 reg = PALMAS_POLARITY_CTRL_INT_POLARITY;
>>         else
>>                 reg = 0;
>> +       if (pdata->irq_flags & IRQ_SRC_DST_INVERTED)
>> +               reg ^= PALMAS_POLARITY_CTRL_INT_POLARITY;
>>         ret = palmas_update_bits(palmas, PALMAS_PU_PD_OD_BASE,
>>                         PALMAS_POLARITY_CTRL, PALMAS_POLARITY_CTRL_INT_POLARITY,
>>                         reg);
>> --
>> 1.8.1.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

