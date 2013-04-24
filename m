Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab3DXI4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:56:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43268 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab3DXI4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <51779304.4040003@st.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
	<CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
	<CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
	<CAJe_ZhehnniZd730jjiOLrHozq8TOJZgFYLqUe4KqgBiQEu8PA@mail.gmail.com>
	<51779304.4040003@st.com>
Date: Wed, 24 Apr 2013 14:26:40 +0530
Message-ID: <CAJe_ZhdZv5LW6kdwyPtJe69mfW6t=WQ4OJnG2H4sUhibattN2A@mail.gmail.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Loic PALLARDY <loic.pallardy@st.com>
Cc: "Anna, Suman" <s-anna@ti.com>, Jassi Brar <jassisinghbrar@gmail.com>,
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On 24 April 2013 13:38, Loic PALLARDY <loic.pallardy@st.com> wrote:
> Hi Jassi,
>
> On 04/24/2013 06:39 AM, Jassi Brar wrote:

>>   The non-atomic API falls flat should just a single client comes with
>> very low latency requirements.
>
> In fact there are different situations for the non/atomic requirements
> (at least from ST POV)
> - one mailbox could be non-atomic only (blocking if we reuse notifier
> wording)
> - one mailbox could be atomic only
> - one mailbox could be both depending on the context and usage (example:
> in the case of ST, one mailbox is used to access the analogue baseband,
> there is no particular atomic requirement for that except during
> register dump called form panic context)
>
> For the 3rd point I agree with you, it should be considered as atomic
> and up to driver to schedule a sleepable task...
>
> I have an internal implementation in which each mailbox is declared
> either atomic or blocking.
> Depending on this parameter, the behavior of the mbox_send_mbox is
> changed...
>
I am only talking about the nature of the API, which I think should as
fast as possible by providing atomic functions (except
mailbox_get/put).
If a controller needs to do sleep-prone tasks, let it schedule those
from API's atomic callbacks.
If a client needs to blink leds after receiving/sending a message, let
it schedule a work for that from API's atomic callback.
Majority of scenarios will simply be a client populating a structure
and pass it onto the controller driver which only need to program a
few registers to put the message on the h/w link.


>>   Consider this example for better understanding, I must send a
>> particular packet to the remote before I could, say, shutdown
>> properly. The client calls mailbox_msg_send which queues the packet
>> because the h/w was busy. Since the api does not inform the client
>> about packet transmission, the client does not know when to shutdown
>> (the packet may have been sent instantly or it may lie on the queue
>> for a long time).
>>   How do you fix this without tx_done callback method?
>>
> This mechanism was preserved to be compatibility with TI DSP bridge. But
> my initial proposal was to remove it, simply because today all mailbox
> customers consider that message is sent or not after calling
> mbox_send_message function.
>
Yeah, I too sense a lot of badness is inherited.

>>>
>>> The size parameter would still be needed. Depending on the h/w, it can be just an u32 or a series of bytes, and even in the latter case, it is not guaranteed that all messages transmitted will occupy the entire h/w shared memory data packet. I can see the current header field getting absorbed into the opaque void * structure for the ST mailbox driver. The size and ptr together provide a very generic message format.
>>>
>> I am not sure about it. The API has no purpose for the .size (it's
>> between the controller and the client driver).
>> Controllers that could send variable length packets could define the
>> packets format for clients as
>>   struct foo_packet {
>>           int size;
>>           .......
>>   }
>> and exchange as typecasted to void* via the API. And this is just one
>> way of doing it.
>> The point being, the API should only pass pointer to packet info
>> between controller and client drivers.
> No today the size is used to store the message in the fifo and that's
> done by the framework.
> If you decide to remove the fifo mechanism inherit for TI legacy, in
> that case yes the mailbox framework doesn't matter about message format
> and size.
>
Of course I desperately want to get rid of the TI legacy stuff in the
common api, that will simply not work on many platforms. My 'shutdown'
example above may be real for some platform.

>>
> I'm really happy to see some new mailbox framework clients coming with
> new requirements to improve the solution.
> Just for the story, mailbox framework topic was addressed during Linaro
> Copenhagen Connect and at the time being it was decided to reuse TI
> solution in a first time and then to improve it...
>
At the time my idea of mailbox was simply a tin box with a lock and a slit.
On a serious note, someone very important pointed out that things
discussed during events like Linaro shouldn't be taken as the
consensus of the community. "We" should have put it up for discussion
on the mailing lists.

>> Maybe it will help if I know what you guys mean by "shared mem" or an
>> "hw fifo" mailbox?
>>
> Hw fifo means that you what a HW IP which contains x bytes fifo.
> When you write one byte in the fifo, an interrupt is automatically
> raised and caught by coprocessor which should read fifo on its side to
> empty it. In that case, Tx RTR is mandatory.
> Shared mem, means that mailbox is made up of a cross interrupt + a
> status register (may be optional) + a shared memory in which messages
> are exchanged.
> After writing message in shared mem, CPU has to raise the cross
> interrupt itself. In case flow control is less important...
>
Well, I have a yet another type of controller where the IRQ status
register provides the data to be exchanged. Anyways I still maintain
that all three(or any more) controller types need not bother the API
with the size of message. The size should be a mandatory member of the
controller specific packet format that will be used by the client to
exchange data with it.

Regards,
-Jassi
