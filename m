Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaKRLrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:47:47 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:21356 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbaKRLrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:47:46 -0500
Message-ID: <546B31CE.2020006@huawei.com>
Date: Tue, 18 Nov 2014 19:47:26 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 04/16] genirq: Introduce irq_chip.irq_compose_msi_msg()
 to support stacked irqchip
References: <20141112133941.647950773@linutronix.de> <20141112134120.137871641@linutronix.de> <546B10D2.4050300@huawei.com> <alpine.DEB.2.11.1411181059090.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411181059090.3909@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.546B31D6.0179,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 6238dd641418c1b785ddebf0b5c717a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 18:02, Thomas Gleixner wrote:

> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>> On 2014/11/12 21:42, Thomas Gleixner wrote:
>>> +int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>>> +{
>>> +	struct irq_data *pos = NULL;
>>> +
>>> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>>> +	for (; data; data = data->parent_data)
>>> +#endif
>>> +		if (data->chip && data->chip->irq_compose_msi_msg)
>>> +			pos = data;
>>> +	if (!pos)
>>> +		return -ENOSYS;
>>> +
>>> +	pos->chip->irq_compose_msi_msg(pos, msg);
>>> +
>>> +	return 0;
>>> +}
>>
>> Adding message composing routine to struct irq_chip is OK to me, and it should
>> be because it is interrupt controllers' duty to compose messages (so that they
>> can parse the messages correctly without any pre-defined rules that endpoint
>> devices absolutely need not to know).
>> However a problem comes out when deciding which parameters should be passed to
>> this routine. A message can associate with multiple interrupts, which makes me
>> think composing messages for each interrupt is not that appropriate. And we
>> can take a look at the new routine irq_chip_compose_msi_msg(). It is called by
>> msi_domain_activate() which will be called by irq_domain_activate_irq() in
>> irq_startup() for each interrupt descriptor, result in composing a message for
>> each interrupt, right? (Unless requiring a judge on the parameter @data when
>> implementing the irq_compose_msi_msg() callback that only compose message for
>> the first entry of that message. But I really don't like that...)
> 
> No, that's not correct. You are looking at some random stale version
> of this. The current state of affairs is in 
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/irqdomain
> 
> See also https://lkml.org/lkml/2014/11/17/764
> 
> In activate we write the message, which is the right point to do so.
> 

I checked the current state, it seems to be the same.
Yes, the decision of postponing the actual hardware programming to the point
where the interrupt actually gets used is right, but here above I was talking
another thing.
As I mentioned, a message can associate with multiple interrupts. Enabling
any of them will call irq_startup(). So if we don't want to compose or write
messages repeatedly, we'd better require performing some checks before
activating the interrupts.

Thanks,
	Abel

