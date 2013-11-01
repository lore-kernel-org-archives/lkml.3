Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3KAKGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:06:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:30167 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3KAKGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,616,1378882800"; 
   d="scan'208";a="426370315"
Date: Fri, 1 Nov 2013 18:07:07 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
Message-ID: <20131101100707.GB30123@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101084329.GB19466@laptop.lan>
 <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 02:22:25AM -0700, Michel Lespinasse wrote:
> On Fri, Nov 1, 2013 at 1:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > AFAICT this isn't correct at all. We used to protect the vma interval
> > tree with the root lock, now we don't. All we've got left is the
> > mmap_sem, but anon_vma chains can cross address-spaces and thus we're up
> > some creek without no paddle.
> 
> Yes, that was my first thought as well (though I wanted to double
> check at first).
> 
> I also want to point out that lately we've seen several changes sent
> out that relax locking with no accompanying explanation of why the
> relaxed locking would be safe. Please don't do that - having a lot of
> performance data is worthless if you can't explain why the new locking
> is safe.

Agreed.

> And I'm not asking to prove a negative ('lack of any possible
> races') there, but at least in this case one could dig out why the
> root anon vma locking was introduced and if they think that this
> reason doesn't apply anymore, explain why...

It was introduced by commit 2b575eb6(And, BTW, I'm sorry that this commit log
about bb4aa39676f is wrong)

   commit 2b575eb64f7a9c701fb4bfdb12388ac547f6c2b6
   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
   Date:   Tue May 24 17:12:11 2011 -0700
   
       mm: convert anon_vma->lock to a mutex
   
       Straightforward conversion of anon_vma->lock to a mutex.
   
       Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
       Acked-by: Hugh Dickins <hughd@google.com>
       Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
       Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
       Cc: David Miller <davem@davemloft.net>
       Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
       Cc: Russell King <rmk@arm.linux.org.uk>
       Cc: Paul Mundt <lethal@linux-sh.org>
       Cc: Jeff Dike <jdike@addtoit.com>
       Cc: Richard Weinberger <richard@nod.at>
       Cc: Tony Luck <tony.luck@intel.com>
       Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
       Cc: Mel Gorman <mel@csn.ul.ie>
       Cc: Nick Piggin <npiggin@kernel.dk>
       Cc: Namhyung Kim <namhyung@gmail.com>
       Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
       Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


As you can see, Peter didn't tell why before. Honestly speaking, that
was my originaly concern as well. I tried to find some possible races;
I guess I may miss something.

Thanks.

	--yliu
