Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3A0VrC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 16:47:02 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43310 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3A0VrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 16:47:00 -0500
Date: Sun, 27 Jan 2013 13:47:01 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Shaohua Li <shli@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Shaohua Li <shli@fusionio.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH next/mmotm] swap: add per-partition lock for swapfile fix
In-Reply-To: <20130127141253.GA27019@kernel.org>
Message-ID: <alpine.LNX.2.00.1301271341030.16981@eggly.anvils>
References: <5101FFF5.6030503@oracle.com> <20130125042512.GA32017@kernel.org> <alpine.LNX.2.00.1301261754530.7300@eggly.anvils> <20130127141253.GA27019@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had all cpus spinning in swap_info_get(), for the lock on an area
being swapped off: probably because get_swap_page() forgot to unlock.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/swapfile.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- mmotm.orig/mm/swapfile.c	2013-01-23 17:55:39.132447115 -0800
+++ mmotm/mm/swapfile.c	2013-01-27 10:41:45.000000000 -0800
@@ -470,10 +470,9 @@ swp_entry_t get_swap_page(void)
 		spin_unlock(&swap_lock);
 		/* This is called for allocating swap entry for cache */
 		offset = scan_swap_map(si, SWAP_HAS_CACHE);
-		if (offset) {
-			spin_unlock(&si->lock);
+		spin_unlock(&si->lock);
+		if (offset)
 			return swp_entry(type, offset);
-		}
 		spin_lock(&swap_lock);
 		next = swap_list.next;
 	}
