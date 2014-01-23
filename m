Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaAWAba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:31:30 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:42361 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaAWAb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:31:27 -0500
Message-ID: <52E062D8.1060206@gmail.com>
Date: Thu, 23 Jan 2014 01:31:20 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power domain
 look-up
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com> <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com> <20140123001802.GF13785@codeaurora.org>
In-Reply-To: <20140123001802.GF13785@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 23.01.2014 01:18, Stephen Boyd wrote:
> On 01/11, Tomasz Figa wrote:
>> +
>> +/**
>> + * of_genpd_lock() - Lock access to of_genpd_providers list
>> + */
>> +static void of_genpd_lock(void)
>> +{
>> +	mutex_lock(&of_genpd_mutex);
>> +}
>> +
>> +/**
>> + * of_genpd_unlock() - Unlock access to of_genpd_providers list
>> + */
>> +static void of_genpd_unlock(void)
>> +{
>> +	mutex_unlock(&of_genpd_mutex);
>> +}
>
> Why do we need these functions? Can't we just call
> mutex_lock/unlock directly?

That would be fine as well, I guess. Just duplicated the pattern used in 
CCF, but can remove them in next version if it's found to be better.

>
>> +
>> +/**
>> + * of_genpd_add_provider() - Register a domain provider for a node
>> + * @np: Device node pointer associated with domain provider
>> + * @genpd_src_get: callback for decoding domain
>> + * @data: context pointer for @genpd_src_get callback.
>
> These look a little outdated.

Oops, missed this.

>
>> + */
>> +int of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
>> +			  void *data)
>> +{
>> +	struct of_genpd_provider *cp;
>> +
>> +	cp = kzalloc(sizeof(struct of_genpd_provider), GFP_KERNEL);
>
> Please use sizeof(*cp) instead.

Right.

>
>> +	if (!cp)
>> +		return -ENOMEM;
>> +
>> +	cp->node = of_node_get(np);
>> +	cp->data = data;
>> +	cp->xlate = xlate;
>> +
>> +	of_genpd_lock();
>> +	list_add(&cp->link, &of_genpd_providers);
>> +	of_genpd_unlock();
>> +	pr_debug("Added domain provider from %s\n", np->full_name);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(of_genpd_add_provider);
>> +
> [...]
>> +
>> +/* See of_genpd_get_from_provider(). */
>> +static struct generic_pm_domain *__of_genpd_get_from_provider(
>> +					struct of_phandle_args *genpdspec)
>> +{
>> +	struct of_genpd_provider *provider;
>> +	struct generic_pm_domain *genpd = ERR_PTR(-ENOENT);
>
> Can this be -EPROBE_DEFER so that we can defer probe until a
> later time if the power domain provider hasn't registered yet?

Yes, this could be useful. Makes me wonder why clock code (on which I 
based this code) doesn't have it done this way.

>
>> +
>> +	/* Check if we have such a provider in our array */
>> +	list_for_each_entry(provider, &of_genpd_providers, link) {
>> +		if (provider->node == genpdspec->np)
>> +			genpd = provider->xlate(genpdspec, provider->data);
>> +		if (!IS_ERR(genpd))
>> +			break;
>> +	}
>> +
>> +	return genpd;
>> +}
>> +
> [...]
>> +static int of_genpd_notifier_call(struct notifier_block *nb,
>> +				  unsigned long event, void *data)
>> +{
>> +	struct device *dev = data;
>> +	int ret;
>> +
>> +	if (!dev->of_node)
>> +		return NOTIFY_DONE;
>> +
>> +	switch (event) {
>> +	case BUS_NOTIFY_BIND_DRIVER:
>> +		ret = of_genpd_add_to_domain(dev);
>> +		break;
>> +
>> +	case BUS_NOTIFY_UNBOUND_DRIVER:
>> +		ret = of_genpd_del_from_domain(dev);
>> +		break;
>> +
>> +	default:
>> +		return NOTIFY_DONE;
>> +	}
>> +
>> +	return notifier_from_errno(ret);
>> +}
>> +
>> +static struct notifier_block of_genpd_notifier_block = {
>> +	.notifier_call = of_genpd_notifier_call,
>> +};
>> +
>> +static int of_genpd_init(void)
>> +{
>> +	return bus_register_notifier(&platform_bus_type,
>> +					&of_genpd_notifier_block);
>> +}
>> +core_initcall(of_genpd_init);
>
> Would it be possible to call the of_genpd_add_to_domain() and
> of_genpd_del_from_domain() functions directly in the driver core,
> similar to how the pinctrl framework has a hook in there? That
> way we're not relying on any initcall ordering for this.

Hmm, the initcall here just registers a notifier, which needs to be done 
just before any driver registers. So, IMHO, current variant is safe, 
given an early enough initcall level is used.

However, doing it the pinctrl way might still have an advantage of not 
relying on specific bus type, so this is worth consideration indeed. I'd 
like to hear Rafael's and Kevin's opinions on this (and other comments 
above too).

Best regards,
Tomasz
