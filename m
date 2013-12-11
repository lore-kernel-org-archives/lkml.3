Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3LKSAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:00:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42259 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3LKSAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:00:09 -0500
Date: Wed, 11 Dec 2013 18:00:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Potentially unbounded allocations in seq_read?
Message-ID: <20131211180007.GX10323@ZenIV.linux.org.uk>
References: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
 <1386784112.6066.61.camel@tursulin-linux.isw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386784112.6066.61.camel@tursulin-linux.isw.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 05:48:32PM +0000, Tvrtko Ursulin wrote:
> On Wed, 2013-12-11 at 17:04 +0000, Tvrtko Ursulin wrote:
> > Hi all,
> > 
> > It seems that the buffer allocation in seq_read can double in size
> > indefinitely, at least I've seen that in practice with /proc/<pid>/smaps
> > (attempting to double m->size to 4M on a read of 1000 bytes). This
> > produces an ugly WARN_ON_ONCE, which should perhaps be avoided? (given
> > that it can be triggered by userspace at will)
> > 
> > From the top comment in seq_file.c one would think that it is a
> > fundamental limitation of the current code that everything which will be
> > read (even if in chunks) needs to be in the kernel side buffer at the
> > same time?
> 
> Oh-oh, seems that m->size is doubled on every read. So if app is reading
> with a buffer smaller than data available, it can do nine reads before
> it hits a >MAX_ORDER allocation. Not good. :)

Huh?  Is that from observation or from reading the code?  If it's the former,
I would really like to see details, if it's the latter... you are misreading
it.  m->size is doubled until it's large enough to hold ->show() output;
size argument of seq_read() has nothing to do with that.  Once the damn
thing is large enough, read() is served from it.  So are subsequent reads,
until you manage to eat all that had been generated.  Then the same buffer
is used for the next entry; again, no doubling unless that next entry is
even bigger and won't fit.  Doubling on each read(2) takes really strange
iterator to trigger and you'll need ->show() spewing bigger and bigger
entries.  Again - details, please...
