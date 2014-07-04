Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbaGDWQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:16:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373AbaGDWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Santosh Kulkarni <santosh.kulkarni@calsoftinc.com>,
        Arshad Hussain <arshad.hussain@calsoftinc.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.15 02/66] iscsi-target: Avoid rejecting incorrect ITT for Data-Out
Date: Fri,  4 Jul 2014 15:14:01 -0700
Message-Id: <20140704221422.926016914@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 97c99b47ac58bacb7c09e1f47d5d184434f6b06a upstream.

This patch changes iscsit_check_dataout_hdr() to dump the incoming
Data-Out payload when the received ITT is not associated with a
WRITE, instead of calling iscsit_reject_cmd() for the non WRITE
ITT descriptor.

This addresses a bug where an initiator sending an Data-Out for
an ITT associated with a READ would end up generating a reject
for the READ, eventually resulting in list corruption.

Reported-by: Santosh Kulkarni <santosh.kulkarni@calsoftinc.com>
Reported-by: Arshad Hussain <arshad.hussain@calsoftinc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1309,7 +1309,7 @@ iscsit_check_dataout_hdr(struct iscsi_co
 	if (cmd->data_direction != DMA_TO_DEVICE) {
 		pr_err("Command ITT: 0x%08x received DataOUT for a"
 			" NON-WRITE command.\n", cmd->init_task_tag);
-		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR, buf);
+		return iscsit_dump_data_payload(conn, payload_length, 1);
 	}
 	se_cmd = &cmd->se_cmd;
 	iscsit_mod_dataout_timer(cmd);


