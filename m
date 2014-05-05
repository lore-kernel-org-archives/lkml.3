Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaEETNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:13:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:7335 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751720AbaEETNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:13:45 -0400
Date: Mon, 5 May 2014 15:13:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Weijie Yang <weijieut@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] swap: change swap_list_head to plist, add
 swap_avail_head
Message-ID: <20140505191341.GA18397@home.goodmis.org>
References: <1397336454-13855-1-git-send-email-ddstreet@ieee.org>
 <1399057350-16300-1-git-send-email-ddstreet@ieee.org>
 <1399057350-16300-5-git-send-email-ddstreet@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399057350-16300-5-git-send-email-ddstreet@ieee.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 03:02:30PM -0400, Dan Streetman wrote:
> Originally get_swap_page() started iterating through the singly-linked
> list of swap_info_structs using swap_list.next or highest_priority_index,
> which both were intended to point to the highest priority active swap
> target that was not full.  The first patch in this series changed the
> singly-linked list to a doubly-linked list, and removed the logic to start
> at the highest priority non-full entry; it starts scanning at the highest
> priority entry each time, even if the entry is full.
> 
> Replace the manually ordered swap_list_head with a plist, renamed to
> swap_active_head for clarity.  Add a new plist, swap_avail_head.
> The original swap_active_head plist contains all active swap_info_structs,
> as before, while the new swap_avail_head plist contains only
> swap_info_structs that are active and available, i.e. not full.
> Add a new spinlock, swap_avail_lock, to protect the swap_avail_head list.
> 
> Mel Gorman suggested using plists since they internally handle ordering
> the list entries based on priority, which is exactly what swap was doing
> manually.  All the ordering code is now removed, and swap_info_struct
> entries and simply added to their corresponding plist and automatically
> ordered correctly.
> 
> Using a new plist for available swap_info_structs simplifies and
> optimizes get_swap_page(), which no longer has to iterate over full
> swap_info_structs.  Using a new spinlock for swap_avail_head plist
> allows each swap_info_struct to add or remove themselves from the
> plist when they become full or not-full; previously they could not
> do so because the swap_info_struct->lock is held when they change
> from full<->not-full, and the swap_lock protecting the main
> swap_active_head must be ordered before any swap_info_struct->lock.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Shaohua Li <shli@fusionio.com>
> 
> ---
> 
> Mel, I tried moving the ordering and rotating code into common list functions
> and I also tried plists, and you were right, using plists is much simpler and
> more maintainable.  The only required update to plist is the plist_rotate()
> function, which is even simpler to use in get_swap_page() than the
> list_rotate_left() function.
> 
> After looking more closely at plists, I don't see how they would reduce
> performance, so I don't think there is any concern there, although Shaohua if
> you have time it might be nice to check this updated patch set's performance.
> I will note that if CONFIG_DEBUG_PI_LIST is set, there's quite a lot of list
> checking going on for each list modification including rotate; that config is
> set if "RT Mutex debugging, deadlock detection" is set, so I assume in that
> case overall system performance is expected to be less than optimal.

I know Peter Zijlstra was doing some work to convert the rtmutex code to use
rb-trees instead of plists. Peter is that moving forward?

If there are other users of plists we should remove the dependency from the 
DEBUG_RT_MUTEX and DEBUG_PI_LIST.

> 
> Also, I might have over-commented in this patch; if so I can remove/reduce
> some of it. :)

"over-commented"?? There's no such word ;-)

-- Steve

