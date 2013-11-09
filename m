Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab3KIHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:16:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab3KIGv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.11 32/94] SCSI: sd: call blk_pm_runtime_init before add_disk
Date: Fri,  8 Nov 2013 22:51:38 -0800
Message-Id: <20131109065206.511780269@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 10c580e4239df5c3344ca00322eca86ab2de880b upstream.

Sujit has found a race condition that would make q->nr_pending
unbalanced, it occurs as Sujit explained:

"
sd_probe_async() ->
	add_disk() ->
		disk_add_event() ->
			schedule(disk_events_workfn)
	sd_revalidate_disk()
	blk_pm_runtime_init()
return;

Let's say the disk_events_workfn() calls sd_check_events() which tries
to send test_unit_ready() and because of sd_revalidate_disk() trying to
send another commands the test_unit_ready() might be re-queued as the
tagged command queuing is disabled.

So the race condition is -

Thread 1 			  |		Thread 2
sd_revalidate_disk()		  |	sd_check_events()
...nr_pending = 0 as q->dev = NULL|	scsi_queue_insert()
blk_runtime_pm_init()		  | 	blk_pm_requeue_request() ->
				  |	nr_pending = -1 since
				  |	q->dev != NULL
"

The problem is, the test_unit_ready request doesn't get counted the
first time it is queued, so the later decrement of q->nr_pending in
blk_pm_requeue_request makes it unbalanced.

Fix this by calling blk_pm_runtime_init before add_disk so that all
requests initiated there will all be counted.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Reported-and-tested-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2853,6 +2853,7 @@ static void sd_probe_async(void *data, a
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
 	}
 
+	blk_pm_runtime_init(sdp->request_queue, dev);
 	add_disk(gd);
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
@@ -2861,7 +2862,6 @@ static void sd_probe_async(void *data, a
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
-	blk_pm_runtime_init(sdp->request_queue, dev);
 	scsi_autopm_put_device(sdp);
 	put_device(&sdkp->dev);
 }


