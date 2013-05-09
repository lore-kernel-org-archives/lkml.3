Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3EIPlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:41:52 -0400
Received: from www.sr71.net ([198.145.64.142]:58744 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3EIPlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:41:51 -0400
Message-ID: <518BC3BD.30005@sr71.net>
Date: Thu, 09 May 2013 08:41:49 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/22] Per-cpu page allocator replacement prototype
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1368028987-8369-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:02 AM, Mel Gorman wrote:
> So preliminary testing indicates the results are mixed bag. As long as
> locks are not contended, it performs fine but parallel fault testing
> hits into spinlock contention on the magazine locks. A greater problem
> is that because CPUs share magazines it means that the struct pages are
> frequently dirtied cache lines. If CPU A frees a page to a magazine and
> CPU B immediately allocates it then the cache line for the page and the
> magazine bounces and this costs. It's on the TODO list to research if the
> available literature has anything useful to say that does not depend on
> per-cpu lists and the associated problems with them.

If we don't want to bounce 'struct page' cache lines around, then we
_need_ to make sure that things that don't share caches don't use the
same magazine.  I'm not sure there's any other way.  But, that doesn't
mean we have to _statically_ assign cores/thread to particular magazines.

Say we had a percpu hint which points us to the last magazine we used.
We always go to it first, and fall back to round-robin if our preferred
one is contended.  That way, if we have a mixture tasks doing heavy and
light allocations, the heavy allocators will tend to "own" a magazine,
and the lighter ones would gravitate to sharing one.

It might be taking things too far, but we could even raise the number of
magazines only when we actually *see* contention on the existing set.

>  24 files changed, 571 insertions(+), 788 deletions(-)

oooooooooooooooooohhhhhhhhhhhhh.

The only question is how much we'll have to bloat it as we try to
optimize things. :)

BTW, I really like the 'magazine' name.  It's not frequently used in
this kind of context and it conjures up a nice mental image whether it
be of stacks of periodicals or firearm ammunition clips.
