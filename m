Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3DWTUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:20:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42847 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018Ab3DWTUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:20:36 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "Tony Lindgren" <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Andy Green (andy.green@linaro.org)" <andy.green@linaro.org>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>
Subject: RE: [PATCHv3 00/14] drivers: mailbox: framework creation
Thread-Topic: [PATCHv3 00/14] drivers: mailbox: framework creation
Thread-Index: AQHOH5rZWZRuXv3gBEiVoUiWll2GeJjgh+uAgAIOGwCAATrpAIAAjqeg
Date: Tue, 23 Apr 2013 19:20:07 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
	<CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
 <CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
In-Reply-To: <CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3NJKh9v015368

Hi Jassi,

> 
> On Mon, Apr 22, 2013 at 9:26 PM, Anna, Suman <s-anna@ti.com> wrote:
> >>
> >> a) No documentation. Usually the header would have proper
> >> documentation of data structures and info for users of both side of the api.
> >
> > I will fix the documentation portion for 3.10. I will also add a TODO as part of the
> documentation so that it highlights the gaps and work-items.
> >
> >>
> >> b) The api is not scalable. The assumption of just one IPC controller
> >> in the platform is hardcoded.
> >
> > Yes, this is a major concern and I will be handling this in the upcoming patches .
> The current code was primarily based on moving the OMAP mailbox code and
> expanding it to support the ST DBX500 mailbox. As it is today, it doesn't scale to
> support multiple IP instances/controllers.
> >
> >>
> >> c) There seems to be no consistent design - mailbox_ops has 12 callback
> hooks.
> >> Some, save_ctx, restore_ctx, enable_irq, disable_irq are exported for
> >> no apparent reason (legacy of a legacy - OMAP), while other hooks are
> >> kept private to the api.
> >> I believe OMAP had valid reasons to make IPC clients save/restore
> >> context of the IPC controller, but I don't think that is the case in
> >> general. I2C client drivers don't save/restore context of I2C
> >> controller's, why should IPC's?  Similarly enable/disable_irq of the controller
> seem too intrusive for a client driver.
> >
> > Yep, these are exported because of the OMAP legacy TIDSPBRIDGE stack, and
> should vanish with the addition of runtime_pm support.
> >
> >>
> >> mailbox_ops.mailbox_type_t makes no sense to me. At least not without
> >> documentation, though I doubt any amount of documentation could help
> >> it - mailbox.c doesn't even read the member. Btw, isn't every mailbox
> >> a MBOX_SHARED_MEM_TYPE? A part of data passed via FIFO/REG could
> >> point to location in shared memory that might have full
> >> command/payload for the message. Or did I get the meaning of
> >> MBOX_SHARED_MEM_TYPE wrong in the absence of documentation?
> >
> > Yes, this needs to be removed, it is a carry-over from the OMAP mailbox code.
> >
> >>
> >> The api seems to worry too much about the low-level details of the
> >> IPC controller (save/restore context, enable/disable_irq and
> >> ack_irq), while it fails to provide a tight well-defined interface to client drivers.
> >>
> >> There are also some code issues, which might come as replies to
> >> respective patches.
> >
> > Thanks for the review of the patches. I will await your comments, and will
> address them as incremental patches.
> >
> So we agree
> a) Documentation is missing.
> b) mailbox_type_t, save_ctx, restore_ctx, ack_irq, enable_irq, disable_irq need
> to be removed.

The mailbox_type_t can be removed right away, but for others, we should give some time for current users to migrate before we remove it completely. 

> c) Support for more than one IPC controllers is needed.
> 
> Out of 11 exported functions, we'll be left with the 5 trivial ones
> mailbox_un/register, mailbox_get/put and mailbox_msg_send.
> mailbox_msg_send_no_irq and mailbox_msg_send_receive_no_irq are STE(?)
> specific quirky requirements, which should be possible to simulate over the
> mailbox API if designed well.

Loic can comment on the existing xxx_no_irq API. The pl320_transmit is somewhat similar to mailbox_msg_send_receive_no_irq, without the irq part.

> 
> Documentation wise, we'd need documentation for what we finally wanna have,
> not the current implementation.
> 
> There are also some desired features in a good API:-
> 
> a) The API should be simple and efficient, i.e, submission of requests by clients
> and notifications of data received by the API should be possible from atomic
> context - most of the IPC is going to be about exchanging 'commands'. The API
> shouldn't add to the latencies.

I think we will have need for both types. It really depends on the purpose of the IPC h/w - some would be simple messaging and may not need the atomic constraints. Sure enough, atomic context is the stricter one, so we can add that. I don't see any users of it currently though.

> 
> b) It would be very useful to allow submission of a new request from the
> completion callback of last one.
> 
> c) The request/free/ack_irq on behalf of the IPC controller driver should be no
> business of the API. The API design should only assume a simple but generic
> enough h/w model beneath it and provide support to h/w that doesn't have an
> expected feature.
>  For example, API should assume the IPC controller can detect and report when
> the remote asserts Ready-To-Receive (RTR). This is when the API callbacks
> .tx_done(mssg) on the client. If some h/w doesn't have RTR assertion interrupt,
> the API should provide optional feature to poll the controller periodically.

Some of these are already part of the mailbox ops. FWIW, I donâ€™t see a need for a .tx_done callback, as this state can really be maintained by the driver implementation itself. The mailbox_msg_send can return an error appropriately based on whether the h/w is ready or not. The current code has the support for queuing up a certain number of messages in case the h/w is busy, but I am planning to change this to a device-based property so that they can choose if it needs that support or not.

> 
> (d) The 'struct mailbox_msg' should be just an opaque void* - the client/protocol
> driver typecasts to void* the IPC controller specific message structure. API
> shouldn't aim the impossible of providing a generic message format.

The size parameter would still be needed. Depending on the h/w, it can be just an u32 or a series of bytes, and even in the latter case, it is not guaranteed that all messages transmitted will occupy the entire h/w shared memory data packet. I can see the current header field getting absorbed into the opaque void * structure for the ST mailbox driver. The size and ptr together provide a very generic message format.

> 
> (a) and (b) are already proved to be useful and supported by a similar API -
> DMAEngine.
> 
> As you see there would be not much of the present left eventually. So I wonder
> if should sculpt a new api out of TI's or start from scratch?
> One of my controllers is similar to 'pl320' (which you left out converting to the
> API). I am in process of implementing all this assuming it is OK to keep a controller
> out of this API :)  So maybe we can collaborate on a new implementation from
> scratch.

This series missed the 3.9 merge window, and is currently slated for getting merged into 3.10. The PL320 made it into 3.9 itself (I wasn't aware of it until I saw it in mainline) and created the drivers/mailbox folder.  I would think it would be relatively straight-forward to adopt it to the mailbox API, as it has only 3 API. We should be doing incremental changes on top of this series, as most of the base API would still be the same. The current series is helping out with couple of efforts, the breaking up of the PRCMU code and on the multiplatform support for OMAP with mailbox enabled. We can definitely collaborate on the improvements. Andy Green would also be interested, as he is also looking into adopting the mailbox API.

Regards
Suman
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
