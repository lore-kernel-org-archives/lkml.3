Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbaBUAWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:22:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaBTXw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 78/82] target: Fix free-after-use regression in PR unregister
Date: Thu, 20 Feb 2014 15:53:01 -0800
Message-Id: <20140220235021.815936392@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pr.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2009,7 +2009,7 @@ core_scsi3_emulate_pro_register(struct s
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
 	sense_reason_t ret = TCM_NO_SENSE;
-	int pr_holder = 0;
+	int pr_holder = 0, type;
 
 	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
@@ -2131,6 +2131,7 @@ core_scsi3_emulate_pro_register(struct s
 			ret = TCM_RESERVATION_CONFLICT;
 			goto out;
 		}
+		type = pr_reg->pr_res_type;
 
 		spin_lock(&pr_tmpl->registration_lock);
 		/*
@@ -2161,6 +2162,7 @@ core_scsi3_emulate_pro_register(struct s
 		 * Release the calling I_T Nexus registration now..
 		 */
 		__core_scsi3_free_registration(cmd->se_dev, pr_reg, NULL, 1);
+		pr_reg = NULL;
 
 		/*
 		 * From spc4r17, section 5.7.11.3 Unregistering
@@ -2174,8 +2176,8 @@ core_scsi3_emulate_pro_register(struct s
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
@@ -2194,7 +2196,8 @@ core_scsi3_emulate_pro_register(struct s
 	ret = core_scsi3_update_and_write_aptpl(dev, aptpl);
 
 out:
-	core_scsi3_put_pr_reg(pr_reg);
+	if (pr_reg)
+		core_scsi3_put_pr_reg(pr_reg);
 	return ret;
 }
 


