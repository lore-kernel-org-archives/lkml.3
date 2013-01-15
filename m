Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab3AOW2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:28:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:41364 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757609Ab3AOW2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chen Gang <gang.chen@asianux.com>, Chris Boot <bootc@bootc.net>,
        Andy Grover <agrover@redhat.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ 050/221] sbp-target: fix error path in sbp_make_tpg()
Date: Tue, 15 Jan 2013 10:49:37 -0800
Message-Id: <20130115185001.639180193@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/sbp/sbp_target.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2207,20 +2207,23 @@ static struct se_portal_group *sbp_make_
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


