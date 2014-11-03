Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaKCRGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:06:23 -0500
Received: from mail-la0-f73.google.com ([209.85.215.73]:58766 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaKCRGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:06:16 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2014 12:06:16 EST
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] mm: alloc_contig_range: demote pages busy message from warn to info
Date: Mon,  3 Nov 2014 17:57:53 +0100
Message-Id: <1415033873-28569-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <2457604.k03RC2Mv4q@avalon>
References: <2457604.k03RC2Mv4q@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having test_pages_isolated failure message as a warning confuses
users into thinking that it is more serious than it really is.  In
reality, if called via CMA, allocation will be retried so a single
test_pages_isolated failure does not prevent allocation from
succeeding.

Demote the warning message to an info message and reformat it such
that the text “failed” does not appear and instead a less worrying
“PFNS busy” is used.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 mm/page_alloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 372e3f3..e2731eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6431,13 +6431,12 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, false)) {
-		pr_warn("alloc_contig_range test_pages_isolated(%lx, %lx) failed\n",
-		       outer_start, end);
+		pr_info("%s: [%lx, %lx) PFNs busy\n",
+			__func__, outer_start, end);
 		ret = -EBUSY;
 		goto done;
 	}
 
-
 	/* Grab isolated pages from freelists. */
 	outer_end = isolate_freepages_range(&cc, outer_start, end);
 	if (!outer_end) {
-- 
2.1.0.rc2.206.gedb03e5

