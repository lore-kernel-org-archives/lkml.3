Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaC0Eip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:38:45 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62813 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaC0Eim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:38:42 -0400
Date: Wed, 26 Mar 2014 21:38:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: tytso@mit.edu
cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
In-Reply-To: <20140326132936.GB4907@thunk.org>
Message-ID: <alpine.DEB.2.02.1403262133100.6103@chino.kir.corp.google.com>
References: <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org> <20140322170322.GA23583@thunk.org> <20140322101512.eaeb542b.akpm@linux-foundation.org> <20140322172606.GB23583@thunk.org> <20140322173207.GC23583@thunk.org>
 <20140322105524.7baec73a.akpm@linux-foundation.org> <20140322192423.GA10176@redhat.com> <alpine.DEB.2.02.1403251800320.21733@chino.kir.corp.google.com> <20140326061904.GA4907@thunk.org> <20140325233209.31756c92.akpm@linux-foundation.org>
 <20140326132936.GB4907@thunk.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, tytso@mit.edu wrote:

> But that's another new user of GFP_NOFAIL (and one added three years
> after David tried to declare There Shalt Be No New Users of
> GFP_NOFAIL), and sure, we could probably patch around that by having
> places where there's no other alternaive to keep a preallocated batch
> of pages and/or allocated structures at each code site.  But that's as
> bad as looping at each code site; in fact, wouldn't it be better if
> the allocator wants to avoid looping, to have a separate batch of
> pages which (ala GFP_ATOMIC) which is reserved for just for GFP_NOFAIL
> allocations when all else fails?
> 

I didn't declare nobody should be adding __GFP_NOFAIL three years ago, 
rather three months ago I proposed a patch to fix __GFP_NOFAIL for 
GFP_ATOMIC allocations you're talking about above since, guess what, 
GPF_ATOMIC | __GFP_NOFAIL today easily returns NULL.  I tried fixing that 
failable-__GFP_NOFAIL problem with 
http://marc.info/?l=linux-kernel&m=138662620812698 but Andrew requested a 
WARN_ON_ONCE() instead since nobody is currently doing that and we agreed 
to warn against new users.

So we should either return to my earlier patch to actually make 
__GFP_NOFAIL not fail, or improve (but not remove) the checkpatch warning 
for these failable cases.  I couldn't care less if we add 5,000 new 
__GFP_NOFAIL users tomorrow, I just care that it does what is expected if 
people are going to be adding them.
