Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3JDS7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:59:06 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:38572
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3JDS7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:59:05 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org, eric@purestorage.com,
        nab@linux-iscsi.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: Derive the FLUSH_TIMEOUT from the basic I/O timeout
Date: Fri,  4 Oct 2013 12:38:36 -0700
Message-Id: <1380915516-28720-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having a separate constant for specifying the timeout on FLUSH
operations, use the basic I/O timeout value that is already configurable
on a per target basis to derive the FLUSH timeout. Looking at the current
definitions of these timeout values, the FLUSH operation is supposed to have
a value that is twice the normal timeout value. This patch preserves this
relationship while leveraging the flexibility of specifying the I/O timeout.

I would like to thank Eric Seppanen <eric@purestorage.com> and 
Nicholas A. Bellinger <nab@linux-iscsi.org> for their help in resolving
this issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/sd.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e62d17d..8aff306 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -829,7 +829,7 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
-	rq->timeout = SD_FLUSH_TIMEOUT;
+	rq->timeout *= 2;
 	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
@@ -1433,6 +1433,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
+	unsigned int timeout = sdp->request_queue->rq_timeout;
 	struct scsi_sense_hdr sshdr;
 
 	if (!scsi_device_online(sdp))
@@ -1448,7 +1449,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * flush everything.
 		 */
 		res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0,
-					     &sshdr, SD_FLUSH_TIMEOUT,
+					     &sshdr, timeout * 2,
 					     SD_MAX_RETRIES, NULL, REQ_PM);
 		if (res == 0)
 			break;
-- 
1.7.4.1

