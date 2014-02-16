Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaBPQeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 11:34:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaBPQeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 11:34:15 -0500
Date: Sun, 16 Feb 2014 08:36:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>, courtney.cavin@sonymobile.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
Message-ID: <20140216163639.GB28616@kroah.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
 <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
 <20140215191514.GD1801@kroah.com>
 <CABb+yY1rsPOM+rycRVzrskV9EaMrge-3JE_2awT81Rup0GTk5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABb+yY1rsPOM+rycRVzrskV9EaMrge-3JE_2awT81Rup0GTk5Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 12:06:44PM +0530, Jassi Brar wrote:
> >> +void ipc_links_unregister(struct ipc_controller *ipc)
> >> +{
> >> +     struct ipc_con *t, *con = NULL;
> >> +     struct ipc_chan *chan;
> >> +
> >> +     mutex_lock(&con_mutex);
> >> +
> >> +     list_for_each_entry(t, &ipc_cons, node)
> >> +             if (!strcmp(ipc->controller_name, t->name)) {
> >> +                     con = t;
> >> +                     break;
> >> +             }
> >> +
> >> +     if (con)
> >> +             list_del(&con->node);
> >> +
> >> +     mutex_unlock(&con_mutex);
> >> +
> >> +     if (!con)
> >> +             return;
> >> +
> >> +     list_for_each_entry(chan, &con->channels, node)
> >> +             ipc_free_channel((void *)chan);
> >
> > Why does this function take a void *?  Shouldn't it take a "real"
> > structure pointer?
> >
> ipc_request/free_channel() is the api for client drivers. I have tried
> to make the return channel opaque object to the clients and yet be
> able to reuse the object within the api implementation. For that
> reason we have mailbox_client.h and mailbox_controller.h so no side
> can abuse what's on the other side. Only the api(mailbox.c) includes
> both the headers.

That's fine, then just "pre-declare" the structure you are going to be
using/calling it in the public header files:
	struct foo;
and then use that, not a void *, which is horrible.  We have a typesafe
language, use it :)

> >> +
> >> +     del_timer_sync(&con->poll);
> >> +
> >> +     kfree(con);
> >> +}
> >> +EXPORT_SYMBOL(ipc_links_unregister);
> >
> >> +struct ipc_client {
> >> +     char *chan_name;
> >> +     void *cl_id;
> >
> > Why a void *?  Can't you have a "real" type here?
> >
> That is for client driver to specify how the controller driver is to
> behave .... the api simply passes it on to the underlying controller
> driver. We couldn't have defined some global real type because the
> same controller behaves differently if the remote f/w changes.

Then call it something like "client_data", as that's more like what it
is, right?

> >> +     void (*rxcb)(void *cl_id, void *mssg);
> >> +     void (*txcb)(void *cl_id, void *mssg, enum xfer_result r);
> >> +     bool tx_block;
> >> +     unsigned long tx_tout;
> >> +     bool knows_txdone;
> >> +     void *link_data;
> >> +};
> >> +
> >> +/**
> >> + * The Client specifies its requirements and capabilities while asking for
> >> + * a channel/mailbox by name. It can't be called from atomic context.
> >> + * The channel is exclusively allocated and can't be used by another
> >> + * client before the owner calls ipc_free_channel.
> >> + */
> >> +void *ipc_request_channel(struct ipc_client *cl);
> >
> > Can't you return a real type, and use it everywhere?  That's much
> > "safer" and nicer.  This isn't other operating systems that have void *
> > everywhere and handles, we have real types in Linux :)
> >
> As I said, we don't want the client driver to interpret the channel it
> has been assigned. For clients a channel assigned is just an opaque
> token that can't be used anyway other than request/release the channel
> from the api.

See above for how to fix that.

> >> +typedef unsigned request_token_t;
> >
> > Ick.  Why add a new typedef?  And if you do need this,
> > drop the "_t" on the end please.
> > Why not just rely on an unsigned int?  Or long?
> > Do you really need a new type?
> >
> We can live without the typedef, it is only to impress that the cookie
> returned is not to be used just like some unsigned... but an opaque object.

Then make it a structure, not a typedef please.

thanks,

greg k-h
