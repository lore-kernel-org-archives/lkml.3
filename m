Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3EHNh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:37:26 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47449
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280Ab3EHNhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:37:22 -0400
Date: Wed, 8 May 2013 15:35:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130508133547.GA8386@dyad.programming.kicks-ass.net>
References: <1367348080-4680-1-git-send-email-sasha.levin@oracle.com>
 <1367348080-4680-3-git-send-email-sasha.levin@oracle.com>
 <20130508100143.GA6131@dyad.programming.kicks-ass.net>
 <518A52D2.4050505@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A52D2.4050505@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 09:27:46AM -0400, Sasha Levin wrote:
> [snip]
> 
> Hi Peter,
> 
> You're right - I broke multithreading for some odd reason (mostly me being stupid)
> after having it working :/
> 
> It's enough to set the __thread flag on current_obj:
> 
> 	diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
> 	index eb5e481..8ef602f 100644
> 	--- a/tools/lib/lockdep/common.c
> 	+++ b/tools/lib/lockdep/common.c
> 	@@ -5,7 +5,7 @@
> 	 #include <unistd.h>
> 	 #include <sys/syscall.h>
> 	
> 	-static struct task_struct current_obj;
> 	+static __thread struct task_struct current_obj;
> 	
> 	 /* lockdep wants these */
> 	 bool debug_locks = true;
> 
> Since we don't need any special initialization of the struct at any point. This
> means that the patch above is enough and we don't need to hook pthread_create.
> 

I tried googling but failed to find the TLS initialization rules. Are they
zero'd for each thread or copied about or what? And is this documented or
implementation behaviour?

If its consistently zero'd then I suppose you're right and we can get away with
just adding __thread; *phew*.
