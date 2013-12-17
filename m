Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3LQSS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:18:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab3LQSP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 095/103] futex: fix handling of read-only-mapped hugepages
Date: Tue, 17 Dec 2013 18:13:24 +0000
Message-Id: <1387304012-23805-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/futex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f0ee318..e564a9a 100644
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
-- 
1.8.3.2

