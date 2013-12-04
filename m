Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3LDXwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:52:20 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:43981 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3LDXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:52:00 -0500
Date: Wed, 4 Dec 2013 15:51:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcg: do not allow task about to OOM kill to
 bypass the limit
In-Reply-To: <1386197114-5317-3-git-send-email-hannes@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1312041546370.6329@chino.kir.corp.google.com>
References: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org> <1386197114-5317-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Johannes Weiner wrote:

> 4942642080ea ("mm: memcg: handle non-error OOM situations more
> gracefully") allowed tasks that already entered a memcg OOM condition
> to bypass the memcg limit on subsequent allocation attempts hoping
> this would expedite finishing the page fault and executing the kill.
> 
> David Rientjes is worried that this breaks memcg isolation guarantees
> and since there is no evidence that the bypass actually speeds up
> fault processing just change it so that these subsequent charge
> attempts fail outright.  The notable exception being __GFP_NOFAIL
> charges which are required to bypass the limit regardless.
> 
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David Rientjes <rientjes@google.com>

Thanks!

I think we should consider marking this for stable@vger.kernel.org for 
3.12 since the original patch went into 3.12-rc6.  Depending on the number 
of allocators in the oom memcg, the amount of memory bypassed can become 
quite large.

For example, in a memcg with a limit of 128MB, if you start 10 concurrent 
processes that simply allocate a lot of memory you can get quite a bit of 
memory bypassed.  If I start 10 membench processes, which would cause a 
128MB memcg to oom even if only one such process were running, we get:

# grep RSS /proc/1092[0-9]/status
VmRSS:	   15724 kB
VmRSS:	   15064 kB
VmRSS:	   13224 kB
VmRSS:	   14520 kB
VmRSS:	   14472 kB
VmRSS:	   13016 kB
VmRSS:	   13024 kB
VmRSS:	   14560 kB
VmRSS:	   14864 kB
VmRSS:	   14772 kB

And all of those total ~140MB of memory while bound to a memcg with a 
128MB limit, about 10% of memory is bypassed.
