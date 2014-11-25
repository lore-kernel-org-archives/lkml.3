Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaKYLj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:39:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbaKYLjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:39:55 -0500
Date: Tue, 25 Nov 2014 03:40:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Chanho Min" <chanho.min@lge.com>
Cc: "'Kirill A. Shutemov'" <kirill.shutemov@linux.intel.com>,
        "'Hugh Dickins'" <hughd@google.com>, "'Michal Hocko'" <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        "'HyoJun Im'" <hyojun.im@lge.com>, "'Gunho Lee'" <gunho.lee@lge.com>,
        "'Wonhong Kwon'" <wonhong.kwon@lge.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] mm: add parameter to disable faultaround
Message-Id: <20141125034016.5638d5e4.akpm@linux-foundation.org>
In-Reply-To: <547465d2.6561420a.04ed.0514SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1416898318-17409-1-git-send-email-chanho.min@lge.com>
	<20141124230502.30f9b6f0.akpm@linux-foundation.org>
	<547465d2.6561420a.04ed.0514SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 20:19:40 +0900 "Chanho Min" <chanho.min@lge.com> wrote:

> > > The faultaround improves the file read performance, whereas pages which
> > > can be dropped by drop_caches are reduced. On some systems, The amount of
> > > freeable pages under memory pressure is more important than read
> > > performance.
> > 
> > The faultaround pages *are* freeable.  Perhaps you meant "free" here.
> > 
> > Please tell us a great deal about the problem which you are trying to
> > solve.  What sort of system, what sort of workload, what is bad about
> > the behaviour which you are observing, etc.
> 
> We are trying to solve two issues.
> 
> We drop page caches by writing to /proc/sys/vm/drop_caches at specific point
> and make suspend-to-disk image. The size of this image is increased if faultaround
> is worked.

OK.

These pages are clean (mostly) and are mapped into process pagetables. 
Obviously mm/vmscan.c:shrink_all_memory() is not freeing these pages
prior to hibernating.

I forget what the policy/tuning is in this area.  IIRC, the intent of
shrink_all_memory() is to free up enough memory so that hibernation can
perform its function, rather than to explicitly reduce the size of the
image.

What I suggest you do is to take a look at how hibernation is calling
shrink_all_memory() and retune it so it shrinks a lot harder.  You may
want to disable swapping, or perhaps reduce it by performing one
shrink_all_memory() in the same way as at present, then perform a
second shrink_all_memory() more aggressively, but with
scan_control.may_swap=0.  The overall effect will be to make
hibernation tear down the process pagetable mappings and free these
pagecache pages before preparing the disk image.

If we can get this working then your hibernation image will be
significantly smaller than it is with this patch, because more pages
will be unmapped and freed.  There will of course be a lot of major
pagefaults after resume.  If that's a problem then perhaps we can tune
the second shrink_all_memory() pass to only unmap ptes for unreferenced
pages.

> Under memory pressure, we want to drop many page caches as possible.
> But, The number of dropped pages are reduced compared to non-faultaround kernel.

Again, why do you want to do this?  What problem is it solving?  I
assume you're using drop_caches for this as well?

Generally, any use of drop_caches is wrong, and indicates there's some
shortcoming in MM.

