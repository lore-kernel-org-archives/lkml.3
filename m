Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaFBWEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:04:10 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47711 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaFBWEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:04:07 -0400
Date: Mon, 2 Jun 2014 18:04:02 -0400
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
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Devicetree List <devicetree@vger.kernel.org>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
Message-ID: <20140602220402.GU32082@beef>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
 <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
 <7978295.UBGxYvcnvH@wuerfel>
 <CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
 <20140529154348.GH32082@beef>
 <CABb+yY2PiGpqy2uevCFexAKeS4aZxJxZHEDJTRN1SW6VVjBzGQ@mail.gmail.com>
 <20140602151454.GK32082@beef>
 <CABb+yY3ZYqtT+R0PwZDtpW0O0SsbxTyiYmXaseZHoj4Nr6UBPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABb+yY3ZYqtT+R0PwZDtpW0O0SsbxTyiYmXaseZHoj4Nr6UBPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding devicetree list]

On Mon, Jun 02, 2014 at 10:41:44PM +0530, Jassi Brar wrote:
> On Mon, Jun 2, 2014 at 8:44 PM, Matt Porter <mporter@linaro.org> wrote:
> > On Fri, May 30, 2014 at 11:01:55AM +0530, Jassi Brar wrote:
> >
> >>  Being more specific to your platform, I think you need some server
> >> code (mailbox's client) that every driver (like clock, pmu, pinmux
> >> etc) registers with to send messages to remote and receive commands
> >> from remote ... perhaps by registering some filter to sort out
> >> messages for each driver.
> >
> > Right, and here's where you hit on the problem. This server you mention
> > is not a piece of hardware, it would be a software construct. As such, it
> > doesn't fit into the DT binding as it exists. It's probably best to
> > illustrate in DT syntax.
> >
> > If I were to represent the hardware relationship in the DT binding now
> > it would look like this:
> >
> > ---
> > cpm: mailbox@deadbeef {
> >         compatible = "brcm,bcm-cpm-mailbox";
> >         reg = <...>;
> >         #mbox-cells <1>;
> >         interrupts = <...>;
> > };
> >
> > /* clock complex */
> > ccu {
> >         compatible = "brcm,bcm-foo-ccu";
> >         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
> >         mbox-names = "system";
> >         /* leaving out other mailboxes for brevity */
> >         #clock-cells <1>;
> >         clock-output-names = "bar",
> >                              "baz";
> > };
> >
> > pmu {
> >         compatible = "brcm,bcm-foo-pmu"
> >         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
> >         mbox-names = "system";
> > };
> >
> > pinmux {
> >         compatible = "brcm,bcm-foo-pinctrl";
> >         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
> >         mbox-names = "system";
> > };
> > ---
> Yeah, I too don't think its a good idea.
> 
> 
> > What we would need to do is completely ignore this information in each
> > of the of the client drivers associated with the clock, pmu, and pinmux
> > devices. This IPC server would need to be instantiated and get the
> > mailbox information from some source. mbox_request_channel() only works
> > when the client has an of_node with the mbox-names property present.
> > Let's say we follow this model and represent it in DT:
> >
> > --
> > cpm: mailbox@deadbeef {
> >         compatible = "brcm,bcm-cpm-mailbox";
> >         reg = <...>;
> >         #mbox-cells <1>;
> >         interrupts = <...>;
> > };
> >
> > cpm_ipc {
> >         compatible = "brcm,bcm-cpm-ipc";
> >         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
> >         mbox-names = "system";
> >         /* leaving out other mailboxes for brevity */
> > };
> > ---
> >
> > This would allow an ipc driver to exclusively own this system channel,
> > but now we've invented a binding that doesn't reflect the hardware at
> > all. It's describing software so I don't believe the DT maintainers will
> > allow this type of construct.
> >
> Must the server node specify MMIO and an IRQ, to be acceptable? Like ...

My bad, that was a cut and paste typo..I intended to remove those
properties as you do below.

> 
> cpm_ipc : cpm@deadbeef {
>          compatible = "brcm,bcm-cpm-ipc";
>        /*  reg = <0xdeadbeef 0x100>; */
>        /*  interrupts = <0 123 4>;  */
>          mbox = <&cpm CPM_SYSTEM_CHANNEL>;
>          mbox-names = "system";
> };

Correct, this should have been:

cpm_ipc {
	compatible = "brcm,bcm-cpm-ipc";
	mbox = <&cpm CPM_SYSTEM_CHANNEL>;
	mbox-names = "system";
};

> cpm_ipc already specifies a hardware resource (mbox) that its driver
> needs, I think that should be enough reason. If it were some purely
> soft property for the driver like
>       mode = "poll";  //or "irq"
> then the node wouldn't be justified because that is the job of a
> build-time config or run-time module option.

Hrm, this is where I'd like to hear from the DT maintainers since we
have to live with this generic binding. If they are ok with us creating
bindings for a virtual device that exists only to match with our ipc
driver then it will work. I'm not aware of other similar examples though.

-Matt
