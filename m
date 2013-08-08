Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab3HHHn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:43:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45508 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852Ab3HHHn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:43:27 -0400
Date: Thu, 8 Aug 2013 00:43:26 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Subject: Re: PREEMPT_RT vs bcache
Message-ID: <20130808074326.GA15409@kmo-pixel>
References: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
 <20130808072623.GA3509@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808072623.GA3509@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 12:26:23AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 07, 2013 at 10:28:18PM +0200, Ben Hutchings wrote:
> > As Kent said back in 2011 (commit 84759c6d18c5), bcache needs
> > {down,up}_read_non_owner().  But these are not implemented by the -rt
> > patchset when PREEMPT_RT_FULL is enabled.  Can they be added, or is
> > there a fundamental conflict here?
> 
> How did they get back in at all?  I'm pretty sure I removed them for
> good reason.

I seem to recall from looking at the logs that you just removed them
because all the old users could be and were converted to something
saner, for what they were doing (using them as completions, I want to
say?)

Bcache isn't using the rw sem as a completion though, it really is a
read/write lock that protects a specific data structure, and  where
we're taking a read lock for the duration of write IOs - and since bios
are asynchronous, that's why we need the non_owner() bit.
