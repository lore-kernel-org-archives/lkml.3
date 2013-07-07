Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3GGLxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 07:53:05 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40262 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3GGLxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 07:53:01 -0400
Subject: [PATCH] swap: warn when a swap area overflows the maximum size
 (resent)
From: Raymond Jennings <shentino@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <1373197450.26573.5.camel@warfang>
References: <1373197450.26573.5.camel@warfang>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Jul 2013 04:52:58 -0700
Message-ID: <1373197978.26573.7.camel@warfang>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silly me, wrong email address

On Sun, 2013-07-07 at 04:44 -0700, Raymond Jennings wrote:
swap: warn when a swap area overflows the maximum size

It is possible to swapon a swap area that is too big for the pte width
to handle.

Presently this failure happens silently.

Instead, emit a diagnostic to warn the user.

Signed-off-by: Raymond Jennings <shentino@gmail.com>
Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

----

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 36af6ee..5a4ce53 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1953,6 +1953,12 @@ static unsigned long read_swap_header(struct
swap_info_struct *p,
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
 			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
+	if (maxpages < swap_header->info.last_page) {
+		printk(KERN_WARNING
+		       "Truncating oversized swap area, only using %luk out of %luk
\n",
+		       maxpages << (PAGE_SHIFT - 10),
+		       swap_header->info.last_page << (PAGE_SHIFT - 10));
+	}
 	if (maxpages > swap_header->info.last_page) {
 		maxpages = swap_header->info.last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */

----

Testing results, root prompt commands and kernel log messages:

# lvresize /dev/system/swap --size 16G
# mkswap /dev/system/swap
# swapon /dev/system/swap

Jul  7 04:27:22 warfang kernel: Adding 16777212k swap
on /dev/mapper/system-swap.  Priority:-1 extents:1 across:16777212k 

# lvresize /dev/system/swap --size 16G
# mkswap /dev/system/swap
# swapon /dev/system/swap

Jul  7 04:27:22 warfang kernel: Truncating oversized swap area, only
using 33554432k out of 67108860k
Jul  7 04:27:22 warfang kernel: Adding 33554428k swap
on /dev/mapper/system-swap.  Priority:-1 extents:1 across:33554428k 


