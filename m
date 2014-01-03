Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaACVA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 16:00:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaACVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 16:00:26 -0500
Date: Fri, 3 Jan 2014 13:00:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
 prep_new_page() race
Message-Id: <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
In-Reply-To: <20140103195547.GB26555@redhat.com>
References: <20131211191855.GA32485@redhat.com>
	<20131213151035.GE5408@redhat.com>
	<20131213162240.GA11762@redhat.com>
	<20131213173406.GG5408@redhat.com>
	<20131216183618.GA28252@redhat.com>
	<20131216201952.GE21218@redhat.com>
	<20131219190846.GA24566@redhat.com>
	<20131219190920.GB24566@redhat.com>
	<20131223114300.GC727@redhat.com>
	<20140103195519.GA26555@redhat.com>
	<20140103195547.GB26555@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014 20:55:47 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> compound_lock(). In theory this page_head can be already freed and
> reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> get_page_unless_zero() can succeed right after set_page_refcounted(),
> and compound_lock() can race with the non-atomic __SetPageHead().

Would be useful to mention that these things are happening inside
prep_compound_opage() (yes?).

> Perhaps we should rework the thp locking (under discussion), but
> until then this patch moves set_page_refcounted() and adds wmb()
> to ensure that page->_count != 0 comes as a last change.
> 
> I am not sure about other callers of set_page_refcounted(), but at
> first glance they look fine to me.

I don't get it.  We're in prep_new_page() - this page is freshly
allocated and no other thread yet has any means by which to look it up
and start fiddling with it?

