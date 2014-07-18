Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbaGRND2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:03:28 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17236 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965413AbaGRNDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:03:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ulrich Obergfell <uobergfe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 062/170] scsi_error: fix invalid setting of host byte
Date: Fri, 18 Jul 2014 14:11:07 +0200
Message-Id: <ddefcdd6b6530ce870b66409a1d4a2eb34fd01ee.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8922a908908ff947f1f211e07e2e97f1169ad3cb upstream.

After scsi_try_to_abort_cmd returns, the eh_abort_handler may have
already found that the command has completed in the device, causing
the host_byte to be nonzero (e.g. it could be DID_ABORT).  When
this happens, ORing DID_TIME_OUT into the host byte will corrupt
the result field and initiate an unwanted command retry.

Fix this by using set_host_byte instead, following the model of
commit 2082ebc45af9c9c648383b8cde0dc1948eadbf31.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
[Fix all instances according to review comments. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 83e591b60193..9ba3642cb19e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -143,7 +143,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	else if (host->hostt->eh_timed_out)
 		rtn = host->hostt->eh_timed_out(scmd);
 
-	scmd->result |= DID_TIME_OUT << 16;
+	set_host_byte(scmd, DID_TIME_OUT);
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
-- 
2.0.0

