Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab3DXXWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:22:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53635 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3DXXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:22:06 -0400
Message-ID: <517867E1.7050301@ti.com>
Date: Wed, 24 Apr 2013 18:16:49 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: Loic PALLARDY <loic.pallardy@st.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Andy Green (andy.green@linaro.org)" <andy.green@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
References: <1363145021-14339-1-git-send-email-s-anna@ti.com> <CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com> <37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com> <CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com> <37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com> <CAJe_ZhehnniZd730jjiOLrHozq8TOJZgFYLqUe4KqgBiQEu8PA@mail.gmail.com> <51779304.4040003@st.com> <CAJe_ZhdZv5LW6kdwyPtJe69mfW6t=WQ4OJnG2H4sUhibattN2A@mail.gmail.com>
In-Reply-To: <CAJe_ZhdZv5LW6kdwyPtJe69mfW6t=WQ4OJnG2H4sUhibattN2A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jassi,

On 04/24/2013 03:56 AM, Jassi Brar wrote:
> Hi -
> 
> On 24 April 2013 13:38, Loic PALLARDY <loic.pallardy@st.com> wrote:
>> Hi Jassi,
>>
>> On 04/24/2013 06:39 AM, Jassi Brar wrote:
> 
>>>   The non-atomic API falls flat should just a single client comes with
>>> very low latency requirements.
>>
>> In fact there are different situations for the non/atomic requirements
>> (at least from ST POV)
>> - one mailbox could be non-atomic only (blocking if we reuse notifier
>> wording)
>> - one mailbox could be atomic only
>> - one mailbox could be both depending on the context and usage (example:
>> in the case of ST, one mailbox is used to access the analogue baseband,
>> there is no particular atomic requirement for that except during
>> register dump called form panic context)
>>
>> For the 3rd point I agree with you, it should be considered as atomic
>> and up to driver to schedule a sleepable task...
>>
>> I have an internal implementation in which each mailbox is declared
>> either atomic or blocking.
>> Depending on this parameter, the behavior of the mbox_send_mbox is
>> changed...
>>
> I am only talking about the nature of the API, which I think should as
> fast as possible by providing atomic functions (except
> mailbox_get/put).
> If a controller needs to do sleep-prone tasks, let it schedule those
> from API's atomic callbacks.
> If a client needs to blink leds after receiving/sending a message, let
> it schedule a work for that from API's atomic callback.
> Majority of scenarios will simply be a client populating a structure
> and pass it onto the controller driver which only need to program a
> few registers to put the message on the h/w link.

I think there are two things here - one is what the client needs to do
upon sending/receiving a message, and the other is what the send API or
the mailbox controller should do when a client tried to send a message
and the controller's shared message/transport is not free (irrespective
of the atomic or non-atomic context). The kfifos in the common driver
code are currently solving the latter problem. The current send API
directly uses the controller to send if it is free, and uses buffering
only when it is busy. But, I see your point that this should should be
the responsibility of the specific controller, or even a property of the
specific mailbox belonging to that controller. This direction would put
most of the onus on the specific controller drivers, and probably the
main API would be very simple. Another factor / attribute to consider is
that a given mailbox may be sharable or exclusive, things are simple if
it is exclusive to a client driver.

> 
> 
>>>   Consider this example for better understanding, I must send a
>>> particular packet to the remote before I could, say, shutdown
>>> properly. The client calls mailbox_msg_send which queues the packet
>>> because the h/w was busy. Since the api does not inform the client
>>> about packet transmission, the client does not know when to shutdown
>>> (the packet may have been sent instantly or it may lie on the queue
>>> for a long time).
>>>   How do you fix this without tx_done callback method?
>>>
>> This mechanism was preserved to be compatibility with TI DSP bridge. But
>> my initial proposal was to remove it, simply because today all mailbox
>> customers consider that message is sent or not after calling
>> mbox_send_message function.
>>
> Yeah, I too sense a lot of badness is inherited.

We are talking two fundamentally different usecases/needs here,
depending on the type of the controller. You seem to be coming from a
usecase where the client driver needs to know when every message is
transmitted (from an atomic context, it is a moot point since either you
are successful or not when transmitting). The example problem you
mentioned maybe very relevant to some hardware, but it hadn't been an
issue on OMAP since the mailbox driver is just for sending messages and
not managing the state of the remote. The remote is a processor in OMAP,
and its state machine is controlled by the remoteproc driver. The remote
has to ack before it can be shutdown. I would imagine that getting a
.tx_done on a particular message is not good enough to know that the
remote is ready for shutdown. I can imagine it to be useful where there
is some inherent knowledge that the client needs to proceed with the
next steps when a message is sent. That said, we need to go with the
stricter one.

> 
>>>>
>>>> The size parameter would still be needed. Depending on the h/w, it can be just an u32 or a series of bytes, and even in the latter case, it is not guaranteed that all messages transmitted will occupy the entire h/w shared memory data packet. I can see the current header field getting absorbed into the opaque void * structure for the ST mailbox driver. The size and ptr together provide a very generic message format.
>>>>
>>> I am not sure about it. The API has no purpose for the .size (it's
>>> between the controller and the client driver).
>>> Controllers that could send variable length packets could define the
>>> packets format for clients as
>>>   struct foo_packet {
>>>           int size;
>>>           .......
>>>   }
>>> and exchange as typecasted to void* via the API. And this is just one
>>> way of doing it.
>>> The point being, the API should only pass pointer to packet info
>>> between controller and client drivers.
>> No today the size is used to store the message in the fifo and that's
>> done by the framework.
>> If you decide to remove the fifo mechanism inherit for TI legacy, in
>> that case yes the mailbox framework doesn't matter about message format
>> and size.
>>

Yep, the size field was a direct need from the buffering needs if the
controller were busy. The Tx RTR in fact was used to flush out the
buffered messages.

> Of course I desperately want to get rid of the TI legacy stuff in the
> common api, that will simply not work on many platforms. My 'shutdown'
> example above may be real for some platform.
> 
>>>
>> I'm really happy to see some new mailbox framework clients coming with
>> new requirements to improve the solution.
>> Just for the story, mailbox framework topic was addressed during Linaro
>> Copenhagen Connect and at the time being it was decided to reuse TI
>> solution in a first time and then to improve it...
>>
> At the time my idea of mailbox was simply a tin box with a lock and a slit.
> On a serious note, someone very important pointed out that things
> discussed during events like Linaro shouldn't be taken as the
> consensus of the community. "We" should have put it up for discussion
> on the mailing lists.
> 
>>> Maybe it will help if I know what you guys mean by "shared mem" or an
>>> "hw fifo" mailbox?
>>>
>> Hw fifo means that you what a HW IP which contains x bytes fifo.
>> When you write one byte in the fifo, an interrupt is automatically
>> raised and caught by coprocessor which should read fifo on its side to
>> empty it. In that case, Tx RTR is mandatory.
>> Shared mem, means that mailbox is made up of a cross interrupt + a
>> status register (may be optional) + a shared memory in which messages
>> are exchanged.
>> After writing message in shared mem, CPU has to raise the cross
>> interrupt itself. In case flow control is less important...
>>
> Well, I have a yet another type of controller where the IRQ status
> register provides the data to be exchanged. Anyways I still maintain
> that all three(or any more) controller types need not bother the API
> with the size of message. The size should be a mandatory member of the
> controller specific packet format that will be used by the client to
> exchange data with it.

I think the discussion on size field is mostly semantics, since it would
be very much relevant if the controller's transport payload is more than
the size of a standard type. It is a non-factor for controllers whose
payload size is a standard type (like for OMAP, where the msg size is
u32). Having 32 bytes of payload, for example, almost always means your
controller packet has to have a size field indicating the actual number
of bytes in the message, and it doesn't matter whether the size is a
register or has to exchanged with the remote as part of the transport
packet structure. My only concern here is that if there can be multiple
clients for a particular mailbox/controller, then all the clients would
have to have an agreement on the controller packet type, and the clients
would mostly have to include the standard mailbox.h as well as a
controller-specific header.

Overall, I see it coming down to following points:
1. Calling contexts: Atomic & non-atomic contexts, with the latter
becoming an extension of the atomic case. I guess this mainly goes with
the controller functional integration - whether it is used for
non-urgent messaging or h/w controller command messages (like PM
usecases?) where .tx_done is relevant.
2. Behavior of the API or controller driver if the controller transport
is busy.
3. Shareable/exclusive nature of a mailbox. If it is shareable, then
duplicating the behavior between clients is not worth it, and this
should be absorbed into the respective controller driver.

regards
Suman

