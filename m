Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaEZS0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:26:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48752 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaEZS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:26:47 -0400
Date: Mon, 26 May 2014 19:26:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140526182644.GP18016@ZenIV.linux.org.uk>
References: <20140526093741.GA1765@lahna.fi.intel.com>
 <20140526135746.GM18016@ZenIV.linux.org.uk>
 <20140526142948.GA1685@lahna.fi.intel.com>
 <20140526152703.GN18016@ZenIV.linux.org.uk>
 <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 11:17:42AM -0700, Linus Torvalds wrote:
> On Mon, May 26, 2014 at 8:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > That's the livelock.  OK.
> 
> Hmm. Is there any reason we don't have some exclusion around
> "check_submounts_and_drop()"?
> 
> That would seem to be the simplest way to avoid any livelock: just
> don't allow concurrent calls (we could make the lock per-filesystem or
> whatever). This whole case should all be for just exceptional cases
> anyway.
> 
> We already sleep in that thing (well, "cond_resched()"), so taking a
> mutex should be fine.

What makes you think that it's another check_submounts_and_drop()?
And not, e.g., shrink_dcache_parent().  Or memory shrinkers.  Or
some twit sitting in a subdirectory and doing stat(2) in a loop, for
that matter...

I really, really wonder WTF is causing that - we have spent 20-odd
seconds spinning while dentries in there were being evicted by
something.  That - on sysfs, where dentry_kill() should be non-blocking
and very fast.  Something very fishy is going on and I'd really like
to understand the use pattern we are seeing there.
