Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3KAMIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:08:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48102 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KAMID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:08:03 -0400
Date: Fri, 1 Nov 2013 13:07:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
Message-ID: <20131101120745.GC10651@twins.programming.kicks-ass.net>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101084329.GB19466@laptop.lan>
 <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
 <20131101100707.GB30123@yliu-dev.sh.intel.com>
 <20131101101514.GD19466@laptop.lan>
 <20131101114429.GD30123@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101114429.GD30123@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 07:44:29PM +0800, Yuanhan Liu wrote:
> commit 012f18004da33ba672e3c60838cc4898126174d3
> Author: Rik van Riel <riel@redhat.com>
> Date:   Mon Aug 9 17:18:40 2010 -0700
> 
>     mm: always lock the root (oldest) anon_vma
> 
>     Always (and only) lock the root (oldest) anon_vma whenever we do something
>     in an anon_vma.  The recently introduced anon_vma scalability is due to
>     the rmap code scanning only the VMAs that need to be scanned.  Many common
>     operations still took the anon_vma lock on the root anon_vma, so always
>     taking that lock is not expected to introduce any scalability issues.
> 
>     However, always taking the same lock does mean we only need to take one
>     lock, which means rmap_walk on pages from any anon_vma in the vma is
>     excluded from occurring during an munmap, expand_stack or other operation
>     that needs to exclude rmap_walk and similar functions.
> 
>     Also add the proper locking to vma_adjust.
> 
>     Signed-off-by: Rik van Riel <riel@redhat.com>
>     Tested-by: Larry Woodman <lwoodman@redhat.com>
>     Acked-by: Larry Woodman <lwoodman@redhat.com>
>     Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>     Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>     Acked-by: Mel Gorman <mel@csn.ul.ie>
>     Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Right that commit did. I'm still not sure why you change both the
locking proper and the locking primitive used in one patch set.

Also, changing the locking proper requires a very detailed explanation
on why it is correct; we've had far too many 'fun' issues with the
anon_vma locking in the past.
