Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbbANXew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:34:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbANXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:34:51 -0500
Date: Wed, 14 Jan 2015 15:34:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] vmscan: move reclaim_state handling to shrink_slab
Message-Id: <20150114153449.038bc61b1bd6fc262f9cea01@linux-foundation.org>
In-Reply-To: <1421243736-21367-1-git-send-email-vdavydov@parallels.com>
References: <1421243736-21367-1-git-send-email-vdavydov@parallels.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 16:55:36 +0300 Vladimir Davydov <vdavydov@parallels.com> wrote:

> current->reclaim_state is only used to count the number of slab pages
> reclaimed by shrink_slab(). So instead of initializing it before we are
> going to call try_to_free_pages() or shrink_zone(), let's set in
> directly in shrink_slab().
> 
> This patch also makes shrink_slab() return the number of reclaimed slab
> pages (obtained from reclaim_state) instead of the number of reclaimed
> objects, because the latter is not of much use - it was only checked by
> drop_slab() to decide whether it should continue reclaim or abort. The
> number of reclaimed pages is more appropriate, because it also can be
> used by shrink_zone() to accumulate scan_control->nr_reclaimed.

Not sure that this is a good change.  If shrink_slab() managed to free
some objects but didn't free any pages then that's a good sign that
additional calls to shrink_slab() *will* free some pages.  With this
change, drop_slab_node() can give up too early.

The general philosophy throughout here is: "pass it nr_to_scan, it
returns nr_scanned/nr_freed".  Switching the return value to
nr_pages_freed kinda breaks that paradigm.

> Note that after this patch try_to_free_mem_cgroup_pages() will count not
> only reclaimed user pages, but also slab pages, which is expected,
> because it can reclaim kmem from kmem-active sub cgroups.
> 
>  mm/page_alloc.c |    4 ---
>  mm/vmscan.c     |   73 ++++++++++++++++++++-----------------------------------
>  2 files changed, 27 insertions(+), 50 deletions(-)

That's nice though.


