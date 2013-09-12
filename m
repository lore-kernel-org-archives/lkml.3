Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab3ILSTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:19:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab3ILSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 05/16] target: Fix se_cmd->state_list leak regression during WRITE failure
Date: Thu, 12 Sep 2013 11:14:57 -0700
Message-Id: <20130912181156.795744516@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit c130480b129fbfd7932ad7af3f4ffcea630b027f upstream.

This patch addresses a v3.11 specific regression where se_cmd->state_list
was being leaked during a fabric WRITE failure, when the fabric releases
an associated se_cmd descriptor before I/O submission occurs, and normal
fast path callbacks have a chance to call target_remove_from_state_list().

It was manifesting with Poison overwritten messages with iscsi-target
once an ImmediateData payload CRC32C failure occured.

This bug was originally introduced during v3.11-rc1 with the following
commit:

commit 0b66818ac6de67a6125ae203272fb76e79b3a20f
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Thu Jun 6 01:36:41 2013 -0700

    target: Drop unnecessary CMD_T_DEV_ACTIVE check from transport_lun_remove_cmd

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2134,6 +2134,7 @@ static void transport_write_pending_qf(s
 
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
+	unsigned long flags;
 	int ret = 0;
 
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
@@ -2144,6 +2145,16 @@ int transport_generic_free_cmd(struct se
 	} else {
 		if (wait_for_tasks)
 			transport_wait_for_tasks(cmd);
+		/*
+		 * Handle WRITE failure case where transport_generic_new_cmd()
+		 * has already added se_cmd to state_list, but fabric has
+		 * failed command before I/O submission.
+		 */
+		if (cmd->state_active) {
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
+			target_remove_from_state_list(cmd);
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		}
 
 		if (cmd->se_lun)
 			transport_lun_remove_cmd(cmd);


