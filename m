Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaJ0S7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:59:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaJ0S7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:59:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 066/105] be2iscsi: check ip buffer before copying
Date: Mon, 27 Oct 2014 11:56:41 -0700
Message-Id: <1414436240-13879-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit a41a9ad3bbf61fae0b6bfb232153da60d14fdbd9 upstream.

Dan Carpenter found a issue where be2iscsi would copy the ip
from userspace to the driver buffer before checking the len
of the data being copied:
http://marc.info/?l=linux-scsi&m=140982651504251&w=2

This patch just has us only copy what we the driver buffer
can support.

Tested-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index b2fcac7..5bb9406 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -897,17 +897,20 @@ mgmt_static_ip_modify(struct beiscsi_hba *phba,
 
 	if (ip_action == IP_ACTION_ADD) {
 		memcpy(req->ip_params.ip_record.ip_addr.addr, ip_param->value,
-		       ip_param->len);
+		       sizeof(req->ip_params.ip_record.ip_addr.addr));
 
 		if (subnet_param)
 			memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
-			       subnet_param->value, subnet_param->len);
+			       subnet_param->value,
+			       sizeof(req->ip_params.ip_record.ip_addr.subnet_mask));
 	} else {
 		memcpy(req->ip_params.ip_record.ip_addr.addr,
-		       if_info->ip_addr.addr, ip_param->len);
+		       if_info->ip_addr.addr,
+		       sizeof(req->ip_params.ip_record.ip_addr.addr));
 
 		memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
-		       if_info->ip_addr.subnet_mask, ip_param->len);
+		       if_info->ip_addr.subnet_mask,
+		       sizeof(req->ip_params.ip_record.ip_addr.subnet_mask));
 	}
 
 	rc = mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
@@ -935,7 +938,7 @@ static int mgmt_modify_gateway(struct beiscsi_hba *phba, uint8_t *gt_addr,
 	req->action = gtway_action;
 	req->ip_addr.ip_type = BE2_IPV4;
 
-	memcpy(req->ip_addr.addr, gt_addr, param_len);
+	memcpy(req->ip_addr.addr, gt_addr, sizeof(req->ip_addr.addr));
 
 	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
 }
-- 
1.9.1

