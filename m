Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaIYDEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:04:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:39323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaIYDEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:04:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,593,1406617200"; 
   d="scan'208";a="608224960"
Message-ID: <54238645.8090502@linux.intel.com>
Date: Thu, 25 Sep 2014 11:04:37 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>
CC: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        yh.chen@mediatek.com, linux-kernel@vger.kernel.org,
        srv_heupstream@mediatek.com, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, nathan.chung@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, eddie.huang@mediatek.com,
        yingjoe.chen@gmail.com, linux-arm-kernel@lists.infradead.org,
        hc.yen@mediatek.com
Subject: Re: [PATCH] [RFC] Using hierarchy irqdomian to implement MTK intpol.
References: <1411574696-1881-1-git-send-email-srv_yingjoe.chen@mediatek.com> <1411611417.21763.56.camel@mtksdaap41>
In-Reply-To: <1411611417.21763.56.camel@mtksdaap41>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,
	Thanks, I will merge them into my next version.
Regards!
Gerry

On 2014/9/25 10:16, Joe.C wrote:
> 
> Jiang,
> 
> Please consider merge the following 2 changes into your next round.
> 
> On Thu, 2014-09-25 at 00:04 +0800, Joe.C wrote:
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index e285f3a..01e852b 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -467,7 +467,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>>  	struct irq_domain *domain;
>>  	irq_hw_number_t hwirq;
>>  	unsigned int type = IRQ_TYPE_NONE;
>> -	unsigned int virq;
>> +	int virq;
>>  
>>  	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
>>  	if (!domain) {
>> @@ -493,8 +493,8 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>>  	else
>>  #endif
>>  		virq = irq_create_mapping(domain, hwirq);
>> -	if (!virq)
>> -		return virq;
>> +	if (virq <= 0)
>> +		return 0;
>>  
>>  	/* Set type if specified and different than the current one */
>>  	if (type != IRQ_TYPE_NONE &&
> 
> irq_of_parse_and_map()/of_irq_to_resource() expect
> irq_create_of_mapping() to return 0 when fail. Return error code will
> cause of_irq_to_resource crash.
> 
> 
>> @@ -716,20 +716,20 @@ const struct irq_domain_ops irq_domain_simple_ops = {
>>  };
>>  EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
>>  
>> -static int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
>> +static int irq_domain_alloc_descs(int virq, unsigned int cnt,
>>  				  irq_hw_number_t hwirq, int node)
>>  {
>>  	unsigned int hint;
>>  
>>  	if (virq >= 0) {
>> -		virq = irq_alloc_descs(virq, virq, nr_irqs, node);
>> +		virq = irq_alloc_descs(virq, virq, cnt, node);
>>  	} else {
>>  		hint = hwirq % nr_irqs;
>>  		if (hint == 0)
>>  			hint++;
>> -		virq = irq_alloc_descs_from(hint, nr_irqs, node);
>> +		virq = irq_alloc_descs_from(hint, cnt, node);
>>  		if (virq <= 0 && hint > 1)
>> -			virq = irq_alloc_descs_from(1, nr_irqs, node);
>> +			virq = irq_alloc_descs_from(1, cnt, node);
>>  	}
>>  
>>  	return virq;
> 
> This come from irq_create_mapping(), the original code is using global
> nr_irqs. Change to match original behavior.
> 
> Joe.C
> 
> 
