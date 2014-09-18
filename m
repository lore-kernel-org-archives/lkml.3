Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaIRJaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:30:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:61065 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbaIRJaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:30:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,546,1406617200"; 
   d="scan'208";a="601504738"
Message-ID: <541AA677.7050907@intel.com>
Date: Thu, 18 Sep 2014 11:31:35 +0200
From: Loic Poulain <loic.poulain@intel.com>
Organization: Intel Corporation SAS - RCS Nanterre B 302 456 199 - 2 rue de
 Paris, 92196 Meudon Cedex, France 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@intel.com>
CC: linus.walleij@linaro.org, heikki.krogerus@linux.intel.com,
        mathias.nyman@linux.intel.com, samuel.ortiz@intel.com,
        linux-kernel@vger.kernel.org, Eric Ernst <eric.ernst@linux.intel.com>
Subject: Re: [PATCHv2] pinctrl: baytrail: Clear DIRECT_IRQ bit
References: <1410961621-15231-1-git-send-email-loic.poulain@intel.com> <20140918074910.GC10854@lahna.fi.intel.com>
In-Reply-To: <20140918074910.GC10854@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn seems necessary because we unconditionally change
the pin behavior, I didn't meet any case where direct irq is truly
used on our platform. But maybe it could happen?
Don't want to cause any hidden regression.

Moreover if it is confirmed that is an hardware issue (BIOS),
We can just keep this patch locally as a workaround and revert
it later once our BIOS fixed.

Regards,
Loic

On 18/09/2014 09:49, Mika Westerberg wrote:
> On Wed, Sep 17, 2014 at 03:47:01PM +0200, Loic Poulain wrote:
>> Direct Irq En bit can be initialized to a bad value.
>> This bit has to be cleared for io access mode.
> +Eric
>
> I would like to have a bit better explanation *why* this bit needs to be
> cleared.
>
> Also want to ask Eric (who added the WARN()), is there something
> preventing us to do this? I remember last time you said that we are not
> supposed to change this bit runtime.
>
> My preference is that we get rid of the WARN() and just unconditionally
> clear the bit.
>
>> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
>> ---
>>   v2: Apply over ff998356b644ebe723127bd9eec6040b59a4a4f6 + add Warning
>>
>>   drivers/pinctrl/pinctrl-baytrail.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
>> index 701a646..77db3db 100644
>> --- a/drivers/pinctrl/pinctrl-baytrail.c
>> +++ b/drivers/pinctrl/pinctrl-baytrail.c
>> @@ -230,10 +230,13 @@ static int byt_irq_type(struct irq_data *d, unsigned type)
>>   	spin_lock_irqsave(&vg->lock, flags);
>>   	value = readl(reg);
>>
>> +	WARN(value & BYT_DIRECT_IRQ_EN, "Clearing direct_irq_en bit");
>> +
> I wonder how the average user react when this pops up in the dmesg :-)
>
>>   	/* For level trigges the BYT_TRIG_POS and BYT_TRIG_NEG bits
>>   	 * are used to indicate high and low level triggering
>>   	 */
>> -	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
>> +	value &= ~(BYT_DIRECT_IRQ_EN | BYT_TRIG_POS | BYT_TRIG_NEG |
>> +		   BYT_TRIG_LVL);
>>
>>   	switch (type) {
>>   	case IRQ_TYPE_LEVEL_HIGH:
>> --
>> 1.8.3.2

-- 
Intel Open Source Technology Center
http://oss.intel.com/

