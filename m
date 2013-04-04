Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765302Ab3DDWan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:30:43 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40947 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765257Ab3DDWam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:30:42 -0400
Date: Thu, 4 Apr 2013 15:30:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Stancek <jstancek@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ian Lance Taylor <iant@google.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: prevent mmap_cache race in find_vma()
Message-ID: <20130404223034.GQ28522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1304041120510.26822@eggly.anvils>
 <CA+55aFwCG2h1ijWTCJ38LVcUyczDAfk72c4MVSU+_-BiLoMOOw@mail.gmail.com>
 <alpine.LNX.2.00.1304041149030.29847@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1304041149030.29847@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040422-2398-0000-0000-000012EEA96D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 12:01:52PM -0700, Hugh Dickins wrote:
> On Thu, 4 Apr 2013, Linus Torvalds wrote:
> > On Thu, Apr 4, 2013 at 11:35 AM, Hugh Dickins <hughd@google.com> wrote:
> > >
> > > find_vma() can be called by multiple threads with read lock
> > > held on mm->mmap_sem and any of them can update mm->mmap_cache.
> > > Prevent compiler from re-fetching mm->mmap_cache, because other
> > > readers could update it in the meantime:
> > 
> > Ack. I do wonder if we should mark the unlocked update too some way
> > (also in find_vma()), although it's probably not a problem in practice
> > since there's no way the compiler can reasonably really do anything
> > odd with it. We *could* make that an ACCESS_ONCE() write too just to
> > highlight the fact that it's an unlocked write to this optimistic data
> > structure.
> 
> Hah, you beat me to it.
> 
> I wanted to get Jan's patch in first, seeing as it actually fixes his
> observed issue; and it is very nice to have such a good description of
> one of those, when ACCESS_ONCE() is usually just an insurance policy.
> 
> But then I was researching the much rarer "ACCESS_ONCE(x) = y" usage
> (popular in drivers/net/wireless/ath/ath9k and kernel/rcutree* and
> sound/firewire, but few places else).
> 
> When Paul reminded us of it yesterday, I came to wonder if actually
> every use of ACCESS_ONCE in the read form should strictly be matched
> by ACCESS_ONCE whenever modifying the location.

>From a hygiene/insurance/documentation point of view, I agree.  Of course,
it is OK to use things like cmpxchg() in place of ACCESS_ONCE().

The possible exceptions that come to mind are (1) if the access in
question is done holding a lock that excludes all other accesses to that
location, (2) if the access in question happens during initialization
before any other CPU has access to that location, and (3) if the access
in question happens during cleanup after all other CPUs have lost access
to that location.  Any others?

/me goes to look to see if the RCU code follows this good advice...

							Thanx, Paul

> My uneducated guess is that strictly it ought to, in the sense of
> insurance policy; but that (apart from that strange split writing
> issue which came up a couple of months ago) in practice our compilers
> have not "advanced" to the point of making this an issue yet.
> 
> > 
> > Anyway, applied.
> 
> Thanks,
> Hugh
> 

