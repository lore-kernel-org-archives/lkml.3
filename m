Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaCMTEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:04:22 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:11568 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaCMTEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:04:20 -0400
Message-ID: <1394737457.2452.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -next] mm,vmacache: also flush cache for VM_CLONE
From: Davidlohr Bueso <davidlohr@hp.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 13 Mar 2014 12:04:17 -0700
In-Reply-To: <20140313153218.GA28278@redhat.com>
References: <20140308184040.GA29602@redhat.com>
	 <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com>
	 <20140308194405.GA32403@redhat.com>
	 <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
	 <20140309125710.GA1829@redhat.com>
	 <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com>
	 <20140309170909.GA13335@redhat.com>
	 <CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com>
	 <1394481375.3867.1.camel@buesod1.americas.hpqcorp.net>
	 <20140313145941.GA26215@redhat.com> <20140313153218.GA28278@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 16:32 +0100, Oleg Nesterov wrote:
> On 03/13, Oleg Nesterov wrote:
> >
> > Yes. But it seems that use_mm() and unuse_mm() should invalidate vmacache too.
> >
> > Suppose that a kernel thread T does, say,
> >
> > 	use_mm(foreign_mm);
> > 	get_user(...);
> > 	unuse_mm();
> >
> > This can trigger a fault and populate T->vmacache[]. If this code is called
> > again vmacache_find() can use the stale entries.
> >
> > Or, assuming that only a kernel thread can do use_mm(), we can change
> > vmacache_valid() to also check !PF_KTHREAD.
> 
> Yes, I think we should check PF_KTHREAD, because
> 
> > Hmm. Another problem is that use_mm() doesn't take ->mmap_sem and thus
> > it can race with vmacache_flush_all()...
> 
> this also closes this race. use_mm() users should not use vmacache at all.
> 
> > Finally. Shouldn't vmacache_update() check current->mm == mm as well?
> > What if access_remote_vm/get_user_pages trigger find_vma() ??? Unless
> > I missed something this is not theoretical at all and can lead to the
> > corrupted vmacache, no?
> 
> Looks like a real problem or I am totally confused. I think we need
> something like below (uncompiled).

Thanks for looking into this Oleg. I was actually chasing a bug
triggered by trinity where we have a stale cache and vmacache_find() is
returning a bogus vma structure even when vma->vm_mm != mm:

https://lkml.org/lkml/2014/3/9/201
https://lkml.org/lkml/2014/3/11/563

So it just might be a real problem.

