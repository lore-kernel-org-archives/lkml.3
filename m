Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3D0Evu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 00:51:50 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61630 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3D0Evt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 00:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <517B242D.7040902@ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
	<CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
	<CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
	<CAJe_ZhehnniZd730jjiOLrHozq8TOJZgFYLqUe4KqgBiQEu8PA@mail.gmail.com>
	<51779304.4040003@st.com>
	<CAJe_ZhdZv5LW6kdwyPtJe69mfW6t=WQ4OJnG2H4sUhibattN2A@mail.gmail.com>
	<517867E1.7050301@ti.com>
	<CAJe_ZhfDZzq+DzA9XDF3PWFUmwcZnDy-mhE4hLNHmf+V4GhOxw@mail.gmail.com>
	<5179AE2F.3040403@ti.com>
	<CAJe_Zhf4miUm4yTyuwc56kpD8Mu4=vsmX4wdQkFDT96JbKR=MQ@mail.gmail.com>
	<517B242D.7040902@ti.com>
Date: Sat, 27 Apr 2013 10:21:48 +0530
Message-ID: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Loic PALLARDY <loic.pallardy@st.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

>> On 26 April 2013 03:59, Suman Anna <s-anna@ti.com> wrote:
>>> On 04/25/2013 12:20 AM, Jassi Brar wrote:

>> I never said no-buffering and I never said buffering should be in
>> controller drivers. In fact I don't remember ever objecting to how
>> buffering is done in TI's framework.
>> A controller could service only 1 request at a time so lets give it
>> just 1 at a time. Let the API handle the complexity of buffering.
>>
>
> Alright, guess this got lost in translation :). I interpreted based on
> the fact that you wanted to get rid of the size field from the
> mailbox_msg definition. Do you have a different mechanism in mind for
> the buffering compared to the present one?
>
Sure, a very simple but efficient one. I had started on pseudo code
implementation the day I first replied, but now I have real code with
the PL320 controller and the Highbank client converted to the API. All
that I say features in the new design. Polishing and documentation
will take just a few hours more. You could see end to end what I have
been talking about.


>
> OK, I didn't think of a no RTR interrupt-based controller. I would thing
> that such a controller is very rudimentary. I wonder if there are any
> controllers like this out there.
>
One of my controllers is like that :)

>>
>> BTW, TI's RX mechanism too seems broken for common API. Receiving
>> every few bytes via 'notify' mechanism is very inefficient. Imagine a
>> platform with no shared memory between co-processors and the local
>> wants to diagnose the remote by asking critical data at least KBs in
>> size.
>
> No shared memory between co-processors and a relatively slow wire
> transport is a bad architecture design to begin with.
>
IMHO it's only about private memory. Even if the controller transfers,
say, 10bytes/interrupt there could always be a requirement to read
some 1MB region of remote's private memory. And the same logic implies
that our TX too should be as fast as possible - the remote might need
its 1MB firmware over the link. So let us just try to serve all
designs rather than evaluate them :)


>>  So when API has nothing to do with received packet and the controller
>> has to get rid of it asap so as to be able to receive the next, IMHO
>> there should be short-circuit from controller to client via the API.
>> No delay, no buffering of RX.
>
> The current TI design is based on the fact that we can get multiple
> messages on a single interrupt due to the h/w fifo and the driver takes
> care of the bottom-half. Leaving it to the client is putting a lot of
> faith in the client and doesn't scale to multiple clients. The client
> would have to perform mostly the same as the driver is doing - so this
> goes back to the base discussion point that we have - which is the lack
> of support for atomic_context receivers in the current code. I perceive
> this as an attribute of the controller/mailbox device itself rather than
> the client.
>
Sorry, I don't understand the concern about faith.
If the controller h/w absolutely can not tell the remote(sender) of a
received packet (as seems to be your case), its driver shouldn't even
try to demux the received messages. The client driver must know which
remotes could send it a message and how to discern them on the
platform. Some 'server' RX client is needed here.
If the controller could indeed map received packet onto remotes, then
ideally the controller driver should declare one (RX only) channel for
each such remote and demux packets onto them.
In either case, 'notify' mechanism is not necessary.


> I agree that all remote-ends will not
> be able to cope up intermixed requests, but isn't this again a
> controller architecture dependent?
>
I think it's more about remote's protocol implementation than
controller's architecture.
If tomorrow TI's remote firmware introduces a new set of critical
commands that may arrive only in a particular sequence, you'll find
yourself sharing a ride on our dinghy :)
And Andy already explained where we come from.

Regards,
-Jassi
