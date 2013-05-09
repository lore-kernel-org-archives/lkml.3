Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3EIBba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 21:31:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37973 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab3EIBb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 21:31:29 -0400
Message-ID: <518AFB1F.7010409@ti.com>
Date: Wed, 8 May 2013 20:25:51 -0500
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
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com> <1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org> <51847070.8040400@ti.com> <CAJe_Zhdbnpu9n46s6L5KNFuTb2K87j+V4htKkmHYtBJ6w+etxQ@mail.gmail.com> <518840A2.5000205@ti.com> <CAJe_ZhedTM_wU7NGH_QRrL=O3JSYjt9ENDLYpOEQNSX3f7OgBA@mail.gmail.com> <518976B9.2030605@ti.com> <CAJe_ZhfpLQzDBSx=2VbD3W-499-g1JOovGDuFwxkE-Cq=HQDww@mail.gmail.com>
In-Reply-To: <CAJe_ZhfpLQzDBSx=2VbD3W-499-g1JOovGDuFwxkE-Cq=HQDww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

>>>>>
>>>>>  The client(s) can always generate TX requests at a rate greater than
>>>>> the API could transmit on the physical link. So as much as we dislike
>>>>> it, we have to buffer TX requests, otherwise N clients would.
>>>>
>>>> The current code doesn't support N clients today anyway, and if they are
>>>> blocking mode on top of it, it would never need Tx buffering.
>>>>
>>> No, I meant if the API doesn't buffer TX requests, then N client
>>> drivers that simply need to send 2 or more messages would have to
>>> buffer them locally.
>>>  Also by buffering TX requests the API reduces TX latency by
>>> submitting the next request atomically as soon as it knows the last TX
>>> is done.
>>
>> OK. I do not have an issue with Tx buffering,
>>
> OK, thanks for confirming.
> 
>> but the manner it is done.
>> As I said before, there is a big implementation detail on client users
>> keeping their pointers in tact until the actual Tx is done - it
>> increases the complexity of client code. I have proposed an idea below
>> on the size discussion.
>>
> What makes this API different that you want it to create internal
> copies of clients' requests?
> I2C clients have been working fine. I believe most other apis work
> similarly. No client died of the burden of having to preserve request
> pointers until the request is served by the API.

You are implying that every client does need to implement a tx_callback,
or needs to care for because of the design in the common core code. I
cannot use local variables in whatever function I am sending the
requests. The example you have given below will fail when the client
doesn't care about tx callbacks neither is blocking, if the entire
request is implemented as a function.

> 
> BTW, by forcing the API to not directly use request structures from
> clients we kill chances of zero-copy transfer use-cases.

I doubt true zero-copy transfers can be achieved for most controllers,
you will almost always copy the client payload into the physical
transport payload. For true zero-copy, you would have to give out the
ioremapped transport payload ptr to a client.

> Sorry, I don't think just to make it "easy" for some rare client (that
> issues non-blocking pass-by-reference requests and don't even care to
> know if the message was ever sent), we should add complexity to the
> API _and_ kill some important use-cases.

The OMAP usecase (existing now) uses this approach, and we got lucky
because our payload is u32 and we will overwrite the ptr with the actual
message value instead of using it as a ptr. The existing API will fail
if I just have these two conditions met by a client - no blocking and no
tx callbacks.

>>> Also logically coupling the independent physical links makes the
>>> controller driver not very portable - what if some other platform has
>>> usage of 3 send+receive and 2 send-only communications of the 8
>>> physical links? The controller h/w is perfectly capable of providing
>>> that, but its driver is not.
>>
>> That's upto that controller driver, right?
>>
> Yes, I meant the OMAP's controller driver need to be re-written
> properly so as to not couple 2 links together as one RX and one TX.

Maybe for a different type of controller, but OMAP definitely doesn't
need this additional complexity for the foreseeable future, neither in
the client nor in the controller driver.

>>>> In anycase,
>>>> global publication will have its own set of problems - mostly you are
>>>> implying another layer of implementation that provides this sharing
>>>> capability (since they have to be outside of any single client).
>>>>
>>> Yes. Though yet another way of doing it is for the controller driver
>>> to populate N logical per physical link that needs to be shared.
>>
>> Yeah, I was implying the same idea.. The notifier chains in the current
>> driver really meant the logical and physical is the same as we are
>> returning the link handle, but with your current design of returning
>> ipc_chan as an opaque handle, you already have the base infrastructure
>> in place. Once we add tx callbacks, even the original mailbox series
>> would have transformed into having a similar concept as what you have.
>>
> Though I would still suggest you manage a remote by a local 'server'
> code - not every client needs to be bothered with request/response for
> every other client.

That's a client protocol or functional integration aspect of the
clients, remote and controller driver on the particular SoC, right?

> Also the OMAP might be lucky, but the remote may not always simply
> respond to commands from local clients. The remote might also send
> some SOS or similar command on behalf of the remote as a whole. Such
> requests should be handled by that local 'server' code.
> 
> 
>>> The OMAP simply pass by value a u32 as a message.  Why do you think it
>>> won't work ? (Please have a look at my implementation of the omap2
>>> controller driver)
>>
>> I am talking about queueing more than 1 request, we simply send a
>> message that can be triggered by either remoteproc for PM purposes or by
>> different rpmsg clients sending a message. It is delivered into the
>> mailbox and there is no implicit ack needed on tx_done since that is
>> dealt by the client messaging protocol sitting above. We will not be
>> using blocking mode, so there can be multiple requests at the same time
>> (in the queue).
>>
> Yes that's what I am talking about.  Multiple requests would still be
> a u32 each.

This discussion came about from your statement, "Most of the clients
won't queue more than 1 request at a time. And then, isn't it only
natural that clients don't mess with requests after submitting them?  I
see mailbox clients working quite like I2C clients."

> Since for OMAP a message is just a 32-bit number, a client would queue
> requests as
> {
>       u32 cmd;
>       cmd = COMMAND_A;
>       ipc_send_message(chan, (void *)cmd);
>       cmd = COMMAND_B;
>       ipc_send_message(chan, (void *)cmd);
>       cmd = COMMAND_C;
>       ipc_send_message(chan, (void *)cmd);
> }

This is the example I mentioned above (Make cmd a structure or an
integer array).

> 
> 
>>>>
>>> As I said, among other advantages, TX buffering is needed to reduce
>>> latencies. My platform's protocol isn't yet clear as to whether use
>>> shared-memory (secure and non-secure versions) for not very large data
>>> transfers or interrupt payload. So if we get good enough speed we
>>> could save cost on dedicated memories.
>>>
>>> I wrote the omap2 controller driver code to convey my proposal better.
>>> If you could please tell me how TX buffering is a problem for OMAP, it
>>> will help me understand your concern better.
>>
>> It is not a problem for OMAP
>>
> Thanks for confirming that it's not a problem for OMAP.
> 
> 
>>  The other thing is that you
>> have defined 10 as the queue length in the core, this should be dictated
>> by the controller or mailbox. What works for one platform may not work
>> for some others (this is what you saw as different config options
>> between OMAP and DBX500)
>>
> Please read the multi-line comment over that single line define.
> The buffer is cheap, just a void*, so we could make it even 50.
> However I am not hung on that.

OK good, because no single number would be good for all the controllers
or all possible clients.

> It purely depends upon how the client uses the link,

i guess you are saying this because of the possible blocking behavior of
a client, or the exclusive access to a link.

> so it can't be driven by the controller. We could make it a Kconfig option.
> What do you suggest?

I am saying controller/link because they are the ones that knows how the
physical transport is, and it may vary from one to another. I would
think that the client dependencies would become a subset of this.
Kconfig option is fine, but we have to think about the best way of
representing it from a multi-platform kernel support perspective.

>>>>
>>> How could the core perform any meaningful sanity check?  What if we
>>> send/receive proper 'datalen' of garbage data?  What if the client
>>> sends a "Give me info in not more than 32-bytes at a time" command to
>>> the remote and the remote has valid info worth only 16 bytes?
>>> IMHO there is not much for core to verify in a packet in transit. The
>>> introduced checks are not worth it and actually limit some scenarios
>>> like above example.
>>
>> OK, I had mainly two ideas, one telling the size of the void * on Tx,
>> with the controller driver specifying max (and maybe min sizes expected)
>>
> No, please. The controller driver is supposed to be reusable over
> various protocols. A protocol dictates the length of each logical TX
> unit. The max-min limits set by the controller driver might work for
> one but fail some other higher level protocol.
> 
>>
>> The second (major reason) idea was driven by the kfifo implementation
>> for buffering in core code for which I need the size field, so that the
>> clients need not be intelligent about the status of its tx submission
>> and maintaining its pointer (if you have different calling contexts). I
>> guess both of us are coming from different perspectives here, you may
>> find kfifos inefficient and I may find the complexity in client driver
>> unnecessary for maintaining pointers. How about defining add and remove
>> buffer ops in the controller driver so that it can choose its
>> implementation, while we keep the overall flow architecture in the core
>> code?
>>
> As I said the API shouldn't keep internal copies of a client's
> requests - it will only kill zero-copy use-cases while adding
> complexity to the core.

This is the reason I was suggesting the nature be dictated by a
controller, rather than 1 design in core code mandating a certain usage.
The client & controller together would know the functional integration
aspect.

> Since it already works fine for OMAP, I request we leave it as such
> for now at least.

OK, we should make a note of it in some documentation.

>>>>
>>>> Yeah, assumptions hold true until an unfortunate SoC comes up with it
>>>> :). The TI AM3352 has one link that doesn't behave quite like the other
>>>> (I am hoping to avoid using it), so I am ok with it for now. Guess we
>>>> can always change it when a concrete need arises.
>>>>
>>> It would work right now :)   If your controller has 2 types of links,
>>> the driver should register each bunch separately, each with its own
>>> ipc_link_ops, with the core. The core can already take care of the
>>> rest.
>>
>> Yeah, it can be done that way, but that's a not-so-elegant work-around
>>
> OTOH I find it elegant and not a "work around".
> Liberally estimating, hardly 10% of IPC controllers would have 2
> classes of physical links. Having link_ops per controller reduces the
> number of ipc_link_ops structures 11:20 as compared to per link.
> 
> 
>> IMHO. It's calling ipc_links_register twice on the same controller. Idea
>> was that the API would distinguish different controllers, not the same
>> one. Also, see the above example if you were to treat a link as Rx or Tx
>> only (functional behavior differences even though the link is exactly
>> the same type).
>>
> Why is calling ipc_links_register() twice, for a controller with 2
> classes of links, a problem ?

It will be inelegant, once you start maintaining the list of
ipc_controllers in the core code. You would have to search all the
controllers in the list with the matching name, and their links. You
will need to define multiple controller specific controller structures
and copy most of the elements from the actual h/w device into the
containing ipc_controller definition. As you said, the clients deal with
the links themselves, so making the ops part of the ipc_link definition
makes it easier on the controller implementations. You are anyway
caching the ops in ipc_chan (per link) and that is what you are using in
the core code. Majority of the time, you would be using the same ops for
all the links, but this gives the flexibility to links. You can avoid
having multiple controller instance denoting the h/w block, just because
of the difference in links behavior.

> 
> And, No, the API need not know if the link is "RX" or "TX", which is
> purely a logical function.
> 
> Please do tell me which controller physically limits its links to do
> only "RX" or only "TX"?  It's just the platform's firmware that
> dictates who sends and who receives on which link, thereby giving the
> illusion of a link being a "RX" or "TX" capable only.
> Even if some h/w limits do exist on links of some controller, still
> the API shouldn't try to discern a "RX" from a "TX" link. When a
> client knows which link to open, it will also know if it should read
> or write to it - this assumption already holds true. If the client
> writes on a link that it's supposed to listen to remote on, no amount
> of policing by the API could help.
>
> Even if the API tries to differentiate "RX" and "TX" links, the
> knowledge must come from a client (it's driven by the protocol on the
> platform), and not the controller because each of its links are
> physically equally capable to do RX or TX on each end.

The API never differentiates, but the controller implementation has to.
>From a controller driver implementation perspective, you still have to
make sure that no client is calling an op on which it is not supposed
to. When you have a mixture like this, a common code would include some
dead paths for certain links.

> 
> 
>>> Yes, I have 2 types of controllers and I already thought about
>>> multiple controllers in a platform.
>>>  What do you expect to do in controller startup/shutdown? Since the
>>> API works on individual links, not the controllers, when would it call
>>> controller_start() and controller_shutdown()?  The ipc_link's
>>> startup/shutdown are already non-atomic, if the controller needs any
>>> setup it could do it in the first link's startup and teardown in the
>>> last link's shutdown. Not to forget the resources lke IRQ are usually
>>> per Link which should be acquired/released upon link's use/idle.
>>>  While writing the OMAP2 controller driver, did I miss any controller
>>> startup/shutdown ?
>>
>> It just delineates the code better, and has flexibility later on to
>> extend any controller ops or exposing new controller-specific API. The
>> controller start and stop will be called in the same function as
>> ipc_request_channel.
>>
> Already one call ipc_link_ops.startup() reaches the controller upon
> ipc_request_channel.
> 
> Do you mean ?
>        ipc_con_ops.startup();
>        ipc_link_ops.startup();

Yes.

> 
> Why have 2 contiguous calls to the controller, to perform similar
> functions?  Not to forget the API and clients don't work on IPC
> controllers, but only on links. So it would be out-of-line for them to
> have to worry about the controller.

As I said, mainly to help dilineate the controller implementation code
better. I can live with it not being present, as my startup function
would anyway be refactored into two - one for the controller, and one
for the link itself. And I bet most would do the same if they have
multiple links in a controller.

> 
>>
>> Yeah, the pm_runtime_enable cannot be called twice when mailbox is
>> invoked from multiple clients on separate links, so there has to a
>> controller-level logic/ref-counting for that. The clocking for us is on
>> the controller.
>>
> No.  You could call pm_runtime_enable/disable any number of times as
> long as they are balanced. The core does refcounting.

Exactly, as long as they are balanced. I have two clients dealing with
two remotes (using two links) so pm_runtime_enable on the h/w block
needs to be called only when the first one comes in. Anyway, this is
just an FYI, as this file will obviously be different since I have to
not break my existing clients.

regards
Suman


