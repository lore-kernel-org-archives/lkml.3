Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaBUMvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbaBUMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 101/121] target: Fix free-after-use regression in PR unregister
Date: Fri, 21 Feb 2014 12:48:45 +0000
Message-Id: <1392986945-9693-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit fc09149df6e20cfbb0bb86f10899607c321a31eb upstream.

This patch addresses a >= v3.11 free-after-use regression
in core_scsi3_emulate_pro_register() that was introduced
in the following commit:

commit bc118fe4c4a8cfa453491ba77c0a146a6d0e73e0
Author: Andy Grover <agrover@redhat.com>
Date:   Thu May 16 10:41:04 2013 -0700

    target: Further refactoring of core_scsi3_emulate_pro_register()

To avoid the free-after-use, save an type value before hand, and
only call core_scsi3_put_pr_reg() with a valid *pr_reg.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_pr.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index adec5a8..3408fdd 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2009,7 +2009,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
 	sense_reason_t ret = TCM_NO_SENSE;
-	int pr_holder = 0;
+	int pr_holder = 0, type;
 
 	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
@@ -2131,6 +2131,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 			ret = TCM_RESERVATION_CONFLICT;
 			goto out;
 		}
+		type = pr_reg->pr_res_type;
 
 		spin_lock(&pr_tmpl->registration_lock);
 		/*
@@ -2161,6 +2162,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		 * Release the calling I_T Nexus registration now..
 		 */
 		__core_scsi3_free_registration(cmd->se_dev, pr_reg, NULL, 1);
+		pr_reg = NULL;
 
 		/*
 		 * From spc4r17, section 5.7.11.3 Unregistering
@@ -2174,8 +2176,8 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		 * RESERVATIONS RELEASED.
 		 */
 		if (pr_holder &&
-		    (pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY ||
-		     pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY)) {
+		    (type == PR_TYPE_WRITE_EXCLUSIVE_REGONLY ||
+		     type == PR_TYPE_EXCLUSIVE_ACCESS_REGONLY)) {
 			list_for_each_entry(pr_reg_p,
 					&pr_tmpl->registration_list,
 					pr_reg_list) {
@@ -2194,7 +2196,8 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	ret = core_scsi3_update_and_write_aptpl(dev, aptpl);
 
 out:
-	core_scsi3_put_pr_reg(pr_reg);
+	if (pr_reg)
+		core_scsi3_put_pr_reg(pr_reg);
 	return ret;
 }
 
-- 
1.9.0

