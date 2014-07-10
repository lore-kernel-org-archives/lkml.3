Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaGJFez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:34:55 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:38149
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaGJFd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:33:29 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH V2 3/8] Drivers: scsi: storvsc: Filter commands based on the storage protocol version
Date: Wed,  9 Jul 2014 23:33:47 -0700
Message-Id: <1404974032-5023-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404974032-5023-1-git-send-email-kys@microsoft.com>
References: <1404974008-4984-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going forward it is possible that some of the commands that are not currently
implemented will be implemented on future Windows hosts. Even if they are not
implemented, we are told the host will corrrectly handle unsupported
commands (by returning appropriate return code and sense information).
Make command filtering depend on the host version.

In this version of the patch I have addressed comments from
Christoph Hellwig <hch@infradead.org>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index cebcef7..8f8847e 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1553,9 +1553,19 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct vmscsi_request *vm_srb;
 	struct stor_mem_pools *memp = scmnd->device->hostdata;
 
-	if (!storvsc_scsi_cmd_ok(scmnd)) {
-		scmnd->scsi_done(scmnd);
-		return 0;
+	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
+		/*
+		 * On legacy hosts filter unimplemented commands.
+		 * Future hosts are expected to correctly handle
+		 * unsupported commands. Furthermore, it is
+		 * possible that some of the currently
+		 * unsupported commands maybe supported in
+		 * future versions of the host.
+		 */
+		if (!storvsc_scsi_cmd_ok(scmnd)) {
+			scmnd->scsi_done(scmnd);
+			return 0;
+		}
 	}
 
 	request_size = sizeof(struct storvsc_cmd_request);
-- 
1.7.4.1

