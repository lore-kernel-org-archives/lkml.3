Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaBJRP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:15:27 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19364 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbaBJRPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:15:23 -0500
Date: Mon, 10 Feb 2014 09:17:06 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "s-anna@ti.com" <s-anna@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.langsdorf@calxeda.com" <mark.langsdorf@calxeda.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "omar.ramirez@copitl.com" <omar.ramirez@copitl.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/6] mailbox: add core framework
Message-ID: <20140210171706.GR1706@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
 <1391820619-25487-2-git-send-email-courtney.cavin@sonymobile.com>
 <4706525.lB7VmvWQMJ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4706525.lB7VmvWQMJ@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:11:00PM +0100, Arnd Bergmann wrote:
> On Friday 07 February 2014 16:50:14 Courtney Cavin wrote:
> > The mailbox drivers are fragmented, and some implement their own core.
> > Unify the drivers and implement common functionality in a framework.
> > 
> > Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> 
> This seems pretty cool overall, great to see someone getting at it@

I'm glad to hear that there's some interest!

> > +static void of_mbox_adapter_add(struct mbox_adapter *adap)
> > +{
> > +	if (!adap->dev)
> > +		return;
> > +
> > +	if (!adap->of_xlate) {
> > +		adap->of_xlate = of_mbox_simple_xlate;
> > +		adap->of_n_cells = 1;
> > +	}
> > +
> > +	of_node_get(adap->dev->of_node);
> > +}
> 
> You should probably check if of_n_cells matches the device node
> #mbox-cells value, otherwise the xlate function will get confused.

Ok.  I was under the impression that the adapter implementations would
add something like that, but I see no reason why putting it here would
hurt.

> > +
> > +	mutex_lock(&mbox_lock);
> > +	list_add(&adap->list, &mbox_adapters);
> > +
> > +	of_mbox_adapter_add(adap);
> > +	mutex_unlock(&mbox_lock);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(mbox_adapter_add);
> 
> Please use EXPORT_SYMBOL_GPL here and elsewhere.

Ok.

> > +/**
> > + * mbox_channel_notify() - notify the core that a channel has a message
> > + * @chan: the channel which has data
> > + * @data: the location of said data
> > + * @len: the length of specified data
> > + *
> > + * This function may be called from interrupt/no-sleep context.
> > + */
> > +int mbox_channel_notify(struct mbox_channel *chan,
> > +		const void *data, unsigned int len)
> > +{
> > +	return atomic_notifier_call_chain(&chan->notifier, len, (void *)data);
> > +}
> > +EXPORT_SYMBOL(mbox_channel_notify);
> 
> What is the reason to use a notifier chain here? Isn't a simple
> callback function pointer enough? I would expect that each mailbox
> can have exactly one consumer, not multiple ones.

Mostly because I didn't see a reason not to.  While a callback function
(and private data) would probably be sufficient, I don't see a specific
reason why a mailbox cannot have multiple consumers, and the API
currently is designed around that concept.

> > +/**
> > + * mbox_add_table() - add a lookup table for adapter consumers
> > + * @table: array of consumers to register
> > + * @num: number of consumers in array
> > + */
> > +void __init mbox_add_table(struct mbox_lookup *table, unsigned int num)
> > +{
> > +	mutex_lock(&mbox_lookup_lock);
> > +	while (num--) {
> > +		if (table->provider && (table->dev_id || table->con_id))
> > +			list_add_tail(&table->list, &mbox_lookup_list);
> > +		table++;
> > +	}
> > +	mutex_unlock(&mbox_lookup_lock);
> > +}
> > +EXPORT_SYMBOL(mbox_add_table);
> 
> I don't understand this part of the API. Why do you need a separate
> lookup table here? Isn't that what the DT lookup does already?

It is.  The lookup/table stuff here is specifically for non-DT-based
mailboxes.

> > +/**
> > + * mbox_request() - lookup and request a MBOX channel
> > + * @dev: device for channel consumer
> > + * @con_id: consumer name
> > + * @nb: notifier block used for receiving messages
> > + *
> > + * The notifier is called as atomic on new messages, so you may not sleep
> > + * in the notifier callback function.
> > + */
> > +struct mbox *mbox_request(struct device *dev, const char *con_id,
> > +		struct notifier_block *nb)
> > +{
> > +	struct mbox_adapter *adap;
> > +	struct mbox_channel *chan;
> > +	struct mbox *mbox;
> > +	int index = 0;
> > +
> > +	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
> > +		return of_mbox_request(dev->of_node, con_id, nb);
> 
> What use case do you have in mind for !CONFIG_OF?

None particularly, except for the existing implementations in
drivers/mailbox.  I simply presumed it wouldn't hurt to implement lookup
tables similar to those the pwm core.

> > +/**
> > + * struct mbox_adapter_ops - MBOX adapter operations
> > + * @put_message: hook for putting messages in the channels MBOX
> > + * @request: optional hook for requesting an MBOX channel
> > + * @release: optional hook for releasing an MBOX channel
> > + * @owner: helps prevent removal of modules exporting active MBOX channels
> > + */
> > +struct mbox_adapter_ops {
> > +	int (*put_message)(struct mbox_adapter *, struct mbox_channel *,
> > +				const void *, unsigned int);
> > +	int (*request)(struct mbox_adapter *, struct mbox_channel *);
> > +	int (*release)(struct mbox_adapter *, struct mbox_channel *);
> > +	struct module *owner;
> > +};
> 
> I think we will need a peek_message() callback for the upcoming
> QMTM driver, to allow client drivers to get a message out before
> the mailbox driver gets an IRQ. This will be used for IRQ mitigation
> in the network driver.

Eeek!  I'm not very fond of 'peek' functions, but I guess I can see a
reason for IRQ mitigation here.  I still cannot help but to try to think
my way out of implementing peek.

What would be the callback flow here?  There's no guarantee that a
mailbox implementation isn't implemented over a sleepy bus, which would
render peek somewhat useless.  Additionally, we have the adapter
protection mutex which can sleep anyway.  This means that a consumer can
not call peek from anywhere atomic, including a notifier, which I think
is your use-case.

Perhaps a FEED_ME return from a notifier, requesting more 'mail' if
available?

> 
> 	Arnd

Thanks for looking!  I appreciate the feedback.

-Courtney
