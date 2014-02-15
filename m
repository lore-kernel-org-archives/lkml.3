Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaBOTNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:13:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaBOTNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:13:53 -0500
Date: Sat, 15 Feb 2014 11:15:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
Message-ID: <20140215191514.GD1801@kroah.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
 <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 11:55:27PM +0530, Jassi Brar wrote:
> +/*
> + * Call for IPC controller drivers to register a controller, adding
> + * its channels/mailboxes to the global pool.
> + */
> +int ipc_links_register(struct ipc_controller *ipc)
> +{
> +	int i, num_links, txdone;
> +	struct ipc_chan *chan;
> +	struct ipc_con *con;
> +
> +	/* Sanity check */
> +	if (!ipc || !ipc->ops)
> +		return -EINVAL;
> +
> +	for (i = 0; ipc->links[i]; i++)
> +		;
> +	if (!i)
> +		return -EINVAL;

So you have to have links?  You should document this in the function
definition.  Actually, why no kerneldoc for the public functions?

> +	num_links = i;
> +
> +	mutex_lock(&con_mutex);
> +	/* Check if already populated */
> +	list_for_each_entry(con, &ipc_cons, node)
> +		if (!strcmp(ipc->controller_name, con->name)) {
> +			mutex_unlock(&con_mutex);
> +			return -EINVAL;
> +		}
> +	mutex_unlock(&con_mutex);

Why drop the lock here?  Shouldn't you grab it for the whole function,
as this could race if two callers want to register the same name.

> +	con = kzalloc(sizeof(*con) + sizeof(*chan) * num_links, GFP_KERNEL);

Are you ok with structures on unaligned boundries?  That might really
slow down some processors if your pointers are unaligned...

> +	if (!con)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&con->channels);
> +	snprintf(con->name, 16, "%s", ipc->controller_name);

Magic name size :(

> +
> +	if (ipc->txdone_irq)
> +		txdone = TXDONE_BY_IRQ;
> +	else if (ipc->txdone_poll)
> +		txdone = TXDONE_BY_POLL;
> +	else /* It has to be ACK then */
> +		txdone = TXDONE_BY_ACK;
> +
> +	if (txdone == TXDONE_BY_POLL) {
> +		con->period = ipc->txpoll_period;
> +		con->poll.function = &poll_txdone;
> +		con->poll.data = (unsigned long)con;
> +		init_timer(&con->poll);
> +	}
> +
> +	chan = (void *)con + sizeof(*con);
> +	for (i = 0; i < num_links; i++) {
> +		chan[i].con = con;
> +		chan[i].assigned = false;
> +		chan[i].link_ops = ipc->ops;
> +		chan[i].link = ipc->links[i];
> +		chan[i].txdone_method = txdone;
> +		chan[i].link->api_priv = &chan[i];
> +		spin_lock_init(&chan[i].lock);
> +		BLOCKING_INIT_NOTIFIER_HEAD(&chan[i].avail);
> +		list_add_tail(&chan[i].node, &con->channels);
> +		snprintf(chan[i].name, 16, "%s", ipc->links[i]->link_name);

Magic name size :(

> +	}
> +
> +	mutex_lock(&con_mutex);
> +	list_add_tail(&con->node, &ipc_cons);
> +	mutex_unlock(&con_mutex);

You could have raced with above, please just grab the lock for the
whole call to be safe.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ipc_links_register);
> +
> +void ipc_links_unregister(struct ipc_controller *ipc)
> +{
> +	struct ipc_con *t, *con = NULL;
> +	struct ipc_chan *chan;
> +
> +	mutex_lock(&con_mutex);
> +
> +	list_for_each_entry(t, &ipc_cons, node)
> +		if (!strcmp(ipc->controller_name, t->name)) {
> +			con = t;
> +			break;
> +		}
> +
> +	if (con)
> +		list_del(&con->node);
> +
> +	mutex_unlock(&con_mutex);
> +
> +	if (!con)
> +		return;
> +
> +	list_for_each_entry(chan, &con->channels, node)
> +		ipc_free_channel((void *)chan);

Why does this function take a void *?  Shouldn't it take a "real"
structure pointer?

> +
> +	del_timer_sync(&con->poll);
> +
> +	kfree(con);
> +}
> +EXPORT_SYMBOL(ipc_links_unregister);

> +struct ipc_client {
> +	char *chan_name;
> +	void *cl_id;

Why a void *?  Can't you have a "real" type here?

> +	void (*rxcb)(void *cl_id, void *mssg);
> +	void (*txcb)(void *cl_id, void *mssg, enum xfer_result r);
> +	bool tx_block;
> +	unsigned long tx_tout;
> +	bool knows_txdone;
> +	void *link_data;
> +};
> +
> +/**
> + * The Client specifies its requirements and capabilities while asking for
> + * a channel/mailbox by name. It can't be called from atomic context.
> + * The channel is exclusively allocated and can't be used by another
> + * client before the owner calls ipc_free_channel.
> + */
> +void *ipc_request_channel(struct ipc_client *cl);

Can't you return a real type, and use it everywhere?  That's much
"safer" and nicer.  This isn't other operating systems that have void *
everywhere and handles, we have real types in Linux :)

thanks,

greg k-h
