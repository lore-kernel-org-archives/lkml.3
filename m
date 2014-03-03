Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaCCS5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:57:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbaCCS5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:57:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Borislav Petkov <bp@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 66/67] EDAC: Correct workqueue setup path
Date: Mon,  3 Mar 2014 10:55:54 -0800
Message-Id: <1393872955-28810-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit cb6ef42e516cb8948f15e4b70dc03af8020050a2 upstream.

We're using edac_mc_workq_setup() both on the init path, when
we load an edac driver and when we change the polling period
(edac_mc_reset_delay_period) through /sys/.../edac_mc_poll_msec.

On that second path we don't need to init the workqueue which has been
initialized already.

Thanks to Tejun for workqueue insights.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1391457913-881-1-git-send-email-prarit@redhat.com
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/edac/edac_mc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index ab5341c..858945e 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -558,7 +558,8 @@ static void edac_mc_workq_function(struct work_struct *work_req)
  *
  *		called with the mem_ctls_mutex held
  */
-static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
+static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec,
+				bool init)
 {
 	edac_dbg(0, "\n");
 
@@ -566,7 +567,9 @@ static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
 	if (mci->op_state != OP_RUNNING_POLL)
 		return;
 
-	INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+	if (init)
+		INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+
 	mod_delayed_work(edac_workqueue, &mci->work, msecs_to_jiffies(msec));
 }
 
@@ -610,7 +613,7 @@ void edac_mc_reset_delay_period(unsigned long value)
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		edac_mc_workq_setup(mci, value);
+		edac_mc_workq_setup(mci, value, false);
 	}
 
 	mutex_unlock(&mem_ctls_mutex);
@@ -766,7 +769,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 		/* This instance is NOW RUNNING */
 		mci->op_state = OP_RUNNING_POLL;
 
-		edac_mc_workq_setup(mci, edac_mc_get_poll_msec());
+		edac_mc_workq_setup(mci, edac_mc_get_poll_msec(), true);
 	} else {
 		mci->op_state = OP_RUNNING_INTERRUPT;
 	}
-- 
1.8.3.2

