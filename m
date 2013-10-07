Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3JGR0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:26:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3JGR0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:26:08 -0400
Date: Mon, 7 Oct 2013 19:26:04 +0200
From: Jan Kara <jack@suse.cz>
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Message-ID: <20131007172604.GD30441@quack.suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211B0176@FMSMSX107.amr.corp.intel.com>
 <20131004183315.GA19557@quack.suse.cz>
 <32E1700B9017364D9B60AED9960492BC211B07B7@FMSMSX107.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211B07B7@FMSMSX107.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 07-10-13 15:38:24, Marciniszyn, Mike wrote:
> > > This patch and the sibling ipath patch will nominally take the mmap_sem
> > > twice where the old routine only took it once.   This is a performance
> > > issue.
> >   It will take mmap_sem only once during normal operation. Only if
> > get_user_pages_unlocked() fail, we have to take mmap_sem again to undo
> > the change of mm->pinned_vm.
> > 
> > > Is the intent here to deprecate get_user_pages()?
> 
> The old code looked like:
> __qib_get_user_pages()
> 	(broken) ulimit test
>              for (...)
> 		get_user_pages()
> 
> qib_get_user_pages()
> 	mmap_sem lock
> 	__qib_get_user_pages()
>              mmap_sem() unlock
> 
> The new code is:
> 
> get_user_pages_unlocked()
> 	mmap_sem  lock
> 	get_user_pages()
> 	mmap_sem unlock
> 
> qib_get_user_pages()
> 	mmap_sem lock
>              ulimit test and locked pages maintenance
>              mmap_sem unlock
> 	for (...)
> 		get_user_pages_unlocked()
> 
> I count an additional pair of mmap_sem transactions in the normal case.
  Ah, sorry, you are right.

> > > Could the lock limit test be pushed into another version of the
> > > wrapper so that there is only one set of mmap_sem transactions?
> >   I'm sorry, I don't understand what you mean here...
> > 
> 
> This is what I had in mind:
> 
> get_user_pages_ulimit_unlocked()
> 	mmap_sem  lock
> 	ulimit test and locked pages maintenance (from qib/ipath)
>              for (...)
> 	       get_user_pages_unlocked()	
> 	mmap_sem unlock
> 	
> qib_get_user_pages()
> 	get_user_pages_ulimit_unlocked()
> 
> This really pushes the code into a new wrapper common to ipath/qib and
> any others that might want to combine locking with ulimit enforcement.
  We could do that but frankly, I'd rather change ulimit enforcement to not
require mmap_sem and use atomic counter instead. I'll see what I can do.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
