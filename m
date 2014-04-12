Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbaDLVD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 17:03:29 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38852 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaDLVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 17:03:27 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Cc: Dan Streetman <ddstreet@ieee.org>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Weijie Yang <weijieut@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] swap: simplify/fix swap_list handling and iteration
Date: Sat, 12 Apr 2014 17:00:52 -0400
Message-Id: <1397336454-13855-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <alpine.LSU.2.11.1402232344280.1890@eggly.anvils>
References: <alpine.LSU.2.11.1402232344280.1890@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
correctly re: the above bug; and the second patch removes the unnecessary
iteration.

The second patch adds a new list that contains only swap_info entries
that are both active and not full, and a new spinlock to protect it.
This allows swap_info entries to be added or removed from the new list
immediately as they become full or not full.


Dan Streetman (2):
  swap: change swap_info singly-linked list to list_head
  swap: use separate priority list for available swap_infos

 include/linux/swap.h     |   8 +--
 include/linux/swapfile.h |   2 +-
 mm/frontswap.c           |  13 ++---
 mm/swapfile.c            | 212 ++++++++++++++++++++++++++++++++++---------------------------------
 4 files changed, 114 insertions(+), 121 deletions(-)
