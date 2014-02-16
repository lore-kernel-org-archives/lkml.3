Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbaBPGgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 01:36:47 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:48475 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaBPGgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 01:36:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140215191514.GD1801@kroah.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
	<20140215191514.GD1801@kroah.com>
Date: Sun, 16 Feb 2014 12:06:44 +0530
Message-ID: <CABb+yY1rsPOM+rycRVzrskV9EaMrge-3JE_2awT81Rup0GTk5Q@mail.gmail.com>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>, courtney.cavin@sonymobile.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[merging replies in one post]

On Sun, Feb 16, 2014 at 12:45 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Feb 15, 2014 at 11:55:27PM +0530, Jassi Brar wrote:
>> +/*
>> + * Call for IPC controller drivers to register a controller, adding
>> + * its channels/mailboxes to the global pool.
>> + */
>> +int ipc_links_register(struct ipc_controller *ipc)
>> +{
>> +     int i, num_links, txdone;
>> +     struct ipc_chan *chan;
>> +     struct ipc_con *con;
>> +
>> +     /* Sanity check */
>> +     if (!ipc || !ipc->ops)
>> +             return -EINVAL;
>> +
>> +     for (i = 0; ipc->links[i]; i++)
>> +             ;
>> +     if (!i)
>> +             return -EINVAL;
>
> So you have to have links?  You should document this in the function
> definition.  Actually, why no kerneldoc for the public functions?
>
Yes a controller registers a bunch of links/mailboxes that can be used
by client drivers to send/recv messages. I'll add kerneldoc for the
api as well.

>> +     num_links = i;
>> +
>> +     mutex_lock(&con_mutex);
>> +     /* Check if already populated */
>> +     list_for_each_entry(con, &ipc_cons, node)
>> +             if (!strcmp(ipc->controller_name, con->name)) {
>> +                     mutex_unlock(&con_mutex);
>> +                     return -EINVAL;
>> +             }
>> +     mutex_unlock(&con_mutex);
>
> Why drop the lock here?  Shouldn't you grab it for the whole function,
> as this could race if two callers want to register the same name.
>
Yes, thanks.

>> +     con = kzalloc(sizeof(*con) + sizeof(*chan) * num_links, GFP_KERNEL);
>
> Are you ok with structures on unaligned boundries?  That might really
> slow down some processors if your pointers are unaligned...
>
OK, I'll align allocation.

>> +     if (!con)
>> +             return -ENOMEM;
>> +
>> +     INIT_LIST_HEAD(&con->channels);
>> +     snprintf(con->name, 16, "%s", ipc->controller_name);
>
> Magic name size :(
>
Yeah I know. I tried to keep the implementation simple.

>> +
>> +     if (ipc->txdone_irq)
>> +             txdone = TXDONE_BY_IRQ;
>> +     else if (ipc->txdone_poll)
>> +             txdone = TXDONE_BY_POLL;
>> +     else /* It has to be ACK then */
>> +             txdone = TXDONE_BY_ACK;
>> +
>> +     if (txdone == TXDONE_BY_POLL) {
>> +             con->period = ipc->txpoll_period;
>> +             con->poll.function = &poll_txdone;
>> +             con->poll.data = (unsigned long)con;
>> +             init_timer(&con->poll);
>> +     }
>> +
>> +     chan = (void *)con + sizeof(*con);
>> +     for (i = 0; i < num_links; i++) {
>> +             chan[i].con = con;
>> +             chan[i].assigned = false;
>> +             chan[i].link_ops = ipc->ops;
>> +             chan[i].link = ipc->links[i];
>> +             chan[i].txdone_method = txdone;
>> +             chan[i].link->api_priv = &chan[i];
>> +             spin_lock_init(&chan[i].lock);
>> +             BLOCKING_INIT_NOTIFIER_HEAD(&chan[i].avail);
>> +             list_add_tail(&chan[i].node, &con->channels);
>> +             snprintf(chan[i].name, 16, "%s", ipc->links[i]->link_name);
>
> Magic name size :(
>
"Controller:Link" specify the 32byte identity of a link.
I haven't yet opened the can of worms that is generic naming/identity
scheme like DMAEngine. Because the local controller and the remote f/w
together represents an entity that the local client driver deals
with.... so many common client drivers.are unlikely.

>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(ipc_links_register);
>> +
>> +void ipc_links_unregister(struct ipc_controller *ipc)
>> +{
>> +     struct ipc_con *t, *con = NULL;
>> +     struct ipc_chan *chan;
>> +
>> +     mutex_lock(&con_mutex);
>> +
>> +     list_for_each_entry(t, &ipc_cons, node)
>> +             if (!strcmp(ipc->controller_name, t->name)) {
>> +                     con = t;
>> +                     break;
>> +             }
>> +
>> +     if (con)
>> +             list_del(&con->node);
>> +
>> +     mutex_unlock(&con_mutex);
>> +
>> +     if (!con)
>> +             return;
>> +
>> +     list_for_each_entry(chan, &con->channels, node)
>> +             ipc_free_channel((void *)chan);
>
> Why does this function take a void *?  Shouldn't it take a "real"
> structure pointer?
>
ipc_request/free_channel() is the api for client drivers. I have tried
to make the return channel opaque object to the clients and yet be
able to reuse the object within the api implementation. For that
reason we have mailbox_client.h and mailbox_controller.h so no side
can abuse what's on the other side. Only the api(mailbox.c) includes
both the headers.

>> +
>> +     del_timer_sync(&con->poll);
>> +
>> +     kfree(con);
>> +}
>> +EXPORT_SYMBOL(ipc_links_unregister);
>
>> +struct ipc_client {
>> +     char *chan_name;
>> +     void *cl_id;
>
> Why a void *?  Can't you have a "real" type here?
>
That is for client driver to specify how the controller driver is to
behave .... the api simply passes it on to the underlying controller
driver. We couldn't have defined some global real type because the
same controller behaves differently if the remote f/w changes.

>> +     void (*rxcb)(void *cl_id, void *mssg);
>> +     void (*txcb)(void *cl_id, void *mssg, enum xfer_result r);
>> +     bool tx_block;
>> +     unsigned long tx_tout;
>> +     bool knows_txdone;
>> +     void *link_data;
>> +};
>> +
>> +/**
>> + * The Client specifies its requirements and capabilities while asking for
>> + * a channel/mailbox by name. It can't be called from atomic context.
>> + * The channel is exclusively allocated and can't be used by another
>> + * client before the owner calls ipc_free_channel.
>> + */
>> +void *ipc_request_channel(struct ipc_client *cl);
>
> Can't you return a real type, and use it everywhere?  That's much
> "safer" and nicer.  This isn't other operating systems that have void *
> everywhere and handles, we have real types in Linux :)
>
As I said, we don't want the client driver to interpret the channel it
has been assigned. For clients a channel assigned is just an opaque
token that can't be used anyway other than request/release the channel
from the api.

> Did you forget a Kconfig file here?  How can this code be built?
Yup, sorry. The patch somehow got that change dropped.

>> +typedef unsigned request_token_t;
>
> Ick.  Why add a new typedef?  And if you do need this,
> drop the "_t" on the end please.
> Why not just rely on an unsigned int?  Or long?
> Do you really need a new type?
>
We can live without the typedef, it is only to impress that the cookie
returned is not to be used just like some unsigned... but an opaque object.

>> +EXPORT_SYMBOL(ipc_link_received_data);
>
> EXPORT_SYMBOL_GPL() on all of these perhaps?
>
Yes of course :)

Thanks,
Jassi
