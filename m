Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaBSVna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:43:30 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44117 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbaBSVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:43:27 -0500
MIME-Version: 1.0
In-Reply-To: <20140218194726.GK1706@sonymobile.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
	<20140218005217.GJ1706@sonymobile.com>
	<CAJe_ZhdAVK2Yar9kVmbVQLD_JBm9KFzvfv5S0Ba-AXsPEO9HsA@mail.gmail.com>
	<20140218194726.GK1706@sonymobile.com>
Date: Thu, 20 Feb 2014 03:13:25 +0530
Message-ID: <CAJe_ZhdzLTE1p8YfWyt8pqjcGA9L1cVnF0QBrJittMGk7h9mhw@mail.gmail.com>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2014 01:17, Courtney Cavin <courtney.cavin@sonymobile.com> wrote:
> On Tue, Feb 18, 2014 at 08:06:55AM +0100, Jassi Brar wrote:
>>
>> >> +void *ipc_request_channel(struct ipc_client *cl)
>> >> +{
> [...]
>> >> +                       spin_lock_irqsave(&chan->lock, flags);
>> >> +                       chan->msg_free = 0;
>> >> +                       chan->msg_count = 0;
>> >> +                       chan->active_req = NULL;
>> >> +                       chan->rxcb = cl->rxcb;
>> >> +                       chan->txcb = cl->txcb;
>> >> +                       chan->cl_id = cl->cl_id;
>> >> +                       chan->assigned = true;
>> >> +                       chan->tx_block = cl->tx_block;
>> >
>> > Copying all of this data is unnecessary, and prone to error.  Just point
>> > to 'cl' in the client struct.
>> >
>> That did occur to me. But I chose to have controller specify its
>> attributes from lower layer and the client from upper layer. The api
>> basically works on channels... which get their
>> functionality/limitations from controllers+clients and save them in
>> their own structure. That also helps 'submit message and moveon' type
>> clients.
>
> I understand how this currently works, but I see no reason why one
> couldn't simply point to the client struct here, instead of duplicating
> the client definition, and copying the data.
>
> I don't see an argument for fire-and-forget clients here.  The lifetime
> of the callback and private data must persist, so why not the containing
> struct?
>
>> >> +                       if (!cl->tx_tout)
>> >> +                               chan->tx_tout = msecs_to_jiffies(3600000);
>> >
>> > An hour!?  Arbitrary, and extremely long.  Either this should be
>> > indefinite, or there should be a reasonably small value here.
>> >
>> Ideally the client _should_ specify the timeout. Here the default 1hr
>> is infinity, roughly speaking.
>> What value do you suggest?
>
> An hour is by definition uncountably far from infinity.  The fact that
> this may seem like it is infinite in a test setup indicates that this
> will cause problems in the future, when/if the timeout occurs.  I
> suggest using wait_for_completion() if this is 0, or alternatively a
> timeout short enough to trigger easily via testing (e.g. 1 second).
>
>> >> +int ipc_links_register(struct ipc_controller *ipc)
>> >> +{
>> >> +       int i, num_links, txdone;
>> >> +       struct ipc_chan *chan;
>> >> +       struct ipc_con *con;
>> >> +
>> >> +       /* Sanity check */
>> >> +       if (!ipc || !ipc->ops)
>> >
>> > You probably want to check for !ipc->links here too, as you immediately
>> > dereference it.
>> >
>> Yeah, right. Thanks.
>>
>> >> +               return -EINVAL;
>> >> +
>> >> +       for (i = 0; ipc->links[i]; i++)
>> >
>> > So you require a NULL node at the end?  Why not have a nlinks/num_links
>> > in the controller struct?  It would save having to count here.
>> >
>> Rather I find that noisy. Why add variables that we can do without?
>> Especially when the variable would be used just once.
>
> Just like the marker link you need at the end of your array?  It's more
> flexible, and easier to understand from an API perspective.
>
>> >> +
>> >> +       chan = (void *)con + sizeof(*con);
>> >> +       for (i = 0; i < num_links; i++) {
>> >> +               chan[i].con = con;
>> >> +               chan[i].assigned = false;
>> >> +               chan[i].link_ops = ipc->ops;
>> >> +               chan[i].link = ipc->links[i];
>> >> +               chan[i].txdone_method = txdone;
>> >> +               chan[i].link->api_priv = &chan[i];
>> >> +               spin_lock_init(&chan[i].lock);
>> >> +               BLOCKING_INIT_NOTIFIER_HEAD(&chan[i].avail);
>> >> +               list_add_tail(&chan[i].node, &con->channels);
>> >
>> > Why not have all of this data exposed in the link definition, so you
>> > don't need this list, and can represent it as a pre-populated array?
>> >
>> Because the api choose to work only in terms of ipc channels. Infact
>> in previous revision there was just one global pool of channels that
>> the api managed. Suman Anna insisted we manage channels in controllers
>> so it makes searching easier.
>
> "Legacy reasons" is not a good argument here.
>
The reason is not legacy... its that a developer of another platform
suggested a way to make searching a bit more efficient.

>> >> +/**
>> >> + * struct ipc_client - User of a mailbox
>> >> + * @chan_name: the "controller:channel" this client wants
>> >
>> > Uh, not a consumer name?  See comment on ipc_request_channel().
>> >
>> Yeah no consumer name. The controller driver gets to name its
>> channels, a client simply uses them.
>
> Yes.  I simply don't think this conforms to "typical" kernel frameworks.
>
Are you sure you are talking about the Linux kernel here?!
 Go look how dmaengine names the channels internally for example. Go
look into ASoC code how the controllers' and codec chips' names are
not decided by the machine drivers(clients) that use them.

>> > Additionally, is there an actual use-case for having an async tx-done
>> > callback?
>> >
>> Yes, some client might need to submit a 'beacon' type message.
>
> Wouldn't this categorize as condition 'b' below?
>
My implementation does support async-tx and async doesn't mean client
doesn't care.

>> >         a) calling the blocking API, since you would have to manage that
>> >            in your own context, just like tx-done
>> >         b) not caring about tx-done?  It seems your code supports this.
> [...]
>> >> +       bool knows_txdone;
>> >
>> > If the client is running the state-machine, this is neither a mailbox,
>> > nor much of a useful framework for whatever it is the client has
>> > implemented.  Could you please explain the motivation here?
>> >
>> You could have read the code and previous threads that had lots of
>> use-cases and rationale explained.
>>
>> Anyways... consider my _real_ use-case that has come to use it.
>>  My IPC controller can not generate interrupt for TX-Done (when the
>> message/reply was read by the remote), but it does interrupt when the
>> remote has sent a message/reply. The client does not run the
>> state-machine, but it sure can save us from polling for TX-Done when
>> it know the received packet is reply to its last TX... so it tells the
>> API the last TX was done and the callback is done much sooner than the
>> next poll. This feature is solely responsible for keeping the IPC
>> latency within acceptable limits for my platform.
>
> It sounds to me that at least part of the wire protocol over which your
> client communicates is the actual mailbox here, and thus should be
> represented in the controller driver itself.  What's underneath seems
> more like some generic fifo without any useful mailbox bits.
>
Please don't assume you know my hardware better than I do. The TX-poll
is done by checking the remote has cleared-off the message register.
The f/w from another source might not even do that and the only way to
detect TX-done would be the client receiving a reply.

>> >> +       void *link_data;
>> >
>> > Random opaque data to pass straight through the framework?  This seems like
>> > a hack.  If this is needed, clearly the framework has not implemented
>> > something generic enough.
>> >
>> Nopes! I strongly suggest you read previous threads.
>>
>> Here's the rant... in IPC a client doesn't behave only according to
>> the underlying controller. But to the combination of controller plus
>> the remote f/w(or the protocol).  For example, one protocol may
>> specify the remote will 'clear' the packet-location after reading it
>> while another protocol will not clear it but sends a particular
>> reply-packet. Since we can not have two drivers for the same
>> controller, someone has to tell the controller driver how to behave
>> for the current protocol... and that 'someone' can only be the client.
>> There can be no generic code that could enumerate all possible
>> behaviors.
>
> Please stop describing this as generic IPC, because it is far from that.
> What you are describing is the difference between a driver for a
> chip/block, and a wire protocol to use across with/it.  In many cases,
> these are completely separate implementations, but they can come in many
> different structures:
>         - Single driver for generic mailbox controller
>         - Driver for bus communication + driver for controller (e.g over i2c)
>         - Driver for bus communication +
>           driver for packeted data + driver for controller
>
> The "controller" in the case of this driver should be exposing whatever
> combination makes it clearly defined as a "mailbox provider". This is
> why it is so very important that this API represents mailboxes.
>
Don't worry, what's important has been done. 5 platforms have drivers
for it (albeit closed so far). And you are still to tell me how this
api wouldn't work for your controller?


>> >> +/**
>> >> + * The Client specifies its requirements and capabilities while asking for
>> >> + * a channel/mailbox by name. It can't be called from atomic context.
>> >> + * The channel is exclusively allocated and can't be used by another
>> >> + * client before the owner calls ipc_free_channel.
>> >> + */
>> >> +void *ipc_request_channel(struct ipc_client *cl);
>> >
>> > Greg has already commented on the return type here, but there are a few
>> > further things I don't quite understand.
>> >
>> > The lookup key here is the name, which is embedded in the struct.
>> > While most of the struct seems to define the client, the name defines
>> > something which seems to be an attribute of the controller.
>> >
>> I am not sure you understand. The client specifies which channel of
>> which controller does it want. The api keeps channels hooked up in
>> controller bunch. And can figure out which channel to return.
>
> I do understand.  My point is that naming the channels/links from the
> controller isn't the normal method for doing this exact thing.  There's
> no reason to expect that a controller can name its channels better than
> a consumer can.  Neither should we expect that a client should know the
> name of a channel without a binding of some sort.
>
> What I'm recommending here is simply to use the same procedure here many
> of the existing frameworks do:
>         - controller maintains indexed list of channels
>         - client device maintains name -> index mappings (from bindings)
>         - client device maintains reference to controller (bindings)
>
> And for platforms without DT support, a global lookup-list similar to
> that in regulators and PWM frameworks, based on client device name (and
> consumer id).
>
>> >
>> > This would also map very cleanly into devicetree bindings, which are
>> > really needed for this framework.  I would also like to see a
>> > devm_ variant of this.
>> >
>> Yeah we need to move onto device tree mappings if things gets fancy.
>> Right now we all had simple clients and unique controllers.
>
> Please don't underestimate the importance of devicetree support here.
> Without it, most new platform/arch support will not be able to use this
> framework.
>
I don't underestimate, I just don't see the pressing need from
platform-specific client drivers. I am OK with DT bindings though.

>> If you problem is with the 'light-weight' part, I'll remove it. But
>> still the clients will behave just as their use-cases are!
>>
>> > With this in mind, I also don't believe that it would be a good idea to
>> > avoid holding a channel, as having drivers "trade" channels can very
>> > easily result in nasty race conditions.
>> >
>> There are use-cases that require holding onto a channel (server model)
>> and there are use-cases that require a client to relieve a channel
>> immediately after it's done. Seems you are not aware of use-case out
>> there in the wild (pls read old threads).
>
> Or perhaps I just disagree that these are valid use-cases....
>
OK I take it on record that I presented you with my use-case (server
model) that's needed to make the platform work.... and you declare it
'invalid'.
Care to grep for QUIRK in kernel ?


>> > or the API needs to support having multiple clients per-channel.
>> >
>> For platforms with 2 or more clients and each client having to do it's
>> own transfer... a channel may be busy when a client needs it. So
>> instead of implementing its own poll mechanism for availability of the
>> channel, the client could (un)register to be notified when a channel
>> become available.
>> BTW, precisely on such platforms a client would like to relieve a
>> channel as soon as its done... which is anyway a good practice of not
>> hogging resources.
>>
>> There are use-cases where a client needs exclusive access to the
>> channel... no other client should be able to send a message in the
>> middle of some 'atomic-sequence' that is already in progress. Which is
>> not possible if the API worked promiscuously. Whereas if the platform
>> wants it could still emulate the 'server' model(multiple clients per
>> channel) by having a global client submitting messages on behalf of
>> other drivers. Again, pls read old threads.
>
> If this server model suits multiple consumers, why would it not suit ...
> multiple consumers with cooperative channel sharing?  It's not common
> practice in the kernel to continually request/release exclusive access
> to a resource.
>
Again, are you sure you are talking about the Linux kernel?
 IRQs, DmaChannels, GPIOs and almost every resource is taken and
released on need basis! It's wrong to hold onto resources when they
are not needed.  What do you think about RPM?

>> >> +
>> >> +/**
>> >> + * struct ipc_link - s/w representation of a communication link
>> >> + * @link_name: Literal name assigned to the link. Physically
>> >> + *    identical channels may have the same name.
>> >
>> > I do not think "physically identical" is enough here.  One would need to
>> > know that the endpoint does not care about which channel you use.
>> > Unfortunately, I think that this would be known more by the client, who
>> > is attempting to communicate with the other side, then the controller,
>> >
>> That part is what 'link_data' is for (provided by the client and
>> passed onto the controller).
>>
>> 'physically identical' is for controller driver and implies if the
>> links are equally capable. For example the PL320 has identical links.
>> A properly written PL320 driver will manage links as floating
>> resources and assign whichever is free. If the platform makes some
>> assumptions that need to be communicated via link_data.
>
> Here's the key. If the platform is making assumptions, then those
> assumptions should be passed directly to the controller driver via
> platform data, not through the channel request.
>
Of course controller driver could take info from platform data... but
not all. There maybe some dynamic configuration needed depending on
the remotes status.

>> >> + * @api_priv: hook for the API to map its private data on the link
>> >> + *    Controller driver must not touch it.
>> >> + */
>> >> +struct ipc_link {
>> >> +       char link_name[16];
>> >> +       void *api_priv;
>> >
>> > There's no reason here to hide things from the controller; it is not
>> > normal that we assume driver developers are malicious.  Documentation
>> > describing that the data is for internal use only is sufficient.
>> >
>> It is common practice for an api to provide hooks for private data of
>> lower layer.
>
> Not in the kernel.
>
Please don't troll!   Just grep  for private_data, priv_data and count hits!


>> >
>> > I have added relevant parties from other series related to this.
>> >
>> > Although I will admit that I didn't go looking at random code on the
>> > internet before submitting my series, I did take a look at the previous
>> > iterations of this submitted for upstream.
>> >
>> But you objections (except cosmetic ones) sound like you are not aware
>> of all use-cases that have been taken care of.
>
> Considering most of my comments are actually cosmetic?
>
> Granted, I do have some concerns about use-cases which I am not convinced are
> valid, and I do think that these should be challenged before upstreaming
> code to support them.  Even if the use-cases are valid, it might still
> be worth discarding them, if we find that they are unique and could
> theoretically be implemented better elsewhere.
>
Denying doesn't help. The 'inconvenient' platforms and use-cases are
out there... what do we say? "Linux won't support your platform... go
fire your designers and come back with a platform that's easy on my
api?"
And we are not talking about supporting some QUIRK mechanism. We
layout 'all' possible combinations of the IPC chain and try to support
them all.
