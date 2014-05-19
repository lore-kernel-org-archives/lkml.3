Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaESNIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:08:54 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61212 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbaESNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:08:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
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
Date: Mon, 19 May 2014 15:08:36 +0200
Message-ID: <4435081.P3BKoakBJD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org> <7978295.UBGxYvcnvH@wuerfel> <CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Froa6siYKhpKBX1cxDTUG92cQeIK5D+DjvTB24IyAG/
 NZya5MSwc+ZXeBZqPhKN04rfby+QkomsYxJtfssRVcGVuTehJM
 8v9r1W8TNt+jbu+n3J+QgS9haIXNKY7eg4GfWe5ykPYq99Sftc
 pdxLDONwAOjOeXFJoHc23j2ZFzryN7OskKBWyE+POAT+igBuUs
 7Tlj8fHx2sGBvWNyi5GRZ6yXOybBZ63ImMJbIqw7lAGW+gh3QT
 Dz5H2xZZgl+S4AVaDyUheG7zmHEERMqsoprKdyAGzRQ1nb/UFi
 GSQLzLMxHuOvW/VFjPBeQOO6APTHR4+XKy8PDbpdSpVbQRINOH
 n6CrdAn18kgmFeA3WGIE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2014 19:03:25 Jassi Brar wrote:
> >> +/**
> >> + * struct mbox_controller - Controller of a class of communication chans
> >> + * @dev:             Device backing this controller
> >> + * @controller_name: Literal name of the controller.
> >> + * @ops:             Operators that work on each communication chan
> >> + * @chans:           Null terminated array of chans.
> >> + * @txdone_irq:              Indicates if the controller can report to API when
> >> + *                   the last transmitted data was read by the remote.
> >> + *                   Eg, if it has some TX ACK irq.
> >> + * @txdone_poll:     If the controller can read but not report the TX
> >> + *                   done. Ex, some register shows the TX status but
> >> + *                   no interrupt rises. Ignored if 'txdone_irq' is set.
> >> + * @txpoll_period:   If 'txdone_poll' is in effect, the API polls for
> >> + *                   last TX's status after these many millisecs
> >> + */
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

I still don't understand why it matters. This data structure is internal
to the kernel, at least I don't see anything that is accessed by the
hardware here. Note that anything that allocates a mbox_controller through
kmalloc will not get the alignment from here anyway, but will get the
default slab alignment instead (which happens to also be 32 bytes on
ARM).

> I am still open to opinion about whether the mailbox ownership should
> be exclusive or shared among clients. Need to handle async messages
> from remote is one reason one might want more than one client to own a
> channel. Allowing for RX via notifiers might be one option but that
> breaks semantics of 'ownership' of a mailbox channel.

I don't have a strong opinion on that.

>  Also, some platform might need to communicate with remote master
> during very early boot like for initializing system timers and clocks.
> The API isn't working then.

Do you have an example for a platform like that? I'd expect that normally
we can have a boot loader that sets up the system timer to work good
enough for us to get into normal driver initialization.

	Arnd
