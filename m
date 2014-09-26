Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbaIZK2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:28:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbaIZJqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 059/142] Drivers: scsi: storvsc: Filter commands based on the storage protocol version
Date: Fri, 26 Sep 2014 11:44:30 +0200
Message-Id: <158cfff2650f44280bc5a0a68eec0d3a8c36c8f8.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8caf92d80526f3d7cc96831ec18b384ebcaccdf0 upstream.

Going forward it is possible that some of the commands that are not currently
implemented will be implemented on future Windows hosts. Even if they are not
implemented, we are told the host will corrrectly handle unsupported
commands (by returning appropriate return code and sense information).
Make command filtering depend on the host version.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/storvsc_drv.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a14a1f7cd577..4bae90722ad2 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1564,9 +1564,19 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
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
2.1.0

