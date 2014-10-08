Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbaJHL4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:56:34 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48281 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbaJHL4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:56:32 -0400
Date: Wed, 8 Oct 2014 12:56:29 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 11/11] perf/x86/intel: Perform rotation on Intel CQM RMIDs
Message-ID: <20141008115629.GR14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-12-git-send-email-matt@console-pimps.org>
 <20141008111927.GG4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008111927.GG4750@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct, at 01:19:27PM, Peter Zijlstra wrote:
> On Wed, Sep 24, 2014 at 03:04:15PM +0100, Matt Fleming wrote:
> > This scheme reserves one RMID at all times for rotation. When we need to
> > schedule a new event we give it the reserved RMID, pick a victim event
> > from the front of the global CQM list and wait for the victim's RMID to
> > drop to zero occupancy, before it becomes the new reserved RMID.
> 
> > +/*
> > + * If we fail to assign a new RMID for intel_cqm_rotation_rmid because
> > + * cachelines are still tagged with RMIDs in limbo, we progressively
> > + * increment the threshold until we find an RMID in limbo with <=
> > + * __intel_cqm_threshold lines tagged. This is designed to mitigate the
> > + * problem where cachelines tagged with an RMID are not steadily being
> > + * evicted.
> > + *
> > + * On successful rotations we decrease the threshold back towards zero.
> > + */
> > +static unsigned int __intel_cqm_threshold;
> 
> Ah, so I was about to tell you there is the possibiliy we'll never quite
> reach 0. But it appears you've cured that with this adaptive threshold
> thing?
 
Yeah, that is the idea. There are more games that we can play for
picking a "good" RMID to reuse, but this threshold provides a final
guarantee that we will make forward progress.

It also provides a good indication of how inaccurate you can expect your
results to be at any given time and for a particular event, but we don't
expose that currently. It might make sense to print a warning each time
the threshold reaches a new high.

> Is there an upper bound on the threshold after which we'll just wait, or
> will you keep increasing it until something matches?

We'll keep increasing it until something matches, though crucially, we
will decrease it for every consecutive match thereafter.

A threshold upper bound does seem like a good idea, though. I'm not a
massive fan of user-configurable knobs, but this does seem like the kind
of thing where people may want that control.

-- 
Matt Fleming, Intel Open Source Technology Center
