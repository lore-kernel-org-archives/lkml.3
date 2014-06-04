Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaFDPfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:35:50 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54108
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaFDPft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:35:49 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from the basic I/O timeout
Date: Wed,  4 Jun 2014 09:33:43 -0700
Message-Id: <1401899623-24194-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to derive the
FLUSH_TIMEOUT from the basic I/O timeout. However, this patch did not use the
basic I/O timeout of the device. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/sd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e9689d5..54150b1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -832,7 +832,9 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
-	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
+	int timeout = sdp->request_queue->rq_timeout;
+
+	rq->timeout = (timeout * SD_FLUSH_TIMEOUT_MULTIPLIER);
 	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
-- 
1.7.4.1

