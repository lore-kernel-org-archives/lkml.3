Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbaAJQMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:12:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913AbaAJQMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:12:51 -0500
Date: Fri, 10 Jan 2014 16:12:47 +0000
From: Mel Gorman <mgorman@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
 prep_new_page() race
Message-ID: <20140110161247.GG27046@suse.de>
References: <20140103195519.GA26555@redhat.com>
 <20140103195547.GB26555@redhat.com>
 <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
 <20140104164347.GA31359@redhat.com>
 <20140108115400.GD27046@suse.de>
 <20140108161338.GA10434@redhat.com>
 <20140108180202.GL27046@suse.de>
 <20140108190443.GA17282@redhat.com>
 <20140109112736.GR27046@suse.de>
 <20140109140447.GA25391@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140109140447.GA25391@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:04:47PM +0100, Oleg Nesterov wrote:
> 
> > #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >         page_head = page;
> >         if (unlikely(PageTail(page))) {
> >                 put_page(page);
> >
> >
> > so I'm still not seeing how a tail page racing with a split ends up with
> > mayhem.
> 
> But get/put(page_tail) plays with page_head which can be freed/reallocated,
> it does compound_lock(page_head).
> 
> > I could also still be stuck in a "la la la, everything is fine" mode.
> 
> More likely it is me who tries to deny the fact I missed something ;)
> 

My hangup was that this was related to futex and I was focusing it as
a specific example that made the patch necessary. However, this is a
therotical case that potentially impacts a put_page if it mistakenly
believes it is still a tail page when it's not due a a parallel split. I
see and understand that race and while I think the patch is overkill, I
have no problem with including it at the start of a series that reexamines
the locking in that area. It makes for a suitable -stable backport and
I hope/expect the reworked locking would then remove the barrier again
for upstream.

I haven't looked at the reworked locking but understand there is a v3 on
the way so I'll wait until that happens and work my way through it.

Thanks and sorry for the noise.

-- 
Mel Gorman
SUSE Labs
