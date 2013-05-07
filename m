Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3EGV4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:56:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43894 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3EGV43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:56:29 -0400
Message-ID: <518976B9.2030605@ti.com>
Date: Tue, 7 May 2013 16:48:41 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Green <andy.green@linaro.org>
Subject: Re: [RFC 2/3] mailbox: Introduce a new common API
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com> <1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org> <51847070.8040400@ti.com> <CAJe_Zhdbnpu9n46s6L5KNFuTb2K87j+V4htKkmHYtBJ6w+etxQ@mail.gmail.com> <518840A2.5000205@ti.com> <CAJe_ZhedTM_wU7NGH_QRrL=O3JSYjt9ENDLYpOEQNSX3f7OgBA@mail.gmail.com>
In-Reply-To: <CAJe_ZhedTM_wU7NGH_QRrL=O3JSYjt9ENDLYpOEQNSX3f7OgBA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

> On 7 May 2013 05:15, Suman Anna <s-anna@ti.com> wrote:
>>>
>>>  The client(s) can always generate TX requests at a rate greater than
>>> the API could transmit on the physical link. So as much as we dislike
>>> it, we have to buffer TX requests, otherwise N clients would.
>>
>> The current code doesn't support N clients today anyway, and if they are
>> blocking mode on top of it, it would never need Tx buffering.
>>
> No, I meant if the API doesn't buffer TX requests, then N client
> drivers that simply need to send 2 or more messages would have to
> buffer them locally.
>  Also by buffering TX requests the API reduces TX latency by
> submitting the next request atomically as soon as it knows the last TX
> is done.

OK. I do not have an issue with Tx buffering, but the manner it is done.
As I said before, there is a big implementation detail on client users
keeping their pointers in tact until the actual Tx is done - it
increases the complexity of client code. I have proposed an idea below
on the size discussion.

>>>
>>> IMHO if clients on OMAP need to buffer RX, let us keep it OMAP
>>> specific. If number of such platforms rise in future we could move
>>> that as an _optional_ helper API on top, that does RX buffering on
>>> behalf of clients ?
>>
>> Yeah, that's my idea as well to put this in the OMAP mailbox controller
>> driver implementation. The IPC stacks on OMAP are quite established
>> (both in remoteproc and DSP/Bridge - different generations), so I cannot
>> afford to break the functionality of either of those. This already means
>> I have to export some API from my controller driver and there is no
>> other way or now.
>>
> Yes, I anticipated that.
> Though imho OMAP's mailbox client/controller drivers could have be better.
>  The controller has 8 instances of identical mailboxes/links which
> operate independent of each other. It is the s/w implementation that
> has tacit understanding of who sends/receives on which link. So
> ideally a client driver should simply, say for omap3430, ask for
> separate "mbox1" to read messages and "mbox0" to send messages to DSP.

I think this is a good example for link_ops specified with the link,
rather than the controller (send_data would be NULL on the Rx instance
for example). In anycase, there is not much to be bought implementing
this way on OMAP (maybe sometime in the far future if we assign receive
queues by processor, rather than defining the pair as a communication
link with some message decoding indicating tx processor), since our
remotes are processors and the link assignment configuration doesn't
change dynamically.

>  The unnecessary logical coupling of 0th and 1st links seems to be the
> cause of 'hacks' like mailbox_dis/enable_irq(), whereas it should have
> been release/request of the RX mbox.

The logical coupling is not the reason, but that's because of the IPC
protocol stack implementation in DSP/Bridge, that's a story for another
day. remoteproc does not suffer from this.

> Also logically coupling the independent physical links makes the
> controller driver not very portable - what if some other platform has
> usage of 3 send+receive and 2 send-only communications of the 8
> physical links? The controller h/w is perfectly capable of providing
> that, but its driver is not.

That's upto that controller driver, right?

>   Similarly something sure seems fishy about the client driver having
> to explicitly save and restore registers of controller. Anyways, OMAP'
> implementation of mailbox is a separate subject.

Yeah, not too concerned here, the save/restore part can be fixed rather
easily. I will look into that once we get the series and the initial
migration done.

>>>>
>>>  If the API provides shared ownership of a mailbox, it won't work for
>>> clients that need exclusive ownership (like 'server' side
>>> implementation of a protocol).
>>>  OTOH if the API provides exclusive ownership, it is still possible to
>>> emulate shared ownership by simply publishing the mailbox handle (void
>>> *chan) globally. It works for all.
>>
>> I am not saying provide this always. Have this dictated by the
>> controller or mailbox (look at my branch). The global publication works
>> well functionality-wise for Tx, but not so much for Rx.
>>
> Right now for RX the clients register a blocking notifier call within
> the API, you could move that out into the same code that publishes the
> TX handlle globally.  I am a bit hesitant because I want to make sure
> we don't push anything into the common API that isn't already done
> right in OMAP's implementation.
> 
>> In anycase,
>> global publication will have its own set of problems - mostly you are
>> implying another layer of implementation that provides this sharing
>> capability (since they have to be outside of any single client).
>>
> Yes. Though yet another way of doing it is for the controller driver
> to populate N logical per physical link that needs to be shared.

Yeah, I was implying the same idea.. The notifier chains in the current
driver really meant the logical and physical is the same as we are
returning the link handle, but with your current design of returning
ipc_chan as an opaque handle, you already have the base infrastructure
in place. Once we add tx callbacks, even the original mailbox series
would have transformed into having a similar concept as what you have.

> 
> BTW, there doesn't exist any code/dt that creates the "omap-rproc"
> platform_device so I may have misunderstood, but it seems the OMAP
> already acquires a mailbox only once and save it in the data structure
> representing the remote, which should simply work as such. No?

Yeah, the rproc device creation code is currently out of tree (you can
find it in Ohad's remoteproc tree on git.kernel.org), it is currently
disabled due to the lack of multi-platform support in mailbox
(dependencies on this series and other DT conversions). The runtime
support would have relinquished the mailboxes. remoteproc already looks
in certain messages for device management, and others it passes onto the
rpmsg bus, but that is rather tightly coupled.

> 
> 
>>>>
>>> Most of the clients won't queue more than 1 request at a time. And
>>> then, isn't it only natural that clients don't mess with requests
>>> after submitting them ?  I see mailbox clients working quite like I2C
>>> clients.
>>
>> The OMAP use-cases do this today, so not a good assumption to make. The
>> OMAP IPC is built upon simple transmitting and processing received
>> messages separately, we will not be using blocking mode or tx callbacks.
>> I really don't need the complexity of having to introduce tx callbacks
>> just because I need to know if my pointer can be freed, as I said - it
>> eliminates the simplicity of using local variables unless the send API
>> is blocking. void * works for OMAP since my payloads are only 4 bytes by
>> themselves (this is a discussion that came up during the earlier series
>> as well), but this is not flexible enough on the clients-side generally.
>>
> The OMAP simply pass by value a u32 as a message.  Why do you think it
> won't work ? (Please have a look at my implementation of the omap2
> controller driver)

I am talking about queueing more than 1 request, we simply send a
message that can be triggered by either remoteproc for PM purposes or by
different rpmsg clients sending a message. It is delivered into the
mailbox and there is no implicit ack needed on tx_done since that is
dealt by the client messaging protocol sitting above. We will not be
using blocking mode, so there can be multiple requests at the same time
(in the queue).

> 
>>>
>>>> Secondly, we may not need the logic around client knows_txdone and
>>>> tx_buffering together. I understand the need for buffering when you have
>>>> TX_POLL or TX_IRQ, but as far as TX_ACK is concerned, it is a client
>>>> protocol-level knowledge, and so the tx buffering logic can remain with
>>>> the client itself. This should simplify the code a little bit and get
>>>> rid of the ipc_client_txdone API.
>>>>
>>> Yeah I had it that way originally. But then I realized we could be
>>> running an 'ACK Packet' protocol over a controller that supports only
>>> POLL. In that case the controller's poll doesn't override client's
>>> knows_txdone because we want the client to cut-short the next poll
>>> delay as soon as it gets an ACK packet.
>>
>> I think the same can be achieved from the Rx path upon an interrupt in
>> the specific controller, without having to introduce the knows_txdone.
>>
> RX may not only be responses, it could very well be a remote command
> just before the response to the last local command. OR the RX
> responses may be out of order. So it can't be tied to the RX
> interrupt.

Do you have the same shared payload in both directions? If so, the above
will work. Otherwise, I understand the scenario.

>> It is knowledge intrinsic to a controller/mailbox. I really hope that
>> there are no controllers where you have to poll for Rx too :)
>>
> No, not intrinsic to controller, but to the high level protocol.
> Yes, I assume the RX to be always interrupt driven :)

Until someone (out of their minds) comes up with it :)

> 
>>>
>>>> Looking at the current use-cases, I think OMAP might be the only one
>>>> which needs the buffering. The API that Loic added suggests that he
>>>> either sends a message and expects a response, or just sends a message
>>>> if the transport is free (I am not sure if he is using the API that uses
>>>> buffering currently). PL320 is the same as the first scenario that Loic has.
>>>>
>>> Yeah I too expect TX buffering to be very rare.
>>
>> If so, can we eliminate this for the first pass, and leave it to the
>> controllers for now or dictate this based on a tx_buffering property? As
>> I see it, we do not yet have an agreement on the Tx buffering semantics.
>>
> As I said, among other advantages, TX buffering is needed to reduce
> latencies. My platform's protocol isn't yet clear as to whether use
> shared-memory (secure and non-secure versions) for not very large data
> transfers or interrupt payload. So if we get good enough speed we
> could save cost on dedicated memories.
> 
> I wrote the omap2 controller driver code to convey my proposal better.
> If you could please tell me how TX buffering is a problem for OMAP, it
> will help me understand your concern better.

It is not a problem for OMAP, it is about only maintaining the void * in
the Tx queue. Since OMAP uses only a u32 message, I could have used the
void * as the u32 message but not a pointer (same approach we had taken
in the previous series). I am talking in general about the void *, and
the limitations it poses on client users. The other thing is that you
have defined 10 as the queue length in the core, this should be dictated
by the controller or mailbox. What works for one platform may not work
for some others (this is what you saw as different config options
between OMAP and DBX500)


>>>
>>> Secondly, I believe we acknowledged the fact that a client can't do
>>> without controller specific knowledge. So in proper implementation the
>>> controller's header would look like
>>>
>>> struct foobar_con_mssg {
>>>    int datalen; /* size of received packet in bytes */
>>>    u8 *buf;  /* buffer that holds the packet data */
>>>     .....
>>> };
>>>
>>> So instead of telling the API the 'datalen' and the remaining
>>> structure of each message, we simply pass "struct foobar_con_mssg *"
>>> as a void* to the API.
>>
>> This has to be documented very well. And yes, I did acknowledge the
>> inter-dependencies portion for understanding the packet structure (there
>> is no way if you have a packet of 6 ints and you expect specific ints
>> for specific fields). The size and void * are generic enough that can be
>> present in the core to perform some error checking. The API would be
>> akin to memcpy then. The other motivation is based on the buffering
>> scheme (same comment as above on Tx buffering), which we haven't agreed
>> upon completely.
>>
> How could the core perform any meaningful sanity check?  What if we
> send/receive proper 'datalen' of garbage data?  What if the client
> sends a "Give me info in not more than 32-bytes at a time" command to
> the remote and the remote has valid info worth only 16 bytes?
> IMHO there is not much for core to verify in a packet in transit. The
> introduced checks are not worth it and actually limit some scenarios
> like above example.

OK, I had mainly two ideas, one telling the size of the void * on Tx,
with the controller driver specifying max (and maybe min sizes expected)
so that some base error check can be done. This may be a basic check,
but atleast provides some level of sanity checking. On Rx-side, send the
size of the void * back to the client driver. The example you gave is
upto the client communication protocol, the remote may not even choose
to send the data if it doesn't have 32 bytes.

The second (major reason) idea was driven by the kfifo implementation
for buffering in core code for which I need the size field, so that the
clients need not be intelligent about the status of its tx submission
and maintaining its pointer (if you have different calling contexts). I
guess both of us are coming from different perspectives here, you may
find kfifos inefficient and I may find the complexity in client driver
unnecessary for maintaining pointers. How about defining add and remove
buffer ops in the controller driver so that it can choose its
implementation, while we keep the overall flow architecture in the core
code?

> 
> 
>>>>
>>>> Assigning the tx_block at channel request time might not be flexible
>>>> enough. We should not impose that the client will request and release
>>>> channels with different modes if both scenarios are needed.
>>>>
>>> If there is one blocking request, no more could arrive (blocking or
>>> non-blocking).
>>
>> Well, you are assuming that there is only one thread from within the
>> client driver who is gonna use the send API. There is nothing in the
>> code that stops from say two threads/contexts queueing in the message
>> from the same client driver. I am ok from my side for this to be sorted
>> out later, since I won't be using the blocking mode,
>>
> Thanks
> 
>>>>
>>>> Do we need to add an API similar to mailbox_msg_send_receive_no_irq, or
>>>> are you leaving it to be client's responsibility?
>>>>
>>> Yes the API provides enough ways for a client to do that.
>>
>> I will let Loic comment on this, based on his usage/complexity in the
>> client. I think you got lucky with PL320 implementation since it fills
>> in the buffer on a Tx done, so you have folded that functionality in
>> send_data itself.
>>
> No, the pl320 models the links properly. The links could be used for
> RX or TX independently.
> Any RX channel will return data only from a remote. The TX returns
> data in tx-buffer which may or may not be changed by the remote after
> reading. The Highbank's protocol make use of that feature. Though I am
> interested to know if Loic has some unmet requirements still.

thanks for the clarification.

> 
> 
>>>>
>>> Yeah, I changed that to it last minute :)
>>> The API has no real use of controller nodes, it works solely on a
>>> global pool of mailboxes. I tried to reflect that in code.
>>
>> Can we go back to using controller nodes? I understand that the API
>> doesn't use much, but the list of controller nodes is gonna be static
>> anyway in the file. It just improves the search algorithm when looking
>> for a mailbox. We have a new device coming up (u-boot patches already
>> submitted) wherein we have 13 controller instances, each with about 4 to
>> 6 links, a linear search would be really painful.
>>
> OK I'll keep a local list of controllers.

Sure, thanks.

> 
> 
>>>>
>>> There are some highly programmable controllers that, if the driver is
>>> proper, could change behavior runtime. For ex, if the controller
>>> supports, a client might want to broadcast messages to multiple
>>> remotes or listen for messages from more than one remote source or
>>> both. The client could, say, specify bitmasks for such source/sink
>>> remotes via cntlr_data while requesting the mailbox.  PL320 could work
>>> in such mode if rest all fits.
>>
>> Are you configuring the specific mailbox or configuring the controller
>> on a whole in this particular example?
>>
> The cntlr_data is to configure the link/mailbox, not the controller.

then, can we rename this to 'link_data' or something that doesn't imply
controller to avoid confusion? I guess you meant it as controller driver
data rather than controller instance data, but the name is a bit misleading.

> 
>>>>
>>> A controller is assumed to be a bunch of identical links/mailboxes.
>>> However the cntlr_data could still help the client specify mode in
>>> which it wants a mailbox behave.
>>
>> Yeah, assumptions hold true until an unfortunate SoC comes up with it
>> :). The TI AM3352 has one link that doesn't behave quite like the other
>> (I am hoping to avoid using it), so I am ok with it for now. Guess we
>> can always change it when a concrete need arises.
>>
> It would work right now :)   If your controller has 2 types of links,
> the driver should register each bunch separately, each with its own
> ipc_link_ops, with the core. The core can already take care of the
> rest.

Yeah, it can be done that way, but that's a not-so-elegant work-around
IMHO. It's calling ipc_links_register twice on the same controller. Idea
was that the API would distinguish different controllers, not the same
one. Also, see the above example if you were to treat a link as Rx or Tx
only (functional behavior differences even though the link is exactly
the same type).

> 
>> I prefer to see the controller_ops for startup/shutdown atleast. This
>> will allow the controller code state machine to be much better
>> maintained and make the code look good. As I said, with our new device,
>> where we have 13 controllers this will be very helpful. Also from what
>> Andy explained, you seem to have two controllers that are quite
>> different from each other.
>>
> Yes, I have 2 types of controllers and I already thought about
> multiple controllers in a platform.
>  What do you expect to do in controller startup/shutdown? Since the
> API works on individual links, not the controllers, when would it call
> controller_start() and controller_shutdown()?  The ipc_link's
> startup/shutdown are already non-atomic, if the controller needs any
> setup it could do it in the first link's startup and teardown in the
> last link's shutdown. Not to forget the resources lke IRQ are usually
> per Link which should be acquired/released upon link's use/idle.
>  While writing the OMAP2 controller driver, did I miss any controller
> startup/shutdown ?

It just delineates the code better, and has flexibility later on to
extend any controller ops or exposing new controller-specific API. The
controller start and stop will be called in the same function as
ipc_request_channel. The other thing is adding a check for the presence
of startup ops before actually invoking it, that way controller
implementations with no special startup needed can avoid it. Controller
ops in ipc_controller and link_ops in ipc_link would give better
flexibility for controller driver implementations.

Yeah, the pm_runtime_enable cannot be called twice when mailbox is
invoked from multiple clients on separate links, so there has to a
controller-level logic/ref-counting for that. The clocking for us is on
the controller.

regards
Suman
