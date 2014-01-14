Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaANUri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:47:38 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44866 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaANUrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:47:36 -0500
Message-ID: <52D5A266.5000504@codeaurora.org>
Date: Tue, 14 Jan 2014 12:47:34 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 02/10] genirq: Add devm_request_any_context_irq()
References: <1388709460-19222-1-git-send-email-sboyd@codeaurora.org> <1388709460-19222-3-git-send-email-sboyd@codeaurora.org> <52CB2D29.3050107@codeaurora.org>
In-Reply-To: <52CB2D29.3050107@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/14 14:24, Stephen Boyd wrote:
> On 01/02/14 16:37, Stephen Boyd wrote:
>> Some drivers use request_any_context_irq() but there isn't a
>> devm_* function for it. Add one so that these drivers don't need
>> to explicitly free the irq on driver detach.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Thomas, can you please review this patch?

ping?

>> ---
>>  include/linux/interrupt.h |  5 +++++
>>  kernel/irq/devres.c       | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 50 insertions(+)
>>
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 0053adde0ed9..a2678d35b5a2 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -158,6 +158,11 @@ devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
>>  					 devname, dev_id);
>>  }
>>  
>> +extern int __must_check
>> +devm_request_any_context_irq(struct device *dev, unsigned int irq,
>> +		 irq_handler_t handler, unsigned long irqflags,
>> +		 const char *devname, void *dev_id);
>> +
>>  extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
>>  
>>  /*
>> diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
>> index bd8e788d71e0..1ef0606797c9 100644
>> --- a/kernel/irq/devres.c
>> +++ b/kernel/irq/devres.c
>> @@ -73,6 +73,51 @@ int devm_request_threaded_irq(struct device *dev, unsigned int irq,
>>  EXPORT_SYMBOL(devm_request_threaded_irq);
>>  
>>  /**
>> + *	devm_request_any_context_irq - allocate an interrupt line for a managed device
>> + *	@dev: device to request interrupt for
>> + *	@irq: Interrupt line to allocate
>> + *	@handler: Function to be called when the IRQ occurs
>> + *	@thread_fn: function to be called in a threaded interrupt context. NULL
>> + *		    for devices which handle everything in @handler
>> + *	@irqflags: Interrupt type flags
>> + *	@devname: An ascii name for the claiming device
>> + *	@dev_id: A cookie passed back to the handler function
>> + *
>> + *	Except for the extra @dev argument, this function takes the
>> + *	same arguments and performs the same function as
>> + *	request_any_context_irq().  IRQs requested with this function will be
>> + *	automatically freed on driver detach.
>> + *
>> + *	If an IRQ allocated with this function needs to be freed
>> + *	separately, devm_free_irq() must be used.
>> + */
>> +int devm_request_any_context_irq(struct device *dev, unsigned int irq,
>> +			      irq_handler_t handler, unsigned long irqflags,
>> +			      const char *devname, void *dev_id)
>> +{
>> +	struct irq_devres *dr;
>> +	int rc;
>> +
>> +	dr = devres_alloc(devm_irq_release, sizeof(struct irq_devres),
>> +			  GFP_KERNEL);
>> +	if (!dr)
>> +		return -ENOMEM;
>> +
>> +	rc = request_any_context_irq(irq, handler, irqflags, devname, dev_id);
>> +	if (rc) {
>> +		devres_free(dr);
>> +		return rc;
>> +	}
>> +
>> +	dr->irq = irq;
>> +	dr->dev_id = dev_id;
>> +	devres_add(dev, dr);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(devm_request_any_context_irq);
>> +
>> +/**
>>   *	devm_free_irq - free an interrupt
>>   *	@dev: device to free interrupt for
>>   *	@irq: Interrupt line to free


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

