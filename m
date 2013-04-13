Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3DMBXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:23:47 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12077 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab3DMBXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:23:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQVAHayaFF5LHr4/2dsb2JhbABQDoJ4vHmFHAQBgQwXdIIfAQEEATocKAsIAxgJJQ8FJQMhARIbh3MFvE8VjWWBJINBA5cBkRKCTFEqgTAk
Date: Sat, 13 Apr 2013 11:23:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130413012341.GJ30622@dastard>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
 <20130410105608.GC1910@suse.de>
 <20130410131245.GC4862@thunk.org>
 <20130411170402.GB11656@suse.de>
 <20130411183512.GA12298@thunk.org>
 <20130411213335.GE9379@quack.suse.cz>
 <20130412025708.GB7445@thunk.org>
 <20130412045042.GA30622@dastard>
 <20130412151952.GA4944@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412151952.GA4944@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 11:19:52AM -0400, Theodore Ts'o wrote:
> On Fri, Apr 12, 2013 at 02:50:42PM +1000, Dave Chinner wrote:
> > > If that is the case, one possible solution that comes to mind would be
> > > to mark buffer_heads that contain metadata with a flag, so that the
> > > flusher thread can write them back at the same priority as reads.
> > 
> > Ext4 is already using REQ_META for this purpose.
> 
> We're using REQ_META | REQ_PRIO for reads, not writes.
> 
> > I'm surprised that no-one has suggested "change the IO elevator"
> > yet.....
> 
> Well, testing to see if the stalls go away with the noop schedule is a
> good thing to try just to validate the theory.

Exactly.

> The thing is, we do want to make ext4 work well with cfq, and
> prioritizing non-readahead read requests ahead of data writeback does
> make sense.  The issue is with is that metadata writes going through
> the block device could in some cases effectively cause a priority
> inversion when what had previously been an asynchronous writeback
> starts blocking a foreground, user-visible process.

Here's the historic problem with CFQ: it's scheduling algorithms
change from release to release, and so what you tune the filesystem
to for this release is likely to cause different behaviour
in a few releases time.

We've had this problem time and time again with CFQ+XFS, so we
stopped trying to "tune" to a particular elevator long ago.  The
best you can do it tag the Io as appropriately as possible (e.g.
metadata with REQ_META, sync IO with ?_SYNC, etc), and then hope CFQ
hasn't been broken since the last release....

> At least, that's the theory; we should confirm that this is indeed
> what is causing the data stalls which Mel is reporting on HDD's before
> we start figuring out how to fix this problem.

*nod*.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
