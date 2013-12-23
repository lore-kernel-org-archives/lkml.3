Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3LWLnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 06:43:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3LWLng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 06:43:36 -0500
Date: Mon, 23 Dec 2013 12:43:00 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 1/1] mm: fix the theoretical compound_lock() vs
 prep_new_page() race
Message-ID: <20131223114300.GC727@redhat.com>
References: <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de>
 <20131211175615.GA24546@redhat.com>
 <20131211191855.GA32485@redhat.com>
 <20131213151035.GE5408@redhat.com>
 <20131213162240.GA11762@redhat.com>
 <20131213173406.GG5408@redhat.com>
 <20131216183618.GA28252@redhat.com>
 <20131216201952.GE21218@redhat.com>
 <20131219190846.GA24566@redhat.com>
 <20131219190920.GB24566@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219190920.GB24566@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:09:20PM +0100, Oleg Nesterov wrote:
> get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> compound_lock(). In theory this page_head can be already freed and
> reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> get_page_unless_zero() can succeed right after set_page_refcounted(),
> and compound_lock() can race with the non-atomic __SetPageHead().
> 
> Perhaps we should rework the thp locking (under discussion), but
> until then this patch moves set_page_refcounted() and adds wmb()
> to ensure that page->_count != 0 comes as a last change.
> 
> I am not sure about other callers of set_page_refcounted(), but at
> first glance they look fine to me.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Andrea Arcangeli <aarcange@redhat.com>

Only one improvement possible, the smp_wmb() could have been put under
CONFIG_TRANSPARENT_HUGEPAGE somehow. No difference for x86-64 though.

Thanks,
Andrea
