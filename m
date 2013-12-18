Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3LRWLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:11:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3LRVMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 24/78] futex: fix handling of read-only-mapped hugepages
Date: Wed, 18 Dec 2013 13:10:52 -0800
Message-Id: <20131218211112.584390752@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -287,7 +287,7 @@ again:
 		put_page(page);
 		/* serialize against __split_huge_page_splitting() */
 		local_irq_disable();
-		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
+		if (likely(__get_user_pages_fast(address, 1, !ro, &page) == 1)) {
 			page_head = compound_head(page);
 			/*
 			 * page_head is valid pointer but we must pin


