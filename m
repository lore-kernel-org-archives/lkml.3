Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaFEAEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:04:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaFDXW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arshad Hussain <arshad.hussain@calsoftinc.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 178/228] iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
Date: Wed,  4 Jun 2014 16:23:27 -0700
Message-Id: <20140604232353.737046035@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 7cbfcc953789ff864c2bf8365a82a3fba4869649 upstream.

This patch changes an incorrect use of BUG_ON to instead generate a
REJECT + PROTOCOL_ERROR in iscsit_process_nop_out() code.  This case
can occur with traditional TCP where a flood of zeros in the data
stream can reach this block for what is presumed to be a NOP-OUT with
a solicited reply, but without a valid iscsi_cmd pointer.

This incorrect BUG_ON was introduced during the v3.11-rc timeframe
with the following commit:

commit 778de368964c5b7e8100cde9f549992d521e9c89
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Fri Jun 14 16:07:47 2013 -0700

    iscsi/isert-target: Refactor ISCSI_OP_NOOP RX handling

Reported-by: Arshad Hussain <arshad.hussain@calsoftinc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1564,7 +1564,9 @@ int iscsit_process_nop_out(struct iscsi_
 	 * Initiator is expecting a NopIN ping reply..
 	 */
 	if (hdr->itt != RESERVED_ITT) {
-		BUG_ON(!cmd);
+		if (!cmd)
+			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
+						(unsigned char *)hdr);
 
 		spin_lock_bh(&conn->cmd_lock);
 		list_add_tail(&cmd->i_conn_node, &conn->conn_cmd_list);


