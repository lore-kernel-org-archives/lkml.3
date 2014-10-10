Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaJJJVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:21:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaJJJVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:21:02 -0400
Date: Fri, 10 Oct 2014 11:20:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [BUG] mm, thp: khugepaged can't allocate on requested node when
 confined to a cpuset
Message-ID: <20141010092052.GU4750@worktop.programming.kicks-ass.net>
References: <20141008191050.GK3778@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008191050.GK3778@sgi.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 02:10:50PM -0500, Alex Thorlton wrote:

> Is this particular bug a known issue?

Its not unexpected for me.

> I've been trying to come up with
> a simple way to fix the bug, but it's a bit difficult since we no longer
> have a way to trace back to the task_struct that we're collapsing for
> once we've reached get_page_from_freelist.  I'm wondering if we might
> want to make the cpuset check higher up in the call-chain and then pass
> that nodemask down instead of sending a NULL nodemask, as we end up
> doing in many (most?) situations.  I can think of several problems with
> that approach as well, but it's all I've come up with so far.
> 
> The obvious workaround is to not isolate khugepaged to a cpuset, but
> since we're allowed to do so, I think the thread should probably behave
> appropriately when pinned to a cpuset.
> 
> Any input on this issue is greatly appreciated.  Thanks, guys!

So for the numa thing we do everything from the affected tasks context.
There was a lot of arguments early on that that could never really work,
but here we are.

Should we convert khugepaged to the same? Drive the whole thing from
task_work? That would make this issue naturally go away.
