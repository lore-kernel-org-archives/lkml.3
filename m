Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3JCVKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:10:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3JCVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:10:10 -0400
Date: Thu, 3 Oct 2013 14:10:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Bob Liu <lliubbo@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com, minchan@kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH] mm: pagevec: cleanup: drop pvec->cold argument in all
 places
Message-Id: <20131003141008.0bf310445041a0919fe84fb9@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1310012243220.5682@chino.kir.corp.google.com>
References: <1380357239-30102-1-git-send-email-bob.liu@oracle.com>
	<20130930150207.3661b5c146b6ecea84194547@linux-foundation.org>
	<alpine.DEB.2.02.1310012243220.5682@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013 22:47:36 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Mon, 30 Sep 2013, Andrew Morton wrote:
> 
> > > Nobody uses the pvec->cold argument of pagevec and it's also unreasonable for
> > > pages in pagevec released as cold page, so drop the cold argument from pagevec.
> > 
> > Is it unreasonable?  I'd say it's unreasonable to assume that all pages
> > in all cases are likely to be cache-hot.  Example: what if the pages
> > are being truncated and were found to be on the inactive LRU,
> > unreferenced?
> > 
> > A useful exercise would be to go through all those pagevec_init() sites
> > and convince ourselves that the decision at each place was the correct
> > one.
> > 
> 
> Agreed, and the "cold" argument to release_pages() becomes a no-op if this 
> patch is merged meaning that anything released through it will 
> automatically go to the start of the pcp lists.  If the pages aren't hot 
> then this is exactly the opposite of what we wanted to do; the fact that 
> the pvec length doesn't take into account the size of cpu cache can almost 
> guarantee that everything isn't cache hot.

The hot/cold pages code was very marginal when we first merged it and I
suspect it has rotted since.

It would be a useful exercise for someone to disable it then run some
benchmarks with a view to removing it all.  But the problem I have with
this approach is perhaps the code *could* become effective if some
careful maintenance work was done on it - we should at least get the
hot/cold decisions optimised before making a decision about the overall
desirability of keeping it.



