Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbaE2Pny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:43:54 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:46139 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbaE2Pnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:43:53 -0400
Date: Thu, 29 May 2014 11:43:48 -0400
From: Matt Porter <mporter@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jassisinghbrar@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
Message-ID: <20140529154348.GH32082@beef>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
 <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
 <7978295.UBGxYvcnvH@wuerfel>
 <CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 07:03:25PM +0530, Jassi Brar wrote:
> On 15 May 2014 19:57, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 15 May 2014 11:41:00 Jassi Brar wrote:

...

> >> +struct mbox_controller {
> >> +     struct device *dev;
> >> +     struct mbox_chan_ops *ops;
> >> +     struct mbox_chan *chans;
> >> +     int num_chans;
> >> +     bool txdone_irq;
> >> +     bool txdone_poll;
> >> +     unsigned txpoll_period;
> >> +     struct mbox_chan *(*of_xlate)(struct mbox_controller *mbox,
> >> +                                     const struct of_phandle_args *sp);
> >> +     /*
> >> +      * If the controller supports only TXDONE_BY_POLL,
> >> +      * this timer polls all the links for txdone.
> >> +      */
> >> +     struct timer_list poll;
> >> +     unsigned period;
> >> +     /* Hook to add to the global controller list */
> >> +     struct list_head node;
> >> +} __aligned(32);
> >
> > What is the __aligned(32) for?
> >
> Attempt to align access to mailbox?
> 
> I am still open to opinion about whether the mailbox ownership should
> be exclusive or shared among clients. Need to handle async messages
> from remote is one reason one might want more than one client to own a
> channel. Allowing for RX via notifiers might be one option but that
> breaks semantics of 'ownership' of a mailbox channel.

This is the case we have on a new family of Broadcom SoCs. One mailbox
channel is the "system" channel and is shared amongst many clients for
reception of unsolicited events from the coprocessor. The same channel
is also used commonly in drivers for debug/inspection of the M0 state.
Functionality for clock, pmu, pinmux, and cpu idle/suspend is implemented
via IPC with the M0 so all of those drivers need to share one mailbox.

There's a lot of common code necessary to construct/parse IPCs for
each of the drivers. I suppose this IPC driver/api could be the
sole owner of that system channel. However, we'd need to develop some
binding to represent IPC resources that devices need to operate. Coming
into this late...I wonder if I missed something about where these vendor
specific IPC layers should live and how, if it makes sense, they should
be represented in DT. In our case, the IPC is an integral part of the
hardware as it's loaded from ROM.

-Matt
