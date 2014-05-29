Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaE2VXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:23:12 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63827 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaE2VXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:23:10 -0400
Message-ID: <1401398588.3645.60.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] vmalloc: use rcu list iterator to reduce vmap_area_lock
 contention
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Yao <ryao@gentoo.org>
Date: Thu, 29 May 2014 14:23:08 -0700
In-Reply-To: <20140529130544.56213f048f331723329ff828@linux-foundation.org>
References: <1401344554-3596-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <20140529130544.56213f048f331723329ff828@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 13:05 -0700, Andrew Morton wrote:
> On Thu, 29 May 2014 15:22:34 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > Richard Yao reported a month ago that his system have a trouble
> > with vmap_area_lock contention during performance analysis
> > by /proc/meminfo. Andrew asked why his analysis checks /proc/meminfo
> > stressfully, but he didn't answer it.
> > 
> > https://lkml.org/lkml/2014/4/10/416
> > 
> > Although I'm not sure that this is right usage or not, there is a solution
> > reducing vmap_area_lock contention with no side-effect. That is just
> > to use rcu list iterator in get_vmalloc_info(). This function only needs
> > values on vmap_area structure, so we don't need to grab a spinlock.
> 
> The mixture of rcu protection and spinlock protection for
> vmap_area_list is pretty confusing.  Are you able to describe the
> overall design here?  When and why do we use one versus the other?

The spinlock protects writers.

rcu can be used in this function because all RCU protocol is already
respected by writers, since Nick Piggin commit db64fe02258f1507e13fe5
("mm: rewrite vmap layer") back in linux-2.6.28

Specifically :
   insertions use list_add_rcu(), 
   deletions use list_del_rcu() and kfree_rcu().

Note the rb tree is not used from rcu reader (it would not be safe),
only the vmap_area_list has full RCU protection.

Note that __purge_vmap_area_lazy() already uses this rcu protection.

        rcu_read_lock();
        list_for_each_entry_rcu(va, &vmap_area_list, list) {
                if (va->flags & VM_LAZY_FREE) {
                        if (va->va_start < *start)
                                *start = va->va_start;
                        if (va->va_end > *end)
                                *end = va->va_end;
                        nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
                        list_add_tail(&va->purge_list, &valist);
                        va->flags |= VM_LAZY_FREEING;
                        va->flags &= ~VM_LAZY_FREE;
                }
        }
        rcu_read_unlock();


