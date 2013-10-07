Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3JGPia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:38:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:8855 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab3JGPi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:38:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1050,1371106800"; 
   d="scan'208";a="370914728"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Topic: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Index: AQHOv3vIHe5gOhmSsEGBHPLZHDmcI5nkkbDAgADFEYCABAwQUA==
Date: Mon, 7 Oct 2013 15:38:24 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B07B7@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211B0176@FMSMSX107.amr.corp.intel.com>
 <20131004183315.GA19557@quack.suse.cz>
In-Reply-To: <20131004183315.GA19557@quack.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch and the sibling ipath patch will nominally take the mmap_sem
> > twice where the old routine only took it once.   This is a performance
> > issue.
>   It will take mmap_sem only once during normal operation. Only if
> get_user_pages_unlocked() fail, we have to take mmap_sem again to undo
> the change of mm->pinned_vm.
> 
> > Is the intent here to deprecate get_user_pages()?

The old code looked like:
__qib_get_user_pages()
	(broken) ulimit test
             for (...)
		get_user_pages()

qib_get_user_pages()
	mmap_sem lock
	__qib_get_user_pages()
             mmap_sem() unlock

The new code is:

get_user_pages_unlocked()
	mmap_sem  lock
	get_user_pages()
	mmap_sem unlock

qib_get_user_pages()
	mmap_sem lock
             ulimit test and locked pages maintenance
             mmap_sem unlock
	for (...)
		get_user_pages_unlocked()

I count an additional pair of mmap_sem transactions in the normal case.

> 
> > Could the lock limit test be pushed into another version of the
> > wrapper so that there is only one set of mmap_sem transactions?
>   I'm sorry, I don't understand what you mean here...
> 

This is what I had in mind:

get_user_pages_ulimit_unlocked()
	mmap_sem  lock
	ulimit test and locked pages maintenance (from qib/ipath)
             for (...)
	       get_user_pages_unlocked()	
	mmap_sem unlock
	
qib_get_user_pages()
	get_user_pages_ulimit_unlocked()

This really pushes the code into a new wrapper common to ipath/qib and any others that might want to combine locking with ulimit enforcement.

Mike
