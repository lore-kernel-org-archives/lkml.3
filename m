Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbbASTJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:09:33 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:24052 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbASTJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:09:31 -0500
X-ME-Helo: beldin
X-ME-Date: Mon, 19 Jan 2015 20:09:28 +0100
X-ME-IP: 109.222.126.211
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
	<1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
	<20150119091705.GG21886@x1>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 19 Jan 2015 20:09:14 +0100
In-Reply-To: <20150119091705.GG21886@x1> (Lee Jones's message of "Mon, 19 Jan
	2015 09:17:05 +0000")
Message-ID: <87ppaah9k5.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Fri, 16 Jan 2015, Robert Jarzmik wrote:
>
>> As a fix, move the gpio0 chained handler setup to a place where we have
>> the guarantee that pxa_gpio_probe() was called before, so that lubbock
>> handler becomes the true IRQ chained handler of GPIO0, demuxing the
>> lubbock IO board interrupts.
>
> How is this guaranteed?
In the following chunk :
	ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler,
			       irqflags, dev_name(&pdev->dev), cot);
	if (ret == -ENOSYS)
		return -EPROBE_DEFER;

See __setup_irq(), and see what happens if the irq chip is not set (which
happens on pxa platform when the gpio driver is not registered).

>> + * Lubbock motherboard driver, supporting lubbock (aka. pxa25x) soc board.
>
> Please use uppercase characters i.e. Lubbock, PXA25X, SoC, etc.
OK, your tree, your rules.

> Superfluous '\n'.
Yep.

> Can this be built as a module?
Not in its current form.

> If so, why isn't it a tristate?
See above.

Now the question is : should it be buildable as a module ? I was thinking it
shouldn't because without this driver lubbock becomes a bit useless (most of its
peripherals are on the motherboard).

>> +struct lubbock {
>> +	void __iomem	*base;
>
> Random spacing.
Right.

>> +	pending = readl(cot->base + COT_IRQ_SET_CLR) & cot->irq_mask;
>> +	for_each_set_bit(bit, &pending, LUBBOCK_NB_IRQ)
>> +		generic_handle_irq(irq_find_mapping(cot->irqdomain, bit));
>
> I'd like to see a '\n' here.
OK.

> Again, I'd prefer some separation between code and the return.
>
> (same in all cases below).
OK.
>
>> +	cot = devm_kzalloc(&pdev->dev, sizeof(*cot), GFP_KERNEL);
>> +	if (!cot)
>> +		return -ENOMEM;
>
> '\n' here.
OK.

>> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>
> platform_get_irq()?
No. I need the flags.

>> +	if (res) {
>> +		cot->irq = (unsigned int)res->start;
>> +		irqflags = res->flags;
>> +	}
>> +	if (!cot->irq)
>> +		return -ENODEV;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
>
> platform_get_irq()?
Yes, certainly.

>> +	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
>> +	writel(0, cot->base + COT_IRQ_SET_CLR);
>
> '\n'
OK.
>> +	ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler,
>> +			       irqflags, dev_name(&pdev->dev), cot);
>> +	if (ret == -ENOSYS)
>> +		return -EPROBE_DEFER;
>
> I haven't seen anyone do this after devm_request_irq() before.
> Why is it required here?
Explained above.

>
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Couldn't request main irq : ret = %d\n",
>> +			ret);
>
> I'm not keen on this type of formatting.  Besides the system will
> print out the returned error on failure.
Well, it will print -EINVAL or -ENODEV. When I'll receive an request on the
driver with -ENODEV, how will I know it will come from this request_irq() or
another part of the code ... Well I can remove it if you want, but I think it's
an error.

>> +	cot->irqdomain =
>> +		irq_domain_add_linear(pdev->dev.of_node, LUBBOCK_NB_IRQ,
>> +				      &lubbock_irq_domain_ops, cot);
>
> As a personal preference, I would prefer to see:
>
> 	cot->irqdomain = irq_domain_add_linear(pdev->dev.of_node,
> 					       LUBBOCK_NB_IRQ,
> 					       &lubbock_irq_domain_ops, cot);
Your tree, your rules. OK.

>
>> +	if (!cot->irqdomain)
>> +		return -ENODEV;
>> +
>> +	ret = 0;
>
> 'ret' will be zero here, or we would have returned already.
Good catch. OK.

>> +	if (base_irq)
>> +		ret = irq_create_strict_mappings(cot->irqdomain, base_irq, 0,
>> +						 LUBBOCK_NB_IRQ);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Couldn't create the irq mapping %d..%d\n",
>> +			base_irq, base_irq + LUBBOCK_NB_IRQ);
>> +		return ret;
>> +	}
>
> Is this solely the check from irq_create_strict_mappings(), therefore
> it should be inside the previous if () { ... }.
As you wish.

>> +	dev_info(&pdev->dev, "base=%p, irq=%d, base_irq=%d\n",
>> +		 cot->base, cot->irq, base_irq);
>
> Please remove this line.
OK.

>> +MODULE_DESCRIPTION("Lubbock driver");
>
> "Lubbock MFD Driver"?
Yes.

>
>> +MODULE_AUTHOR("Robert Jarzmik");
>
> Email.
Sure

Thanks for the review.

-- 
Robert
