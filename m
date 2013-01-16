Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab3APQMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:12:47 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57727 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab3APQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:12:29 -0500
Date: Wed, 16 Jan 2013 08:12:24 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
Message-ID: <20130116161224.GO2668@htj.dyndns.org>
References: <20130116003530.GK2668@htj.dyndns.org>
 <Pine.LNX.4.44L0.1301152253070.26877-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301152253070.26877-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Tue, Jan 15, 2013 at 11:01:15PM -0500, Alan Stern wrote:
> > The current domain implementation is somewhere inbetween.  It's not
> > completely simplistic system and at the same time not developed enough
> > to do properly stacked flushing.
> 
> I like your idea of chronological synchronization: Insist that anybody
> who wants to flush async jobs must get a cookie, and then only allow
> them to wait for async jobs started after the cookie was issued.
> 
> I don't know if this is possible with the current implementation.  It 
> would require changing every call to async_synchronize_*(), and in a 
> nontrivial way.  But it might provide a proper solution to all these 
> problems.

The problem here is that "flush everything which comes before me" is
used to order async jobs.  e.g. after async jobs probe the hardware
they order themselves by flushing before registering them, so unless
we build accurate flushing dependencies, those dependencies will reach
beyond the time window we're interested in and bring in deadlocks.

And, as Linus pointed it out, tracking dependency through
request_module() is tricky no matter what we do.  I think it can be
done by matching the ones calling request_module() and the ones
actually loading modules but it's gonna be nasty.

There aren't too many which use async anyway so changing stuff
shouldn't be too difficult but I think the simpicity or dumbness is
one of major attractions of async, so it'd be nice to keep things that
way and the PF_USED_ASYNC hack seems to be able to hold things
together for now.

Thanks.

-- 
tejun
