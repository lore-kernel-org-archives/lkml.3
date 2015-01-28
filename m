Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbbA1Bjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:39:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbbA1Bil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 74/77] mm: page_alloc: abort fair zone allocation policy when remotes nodes are encountered
Date: Tue, 27 Jan 2015 17:27:52 -0800
Message-Id: <20150128012748.178691108@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit f7b5d647946aae1647bf5cd26c16b3a793c1ac49 upstream.

The purpose of numa_zonelist_order=zone is to preserve lower zones for
use with 32-bit devices.  If locality is preferred then the
numa_zonelist_order=node policy should be used.

Unfortunately, the fair zone allocation policy overrides this by
skipping zones on remote nodes until the lower one is found.  While this
makes sense from a page aging and performance perspective, it breaks the
expected zonelist policy.  This patch restores the expected behaviour
for zone-list ordering.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1980,7 +1980,7 @@ zonelist_scan:
 		 */
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
-				continue;
+				break;
 			if (atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]) <= 0)
 				continue;
 		}


