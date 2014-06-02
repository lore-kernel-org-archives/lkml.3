Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaFBPPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:15:01 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44133 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaFBPO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:14:59 -0400
Date: Mon, 2 Jun 2014 11:14:54 -0400
From: Matt Porter <mporter@linaro.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20140602151454.GK32082@beef>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
 <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
 <7978295.UBGxYvcnvH@wuerfel>
 <CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
 <20140529154348.GH32082@beef>
 <CABb+yY2PiGpqy2uevCFexAKeS4aZxJxZHEDJTRN1SW6VVjBzGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABb+yY2PiGpqy2uevCFexAKeS4aZxJxZHEDJTRN1SW6VVjBzGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:01:55AM +0530, Jassi Brar wrote:
> On Thu, May 29, 2014 at 9:13 PM, Matt Porter <mporter@linaro.org> wrote:
> > On Fri, May 16, 2014 at 07:03:25PM +0530, Jassi Brar wrote:
> >> On 15 May 2014 19:57, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Thursday 15 May 2014 11:41:00 Jassi Brar wrote:
> >
> > ...
> >
> >> >> +struct mbox_controller {
> >> >> +     struct device *dev;
> >> >> +     struct mbox_chan_ops *ops;
> >> >> +     struct mbox_chan *chans;
> >> >> +     int num_chans;
> >> >> +     bool txdone_irq;
> >> >> +     bool txdone_poll;
> >> >> +     unsigned txpoll_period;
> >> >> +     struct mbox_chan *(*of_xlate)(struct mbox_controller *mbox,
> >> >> +                                     const struct of_phandle_args *sp);
> >> >> +     /*
> >> >> +      * If the controller supports only TXDONE_BY_POLL,
> >> >> +      * this timer polls all the links for txdone.
> >> >> +      */
> >> >> +     struct timer_list poll;
> >> >> +     unsigned period;
> >> >> +     /* Hook to add to the global controller list */
> >> >> +     struct list_head node;
> >> >> +} __aligned(32);
> >> >
> >> > What is the __aligned(32) for?
> >> >
> >> Attempt to align access to mailbox?
> >>
> >> I am still open to opinion about whether the mailbox ownership should
> >> be exclusive or shared among clients. Need to handle async messages
> >> from remote is one reason one might want more than one client to own a
> >> channel. Allowing for RX via notifiers might be one option but that
> >> breaks semantics of 'ownership' of a mailbox channel.
> >
> > This is the case we have on a new family of Broadcom SoCs. One mailbox
> > channel is the "system" channel and is shared amongst many clients for
> > reception of unsolicited events from the coprocessor. The same channel
> > is also used commonly in drivers for debug/inspection of the M0 state.
> > Functionality for clock, pmu, pinmux, and cpu idle/suspend is implemented
> > via IPC with the M0 so all of those drivers need to share one mailbox.
> >
> OK, so you have a single mailbox channel used for communication with
> the remote master.

Yes, specifically, single mailbox channel is shared by many clients
for interrupt events.

> 
> > There's a lot of common code necessary to construct/parse IPCs for
> > each of the drivers. I suppose this IPC driver/api could be the
> > sole owner of that system channel. However, we'd need to develop some
> > binding to represent IPC resources that devices need to operate. Coming
> > into this late...I wonder if I missed something about where these vendor
> > specific IPC layers should live and how, if it makes sense, they should
> > be represented in DT. In our case, the IPC is an integral part of the
> > hardware as it's loaded from ROM.
> >
> Like other platforms, the IPC protocol is going to be very specific to
> Broadcom, even if the mailbox controller is some popular third party
> IP like PL320. So you/Broadcom have to implement parser code for IPC
> (client) above the mailbox common api and the controller driver below
> it. Any resource/feature specific to your client and your controller
> should be passed via some Broadcom specific DT bindings. The common
> mailbox api DT bindings provide only for channel-client mapping.

Agreed.

>  Being more specific to your platform, I think you need some server
> code (mailbox's client) that every driver (like clock, pmu, pinmux
> etc) registers with to send messages to remote and receive commands
> from remote ... perhaps by registering some filter to sort out
> messages for each driver.

Right, and here's where you hit on the problem. This server you mention
is not a piece of hardware, it would be a software construct. As such, it
doesn't fit into the DT binding as it exists. It's probably best to
illustrate in DT syntax.

If I were to represent the hardware relationship in the DT binding now
it would look like this:

---
cpm: mailbox@deadbeef {
        compatible = "brcm,bcm-cpm-mailbox";
        reg = <...>;
        #mbox-cells <1>;
        interrupts = <...>;
};

/* clock complex */
ccu {
        compatible = "brcm,bcm-foo-ccu";
        mbox = <&cpm CPM_SYSTEM_CHANNEL>;
	mbox-names = "system";
	/* leaving out other mailboxes for brevity */
        #clock-cells <1>;
        clock-output-names = "bar",
                             "baz";
};

pmu {
        compatible = "brcm,bcm-foo-pmu"
        mbox = <&cpm CPM_SYSTEM_CHANNEL>;
	mbox-names = "system";
};

pinmux {
	compatible = "brcm,bcm-foo-pinctrl";
        mbox = <&cpm CPM_SYSTEM_CHANNEL>;
	mbox-names = "system";
};
---

What we would need to do is completely ignore this information in each
of the of the client drivers associated with the clock, pmu, and pinmux
devices. This IPC server would need to be instantiated and get the
mailbox information from some source. mbox_request_channel() only works
when the client has an of_node with the mbox-names property present.
Let's say we follow this model and represent it in DT:

--
cpm: mailbox@deadbeef {
        compatible = "brcm,bcm-cpm-mailbox";
        reg = <...>;
        #mbox-cells <1>;
        interrupts = <...>;
};

cpm_ipc {
	compatible = "brcm,bcm-cpm-ipc";
	mbox = <&cpm CPM_SYSTEM_CHANNEL>;
	mbox-names = "system";
	/* leaving out other mailboxes for brevity */
};
---

This would allow an ipc driver to exclusively own this system channel,
but now we've invented a binding that doesn't reflect the hardware at
all. It's describing software so I don't believe the DT maintainers will
allow this type of construct.

One possibly is to bring back string-based channel matching, and allow
the controller node to optionally handle the mbox-names property. As in:

---
cpm: mailbox@deadbeef {
        compatible = "brcm,bcm-cpm-mailbox";
        reg = <...>;
        interrupts = <...>;
        #mbox-cells <1>;
	mbox-names = "foo",
		     "bar",
		     "baz",
		     "system";
};
---

and allow a non-DT based mbox_request_channel() path using string
matching. I know it's icky and the reasons for dropping that in the
first place but I'm just throwing out one option that would work here.

-Matt
