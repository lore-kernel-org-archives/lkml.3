Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaAMRBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:01:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaAMQB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shivaram U <shivaram.u@quadstor.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 043/208] qla2xxx: Fix schedule_delayed_work() for target timeout calculations
Date: Mon, 13 Jan 2014 15:58:04 +0000
Message-Id: <1389628849-1614-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaram Upadhyayula <shivaram.u@quadstor.com>

commit 63832aabec12a28a41a221773ab3819d30ba0a67 upstream.

This patch fixes two cases in qla_target.c code where the
schedule_delayed_work() value was being incorrectly calculated
from sess->expires - jiffies.

Signed-off-by: Shivaram U <shivaram.u@quadstor.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 83a8f7a..2a636c1 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -481,7 +481,7 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 		schedule_delayed_work(&tgt->sess_del_work, 0);
 	else
 		schedule_delayed_work(&tgt->sess_del_work,
-		    jiffies - sess->expires);
+		    sess->expires - jiffies);
 }
 
 /* ha->hardware_lock supposed to be held on entry */
@@ -560,13 +560,14 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess;
-	unsigned long flags;
+	unsigned long flags, elapsed;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	while (!list_empty(&tgt->del_sess_list)) {
 		sess = list_entry(tgt->del_sess_list.next, typeof(*sess),
 		    del_list_entry);
-		if (time_after_eq(jiffies, sess->expires)) {
+		elapsed = jiffies;
+		if (time_after_eq(elapsed, sess->expires)) {
 			qlt_undelete_sess(sess);
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
@@ -576,7 +577,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 			ha->tgt.tgt_ops->put_sess(sess);
 		} else {
 			schedule_delayed_work(&tgt->sess_del_work,
-			    jiffies - sess->expires);
+			    sess->expires - elapsed);
 			break;
 		}
 	}
-- 
1.8.3.2

