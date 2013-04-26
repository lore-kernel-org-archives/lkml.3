Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab3DZDqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 23:46:05 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60364 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758957Ab3DZDqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 23:46:03 -0400
MIME-Version: 1.0
In-Reply-To: <5179AE2F.3040403@ti.com>
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
Date: Fri, 26 Apr 2013 09:16:02 +0530
Message-ID: <CAJe_Zhf4miUm4yTyuwc56kpD8Mu4=vsmX4wdQkFDT96JbKR=MQ@mail.gmail.com>
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

On 26 April 2013 03:59, Suman Anna <s-anna@ti.com> wrote:
> On 04/25/2013 12:20 AM, Jassi Brar wrote:
> tranmitting right away. OK, I thought you didn't want buffering, if that
> is not the case, then the buffering should be within the main driver
> code, like it is now, but configurable based on the controller or
> mailbox properties. If it is present in individual controller drivers,
> then we would be duplicating stuff. Are you envisioning that this be
> left to the individual controllers?
>
Please don't accuse me of such bad visions :)
I never said no-buffering and I never said buffering should be in
controller drivers. In fact I don't remember ever objecting to how
buffering is done in TI's framework.
A controller could service only 1 request at a time so lets give it
just 1 at a time. Let the API handle the complexity of buffering.

>> I am afraid you are confusing the meaning of 'atomic context' here.
>> atomic context doesn't mean instant transmission of data, but that the
>> API calls could be made from even atomic context and that the client &
>> controller can't sleep in callbacks from the API. So it's not moot.
>
> I understood the atomic context, and the question is about the behavior
> of the '.tx_done' callback when sending from atomic context. Is there
> such a usecase/need for you in that you want to send a response back
> from an atomic context, yet get a callback?
>
Let me get in detail...
The TX-Wheel has to tick. Someone has to tell the framework that the
last TX was consumed by the remote and now it's time to submit the
next TX (RX will always be driven by the controller's IRQ so it's
straight).
If the controller h/w gets some interrupt indicating
Remote-RTR/TX-Done then the ticker is driven by controller's TX-IRQ
handler. Otherwise, if the controller does sense RTR but not report
(by reading status in some register but no irq), then API has to poll
it periodically and move the ticker. If the controller can neither
report nor sense RTR, the client/protocol driver must run the ticker
(usually upon receiving some ACK packet on the RX channel).
This TX ticker should be callable from atomic context (controller's
IRQ handler) and calls into callback of the client. It is desirable
that the client be able to submit yet another TX request from the
callback. That way the client can avoid having to schedule work from
the callback if the TX doesn't involve any sleepable task. The scheme
is working very well in DMA-Engine stack.

BTW, TI's RX mechanism too seems broken for common API. Receiving
every few bytes via 'notify' mechanism is very inefficient. Imagine a
platform with no shared memory between co-processors and the local
wants to diagnose the remote by asking critical data at least KBs in
size.
 So when API has nothing to do with received packet and the controller
has to get rid of it asap so as to be able to receive the next, IMHO
there should be short-circuit from controller to client via the API.
No delay, no buffering of RX.


>> It's the controller driver that actually puts the data on the bus. So
>> only it should define the format in which it accepts data from the
>> clients. Every client should simply populate the packet structure
>> defined in  my_lovely_controller.h and pass on the struct pointer to
>> the controller driver via API.
>> No negotiations for the driver seat among passengers :)
>
> OK, I was trying to avoid including my_lovely_controller.h and only
> include the standard .h file as a client user, the client would anyway
> need to have the intrinsic knowledge of the packet structure.
>
Not including my_controller.h doesn't make things standard.
As we know, the client anyway has to have intrinsic knowledge of the
packet structure(which is dictated by the controller), so not
including my_controller.h will only confuse people as to where the
packet info came from?

>>>
>> I think the mailbox should be exclusively held by a client. That makes
>> many things simpler. Also remote firmwares won't be always robust
>> enough to handle commands from different subsystems intermixed. The
>> API only has to make sure the mailbox_get/put operations are very
>> thin.
>
> This might be the case for specific remotes where we expect only one
> client driver to be responsible for talking to it, but for generic
> offloading, you do not want to have this restriction. You do not want
> peer clients to go through a single main client, as the latencies or the
> infrastructure imposed by the main client may not be suitable for the
> other clients. The stricter usecase here would be the shareable mailbox,
> and if it is exclusive, as dictated by a controller or device property,
> then so be it and things would get simplified for that controller/device.
>
Shared Vs Exclusive had been the dilemma of DMAEngine too.
If the controller has physical channels at least as many as clients,
exclusivity is no problem.
Sharing is desirable when the controller has to serve clients more
than its physical channels. We solve that by having the controller
declare exclusive virtual channels and internally scheduling the
requests onto physical channels.
 And as Andy pointed out, some remote-ends may not cope with requests
coming from different subsystems intermixed.

Regards,
-Jassi
