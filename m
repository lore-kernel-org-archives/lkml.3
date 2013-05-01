Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160Ab3EAWSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:18:23 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51266 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669Ab3EAWRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:17:30 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 1/4] mmzone: make holding lock_memory_hotplug() a requirement for updating pgdat size
Date: Wed,  1 May 2013 15:17:12 -0700
Message-Id: <1367446635-12856-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-9360-0000-0000-000011FCD099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All updaters of pgdat size (spanned_pages, start_pfn, and
present_pages) currently also hold lock_memory_hotplug() (in addition
to pgdat_resize_lock()).

Document this and make holding of that lock a requirement on the update
side for now, but keep the pgdat_resize_lock() around for readers that
can't lock a mutex.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mmzone.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5c76737..09ac172 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -716,6 +716,9 @@ typedef struct pglist_data {
 	 * or node_spanned_pages stay constant.  Holding this will also
 	 * guarantee that any pfn_valid() stays that way.
 	 *
+	 * Updaters of any of these fields also must hold
+	 * lock_memory_hotplug().
+	 *
 	 * Nests above zone->lock and zone->size_seqlock.
 	 */
 	spinlock_t node_size_lock;
-- 
1.8.2.2

