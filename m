Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaFFOrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:47:02 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:53201 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbaFFOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:47:01 -0400
Date: Fri, 6 Jun 2014 09:46:57 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 5/8] slub: make slab_free non-preemptable
In-Reply-To: <7cd6784a36ed997cc6631615d98e11e02e811b1b.1402060096.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1406060942160.32229@gentwo.org>
References: <cover.1402060096.git.vdavydov@parallels.com> <7cd6784a36ed997cc6631615d98e11e02e811b1b.1402060096.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Vladimir Davydov wrote:

> This patch makes SLUB's implementation of kmem_cache_free
> non-preemptable. As a result, synchronize_sched() will work as a barrier
> against kmem_cache_free's in flight, so that issuing it before cache
> destruction will protect us against the use-after-free.


Subject: slub: reenable preemption before the freeing of slabs from slab_free

I would prefer to call the page allocator with preemption enabled if possible.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2014-05-29 11:45:32.065859887 -0500
+++ linux/mm/slub.c	2014-06-06 09:45:12.822480834 -0500
@@ -1998,6 +1998,7 @@
 	if (n)
 		spin_unlock(&n->list_lock);

+	preempt_enable();
 	while (discard_page) {
 		page = discard_page;
 		discard_page = discard_page->next;
@@ -2006,6 +2007,7 @@
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
+	preempt_disable();
 #endif
 }

