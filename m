Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaDAMIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:08:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaDALQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 043/144] iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
Date: Tue,  1 Apr 2014 12:14:07 +0100
Message-Id: <1396350948-29910-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit a2a99cea5ec7c1e47825559f0e75a4efbcf8aee3 upstream.

This patch fixes a bug in iscsit_get_tpg_from_np() where the
tpg->tpg_state sanity check was looking for TPG_STATE_FREE,
instead of != TPG_STATE_ACTIVE.

The latter is expected during a normal TPG shutdown once the
tpg_state goes into TPG_STATE_INACTIVE in order to reject any
new incoming login attempts.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target_tpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 439260b..f31b4c5 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -138,7 +138,7 @@ struct iscsi_portal_group *iscsit_get_tpg_from_np(
 	list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
 
 		spin_lock(&tpg->tpg_state_lock);
-		if (tpg->tpg_state == TPG_STATE_FREE) {
+		if (tpg->tpg_state != TPG_STATE_ACTIVE) {
 			spin_unlock(&tpg->tpg_state_lock);
 			continue;
 		}
-- 
1.9.1

