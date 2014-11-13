Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaKMKs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:48:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52067 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaKMKs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:48:57 -0500
Message-ID: <54648C95.6020704@arm.com>
Date: Thu, 13 Nov 2014 10:48:53 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 07/16] genirq: Introduce helper irq_domain_set_info()
 to reduce duplicated code
References: <20141112133941.647950773@linutronix.de>  <20141112134120.393705922@linutronix.de> <1415872649.17958.37.camel@mtksdaap41> <54648138.2070900@linux.intel.com>
In-Reply-To: <54648138.2070900@linux.intel.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Nov 2014 10:48:54.0405 (UTC) FILETIME=[6B327B50:01CFFF2F]
X-MC-Unique: 114111310485404901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/14 10:00, Jiang Liu wrote:
> On 2014/11/13 17:57, Yingjoe Chen wrote:
>> On Wed, 2014-11-12 at 13:43 +0000, Thomas Gleixner wrote:
>>> Index: tip/kernel/irq/irqdomain.c
>>> ===================================================================
>>> --- tip.orig/kernel/irq/irqdomain.c
>>> +++ tip/kernel/irq/irqdomain.c
>>> @@ -882,6 +882,16 @@ int irq_domain_set_hwirq_and_chip(struct
>>>  	return 0;
>>>  }
>>>  
>>> +void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
>>> +			 irq_hw_number_t hwirq, struct irq_chip *chip,
>>> +			 void *chip_data, irq_flow_handler_t handler,
>>> +			 void *handler_data, const char *handler_name)
>>> +{
>>> +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
>>> +	__irq_set_handler(virq, handler, 0, handler_name);
>>> +	irq_set_handler_data(virq, handler_data);
>>> +}
>>> +
>>
>> Hi,
>>
>> While trying to use this function, I'm not sure about its interface.
>> This function have 8 parameters but only save 3 function calls. After
>> checking uses in Jiang's original patch, I think this make code harder
>> to understand.
> Hi Joe,
> 	It's true, but we also want to reduce duplicated code:(

I'm in two minds about this one.

Yes, it looks horrible (to be fair, I hate anything that has more than 3
or 4 parameters, because I can never remember what they're for).

On the other hand, it gives you a nice check-point in your code, with
all the bits you need to set, or at least consider. Because it depends
on so many things that you may have to construct/obtain, you quickly
realize that there is not that many locations in your stack that fits
these requirements. Yes, this a twisted reasoning.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

