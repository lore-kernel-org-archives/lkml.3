Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbaJ1Dr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:47:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863AbaJ1Dr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:47:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John Soni Jose <sony.john-n@emulex.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 022/100] be2iscsi: check ip buffer before copying
Date: Tue, 28 Oct 2014 11:35:07 +0800
Message-Id: <20141028033501.623635825@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/be2iscsi/be_mgmt.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -897,17 +897,20 @@ mgmt_static_ip_modify(struct beiscsi_hba
 
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
@@ -935,7 +938,7 @@ static int mgmt_modify_gateway(struct be
 	req->action = gtway_action;
 	req->ip_addr.ip_type = BE2_IPV4;
 
-	memcpy(req->ip_addr.addr, gt_addr, param_len);
+	memcpy(req->ip_addr.addr, gt_addr, sizeof(req->ip_addr.addr));
 
 	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
 }


