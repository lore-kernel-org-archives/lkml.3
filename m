Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBNUPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:15:12 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11196 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbaBNUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:15:09 -0500
Date: Fri, 14 Feb 2014 12:16:52 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>
Subject: Re: [RFC 1/6] mailbox: add core framework
Message-ID: <20140214201652.GI1706@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
 <1765844.1kjKsO2Rzo@wuerfel>
 <20140212183143.GD1706@sonymobile.com>
 <201402142048.25456.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201402142048.25456.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 08:48:25PM +0100, Arnd Bergmann wrote:
> On Wednesday 12 February 2014, Courtney Cavin wrote:
> > On Tue, Feb 11, 2014 at 09:35:01AM +0100, Arnd Bergmann wrote:
> > > On Monday 10 February 2014 16:23:48 Courtney Cavin wrote:
> 
> > Then again, I think that the context management stuff is the exception as well,
> > and I think that can/should also be handled in a higher level.  Regardless, I
> > went ahead and drafted the async flags idea out anyway, so here's some
> > pseudo-code.  I also tried to shoe-horn in 'peek', and you can see how that
> > turns out.  Let me know if this is something like what you had in mind.
> 
> The async implementation looks good to me, assuming we actually need both
> sync and async operations, which I can't tell for sure.

Yea, I would like some further input on that specifically.  I have added
Linus Walleij and Jassi Brar, who have had good input on mailboxes in
the past, and somehow I missed in this series.

> For the peek operation, it wouldn't work for the ethernet case, which
> has to call it from atomic context in net_rx_action.

It wouldn't work if the mbox is not requested with MBOX_ASYNC, but
otherwise that should be fine, as it would just peek into the kfifo.
That doesn't seem like a desirable method for ethernet use-case though,
as it ends up being two extra copies.

> > 	/**
> > 	 * so this is where this lock makes things difficult, as this function
> > 	 * might_sleep(), but only really because of the lock.  Either we can
> > 	 * remove the lock and force the adapter to do its own locking
> > 	 * spinlock-style, or we can accept the sleep here, which seems a bit
> > 	 * stupid in a peek function.  Neither option is good.  Additionally,
> > 	 * there's no guarantee that the adapter doesn't operate over a bus
> > 	 * which itself might_sleep(), exacerbating the problem.
> > 	 */
> > 	mutex_lock(&mbox->adapter->lock);
> > 	rc = mbox->adapter->ops->peek_message(mbox->adapter, mbox->chan, msg);
> > 	mutex_lock(&mbox->adapter->lock);
> 
> If we decide that peek() must not sleep, any driver that operates on a
> slow bus could just always report "no data" here.

Yes indeed, or it could just not implement peek, which seems reasonable.

> Moving the locking into the mbox driver here sounds appropriate.

I don't really like doing that for the entirety of the mbox core, as it
makes the simple adapters harder to write properly.  Since peek is not
a typical use-case, perhaps we could remove the locking for just peek,
and have a Big Fat Warning in the description of how to properly
implement it?

> 	Arnd

Thanks for the input!

-Courtney
