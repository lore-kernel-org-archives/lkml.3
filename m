Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3C1WdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:33:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3C1Wc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:32:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] irqchip: Add support for ARMv7-M's NVIC
Date: Thu, 28 Mar 2013 22:32:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
References: <alpine.LFD.2.02.1303122150490.22263@ionos> <1363612826-15623-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1363612826-15623-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201303282232.42955.arnd@arndb.de>
X-Provags-ID: V02:K0:KuRC9ndWN0WvXKjbngpzwRkLBpTYrFMVKZmEHOWNIcY
 qHTES5GzbNZ9mAXpTyOyagE6bB3ef5JTaCNQ8eGEXNigBAFV+q
 CQ9K9u+OA3kdcWAOjhIFOEdkB1WYT6+xius6CgeaRukS87jzyh
 UsKGTUwhWnMLqnXUPUtHN2gCYNg6j+He6/HORi8ZhC6IOeyaI/
 SSSgohCk9c43MF6kbm3SXBrwpX4Kl6Hwk+En3DBfE9NHqetyPH
 o466U3eieMJ2+T8qtD6HIrX0PIWTg6euF+PmIuw//S8XQSbJ3P
 p6z9qcf22YYFk1fzAG3gDOuRKX4FlCe1JaNjgAPUnl5lVnr8RR
 o8p+8l/xiLwzF4u5MG8U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 March 2013, Uwe Kleine-König wrote:

> +static int __init nvic_init_bases(struct device_node *node,
> +				  void __iomem *nvic_base)
> +{

There is probably no point to keep this function separate from
nvic_of_init any more, unless you plan to mke it globally
accessible and called from non-DT platforms. In that case
you would need an irq_base argument though.

> +	irq_base = irq_alloc_descs_from(16, irqs, numa_node_id());
> +	if (irq_base < 0) {
> +		pr_warn("Cannot allocate irq_descs\n");
> +		ret = irq_base;
> +		goto err_irq_alloc_descs;
> +	}
> +	if (irq_base != 16) {
> +		/*
> +		 * The entry code just passes the exception number (i.e. irq
> +		 * number + 16) to asm_do_IRQ, so the offset needs to be fixed
> +		 * here.
> +		 */
> +		pr_warn("Failed to allocate irq_descs at offset 16\n");
> +		goto err_wrong_irq_base;
> +	}
> +
> +	irq_domain = irq_domain_add_legacy(node, irqs, irq_base, 0,
> +					   &irq_domain_simple_ops, NULL);

Why do you use a legacy domain here, and hardcode the irq_base?
For a fully DT-enabled platform, the base should not matter and you
can use irq_domain_add_linear, while a legacy platform would likely
need a different base.

> +static int __init nvic_of_init(struct device_node *node,
> +			       struct device_node *parent)
> +{
> +	void __iomem *nvic_base;
> +
> +	if (!node)
> +		return -ENODEV;

As Thomas commented, the check for !node is pointless here.

	Arnd
