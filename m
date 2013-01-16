Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab3APQE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:04:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346Ab3APQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Boot <bootc@bootc.net>, Andy Grover <agrover@redhat.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 107/222] sbp-target: fix error path in sbp_make_tpg()
Date: Wed, 16 Jan 2013 13:55:07 -0200
Message-Id: <1358351822-7675-108-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Boot <bootc@bootc.net>

commit e1fe2060d7e8f58a69374135e32e90f0bb79a7fd upstream.

If the TPG memory is allocated successfully, but we fail further along
in the function, a dangling pointer to freed memory is left in the TPort
structure. This is mostly harmless, but does prevent re-trying the
operation without first removing the TPort altogether.

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/sbp/sbp_target.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 7e6136e..e935aaa 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2221,20 +2221,23 @@ static struct se_portal_group *sbp_make_tpg(
 	tport->mgt_agt = sbp_management_agent_register(tport);
 	if (IS_ERR(tport->mgt_agt)) {
 		ret = PTR_ERR(tport->mgt_agt);
-		kfree(tpg);
-		return ERR_PTR(ret);
+		goto out_free_tpg;
 	}
 
 	ret = core_tpg_register(&sbp_fabric_configfs->tf_ops, wwn,
 			&tpg->se_tpg, (void *)tpg,
 			TRANSPORT_TPG_TYPE_NORMAL);
-	if (ret < 0) {
-		sbp_management_agent_unregister(tport->mgt_agt);
-		kfree(tpg);
-		return ERR_PTR(ret);
-	}
+	if (ret < 0)
+		goto out_unreg_mgt_agt;
 
 	return &tpg->se_tpg;
+
+out_unreg_mgt_agt:
+	sbp_management_agent_unregister(tport->mgt_agt);
+out_free_tpg:
+	tport->tpg = NULL;
+	kfree(tpg);
+	return ERR_PTR(ret);
 }
 
 static void sbp_drop_tpg(struct se_portal_group *se_tpg)
-- 
1.7.9.5

