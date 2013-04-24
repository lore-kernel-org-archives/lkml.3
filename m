Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3DXEjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 00:39:19 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58968 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3DXEjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 00:39:18 -0400
MIME-Version: 1.0
In-Reply-To: <37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
	<CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
	<CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
Date: Wed, 24 Apr 2013 10:09:17 +0530
Message-ID: <CAJe_ZhehnniZd730jjiOLrHozq8TOJZgFYLqUe4KqgBiQEu8PA@mail.gmail.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
From: Jassi Brar <jaswinder.singh@linaro.org>
To: "Anna, Suman" <s-anna@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Andy Green (andy.green@linaro.org)" <andy.green@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

[please limit replies to not more than 80 columns per line]

On 24 April 2013 00:50, Anna, Suman <s-anna@ti.com> wrote:

>>
>> Documentation wise, we'd need documentation for what we finally wanna have,
>> not the current implementation.
>>
>> There are also some desired features in a good API:-
>>
>> a) The API should be simple and efficient, i.e, submission of requests by clients
>> and notifications of data received by the API should be possible from atomic
>> context - most of the IPC is going to be about exchanging 'commands'. The API
>> shouldn't add to the latencies.
>
> I think we will have need for both types. It really depends on the purpose of the IPC h/w - some would be simple messaging and may not need the atomic constraints. Sure enough, atomic context is the stricter one, so we can add that. I don't see any users of it currently though.
>
IMHO the API authors should take the other POV :  if _majority_ of
clients _require_ non-atomic context, only then the API should support
non-atomic version of the calls too. Otherwise let the minority of
drivers schedule their sleepable tasks from the API's atomic
callbacks.
 The non-atomic API falls flat should just a single client comes with
very low latency requirements.

>>  For example, API should assume the IPC controller can detect and report when
>> the remote asserts Ready-To-Receive (RTR). This is when the API callbacks
>> .tx_done(mssg) on the client. If some h/w doesn't have RTR assertion interrupt,
>> the API should provide optional feature to poll the controller periodically.
>
> Some of these are already part of the mailbox ops. FWIW, I don’t see a need for a .tx_done callback, as this state can really be maintained by the driver implementation itself. The mailbox_msg_send can return an error appropriately based on whether the h/w is ready or not. The current code has the support for queuing up a certain number of messages in case the h/w is busy, but I am planning to change this to a device-based property so that they can choose if it needs that support or not.
>
Not really. The TI's api does buffer requests from a client but it
does not tell the client when the message is actually sent to the
remote over the h/w channel.

 Consider this example for better understanding, I must send a
particular packet to the remote before I could, say, shutdown
properly. The client calls mailbox_msg_send which queues the packet
because the h/w was busy. Since the api does not inform the client
about packet transmission, the client does not know when to shutdown
(the packet may have been sent instantly or it may lie on the queue
for a long time).
 How do you fix this without tx_done callback method?


>>
>> (d) The 'struct mailbox_msg' should be just an opaque void* - the client/protocol
>> driver typecasts to void* the IPC controller specific message structure. API
>> shouldn't aim the impossible of providing a generic message format.
>
> The size parameter would still be needed. Depending on the h/w, it can be just an u32 or a series of bytes, and even in the latter case, it is not guaranteed that all messages transmitted will occupy the entire h/w shared memory data packet. I can see the current header field getting absorbed into the opaque void * structure for the ST mailbox driver. The size and ptr together provide a very generic message format.
>
I am not sure about it. The API has no purpose for the .size (it's
between the controller and the client driver).
Controllers that could send variable length packets could define the
packets format for clients as
 struct foo_packet {
         int size;
         .......
 }
and exchange as typecasted to void* via the API. And this is just one
way of doing it.
The point being, the API should only pass pointer to packet info
between controller and client drivers.

>>
>> As you see there would be not much of the present left eventually. So I wonder
>> if should sculpt a new api out of TI's or start from scratch?
>> One of my controllers is similar to 'pl320' (which you left out converting to the
>> API). I am in process of implementing all this assuming it is OK to keep a controller
>> out of this API :)  So maybe we can collaborate on a new implementation from
>> scratch.
>
> This series missed the 3.9 merge window, and is currently slated for getting merged into 3.10. The PL320 made it into 3.9 itself (I wasn't aware of it until I saw it in mainline) and created the drivers/mailbox folder.  I would think it would be relatively straight-forward to adopt it to the mailbox API, as it has only 3 API. We should be doing incremental changes on top of this series, as most of the base API would still be the same. The current series is helping out with couple of efforts, the breaking up of the PRCMU code and on the multiplatform support for OMAP with mailbox enabled. We can definitely collaborate on the improvements. Andy Green would also be interested, as he is also looking into adopting the mailbox API.
>
I don't think it should into 3.10 just because it missed the 3.9
window, when its quality is doubted.
I am going to have to live with IPC controller code for sometime now,
so I care that I build upon a sound API. And I am more than happy to
help on a proper implementation.

Regards,
Jassi
