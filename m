Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbaAGAKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:10:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbaAFWiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shivaram U <shivaram.u@quadstor.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 034/144] qla2xxx: Fix schedule_delayed_work() for target timeout calculations
Date: Mon,  6 Jan 2014 14:36:35 -0800
Message-Id: <20140106223746.300630915@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaram Upadhyayula <shivaram.u@quadstor.com>

commit 63832aabec12a28a41a221773ab3819d30ba0a67 upstream.

This patch fixes two cases in qla_target.c code where the
schedule_delayed_work() value was being incorrectly calculated
from sess->expires - jiffies.

Signed-off-by: Shivaram U <shivaram.u@quadstor.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_target.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -471,7 +471,7 @@ static void qlt_schedule_sess_for_deleti
 		schedule_delayed_work(&tgt->sess_del_work, 0);
 	else
 		schedule_delayed_work(&tgt->sess_del_work,
-		    jiffies - sess->expires);
+		    sess->expires - jiffies);
 }
 
 /* ha->hardware_lock supposed to be held on entry */
@@ -550,13 +550,14 @@ static void qlt_del_sess_work_fn(struct
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
@@ -566,7 +567,7 @@ static void qlt_del_sess_work_fn(struct
 			ha->tgt.tgt_ops->put_sess(sess);
 		} else {
 			schedule_delayed_work(&tgt->sess_del_work,
-			    jiffies - sess->expires);
+			    sess->expires - elapsed);
 			break;
 		}
 	}


