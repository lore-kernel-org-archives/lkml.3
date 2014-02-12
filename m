Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaBLSaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:30:04 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9437 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbaBLSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:30:00 -0500
Date: Wed, 12 Feb 2014 10:31:43 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "s-anna@ti.com" <s-anna@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Tony Lindgren <tony@atomide.com>,
        "omar.ramirez@copitl.com" <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/6] mailbox: add core framework
Message-ID: <20140212183143.GD1706@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
 <CAL_JsqK0YoVu0BfKSUfBQGoriCa4z-teXUQe6RPpjM2KKpeMAw@mail.gmail.com>
 <20140211002347.GW1706@sonymobile.com>
 <1765844.1kjKsO2Rzo@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1765844.1kjKsO2Rzo@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 09:35:01AM +0100, Arnd Bergmann wrote:
> On Monday 10 February 2014 16:23:48 Courtney Cavin wrote:
> 
> > While I'm not sure the dislike of notifiers entirely justifies not using
> > them here, where they seem to make sense, I can understand that they
> > might not fully implement what we need to expose.
> 
> I think we need to look at a few more examples of things that people
> want to with the framework to come up with a good interface. It's
> possible that we end up with multiple alternative notification
> methods, but it would be good to come up with one that works well
> for everyone.
> 
> > Regarding handlers running in IRQ context: currently the API is designed
> > to do just that.  From the use-cases I've found, most message handlers
> > simply queue something to happen at a later point.  This is logical, as
> > the callback will be async, so you'll need to swap contexts or add locks
> > in your consumer anyway.
> 
> Right. You may also have some handlers that need to run with extreme
> latency constraints, so we need at least the option of getting the
> callback from hardirq context, or possibly from softirq/tasklet
> as in the dmaengine case.
> 
> > The dma engine is large and confused, so I'm not sure entirely which
> > part you are refering to.  I've looked at having async completion going
> > both ways, but what I see every time is code complication in both the
> > adapter and in the consumers in the simple use-case.  It doesn't really
> > make sense to make an API which makes things so generic that it becomes
> > hard to use.  What I tried to follow here when designing the API was
> > what I saw in the actual implementations, not what was future-proof:
> > 	- Message receive callbacks may be called from IRQ context
> > 	- Message send implementations may sleep
> 
> I can imagine cases where you want to send messages from softirq
> context, or from the same context in which you received the incoming
> mail, so it would be good to have the API flexible enough to deal
> with that. As a first step, always allowing send to sleep seems
> fine. Alternatively, we could have a 'sync' flag in the send
> API, to choose between "arrange this message to be sent out as
> soon as possible, but don't sleep" and "send this message and
> make sure it has arrived at the other end" as you do now.

Although I'm not sure there's currently a requirement for this, I can see that
this could be needed in the future.

> > What I can do is try to alleviate implementation efforts of future
> > requirements--as honestly, we can't really say exactly what they are--by
> > turning the messages into structs themselves, so at a later point flags,
> > ack callbacks, and rainbows can be added.  I can then stop using
> > notifiers, and re-invent that functionality with a mbox_ prefix.
> 
> I don't think there is a point in reimplementing notifiers under a
> different name. The question is rather how we want to deal with
> the 'multiple listener' case. If this case is the exception rather
> than the rule, I'd prefer making the callback API handle only
> single listeners and adding higher-level abstractions for the
> cases where we do need multiple listeners, but it really depends
> on what people need.

I wasn't actually planning on directly ripping-off notifiers under a new name.
Rather, as switching to message structs is probably a good idea anyway, I don't
think the notifier API properly represents that,... the void pointer is a bit
vague.  It could be that it would turn out as a wrapper around notifiers.  As
you said though, I do think this is the exception, so I'm fine with the single
callback idea, as long as Rob and Suman agree that this will be suitable for
their use-cases.

Then again, I think that the context management stuff is the exception as well,
and I think that can/should also be handled in a higher level.  Regardless, I
went ahead and drafted the async flags idea out anyway, so here's some
pseudo-code.  I also tried to shoe-horn in 'peek', and you can see how that
turns out.  Let me know if this is something like what you had in mind.

enum {
	MBOX_ASYNC	= BIT(0),
};

struct mbox_adapter_ops {
	...
	int (*put_message)(struct mbox_adapter *, struct mbox_channel *,
			const struct mbox_message *msg)
	int (*peek_message)(struct mbox_adapter *, struct mbox_channel *,
			struct mbox_message *msg)
};

struct mbox;

#define MBOX_FIFO_SIZE PAGE_SZ /* or not? */

struct mbox_channel {
	...
	unsigned long flags; /* MBOX_ASYNC, for now */
	struct mbox *consumer;
	struct kfifo_rec_ptr_1 rx_fifo;
	/**
	 * probably should be allocated only if user needs to call
	 * mbox_put_message with MBOX_ASYNC, instead of statically.
	 */
	STRUCT_KFIFO_REC_1(MBOX_FIFO_SIZE) tx_fifo;
	struct work_struct rx_work;
	struct work_struct tx_work;
}

struct mbox {
	struct mbox_channel *chan;
	struct mbox_adapter *adapter;
	void (*cb)(void *, struct mbox *, const struct mbox_message *);
	void *priv;
};

struct mbox_message {
	void *data;
	unsigned int len;
};

static void rx_work(struct work_struct *work)
{
	struct mbox_channel *chan;
	struct mbox_message msg;

	chan = container_of(work, struct mbox_channel, rx_work);
	msg.len = kfifo_out(&chan->rx_fifo, msg.data);
	chan->consumer->cb(chan->consumer, &msg);
}

/* called from adapter, typically in a IRQ handler */
int mbox_channel_notify(struct mbox_channel *chan,
		const struct mbox_message *msg)
{
	if (chan->flags & MBOX_ASYNC) {
		kfifo_in(&chan->rx_fifo, msg->data, msg->len);
		schedule_work(&chan->rx_work);
		return 0;
	}

	/*
	 * consumer may not sleep here, as they did not specify this
	 * requirement in channel flags when requesting
	 */
	return chan->consumer->cb(chan->consumer->priv, chan->consumer, msg);
}

static void tx_work(struct work_struct *work)
{
	struct mbox_channel *chan;
	struct mbox_message msg;
	char buf[PAGE_SZ]; /* should max size be specified by the adapter? */

	chan = container_of(work, struct mbox_channel, tx_work);
	msg.len = kfifo_out(&chan->tx_fifo, buf, sizeof(buf));
	msg.data = buf;

	mutex_lock(&chan->adapter->lock);
	chan->adapter->ops->put_message(chan->adapter, chan, &msg);
	mutex_unlock(&chan->adapter->lock);
}

/* called from consumer */
int mbox_put_message(struct mbox *mbox, const struct mbox_message *msg,
		unsigned long flags)
{
	int rc;

	if (flags & MBOX_ASYNC) {
		kfifo_in(&chan->tx_fifo, msg->data, msg->len);
		schedule_work(&mbox->chan->tx_work);
		return 0;
	}

	/**
	 * obviously, if not because of the lock, then because the adapter
	 * should wait for an ACK from it's controller if appropriate.
	 */
	might_sleep();

	mutex_lock(&mbox->adapter->lock);
	rc = mbox->adapter->ops->put_message(mbox->adapter, mbox->chan, msg);
	mutex_unlock(&mbox->adapter->lock);

	return rc;
}

/* called from consumer; illustrates the problem with peek */
int mbox_peek_message(struct mbox *mbox, struct mbox_message *msg)
{

	int rc;
	if (chan->flags & MBOX_ASYNC) {
		msg->len = kfifo_out_peek(&mbox->chan->rx_fifo,
				msg->data, msg->len);
		return 0;
	}

	/**
	 * It is unlikely that most adapters are able to properly implement
	 * this, so we have to allow for that.
	 */
	if (!mbox->adapter->ops->peek_message)
		return -EOPNOTSUPP;

	/**
	 * so this is where this lock makes things difficult, as this function
	 * might_sleep(), but only really because of the lock.  Either we can
	 * remove the lock and force the adapter to do its own locking
	 * spinlock-style, or we can accept the sleep here, which seems a bit
	 * stupid in a peek function.  Neither option is good.  Additionally,
	 * there's no guarantee that the adapter doesn't operate over a bus
	 * which itself might_sleep(), exacerbating the problem.
	 */
	mutex_lock(&mbox->adapter->lock);
	rc = mbox->adapter->ops->peek_message(mbox->adapter, mbox->chan, msg);
	mutex_lock(&mbox->adapter->lock);

	return rc;
}

struct mbox *mbox_request(struct device *dev, const char *con_id,
		void (*receive)(void *, struct mbox *, const struct mbox_message *),
		void *priv, unsigned long flags)
{
	struct mbox_channel *chan;
	struct mbox *mbox;
	int rc;
	...
	chan->flags = flags;
	if (flags & MBOX_ASYNC) {
		rc = kfifo_alloc(&chan->rx_fifo, MBOX_FIFO_SIZE, GFP_KERNEL);
		if (rc)
			return rc;
		INIT_WORK(&chan->rx_work, rx_work);
	}
	if (1 /* consumer plans on calling put_message with MBOX_ASYNC */) {
		INIT_KFIFO(chan->tx_fifo);
		INIT_WORK(&chan->tx_work, tx_work);
	}
	chan->consumer = mbox;
	mbox->cb = receive;
	mbox->priv = priv;
	...
	return mbox;
}
