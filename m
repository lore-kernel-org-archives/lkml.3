Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaBJOM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:12:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51466 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaBJOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:12:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: s-anna@ti.com, rob.herring@calxeda.com, rafael.j.wysocki@intel.com,
        mark.langsdorf@calxeda.com, tony@atomide.com, omar.ramirez@copitl.com,
        gregkh@linuxfoundation.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/6] mailbox: add core framework
Date: Mon, 10 Feb 2014 15:11 +0100
Message-ID: <4706525.lB7VmvWQMJ@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1391820619-25487-2-git-send-email-courtney.cavin@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com> <1391820619-25487-2-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TLnYUzpOQXiDwcD4iToyFyDQI3tmrpTMQXZ5poOEput
 RjBw3IBlNPcj5t4ua1vQSHvcxNybDpEbgY5qe1MBkIHmKwkr85
 src9z4/rqwKNfAuuoaXAGbxC+K9GK+F7L31Rx16PP/SMQf974d
 ROoUbyZ2OI4iRaSxePESlNuEBfzwrRsfW6/rHS8DGe7sIJrjqq
 92nkzPpoR4X0jUFPB8jkigVUp+rWnwN6S/BPcu/aUpY227ZvYb
 7spGJJTRHjmy16RRNK3g6ifRPTRUhTuR+isJlwHT3FCvxeCOEp
 5VqzwkzQa2g0em4po85LNLUg/gPG8fpN3Vj6P9LWDShvgU3xby
 ZXA3422fqNZ3I7eCRqxA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 February 2014 16:50:14 Courtney Cavin wrote:
> The mailbox drivers are fragmented, and some implement their own core.
> Unify the drivers and implement common functionality in a framework.
> 
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>

This seems pretty cool overall, great to see someone getting at it@

> +static void of_mbox_adapter_add(struct mbox_adapter *adap)
> +{
> +	if (!adap->dev)
> +		return;
> +
> +	if (!adap->of_xlate) {
> +		adap->of_xlate = of_mbox_simple_xlate;
> +		adap->of_n_cells = 1;
> +	}
> +
> +	of_node_get(adap->dev->of_node);
> +}

You should probably check if of_n_cells matches the device node
#mbox-cells value, otherwise the xlate function will get confused.

> +
> +	mutex_lock(&mbox_lock);
> +	list_add(&adap->list, &mbox_adapters);
> +
> +	of_mbox_adapter_add(adap);
> +	mutex_unlock(&mbox_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(mbox_adapter_add);

Please use EXPORT_SYMBOL_GPL here and elsewhere.

> +/**
> + * mbox_channel_notify() - notify the core that a channel has a message
> + * @chan: the channel which has data
> + * @data: the location of said data
> + * @len: the length of specified data
> + *
> + * This function may be called from interrupt/no-sleep context.
> + */
> +int mbox_channel_notify(struct mbox_channel *chan,
> +		const void *data, unsigned int len)
> +{
> +	return atomic_notifier_call_chain(&chan->notifier, len, (void *)data);
> +}
> +EXPORT_SYMBOL(mbox_channel_notify);

What is the reason to use a notifier chain here? Isn't a simple
callback function pointer enough? I would expect that each mailbox
can have exactly one consumer, not multiple ones.

> +/**
> + * mbox_add_table() - add a lookup table for adapter consumers
> + * @table: array of consumers to register
> + * @num: number of consumers in array
> + */
> +void __init mbox_add_table(struct mbox_lookup *table, unsigned int num)
> +{
> +	mutex_lock(&mbox_lookup_lock);
> +	while (num--) {
> +		if (table->provider && (table->dev_id || table->con_id))
> +			list_add_tail(&table->list, &mbox_lookup_list);
> +		table++;
> +	}
> +	mutex_unlock(&mbox_lookup_lock);
> +}
> +EXPORT_SYMBOL(mbox_add_table);

I don't understand this part of the API. Why do you need a separate
lookup table here? Isn't that what the DT lookup does already?

> +/**
> + * mbox_request() - lookup and request a MBOX channel
> + * @dev: device for channel consumer
> + * @con_id: consumer name
> + * @nb: notifier block used for receiving messages
> + *
> + * The notifier is called as atomic on new messages, so you may not sleep
> + * in the notifier callback function.
> + */
> +struct mbox *mbox_request(struct device *dev, const char *con_id,
> +		struct notifier_block *nb)
> +{
> +	struct mbox_adapter *adap;
> +	struct mbox_channel *chan;
> +	struct mbox *mbox;
> +	int index = 0;
> +
> +	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
> +		return of_mbox_request(dev->of_node, con_id, nb);

What use case do you have in mind for !CONFIG_OF?

> +/**
> + * struct mbox_adapter_ops - MBOX adapter operations
> + * @put_message: hook for putting messages in the channels MBOX
> + * @request: optional hook for requesting an MBOX channel
> + * @release: optional hook for releasing an MBOX channel
> + * @owner: helps prevent removal of modules exporting active MBOX channels
> + */
> +struct mbox_adapter_ops {
> +	int (*put_message)(struct mbox_adapter *, struct mbox_channel *,
> +				const void *, unsigned int);
> +	int (*request)(struct mbox_adapter *, struct mbox_channel *);
> +	int (*release)(struct mbox_adapter *, struct mbox_channel *);
> +	struct module *owner;
> +};

I think we will need a peek_message() callback for the upcoming
QMTM driver, to allow client drivers to get a message out before
the mailbox driver gets an IRQ. This will be used for IRQ mitigation
in the network driver.

	Arnd
