Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab3K0Xeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:34:31 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:33004 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab3K0Xe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:34:26 -0500
Date: Wed, 27 Nov 2013 15:34:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
In-Reply-To: <20131127225340.GE3556@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com> <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com> <20131127163916.GB3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com> <20131127225340.GE3556@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Johannes Weiner wrote:

> > We don't give __GFP_NOFAIL allocations access to memory reserves in the 
> > page allocator and we do call the oom killer for them so that a process is 
> > killed so that memory is freed.  Why do we have a different policy for 
> > memcg?
> 
> Oh boy, that's the epic story we dealt with all throughout the last
> merge window... ;-)
> 
> __GFP_NOFAIL allocations might come in with various filesystem locks
> held that could prevent an OOM victim from exiting, so a loop around
> the OOM killer in an allocation context is prone to loop endlessly.
> 

Ok, so let's forget about GFP_KERNEL | __GFP_NOFAIL since anything doing 
__GFP_FS should not be holding such locks, we have some of those in the 
drivers code and that makes sense that they are doing GFP_KERNEL.

Focusing on the GFP_NOFS | __GFP_NOFAIL allocations in the filesystem 
code, the kernel oom killer independent of memcg never gets called because 
!__GFP_FS and they'll simply loop around the page allocator forever.

In the past, Andrew has expressed the desire to get rid of __GFP_NOFAIL 
entirely since it's flawed when combined with GFP_NOFS (and GFP_KERNEL | 
__GFP_NOFAIL could simply be reimplemented in the caller) because of the 
reason you point out in addition to making it very difficult in the page 
allocator to free memory independent of memcg.

So I'm wondering if we should just disable the oom killer in memcg for 
__GFP_NOFAIL as you've done here, but not bypass to the root memcg and 
just allow them to spin?  I think we should be focused on the fixing the 
callers rather than breaking memcg isolation.
