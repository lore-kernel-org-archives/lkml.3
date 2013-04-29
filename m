Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3D2PiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:38:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51773 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab3D2PiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:38:21 -0400
Message-ID: <517E9284.1010209@ti.com>
Date: Mon, 29 Apr 2013 10:32:20 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Green <andy.green@linaro.org>
CC: Jassi Brar <jaswinder.singh@linaro.org>,
        Loic PALLARDY <loic.pallardy@st.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
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
References: <1363145021-14339-1-git-send-email-s-anna@ti.com> <CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com> <37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com> <CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com> <37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com> <CAJe_ZhehnniZd730jjiOLrHozq8TOJZgFYLqUe4KqgBiQEu8PA@mail.gmail.com> <51779304.4040003@st.com> <CAJe_ZhdZv5LW6kdwyPtJe69mfW6t=WQ4OJnG2H4sUhibattN2A@mail.gmail.com> <517867E1.7050301@ti.com> <CAJe_ZhfDZzq+DzA9XDF3PWFUmwcZnDy-mhE4hLNHmf+V4GhOxw@mail.gmail.com> <5179AE2F.3040403@ti.com> <CAJe_Zhf4miUm4yTyuwc56kpD8Mu4=vsmX4wdQkFDT96JbKR=MQ@mail.gmail.com> <517B242D.7040902@ti.com> <517B2E55.4070708@linaro.org>
In-Reply-To: <517B2E55.4070708@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 04/26/2013 08:48 PM, Andy Green wrote:
> On 27/04/13 09:04, the mail apparently from Suman Anna included:
> 
> Hi Suman -
> 
>> Even though both the scenarios look very similar, I believe there are
>> some slight differences. All the devices belonging to a controller may
>> not be of the same type (meaning, intended towards the same remote or be
>> used interchangeably with one another). It is definitely possible if you
>> have a similar scenario to the DMA physical channels and your remote
>> rx interrupt can identify the device/channel to process. This would be
>> very much dependent on the architecture of a controller. The particular
>> example that I have in mind is s/w clients between the same set of
>> remote and host entities using the same device - the send part is anyway
>> arbitrated by the controller, and the same received message can be
>> delivered to the clients, with the clients making the decision whether
>> the packet belongs to them or not. I agree that all remote-ends will not
>> be able to cope up intermixed requests, but isn't this again a
>> controller architecture dependent?
> 
> Maybe it's helpful to describe our situation more concretely, because
> the problem is not coming from "the architecture of the [mailbox]
> controller".

Thanks for explaining the usecase. I do think that similar approaches
will become more common (TI AM335 has something similar as well - though
it is related to suspend). The right word should have been "controller
functional integration", I said it as s/w architecture or usage model.
In your case, it is clear that you need time-shared exclusive access,
whereas I am talking about simultaneous-shared usecases.

> 
> In the SoC we work on clock and subsystem power control registers, a
> serial bus, and some other assets are not directly accessible from
> Linux.  We must ask a coprocessor to operate these for us, using the
> mailbox.
> 
> So at any one time, the clock driver or voltagedomain driver for the SoC
> may want to own the mailbox and perform one or more operations over it
> synchronously, in some cases on the remote side involving transactions
> on a serial bus.  We don't want other transactions to be occurring while
> we wait for the serial bus to complete what the driver who started that
> asked for, for example.
> 
> We can cope with this by having an outer driver mediate access to the
> mailbox.  But then there are multiple sync primitives like completions
> and notifiers per operation, because your core already does this.
> 
> In short the FIFO + sync operations approach your core implements
> doesn't fit our use case.  That can be our problem, in which case we'll
> live with the outer mediation driver on top of the mailbox, or it can be
> a sign the fixed choice of FIFO + sync operations in your core did not
> quite hit the nail on the head to really model all the facets of legit
> mailbox usage.

I agree that the current code doesn't address this usage. The changes
(should have them ready in the next couple of days) I am working on
actually makes this conditional.

> 
> At least, this real scenario should be interesting to think about before
> rejecting ^^

No, I didn't reject anything, we are dealing with two contrasting
usecases dependent on the functional integration, and we have to find a
middle ground.

regards
Suman

