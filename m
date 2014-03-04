Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbaCDUIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:08:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381AbaCDUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Dr. Greg Wettstein" <greg@enjellic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 89/97] qla2xxx: Fix kernel panic on selective retransmission request
Date: Tue,  4 Mar 2014 12:04:42 -0800
Message-Id: <20140304200348.936191857@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Dr. Greg Wettstein" <greg@enjellic.com>

commit 6f58c780e5a5b43a6d2121e0d43cdcba1d3cc5fc upstream.

A selective retransmission request (SRR) is a fibre-channel
protocol control request which provides support for requesting
retransmission of a data sequence in response to an issue such as
frame loss or corruption.  These events are experienced
infrequently in fibre-channel based networks which makes
it difficult to test and assess codepaths which handle these
events.

We were fortunate enough, for some definition of fortunate, to
have a metro-area single-mode SAN link which, at 10 GBPS
sustained load levels, would consistently generate SRR's in
a SCST based target implementation using our SCST/in-kernel
Qlogic target interface driver.  In response to an SRR the
in-kernel Qlogic target driver immediately panics resulting
in a catastrophic storage failure for serviced initiators.

The culprit was a debug statement in the qla_target.c file which
does not verify that a pointer to the SCSI CDB is not null.
The unchecked pointer dereference results in the kernel panic
and resultant system failure.

The other two references to the SCSI CDB by the SRR handling code
use a ternary operator to verify a non-null pointer is being
acted on.  This patch simply adds a similar test to the implicated
debug statement.

This patch is a candidate for any stable kernel being maintained
since it addresses a potentially catastrophic event with
minimal downside.

Signed-off-by: Dr. Greg Wettstein <greg@enjellic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_target.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3339,7 +3339,8 @@ restart:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02c,
 		    "SRR cmd %p (se_cmd %p, tag %d, op %x), "
 		    "sg_cnt=%d, offset=%d", cmd, &cmd->se_cmd, cmd->tag,
-		    se_cmd->t_task_cdb[0], cmd->sg_cnt, cmd->offset);
+		    se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
+		    cmd->sg_cnt, cmd->offset);
 
 		qlt_handle_srr(vha, sctio, imm);
 


