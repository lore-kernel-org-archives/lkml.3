Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaDNRXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:23:42 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:55752 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbaDNRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:23:41 -0400
Date: Mon, 14 Apr 2014 19:23:34 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/mempool: warn about __GFP_ZERO usage
Message-ID: <alpine.LFD.2.11.1404141918170.1561@denkbrett>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041417-5024-0000-0000-0000097C65F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recently found out the hard way, that using mempool_alloc together with
__GFP_ZERO is not a good idea since memory which comes from the pool of
preallocated elemtents is not zeroed. Fixing this doesn't seem to be trivial
since mempool is not aware of the size of the objects it manages.

Last time someone addressed this on lkml just the callers of mempool_alloc
were fixed which obviously didn't help new users of mempool...
How about the following patch?

Regards,
Sebastian
---

mm/mempool: warn about __GFP_ZERO usage

Memory obtained via mempool_alloc is not always zeroed even when
called with __GFP_ZERO. Add a note and VM_BUG_ON statement to make
that clear.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 mm/mempool.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -192,6 +192,7 @@ EXPORT_SYMBOL(mempool_resize);
  * returns NULL. Note that due to preallocation, this function
  * *never* fails when called from process contexts. (it might
  * fail if called from an IRQ context.)
+ * Note: using __GFP_ZERO is not supported.
  */
 void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
@@ -200,6 +201,7 @@ void * mempool_alloc(mempool_t *pool, gf
 	wait_queue_t wait;
 	gfp_t gfp_temp;
 
+	VM_BUG_ON(gfp_mask & __GFP_ZERO);
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */

