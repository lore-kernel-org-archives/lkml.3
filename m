Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaBVXDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:03:08 -0500
Received: from netrider.rowland.org ([192.131.102.5]:37996 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750703AbaBVXDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:03:05 -0500
Date: Sat, 22 Feb 2014 18:03:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>, Peter Hurley <peter@hurleysoftware.com>
cc: laijs@cn.fujitsu.com,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 5/9] usb: don't use PREPARE_DELAYED_WORK
In-Reply-To: <20140222153755.GG12830@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1402221752540.372-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Feb 2014, Tejun Heo wrote:

> On Sat, Feb 22, 2014 at 10:14:48AM -0500, Alan Stern wrote:
> > Is the cancel_delayed_work_sync(&hub->init_work) call in hub_quiesce()
> > going to get confused by all this?
> 
> Yeah, you can't cancel a work item which hasn't been initialzed.
> Maybe move init of the first work function there?  I don't think it
> really matters tho.
> 
> > It's worth mentioning that the only reason for the hub_init_func3 stuff
> > is, as the comment says, to avoid a long sleep (100 ms) inside a work
> > routine.  With all the changes to the work queue infrastructure, maybe
> > this doesn't matter so much any more.  If we got rid of it then there
> > wouldn't be any multiplexing, and this whole issue would become moot.
> 
> I don't really think that'd be necessary.  Just sleeping synchronously
> should be fine.  How many threads are we talking about?

One thread per hub (no more than 10 on a typical system).  The code in
question is part of the hub driver's probe sequence.


On Sat, 22 Feb 2014, Peter Hurley wrote:

> If a running hub init does not need to be single-threaded wrt
> a different running hub init,

I'm not quite sure what that means, but the hub init threads are indeed
independent of each other.

>  then a single init work could be queued to
> the system_unbound_wq which doesn't care about running times.

This sort of thing sounds like the best approach.  Tejun, do you want
to rewrite the patch, getting rid of the hub_init_func3 and HUB_INIT3
business entirely?  Or would you like me to do it?

Alan Stern

