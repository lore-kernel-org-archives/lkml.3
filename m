Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab3FKWkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:40:45 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:42343 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342Ab3FKWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:40:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmcQABSnt1F5LO/z/2dsb2JhbABZgwm6EYUxBAGBABd0giMBAQQBOhwjBQsIAw4KCSUPBSUDIROIBwW6JxaNf4EdB4NgA5c/kUODISo
Date: Wed, 12 Jun 2013 08:40:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: 3.10-rc4 stalls during mmap writes
Message-ID: <20130611224015.GQ29338@dastard>
References: <20130607193712.GD2995@sbohrermbp13-local.rgmadvisors.com>
 <20130609033744.GA29376@dastard>
 <20130610184559.GA3594@sbohrermbp13-local.rgmadvisors.com>
 <20130610205315.GB29376@dastard>
 <20130611161735.GA3955@sbohrermbp13-local.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611161735.GA3955@sbohrermbp13-local.rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 11:17:35AM -0500, Shawn Bohrer wrote:
> In the workload I've been debugging we append data to many small files
> using mmap.  The writes are small and the total data rate is very low
> thus for most files it may take several minutes to fill a page.
> Having low-latency writes are important, but as you know stalls are
> always possible.  One way to reduce the probability of a stall is to
> reduce the frequency of writeback, and adjusting
> vm.dirty_expire_centisecs and/or vm.dirty_writeback_centisecs should
> allow us to do that.
> 
> On kernels 3.4 and older we chose to increase
> vm.dirty_expire_centisecs to 30000 since we can comfortably loose 5
> minutes of data in the event of a system failure and we believed this
> would cause a fairly consistent low data rate as every
> vm.dirty_writeback_centisecs (5s) it would writeback all dirty pages
> that were vm.dirty_expire_centisecs (5min) old.

I'm not surprised that behaviour ni the VM has changed - delaying
flusher thread execution for up to 5 minutes on dirty inodes means
that memory pressure is determining your writeback patterns.

> On old kernels that
> isn't exactly what happened.  Instead every 5 minutes there would be a
> burst of writeback and a slow trickle at all other times.  This also
> reduced the total amount of data written back since the same dirty
> page wasn't written back every 30 seconds.  This also virtually
> eliminated the stalls we saw so it was left alone.

So the slow trickle is memory pressure driven writeback....

> On 3.10 vm.dirty_expire_centisecs=30000 no longer does the same thing.
> Honestly I'm not sure what it does, but the result is a fairly
> consistent high data rate being written back to disk.  The fact that
> is consistent might lead me to believe that it writes back all pages
> that are vm.dirty_expire_centisecs old every
> vm.dirty_writeback_centisecs, but the data rate is far too high for
> that to be true.  It appears that I can effectively get the same old
> behavior by setting vm.dirty_writeback_centisecs=30000.

You probably need to do some tracepoint analysis to find out what is
triggering the writeback. Once we have an idea of the writeback
trigger, we might be able to explain the difference in behaviour.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
