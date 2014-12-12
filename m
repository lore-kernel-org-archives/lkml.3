Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbaLLGWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:22:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51808 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759466AbaLLGRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mike Snitzer" <snitzer@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>,
        "Joe Thornber" <ejt@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.419802950@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 044/164] dm bufio: update last_accessed when relinking
 a buffer
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit eb76faf53b1ff7a77ce3f78cc98ad392ac70c2a0 upstream.

The 'last_accessed' member of the dm_buffer structure was only set when
the the buffer was created.  This led to each buffer being discarded
after dm_bufio_max_age time even if it was used recently.  In practice
this resulted in all thinp metadata being evicted soon after being read
-- this is particularly problematic for metadata intensive workloads
like multithreaded small random IO.

'last_accessed' is now updated each time the buffer is moved to the head
of the LRU list, so the buffer is now properly discarded if it was not
used in dm_bufio_max_age time.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-bufio.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -468,6 +468,7 @@ static void __relink_lru(struct dm_buffe
 	b->list_mode = dirty;
 	list_del(&b->lru_list);
 	list_add(&b->lru_list, &c->lru[dirty]);
+	b->last_accessed = jiffies;
 }
 
 /*----------------------------------------------------------------

