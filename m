Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3LKXF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:05:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3LKXFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:05:23 -0500
Date: Wed, 11 Dec 2013 15:05:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] mm readahead: Fix the readahead fail in case of
 empty numa node
Message-Id: <20131211150522.4b853323e8b82f342f81b64d@linux-foundation.org>
In-Reply-To: <20131211224917.GF1163@quack.suse.cz>
References: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	<20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org>
	<529EE811.5050306@linux.vnet.ibm.com>
	<20131204004125.a06f7dfc.akpm@linux-foundation.org>
	<529EF0FB.2050808@linux.vnet.ibm.com>
	<20131204134838.a048880a1db9e9acd14a39e4@linux-foundation.org>
	<20131211224917.GF1163@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 23:49:17 +0100 Jan Kara <jack@suse.cz> wrote:

> >  /*
> > - * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
> > - * sensible upper limit.
> > + * max_sane_readahead() is disabled.  It can later be removed altogether, but
> > + * let's keep a skeleton in place for now, in case disabling was the wrong call.
> >   */
> >  unsigned long max_sane_readahead(unsigned long nr)
> >  {
> > -	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
> > -		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
> > +	return nr;
> >  }
> >  
> >  /*
> > 
> > Can anyone see a problem with this?
>   Well, the downside seems to be that if userspace previously issued
> MADV/FADV_WILLNEED on a huge file, we trimmed the request to a sensible
> size. Now we try to read the whole huge file which is pretty much
> guaranteed to be useless (as we'll be pushing out of cache data we just
> read a while ago). And guessing the right readahead size from userspace
> isn't trivial so it would make WILLNEED advice less useful. What do you
> think?

OK, yes, there is conceivably a back-compatibility issue there.  There
indeed might be applications which decide the chuck the whole thing at
the kernel and let the kernel work out what is a sensible readahead
size to perform.

But I'm really struggling to think up an implementation!  The current
code looks only at the caller's node and doesn't seem to make much
sense.  Should we look at all nodes?  Hard to say without prior
knowledge of where those pages will be coming from.

