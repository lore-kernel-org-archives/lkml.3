Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3GUQ3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 12:29:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46782 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3GUQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 12:29:30 -0400
Subject: mmotm: swap overflow warning patch: mangled description and
 missing review tag
From: Raymond Jennings <shentino@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Jul 2013 09:29:27 -0700
Message-ID: <1374424167.14112.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I checked the mmotm queue and it seems that my mid-air corrections got
the patch mangled when it was saved to your mail queue, and in addition
to a missing correction of a typo in my testing log, Rik van Riel's
Reviewed-By tag vanished

http://www.ozlabs.org/~akpm/mmotm/broken-out/swap-warn-when-a-swap-area-overflows-the-maximum-size.patch

If you could fix my test transcript and properly credit Rik for
reviewing my patch before you ship it to linus I'd appreciate it.

The correctly formatted patch and description with corrections and tags
follows:
----
From: Raymond Jennings <shentino@gmail.com>
Subject: swap: warn when a swap area overflows the maximum size

It is possible to swapon a swap area that is too big for the pte width
to handle.

Presently this failure happens silently.

Instead, emit a diagnostic to warn the user.

Testing results, root prompt commands and kernel log messages:

# lvresize /dev/system/swap --size 16G
# mkswap /dev/system/swap
# swapon /dev/system/swap

Jul  7 04:27:22 warfang kernel: Adding 16777212k swap
on /dev/mapper/system-swap.  Priority:-1 extents:1 across:16777212k 

# lvresize /dev/system/swap --size 64G
# mkswap /dev/system/swap
# swapon /dev/system/swap

Jul  7 04:27:22 warfang kernel: Truncating oversized swap area, only
using 33554432k out of 67108860k
Jul  7 04:27:22 warfang kernel: Adding 33554428k swap
on /dev/mapper/system-swap.  Priority:-1 extents:1 across:33554428k 

Signed-off-by: Raymond Jennings <shentino@gmail.com>
Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN
mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size
mm/swapfile.c
---
a/mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size
+++ a/mm/swapfile.c
@@ -1953,6 +1953,12 @@ static unsigned long read_swap_header(st
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
 			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
+	if (swap_header->info.last_page > maxpages) {
+		printk(KERN_WARNING
+			"Truncating oversized swap area, only using %luk out of %luk\n",
+			maxpages << (PAGE_SHIFT - 10),
+			swap_header->info.last_page << (PAGE_SHIFT - 10));
+	}
 	if (maxpages > swap_header->info.last_page) {
 		maxpages = swap_header->info.last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */


