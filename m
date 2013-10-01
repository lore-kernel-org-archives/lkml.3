Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3JALrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:47:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:40848 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab3JALrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:47:21 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@openvz.org>
Subject: [PATCH] mm: don't forget to free shrinker->nr_deferred
Date: Tue,  1 Oct 2013 15:47:47 +0400
Message-Id: <1380628067-923868-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This leak was added by v3.11-8748-g1d3d443 "vmscan: per-node deferred work"

unreferenced object 0xffff88006ada3bd0 (size 8):
  comm "criu", pid 14781, jiffies 4295238251 (age 105.641s)
  hex dump (first 8 bytes):
    00 00 00 00 00 00 00 00                          ........
  backtrace:
    [<ffffffff8170caee>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff811c0527>] __kmalloc+0x247/0x310
    [<ffffffff8117848c>] register_shrinker+0x3c/0xa0
    [<ffffffff811e115b>] sget+0x5ab/0x670
    [<ffffffff812532f4>] proc_mount+0x54/0x170
    [<ffffffff811e1893>] mount_fs+0x43/0x1b0
    [<ffffffff81202dd2>] vfs_kern_mount+0x72/0x110
    [<ffffffff81202e89>] kern_mount_data+0x19/0x30
    [<ffffffff812530a0>] pid_ns_prepare_proc+0x20/0x40
    [<ffffffff81083c56>] alloc_pid+0x466/0x4a0
    [<ffffffff8105aeda>] copy_process+0xc6a/0x1860
    [<ffffffff8105beab>] do_fork+0x8b/0x370
    [<ffffffff8105c1a6>] SyS_clone+0x16/0x20
    [<ffffffff8171f739>] stub_clone+0x69/0x90
    [<ffffffffffffffff>] 0xffffffffffffffff

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Glauber Costa <glommer@openvz.org>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index beb3577..fbd191a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -210,6 +210,8 @@ void unregister_shrinker(struct shrinker *shrinker)
 	down_write(&shrinker_rwsem);
 	list_del(&shrinker->list);
 	up_write(&shrinker_rwsem);
+
+	kfree(shrinker->nr_deferred);
 }
 EXPORT_SYMBOL(unregister_shrinker);
 
-- 
1.7.1

