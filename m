Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3FEXGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:06:33 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42547 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab3FEXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:06:31 -0400
Date: Wed, 5 Jun 2013 16:06:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: memcontrol: fix lockless reclaim hierarchy
 iterator
Message-ID: <20130605230625.GN10693@mtj.dyndns.org>
References: <1370472826-29959-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370472826-29959-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 06:53:45PM -0400, Johannes Weiner wrote:
> The lockless reclaim hierarchy iterator currently has a misplaced
> barrier that can lead to use-after-free crashes.
> 
> The reclaim hierarchy iterator consist of a sequence count and a
> position pointer that are read and written locklessly, with memory
> barriers enforcing ordering.
> 
> The write side sets the position pointer first, then updates the
> sequence count to "publish" the new position.  Likewise, the read side
> must read the sequence count first, then the position.  If the
> sequence count is up to date, it's guaranteed that the position is up
> to date as well:
> 
>   writer:                         reader:
>   iter->position = position       if iter->sequence == expected:
>   smp_wmb()                           smp_rmb()
>   iter->sequence = sequence           position = iter->position
> 
> However, the read side barrier is currently misplaced, which can lead
> to dereferencing stale position pointers that no longer point to valid
> memory.  Fix this.
> 
> Reported-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@kernel.org [3.10+]

Reviewed-by: Tejun Heo <tj@kernel.org>

Oops, right, the references were reversed too.

Thanks.

-- 
tejun
