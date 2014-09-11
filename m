Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaIKNEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:04:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbaIKNEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Christoph Hellwig" <hch@lst.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Hannes Reinecke" <hare@suse.de>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.694198674@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 023/131] Drivers: scsi: storvsc: Implement a
 eh_timed_out handler
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 56b26e69c8283121febedd12b3cc193384af46b9 upstream.

On Azure, we have seen instances of unbounded I/O latencies. To deal with
this issue, implement handler that can reset the timeout. Note that the
host gaurantees that it will respond to each command that has been issued.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
[hch: added a better comment explaining the issue]
Signed-off-by: Christoph Hellwig <hch@lst.de>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/hv/storvsc_drv.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/hyperv.h>
+#include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -1129,6 +1130,16 @@ static void storvsc_command_completion(s
 	kmem_cache_free(host_dev->request_pool, cmd_request);
 }
 
+/*
+ * The host guarantees to respond to each command, although I/O latencies might
+ * be unbounded on Azure.  Reset the timer unconditionally to give the host a
+ * chance to perform EH.
+ */
+static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd *scmnd)
+{
+	return BLK_EH_RESET_TIMER;
+}
+
 static bool storvsc_check_scsi_cmd(struct scsi_cmnd *scmnd)
 {
 	bool allowed = true;
@@ -1305,6 +1316,7 @@ static struct scsi_host_template scsi_dr
 	.bios_param =		storvsc_get_chs,
 	.queuecommand =		storvsc_queuecommand,
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
+	.eh_timed_out =		storvsc_eh_timed_out,
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		1,

