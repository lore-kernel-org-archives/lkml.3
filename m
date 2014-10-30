Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbaJ3Q6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:58:04 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33500 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759469AbaJ3Q6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:58:00 -0400
MIME-Version: 1.0
In-Reply-To: <20141030132239.GC19386@ulmo>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
	<1414535277-15645-3-git-send-email-abrestic@chromium.org>
	<20141029113415.GD28356@ulmo.nvidia.com>
	<CAL1qeaG2DFyfsPa2wgDqOkYTbnJ-tXoiV48AF9EaSCf1QCtOyQ@mail.gmail.com>
	<20141030132239.GC19386@ulmo>
Date: Thu, 30 Oct 2014 09:57:59 -0700
X-Google-Sender-Auth: kJkdjbU9WuX2l3MezNea-Fi2r10
Message-ID: <CAL1qeaFUKmkRGRr06bWK-yqypHCg_U1qJmUJc9p24xiDLDoaug@mail.gmail.com>
Subject: Re: [PATCH RESEND V4 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
From: Andrew Bresticker <abrestic@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 6:22 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Wed, Oct 29, 2014 at 11:02:36AM -0700, Andrew Bresticker wrote:
> [...]
>> > Maybe something like this patch would be more correct in handling
>> > this:
>> >
>> > diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
>> > index afcb430508ec..85691a7d8ca6 100644
>> > --- a/drivers/mailbox/mailbox.c
>> > +++ b/drivers/mailbox/mailbox.c
>> > @@ -117,10 +117,11 @@ static void poll_txdone(unsigned long data)
>> >                 struct mbox_chan *chan = &mbox->chans[i];
>> >
>> >                 if (chan->active_req && chan->cl) {
>> > -                       resched = true;
>> >                         txdone = chan->mbox->ops->last_tx_done(chan);
>> >                         if (txdone)
>> >                                 tx_tick(chan, 0);
>> > +                       else
>> > +                               resched = true;
>> >                 }
>> >         }
>>
>> ... but we still need to re-arm the timer if tx_tick() submits another
>> message.  Perhaps the better thing to do is to have msg_submit() arm
>> the timer.
>
> I think we need both. If the last transmission isn't done yet we still
> want to keep polling. And we also want to poll if a new message is sent
> subsequently.
>
> Perhaps it would be as easy as moving the poll handling code from
> mbox_send_message() (if (chan->txdone_method == TXDONE_BY_POLL)) into
> msg_submit()? That has the additional advantage of being able to omit
> the polling when an error happens during the mbox' .send_data().

Yes, this is exactly what I've done :).
