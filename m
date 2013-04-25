Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab3DYFUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:20:21 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:55010 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3DYFUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <517867E1.7050301@ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
	<CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
	<CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
	<CAJe_ZhehnniZd730jjiOLrHozq8TOJZgFYLqUe4KqgBiQEu8PA@mail.gmail.com>
	<51779304.4040003@st.com>
	<CAJe_ZhdZv5LW6kdwyPtJe69mfW6t=WQ4OJnG2H4sUhibattN2A@mail.gmail.com>
	<517867E1.7050301@ti.com>
Date: Thu, 25 Apr 2013 10:50:18 +0530
Message-ID: <CAJe_ZhfDZzq+DzA9XDF3PWFUmwcZnDy-mhE4hLNHmf+V4GhOxw@mail.gmail.com>
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

On 25 April 2013 04:46, Suman Anna <s-anna@ti.com> wrote:
> On 04/24/2013 03:56 AM, Jassi Brar wrote:
>

> I think there are two things here - one is what the client needs to do
> upon sending/receiving a message, and the other is what the send API or
> the mailbox controller should do when a client tried to send a message
> and the controller's shared message/transport is not free (irrespective
> of the atomic or non-atomic context). The kfifos in the common driver
> code are currently solving the latter problem. The current send API
> directly uses the controller to send if it is free, and uses buffering
> only when it is busy. But, I see your point that this should should be
> the responsibility of the specific controller, or even a property of the
> specific mailbox belonging to that controller. This direction would put
> most of the onus on the specific controller drivers, and probably the
> main API would be very simple. Another factor / attribute to consider is
> that a given mailbox may be sharable or exclusive, things are simple if
> it is exclusive to a client driver.
>
I never suggested we don't use buffering. I too believe the API should
buffer requests but also that it should still do atomic callbacks. The
impact on implementation would be that the queue buffer can not grow
at runtime. But that should be fine because a reasonable size (say 10
or even 50) could be chosen and we allow submission of requests from
tx_done callback.

>
> We are talking two fundamentally different usecases/needs here,
> depending on the type of the controller. You seem to be coming from a
> usecase where the client driver needs to know when every message is
> transmitted (from an atomic context, it is a moot point since either you
> are successful or not when transmitting).
>
I am afraid you are confusing the meaning of 'atomic context' here.
atomic context doesn't mean instant transmission of data, but that the
API calls could be made from even atomic context and that the client &
controller can't sleep in callbacks from the API. So it's not moot.

> The remote
> has to ack before it can be shutdown. I would imagine that getting a
> .tx_done on a particular message is not good enough to know that the
> remote is ready for shutdown. I can imagine it to be useful where there
> is some inherent knowledge that the client needs to proceed with the
> next steps when a message is sent.
>
Of course we are not specifying how the mailbox signals are
interpreted by the remote. It should suffice just to realize that
there exists genuine requirement for a client to know when its message
was received by the remote.

> That said, we need to go with the
> stricter one.
>
Great, that we agree.

> My only concern here is that if there can be multiple
> clients for a particular mailbox/controller, then all the clients would
> have to have an agreement on the controller packet type, and the clients
> would mostly have to include the standard mailbox.h as well as a
> controller-specific header.
>
It's the controller driver that actually puts the data on the bus. So
only it should define the format in which it accepts data from the
clients. Every client should simply populate the packet structure
defined in  my_lovely_controller.h and pass on the struct pointer to
the controller driver via API.
No negotiations for the driver seat among passengers :)

> Overall, I see it coming down to following points:
> 1. Calling contexts: Atomic & non-atomic contexts, with the latter
> becoming an extension of the atomic case. I guess this mainly goes with
> the controller functional integration - whether it is used for
> non-urgent messaging or h/w controller command messages (like PM
> usecases?) where .tx_done is relevant.
>
Urgency or not is a business of the client driver. The API and the
controller driver should not delay things more than absolute
necessary.
.tx_done is not about urgency but about h/w provision of 'ack'.

> 2. Behavior of the API or controller driver if the controller transport
> is busy.
I think we both want requests buffered in the API.

> 3. Shareable/exclusive nature of a mailbox. If it is shareable, then
> duplicating the behavior between clients is not worth it, and this
> should be absorbed into the respective controller driver.
>
I think the mailbox should be exclusively held by a client. That makes
many things simpler. Also remote firmwares won't be always robust
enough to handle commands from different subsystems intermixed. The
API only has to make sure the mailbox_get/put operations are very
thin.

Regards,
Jassi
