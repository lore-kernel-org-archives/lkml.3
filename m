Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab3DBWMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:12:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab3DBWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Leung <jleung@curriegrad2004.ca>, Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 044/124] target: Fix RESERVATION_CONFLICT status regression for iscsi-target special case
Date: Tue,  2 Apr 2013 15:10:26 -0700
Message-Id: <20130402221109.332976937@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit f85eda8d75d37a3796cee7f5a906e50e3f13d9e1 upstream.

This patch fixes a regression introduced in v3.8-rc1 code where a failed
target_check_reservation() check in target_setup_cmd_from_cdb() was causing
an incorrect SAM_STAT_GOOD status to be returned during a WRITE operation
performed by an unregistered / unreserved iscsi initiator port.

This regression is only effecting iscsi-target due to a special case check
for TCM_RESERVATION_CONFLICT within iscsi_target_erl1.c:iscsit_execute_cmd(),
and was still correctly disallowing WRITE commands from backend submission
for unregistered / unreserved initiator ports, while returning the incorrect
SAM_STAT_GOOD status due to the missing SAM_STAT_RESERVATION_CONFLICT
assignment.

This regression was first introduced with:

commit de103c93aff0bed0ae984274e5dc8b95899badab
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Nov 6 12:24:09 2012 -0800

    target: pass sense_reason as a return value

Go ahead and re-add the missing SAM_STAT_RESERVATION_CONFLICT assignment
during a target_check_reservation() failure, so that iscsi-target code
sends the correct SCSI status.

All other fabrics using target_submit_cmd_*() with a RESERVATION_CONFLICT
call to transport_generic_request_failure() are not effected by this bug.

Reported-by: Jeff Leung <jleung@curriegrad2004.ca>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1136,8 +1136,10 @@ target_setup_cmd_from_cdb(struct se_cmd
 		return ret;
 
 	ret = target_check_reservation(cmd);
-	if (ret)
+	if (ret) {
+		cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
 		return ret;
+	}
 
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret)


