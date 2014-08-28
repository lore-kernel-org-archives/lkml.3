Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaH1SgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaH1Sfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:35:52 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 04/97] mm: prevent setting of a value less than 0 to min_free_kbytes
Date: Thu, 28 Aug 2014 19:34:12 +0100
Message-Id: <1409250945-30874-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Han Pingtian <hanpt@linux.vnet.ibm.com>

commit da8c757b080ee84f219fa2368cb5dd23ac304fc0 upstream.

If echo -1 > /proc/vm/sys/min_free_kbytes, the system will hang.  Changing
proc_dointvec() to proc_dointvec_minmax() in the
min_free_kbytes_sysctl_handler() can prevent this to happen.

mhocko said:

: You can still do echo $BIG_VALUE > /proc/vm/sys/min_free_kbytes and make
: your machine unusable but I agree that proc_dointvec_minmax is more
: suitable here as we already have:
:
: 	.proc_handler   = min_free_kbytes_sysctl_handler,
: 	.extra1         = &zero,
:
: It used to work properly but then 6fce56ec91b5 ("sysctl: Remove references
: to ctl_name and strategy from the generic sysctl table") has removed
: sysctl_intvec strategy and so extra1 is ignored.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e0a9cf..bffedeb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5734,7 +5734,12 @@ module_init(init_per_zone_wmark_min)
 int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec(table, write, buffer, length, ppos);
+	int rc;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
 	if (write) {
 		user_min_free_kbytes = min_free_kbytes;
 		setup_per_zone_wmarks();
-- 
1.8.4.5

