Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673AbaGXKKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:10:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934520AbaGXJr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian King <brking@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/128] ibmvscsi: Abort init sequence during error recovery
Date: Thu, 24 Jul 2014 10:45:13 +0100
Message-Id: <1406195177-8656-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 9ee755974bea2f9880e517ec985dc9dede1b3a36 upstream.

If a CRQ reset is triggered for some reason while in the middle
of performing VSCSI adapter initialization, we don't want to
call the done function for the initialization MAD commands as
this will only result in two threads attempting initialization
at the same time, resulting in failures.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index d0fa4b6c551f..1e29efc8271a 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -794,7 +794,8 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 				       evt->hostdata->dev);
 			if (evt->cmnd_done)
 				evt->cmnd_done(evt->cmnd);
-		} else if (evt->done)
+		} else if (evt->done && evt->crq.format != VIOSRP_MAD_FORMAT &&
+			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
 			evt->done(evt);
 		free_event_struct(&evt->hostdata->pool, evt);
 		spin_lock_irqsave(hostdata->host->host_lock, flags);
-- 
1.9.1

