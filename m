Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaDAQNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:13:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44523 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaDAQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:13:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ales Novak <alnovak@suse.cz>, Thomas Abraham <tabraham@suse.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 69/86] [SCSI] storvsc: NULL pointer dereference fix
Date: Tue,  1 Apr 2014 09:08:22 -0700
Message-Id: <1396368519-12728-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ales Novak <alnovak@suse.cz>

commit b12bb60d6c350b348a4e1460cd68f97ccae9822e upstream.

If the initialization of storvsc fails, the storvsc_device_destroy()
causes NULL pointer dereference.

storvsc_bus_scan()
  scsi_scan_target()
    __scsi_scan_target()
      scsi_probe_and_add_lun(hostdata=NULL)
        scsi_alloc_sdev(hostdata=NULL)

	  sdev->hostdata = hostdata

	  now the host allocation fails

          __scsi_remove_device(sdev)

	  calls sdev->host->hostt->slave_destroy() ==
	  storvsc_device_destroy(sdev)
	    access of sdev->hostdata->request_mempool

Signed-off-by: Ales Novak <alnovak@suse.cz>
Signed-off-by: Thomas Abraham <tabraham@suse.com>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/storvsc_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 0374eee..a05f122 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1141,6 +1141,9 @@ static void storvsc_device_destroy(struct scsi_device *sdevice)
 {
 	struct stor_mem_pools *memp = sdevice->hostdata;
 
+	if (!memp)
+		return;
+
 	mempool_destroy(memp->request_mempool);
 	kmem_cache_destroy(memp->request_pool);
 	kfree(memp);
-- 
1.8.3.2

