Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445Ab3DDOAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:00:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:45444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760858Ab3DDOAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:00:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,408,1363158000"; 
   d="scan'208";a="313594994"
Message-ID: <515D87AA.4050604@intel.com>
Date: Thu, 04 Apr 2013 22:01:14 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] blk: start bypass mode in blk_unregister_queue
References: <1364308501-1640-1-git-send-email-aaron.lu@intel.com>
In-Reply-To: <1364308501-1640-1-git-send-email-aaron.lu@intel.com>
X-Forwarded-Message-Id: <1364308501-1640-1-git-send-email-aaron.lu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blk_register_queue, we will end bypass mode for the queue; but in
blk_unregister_queue, we didn't start bypass mode for it. This would
cause the WARN_ON_ONCE(q->bypass_depth < 0) to trigger if the queue gets
registered, unregistered and then again registered, e.g. unload scsi
cdrom module driver sr_mod and then reload it will trigger such a
warning.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 block/blk-sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6206a93..bd322a1 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -615,4 +615,6 @@ void blk_unregister_queue(struct gendisk *disk)
 	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 	kobject_put(&disk_to_dev(disk)->kobj);
+
+	blk_queue_bypass_start(q);
 }
-- 
1.8.1.5

