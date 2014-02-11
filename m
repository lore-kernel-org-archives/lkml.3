Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaBKIfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:35:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKIf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:35:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "s-anna@ti.com" <s-anna@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Tony Lindgren <tony@atomide.com>,
        "omar.ramirez@copitl.com" <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/6] mailbox: add core framework
Date: Tue, 11 Feb 2014 09:35:01 +0100
Message-ID: <1765844.1kjKsO2Rzo@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140211002347.GW1706@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com> <CAL_JsqK0YoVu0BfKSUfBQGoriCa4z-teXUQe6RPpjM2KKpeMAw@mail.gmail.com> <20140211002347.GW1706@sonymobile.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6AVTd3frE4haL1UMG193BoSbKt0ezbk39XzYCUEHQEc
 VlRmXKdZTlI7pGZHvKuwZqO9MwGekq1oZjHtRohJi7eAtPTG5M
 uYfZnBz4E2rM/fecEcsPGzWsILf3rzFvCGSgni4KHWtp/wJS27
 fIDlHxzY/1FyIfv5JDsHQ+/lOrdIf9twcPBgLIDD0Z0RLwzb0n
 KXiUS1jh7kDx0I9pmW2ydt3zwBzhehnGR6bmpgojNU4VLO4P5+
 IPElEFpvBdXB8vOS4SXI9E6wX56ZaGeBqNEu7l4zgNVVehEeVv
 +uD+NrfyTeRv0MOoFQt/FaQw1o16Rh99RsYPdvjzw5a2apqMN0
 QXnvoXKcqlFyYQ2Qexzk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 February 2014 16:23:48 Courtney Cavin wrote:

> While I'm not sure the dislike of notifiers entirely justifies not using
> them here, where they seem to make sense, I can understand that they
> might not fully implement what we need to expose.

I think we need to look at a few more examples of things that people
want to with the framework to come up with a good interface. It's
possible that we end up with multiple alternative notification
methods, but it would be good to come up with one that works well
for everyone.

> Regarding handlers running in IRQ context: currently the API is designed
> to do just that.  From the use-cases I've found, most message handlers
> simply queue something to happen at a later point.  This is logical, as
> the callback will be async, so you'll need to swap contexts or add locks
> in your consumer anyway.

Right. You may also have some handlers that need to run with extreme
latency constraints, so we need at least the option of getting the
callback from hardirq context, or possibly from softirq/tasklet
as in the dmaengine case.

> The dma engine is large and confused, so I'm not sure entirely which
> part you are refering to.  I've looked at having async completion going
> both ways, but what I see every time is code complication in both the
> adapter and in the consumers in the simple use-case.  It doesn't really
> make sense to make an API which makes things so generic that it becomes
> hard to use.  What I tried to follow here when designing the API was
> what I saw in the actual implementations, not what was future-proof:
> 	- Message receive callbacks may be called from IRQ context
> 	- Message send implementations may sleep

I can imagine cases where you want to send messages from softirq
context, or from the same context in which you received the incoming
mail, so it would be good to have the API flexible enough to deal
with that. As a first step, always allowing send to sleep seems
fine. Alternatively, we could have a 'sync' flag in the send
API, to choose between "arrange this message to be sent out as
soon as possible, but don't sleep" and "send this message and
make sure it has arrived at the other end" as you do now.

> What I can do is try to alleviate implementation efforts of future
> requirements--as honestly, we can't really say exactly what they are--by
> turning the messages into structs themselves, so at a later point flags,
> ack callbacks, and rainbows can be added.  I can then stop using
> notifiers, and re-invent that functionality with a mbox_ prefix.

I don't think there is a point in reimplementing notifiers under a
different name. The question is rather how we want to deal with
the 'multiple listener' case. If this case is the exception rather
than the rule, I'd prefer making the callback API handle only
single listeners and adding higher-level abstractions for the
cases where we do need multiple listeners, but it really depends
on what people need.

	Arnd
