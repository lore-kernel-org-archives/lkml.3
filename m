Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbaGABIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:08:00 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63574 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193AbaGABH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:07:56 -0400
Date: Mon, 30 Jun 2014 18:06:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next] mm: memcontrol: rewrite charge API: fix
 shmem_unuse
In-Reply-To: <20140630173428.5ebeed18.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.1406301805020.10594@eggly.anvils>
References: <alpine.LSU.2.11.1406301541420.4349@eggly.anvils> <20140630160212.46caf9c3d41445b61fece666@linux-foundation.org> <alpine.LSU.2.11.1406301658430.4898@eggly.anvils> <20140630173428.5ebeed18.akpm@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Andrew Morton wrote:
> On Mon, 30 Jun 2014 17:10:54 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > On Mon, 30 Jun 2014, Andrew Morton wrote:
> > > On Mon, 30 Jun 2014 15:48:39 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > > > -		return 0;
> > > > +		return -EAGAIN;
> > > 
> > > Maybe it's time to document the shmem_unuse_inode() return values.
> > 
> > Oh dear.  I had hoped they would look after themselves.  This one is a
> > private matter between shmem_unuse_inode and its one caller, just below.
> 
> Well, readers of shmem_unuse_inode() won't know that unless we tell them.

Add comments on the private use of -EAGAIN.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 3.16-rc2-mm1+/mm/shmem.c	2014-06-30 15:05:50.736335600 -0700
+++ linux/mm/shmem.c	2014-06-30 18:00:02.820584009 -0700
@@ -611,7 +611,7 @@ static int shmem_unuse_inode(struct shme
 	radswap = swp_to_radix_entry(swap);
 	index = radix_tree_locate_item(&mapping->page_tree, radswap);
 	if (index == -1)
-		return -EAGAIN;
+		return -EAGAIN;	/* tell shmem_unuse we found nothing */
 
 	/*
 	 * Move _head_ to start search for next from here.
@@ -712,6 +712,7 @@ int shmem_unuse(swp_entry_t swap, struct
 		cond_resched();
 		if (error != -EAGAIN)
 			break;
+		/* found nothing in this: move on to search the next */
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
 
