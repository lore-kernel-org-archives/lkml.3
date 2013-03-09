Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab3CIAc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:32:26 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:12535 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759955Ab3CIAcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:32:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsbAHqCOlF5LH9g/2dsb2JhbABDhzy4BYUWAQIBgVwXdIIsAQEFOhwjEAgDDgoJJQ8FJQMhE4gSvCYVjXYYH0oHgl9hA5ZSkHODHg
Date: Sat, 9 Mar 2013 11:32:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Michel Lespinasse <walken@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a
 reader
Message-ID: <20130309003221.GE23616@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
 <1362612111-28673-12-git-send-email-walken@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362612111-28673-12-git-send-email-walken@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 03:21:50PM -0800, Michel Lespinasse wrote:
> When the first queued waiter is a reader, wake all readers instead of
> just those that are at the front of the queue. There are really two
> motivations for this change:

Isn't this a significant change of semantics for the rwsem? i.e.
that read lock requests that come after a write lock request now
jump ahead of the write lock request? i.e.the write lock request is
no longer a barrier in the queue?

XFS has long assumed that a rwsem write lock is a barrier that
stops new read locks from being taken, and this change will break
that assumption. Given that this barrier assumption is used as the
basis for serialisation of operations like IO vs truncate, there's a
bit more at stake than just improving parallelism here.  i.e. IO
issued after truncate/preallocate/hole punch could now be issued
ahead of the pending metadata operation, whereas currently the IO
issued after the pending metadata operation is waiting for the write
lock will be only be processed -after- the metadata modification
operation completes...

That is a recipe for weird data corruption problems because
applications are likely to have implicit dependencies on the barrier
effect of metadata operations on data IO...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
