Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab3FRRWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:22:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49746 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3FRRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:22:45 -0400
Message-ID: <51C09761.1020704@wwwdotorg.org>
Date: Tue, 18 Jun 2013 11:22:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "J, KEERTHY" <j-keerthy@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH v2 1/4] MFD: Palmas: Check if interrupts property exists
 and then only request irq
References: <1371549692-7361-1-git-send-email-j-keerthy@ti.com> <1371549692-7361-2-git-send-email-j-keerthy@ti.com> <51C0820B.4020404@wwwdotorg.org> <DC88CAD03C0052499C1907B327FC63229EC563@DBDE04.ent.ti.com> <51C093FF.6000204@wwwdotorg.org> <DC88CAD03C0052499C1907B327FC63229EC5B4@DBDE04.ent.ti.com>
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229EC5B4@DBDE04.ent.ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 11:19 AM, J, KEERTHY wrote:
> 
> 
>> -----Original Message-----
>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>> Sent: Tuesday, June 18, 2013 10:38 PM
>> To: J, KEERTHY
>> Cc: linux-omap@vger.kernel.org; broonie@kernel.org;
>> ldewangan@nvidia.com; sameo@linux.intel.com; grant.likely@secretlab.ca;
>> swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-
>> doc@vger.kernel.org; gg@slimlogic.co.uk
>> Subject: Re: [PATCH v2 1/4] MFD: Palmas: Check if interrupts property
>> exists and then only request irq
>>
>> On 06/18/2013 10:54 AM, J, KEERTHY wrote:
>>> Hi Stephen,
>>>
>>>> -----Original Message-----
>>>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>>>> Sent: Tuesday, June 18, 2013 9:22 PM
>>>> To: J, KEERTHY
>>>> Cc: linux-omap@vger.kernel.org; broonie@kernel.org;
>>>> ldewangan@nvidia.com; sameo@linux.intel.com;
>>>> grant.likely@secretlab.ca; swarren@nvidia.com;
>>>> linux-kernel@vger.kernel.org; linux- doc@vger.kernel.org;
>>>> gg@slimlogic.co.uk
>>>> Subject: Re: [PATCH v2 1/4] MFD: Palmas: Check if interrupts
>> property
>>>> exists and then only request irq
>>>>
>>>> On 06/18/2013 04:01 AM, J Keerthy wrote:
>>>>> Check if interrupts property exists and then only request irq.
>>>>> On some boards INT line might not be connected to a valid irq line
>>>>> on the application processor. Hence keeping a check before
>>>>> requesting irq.
>>>>
>>>> When there is no interrupts property, surely i2c->irq == 0, which is
>>>> an invalid IRQ, and hence there's no need to check this before
>>>> copying the value?
>>>
>>> The intent here is NOT to request irq with 0 or Invalid IRQ.
>>
>> Sure.
>>
>>> The board File will not populate the interrupts entry if the INT line
>>> is not Connected.
>>
>> Do you mean the interrupts DT property won't be present if there is no
>> interrupt. If so, sure.
> 
> Yes.
> 
>>
>>> Hence the patch checks for the 'interrupts' property.
>>
>> That shouldn't be necessary; IIRC, the I2C core has already parsed the
>> interrupts property if there was one, and if there wasn't, it has set
>> i2c->irq to some invalid value already.
>>
>> So, you simply need to check the value in i2c->irq, and don't need to
>> look at the DT at all.
> 
> Instead of checking the Invalid irq value which most likely can be 0.
> I am not sure.
> I am explicitly checking if the interrupts property exists or not.
> 
> If not present then It throws out a warning. Either there is no
> Valid INT line connection or the DeviceTree was not populated fully.
> 
> This additional piece of information is good to have in the driver
> IMHO. Let me know if this is rational enough to have in the driver.

No, you should just check the IRQ number.

Consider this:

If the device was instantiated from a board file *or* a device tree,
i2c->irq is correctly set. Hence, checking that value works in both cases.

If you check the interrupts DT property, that will only work if the
device was instantiated from device tree, and not if it was instantiated
from a board file; the property will never exist in the board file case,
and hence you'll never be able to have a board file provide an interrupt.
