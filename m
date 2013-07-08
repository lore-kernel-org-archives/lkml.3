Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3GHVoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 17:44:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:2182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3GHVoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 17:44:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1022,1363158000"; 
   d="scan'208";a="328410507"
Subject: [PATCH] x86: perf: fix incorrect use of do_div() in nmi warning
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 08 Jul 2013 14:44:04 -0700
Message-Id: <20130708214404.B0B6EA66@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This fixes a bug present in 3.10 and introduced here:

commit 2ab00456ea8a0d79acb1390659b98416111880b2
Author: Dave Hansen <dave.hansen@linux.intel.com>
Date:   Fri Jun 21 08:51:35 2013 -0700

    x86: Warn when NMI handlers take large amounts of time

I completely botched understanding the calling conventions of
do_div().  I assumed that do_div() returned the result instead
of realizing that it modifies its argument and returns a
remainder.  The side-effect from this would be bogus numbers
for the "msecs" value in the warning messages:

	INFO: NMI handler (perf_event_nmi_handler) took too long to run: 0.114 msecs

Note, there was a second fix posted by Stephane Eranian for
a separate patch which I also botched:

	http://lkml.kernel.org/r/20130704223010.GA30625@quad

Both of these fixes need to get pulled in to Linus's tree and
the 3.10 stable tree.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Cc: x86@kernel.org
---

 linux.git-davehans/arch/x86/kernel/nmi.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/nmi.c~dave-is-stupid-do_div arch/x86/kernel/nmi.c
--- linux.git/arch/x86/kernel/nmi.c~dave-is-stupid-do_div	2013-07-08 13:10:55.498656504 -0700
+++ linux.git-davehans/arch/x86/kernel/nmi.c	2013-07-08 13:10:55.501656637 -0700
@@ -111,7 +111,7 @@ static int __kprobes nmi_handle(unsigned
 	 */
 	list_for_each_entry_rcu(a, &desc->head, list) {
 		u64 before, delta, whole_msecs;
-		int decimal_msecs, thishandled;
+		int remainder_ns, decimal_msecs, thishandled;
 
 		before = local_clock();
 		thishandled = a->handler(type, regs);
@@ -123,8 +123,9 @@ static int __kprobes nmi_handle(unsigned
 			continue;
 
 		nmi_longest_ns = delta;
-		whole_msecs = do_div(delta, (1000 * 1000));
-		decimal_msecs = do_div(delta, 1000) % 1000;
+		whole_msecs = delta;
+		remainder_ns = do_div(whole_msecs, (1000 * 1000));
+		decimal_msecs = remainder_ns / 1000;
 		printk_ratelimited(KERN_INFO
 			"INFO: NMI handler (%ps) took too long to run: "
 			"%lld.%03d msecs\n", a->handler, whole_msecs,
_
