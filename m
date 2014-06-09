Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712AbaFIXL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:11:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbaFIWpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 28/78] dm thin: add no_space_timeout dm-thin-pool module param
Date: Mon,  9 Jun 2014 15:48:08 -0700
Message-Id: <20140609224814.252926871@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 80c578930ce77ba8bcfb226a184b482020bdda7b upstream.

Commit 85ad643b ("dm thin: add timeout to stop out-of-data-space mode
holding IO forever") introduced a fixed 60 second timeout.  Users may
want to either disable or modify this timeout.

Allow the out-of-data-space timeout to be configured using the
'no_space_timeout' dm-thin-pool module param.  Setting it to 0 will
disable the timeout, resulting in IO being queued until more data space
is added to the thin-pool.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/device-mapper/thin-provisioning.txt |    5 ++++-
 drivers/md/dm-thin.c                              |   12 +++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -309,7 +309,10 @@ ii) Status
     error_if_no_space|queue_if_no_space
 	If the pool runs out of data or metadata space, the pool will
 	either queue or error the IO destined to the data device.  The
-	default is to queue the IO until more space is added.
+	default is to queue the IO until more space is added or the
+	'no_space_timeout' expires.  The 'no_space_timeout' dm-thin-pool
+	module parameter can be used to change this timeout -- it
+	defaults to 60 seconds but may be disabled using a value of 0.
 
 iii) Messages
 
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -25,7 +25,9 @@
 #define MAPPING_POOL_SIZE 1024
 #define PRISON_CELLS 1024
 #define COMMIT_PERIOD HZ
-#define NO_SPACE_TIMEOUT (HZ * 60)
+#define NO_SPACE_TIMEOUT_SECS 60
+
+static unsigned no_space_timeout_secs = NO_SPACE_TIMEOUT_SECS;
 
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(snapshot_copy_throttle,
 		"A percentage of time allocated for copy on write");
@@ -1529,6 +1531,7 @@ static void set_pool_mode(struct pool *p
 	struct pool_c *pt = pool->ti->private;
 	bool needs_check = dm_pool_metadata_needs_check(pool->pmd);
 	enum pool_mode old_mode = get_pool_mode(pool);
+	unsigned long no_space_timeout = ACCESS_ONCE(no_space_timeout_secs) * HZ;
 
 	/*
 	 * Never allow the pool to transition to PM_WRITE mode if user
@@ -1591,8 +1594,8 @@ static void set_pool_mode(struct pool *p
 		pool->process_prepared_mapping = process_prepared_mapping;
 		pool->process_prepared_discard = process_prepared_discard_passdown;
 
-		if (!pool->pf.error_if_no_space)
-			queue_delayed_work(pool->wq, &pool->no_space_timeout, NO_SPACE_TIMEOUT);
+		if (!pool->pf.error_if_no_space && no_space_timeout)
+			queue_delayed_work(pool->wq, &pool->no_space_timeout, no_space_timeout);
 		break;
 
 	case PM_WRITE:
@@ -3326,6 +3329,9 @@ static void dm_thin_exit(void)
 module_init(dm_thin_init);
 module_exit(dm_thin_exit);
 
+module_param_named(no_space_timeout, no_space_timeout_secs, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(no_space_timeout, "Out of data space queue IO timeout in seconds");
+
 MODULE_DESCRIPTION(DM_NAME " thin provisioning target");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");


