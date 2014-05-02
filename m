Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaEBTDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:03:44 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:63927 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaEBTDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:03:41 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Cc: Dan Streetman <ddstreet@ieee.org>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Weijie Yang <weijieut@gmail.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/4] swap: simplify/fix swap_list handling and iteration
Date: Fri,  2 May 2014 15:02:26 -0400
Message-Id: <1399057350-16300-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397336454-13855-1-git-send-email-ddstreet@ieee.org>
References: <1397336454-13855-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This second iteration of this patchset adds two more patches, to add
functions to plist; those are the 2nd and 3rd patches.  The first patch
is unchanged functionally, it only has added/modified comments.  The last
patch is changed to use plists instead of regular lists, as it did before.


The logic controlling the singly-linked list of swap_info_struct entries
for all active, i.e. swapon'ed, swap targets is rather complex, because:
-it stores the entries in priority order
-there is a pointer to the highest priority entry
-there is a pointer to the highest priority not-full entry
-there is a highest_priority_index variable set outside the swap_lock
-swap entries of equal priority should be used equally

this complexity leads to bugs such as:
https://lkml.org/lkml/2014/2/13/181
where different priority swap targets are incorrectly used equally.

That bug probably could be solved with the existing singly-linked lists,
but I think it would only add more complexity to the already difficult
to understand get_swap_page() swap_list iteration logic.

The first patch changes from a singly-linked list to a doubly-linked
list using list_heads; the highest_priority_index and related code are
removed and get_swap_page() starts each iteration at the highest priority
swap_info entry, even if it's full.  While this does introduce
unnecessary list iteration (i.e. Schlemiel the painter's algorithm)
in the case where one or more of the highest priority entries are full,
the iteration and manipulation code is much simpler and behaves
correctly re: the above bug; and the fourth patch removes the unnecessary
iteration.

The second patch adds some minor plist helper functions; nothing new
really, just functions to match existing regular list functions.  These
are used by the next two patches.

The third patch adds plist_rotate(), which is used by get_swap_page()
in the next patch - it performs the rotating of same-priority entries
so that all equal-priority swap_info_structs get used equally.

The fourth patch converts the main list into a plist, and adds a new plist
that contains only swap_info entries that are both active and not full.
As Mel suggested using plists allows removing all the ordering code from
swap - plists handle ordering automatically.  The list naming is also
clarified now that there are two lists, with the original list changed
from swap_list_head to swap_active_head and the new list named
swap_avail_head.  A new spinlock is also added for the new list, so
swap_info entries can be added or removed from the new list immediately
as they become full or not full.



Dan Streetman (4):
  swap: change swap_info singly-linked list to list_head
  plist: add helper functions
  plist: add plist_rotate
  swap: change swap_list_head to plist, add swap_avail_head

 include/linux/plist.h    |  45 ++++++++++
 include/linux/swap.h     |   8 +-
 include/linux/swapfile.h |   2 +-
 lib/plist.c              |  48 ++++++++++
 mm/frontswap.c           |  13 +--
 mm/swapfile.c            | 223 ++++++++++++++++++++++++-----------------------
 6 files changed, 215 insertions(+), 124 deletions(-)

-- 
1.8.3.1

