Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaBKAWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:22:08 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5184 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbaBKAWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:22:06 -0500
Date: Mon, 10 Feb 2014 16:23:48 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Rob Herring <robherring2@gmail.com>
CC: Josh Cartwright <joshc@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20140211002347.GW1706@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
 <1391820619-25487-2-git-send-email-courtney.cavin@sonymobile.com>
 <4706525.lB7VmvWQMJ@wuerfel>
 <CAL_JsqKa6nyPOa0M67svUR20Y3JNZcFhsTZE=ooV-eg6_ZBaMw@mail.gmail.com>
 <20140210190934.GA841@joshc.qualcomm.com>
 <20140210195914.GU1706@sonymobile.com>
 <CAL_JsqK0YoVu0BfKSUfBQGoriCa4z-teXUQe6RPpjM2KKpeMAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAL_JsqK0YoVu0BfKSUfBQGoriCa4z-teXUQe6RPpjM2KKpeMAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 09:45:07PM +0100, Rob Herring wrote:
> On Mon, Feb 10, 2014 at 1:59 PM, Courtney Cavin
> <courtney.cavin@sonymobile.com> wrote:
> > On Mon, Feb 10, 2014 at 08:09:34PM +0100, Josh Cartwright wrote:
> >> On Mon, Feb 10, 2014 at 11:52:05AM -0600, Rob Herring wrote:
> >> > On Mon, Feb 10, 2014 at 8:11 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > > On Friday 07 February 2014 16:50:14 Courtney Cavin wrote:
> >> [..]
> >> > >> +int mbox_channel_notify(struct mbox_channel *chan,
> >> > >> +             const void *data, unsigned int len)
> >> > >> +{
> >> > >> +     return atomic_notifier_call_chain(&chan->notifier, len, (void *)data);
> >> > >> +}
> >> > >> +EXPORT_SYMBOL(mbox_channel_notify);
> >> > >
> >> > > What is the reason to use a notifier chain here? Isn't a simple
> >> > > callback function pointer enough? I would expect that each mailbox
> >> > > can have exactly one consumer, not multiple ones.
> >> >
> >> > It probably can be a callback, but there can be multiple consumers. It
> >> > was only a notifier on the pl320 as there was no framework at the time
> >> > and to avoid creating custom interfaces between drivers. On highbank
> >> > for example, we can asynchronously receive the events for temperature
> >> > change, power off, and reset. So either there needs to be an event
> >> > demux somewhere or callbacks have to return whether they handled an
> >> > event or not.
> >>
> >> I'm not familiar with highbank IPC, but with these requirements should
> >> the mailbox core even bother with asynchronous notifier chain?  It
> >> sounds like a better fit might be for the mailbox core to implement a
> >> proper adapter-specific irqdomain and used a chained irq handler to
> >> demux (or have consumers request with IRQF_SHARED in the shared case).
> >
> > Although modeling this using irqdomains makes sense for the notification
> > bit, and would probably suit most adapters, there's the issue of data
> > being passed around which doesn't quite fit.  "Ok, I have mail... where
> > is it?"  Did you have something in mind for that?
> >
> > Frankly, I don't see the notifier chain as being extraneous or
> > over-complicated here core-wise or implementation-wise, and unless I
> > understand Rob incorrectly, should suit the existing use-cases.  Am I
> > missing something?
> 
> Well, I think notifiers are not liked very much. I don't know that irq
> handlers would be the right answer either as these are not h/w events
> really and we may not want handlers to run in irq context. I would say
> a callback similar to how the dma engine framework works is the right
> answer. On the send side, you may want to have completion callbacks as
> well.

While I'm not sure the dislike of notifiers entirely justifies not using
them here, where they seem to make sense, I can understand that they
might not fully implement what we need to expose.

Regarding handlers running in IRQ context: currently the API is designed
to do just that.  From the use-cases I've found, most message handlers
simply queue something to happen at a later point.  This is logical, as
the callback will be async, so you'll need to swap contexts or add locks
in your consumer anyway.

The dma engine is large and confused, so I'm not sure entirely which
part you are refering to.  I've looked at having async completion going
both ways, but what I see every time is code complication in both the
adapter and in the consumers in the simple use-case.  It doesn't really
make sense to make an API which makes things so generic that it becomes
hard to use.  What I tried to follow here when designing the API was
what I saw in the actual implementations, not what was future-proof:
	- Message receive callbacks may be called from IRQ context
	- Message send implementations may sleep

I think that these allowances enable the simple use-case to be very easy
to write, and the more complex use-cases still possible--albiet
sometimes at a higher level.

What I can do is try to alleviate implementation efforts of future
requirements--as honestly, we can't really say exactly what they are--by
turning the messages into structs themselves, so at a later point flags,
ack callbacks, and rainbows can be added.  I can then stop using
notifiers, and re-invent that functionality with a mbox_ prefix.

Comments?

-Courtney
