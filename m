Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaGHXqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:46:36 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:56279
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbaGHXqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:46:33 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the storage protocol version
Date: Tue,  8 Jul 2014 17:46:46 -0700
Message-Id: <1404866812-26950-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going forward it is possible that some of the commands that are not currently
implemented will be implemented on future Windows hosts. Make command filtering
depend on the host version.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 2e4131c..759853c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1556,9 +1556,14 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct vmscsi_request *vm_srb;
 	struct stor_mem_pools *memp = scmnd->device->hostdata;
 
-	if (!storvsc_scsi_cmd_ok(scmnd)) {
-		scmnd->scsi_done(scmnd);
-		return 0;
+	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
+		/*
+		 * On legacy hosts filter unimplemented commands.
+		 */
+		if (!storvsc_scsi_cmd_ok(scmnd)) {
+			scmnd->scsi_done(scmnd);
+			return 0;
+		}
 	}
 
 	request_size = sizeof(struct storvsc_cmd_request);
-- 
1.7.4.1

