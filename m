Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3DWEvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:51:08 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61267 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab3DWEvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:51:06 -0400
MIME-Version: 1.0
In-Reply-To: <37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
	<CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
Date: Tue, 23 Apr 2013 10:21:06 +0530
Message-ID: <CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
From: Jassi Brar <jassisinghbrar@gmail.com>
To: "Anna, Suman" <s-anna@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Andy Green (andy.green@linaro.org)" <andy.green@linaro.org>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Mon, Apr 22, 2013 at 9:26 PM, Anna, Suman <s-anna@ti.com> wrote:
>>
>> a) No documentation. Usually the header would have proper documentation of
>> data structures and info for users of both side of the api.
>
> I will fix the documentation portion for 3.10. I will also add a TODO as part of the documentation so that it highlights the gaps and work-items.
>
>>
>> b) The api is not scalable. The assumption of just one IPC controller in the
>> platform is hardcoded.
>
> Yes, this is a major concern and I will be handling this in the upcoming patches . The current code was primarily based on moving the OMAP mailbox code and expanding it to support the ST DBX500 mailbox. As it is today, it doesn't scale to support multiple IP instances/controllers.
>
>>
>> c) There seems to be no consistent design - mailbox_ops has 12 callback hooks.
>> Some, save_ctx, restore_ctx, enable_irq, disable_irq are exported for no
>> apparent reason (legacy of a legacy - OMAP), while other hooks are kept private
>> to the api.
>> I believe OMAP had valid reasons to make IPC clients save/restore context of the
>> IPC controller, but I don't think that is the case in general. I2C client drivers don't
>> save/restore context of I2C controller's, why should IPC's?  Similarly
>> enable/disable_irq of the controller seem too intrusive for a client driver.
>
> Yep, these are exported because of the OMAP legacy TIDSPBRIDGE stack, and should vanish with the addition of runtime_pm support.
>
>>
>> mailbox_ops.mailbox_type_t makes no sense to me. At least not without
>> documentation, though I doubt any amount of documentation could help it -
>> mailbox.c doesn't even read the member. Btw, isn't every mailbox a
>> MBOX_SHARED_MEM_TYPE? A part of data passed via FIFO/REG could point to
>> location in shared memory that might have full command/payload for the
>> message. Or did I get the meaning of MBOX_SHARED_MEM_TYPE wrong in the
>> absence of documentation?
>
> Yes, this needs to be removed, it is a carry-over from the OMAP mailbox code.
>
>>
>> The api seems to worry too much about the low-level details of the IPC controller
>> (save/restore context, enable/disable_irq and ack_irq), while it fails to provide a
>> tight well-defined interface to client drivers.
>>
>> There are also some code issues, which might come as replies to respective
>> patches.
>
> Thanks for the review of the patches. I will await your comments, and will address them as incremental patches.
>
So we agree
a) Documentation is missing.
b) mailbox_type_t, save_ctx, restore_ctx, ack_irq, enable_irq,
disable_irq need to be removed.
c) Support for more than one IPC controllers is needed.

Out of 11 exported functions, we'll be left with the 5 trivial ones
mailbox_un/register, mailbox_get/put and mailbox_msg_send.
mailbox_msg_send_no_irq and mailbox_msg_send_receive_no_irq are STE(?)
specific quirky requirements, which should be possible to simulate
over the mailbox API if designed well.

Documentation wise, we'd need documentation for what we finally wanna
have, not the current implementation.

There are also some desired features in a good API:-

a) The API should be simple and efficient, i.e, submission of requests
by clients and notifications of data received by the API should be
possible from atomic context - most of the IPC is going to be about
exchanging 'commands'. The API shouldn't add to the latencies.

b) It would be very useful to allow submission of a new request from
the completion callback of last one.

c) The request/free/ack_irq on behalf of the IPC controller driver
should be no business of the API. The API design should only assume a
simple but generic enough h/w model beneath it and provide support to
h/w that doesn't have an expected feature.
 For example, API should assume the IPC controller can detect and
report when the remote asserts Ready-To-Receive (RTR). This is when
the API callbacks .tx_done(mssg) on the client. If some h/w doesn't
have RTR assertion interrupt, the API should provide optional feature
to poll the controller periodically.

(d) The 'struct mailbox_msg' should be just an opaque void* - the
client/protocol driver typecasts to void* the IPC controller specific
message structure. API shouldn't aim the impossible of providing a
generic message format.

(a) and (b) are already proved to be useful and supported by a similar
API - DMAEngine.

As you see there would be not much of the present left eventually. So
I wonder if should sculpt a new api out of TI's or start from scratch?
One of my controllers is similar to 'pl320' (which you left out
converting to the API). I am in process of implementing all this
assuming it is OK to keep a controller out of this API :)  So maybe we
can collaborate on a new implementation from scratch.

Regards,
Jassi
