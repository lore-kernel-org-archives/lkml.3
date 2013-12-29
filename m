Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab3L2CsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:48:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55147 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab3L2CKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:22 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Darren Hart" <dvhart@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Mel Gorman" <mgorman@suse.de>, "Oleg Nesterov" <oleg@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.926384229@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 141/185] futex: fix handling of read-only-mapped hugepages
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit f12d5bfceb7e1f9051563381ec047f7f13956c3c upstream.

The hugepage code had the exact same bug that regular pages had in
commit 7485d0d3758e ("futexes: Remove rw parameter from
get_futex_key()").

The regular page case was fixed by commit 9ea71503a8ed ("futex: Fix
regression with read only mappings"), but the transparent hugepage case
(added in a5b338f2b0b1: "thp: update futex compound knowledge") case
remained broken.

Found by Dave Jones and his trinity tool.

Reported-and-tested-by: Dave Jones <davej@fedoraproject.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -285,7 +285,7 @@ again:
 		put_page(page);
 		/* serialize against __split_huge_page_splitting() */
 		local_irq_disable();
-		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
+		if (likely(__get_user_pages_fast(address, 1, !ro, &page) == 1)) {
 			page_head = compound_head(page);
 			/*
 			 * page_head is valid pointer but we must pin

