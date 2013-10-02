Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3JBFrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:47:40 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53298 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3JBFri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:47:38 -0400
Date: Tue, 1 Oct 2013 22:47:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Bob Liu <lliubbo@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com, minchan@kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH] mm: pagevec: cleanup: drop pvec->cold argument in all
 places
In-Reply-To: <20130930150207.3661b5c146b6ecea84194547@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1310012243220.5682@chino.kir.corp.google.com>
References: <1380357239-30102-1-git-send-email-bob.liu@oracle.com> <20130930150207.3661b5c146b6ecea84194547@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Sep 2013, Andrew Morton wrote:

> > Nobody uses the pvec->cold argument of pagevec and it's also unreasonable for
> > pages in pagevec released as cold page, so drop the cold argument from pagevec.
> 
> Is it unreasonable?  I'd say it's unreasonable to assume that all pages
> in all cases are likely to be cache-hot.  Example: what if the pages
> are being truncated and were found to be on the inactive LRU,
> unreferenced?
> 
> A useful exercise would be to go through all those pagevec_init() sites
> and convince ourselves that the decision at each place was the correct
> one.
> 

Agreed, and the "cold" argument to release_pages() becomes a no-op if this 
patch is merged meaning that anything released through it will 
automatically go to the start of the pcp lists.  If the pages aren't hot 
then this is exactly the opposite of what we wanted to do; the fact that 
the pvec length doesn't take into account the size of cpu cache can almost 
guarantee that everything isn't cache hot.
