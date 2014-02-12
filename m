Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaBLRXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:23:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51814 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaBLRW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:22:59 -0500
Date: Wed, 12 Feb 2014 18:22:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: linux-edac@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] EDAC: Correct workqueue setup path
Message-ID: <20140212172254.GI5121@pd.tnic>
References: <1391457913-881-1-git-send-email-prarit@redhat.com>
 <20140212150748.GE5121@pd.tnic>
 <20140212151657.GL24490@htj.dyndns.org>
 <20140212155752.GF5121@pd.tnic>
 <20140212162311.GB26809@htj.dyndns.org>
 <20140212163644.GG5121@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140212163644.GG5121@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We're using edac_mc_workq_setup() both on the init path, when
we load an edac driver and when we change the polling period
(edac_mc_reset_delay_period) through /sys/.../edac_mc_poll_msec.

On that second path we don't need to init the workqueue which has been
initialized already.

Thanks to Tejun for workqueue insights.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/edac/edac_mc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index aef5ec24908e..33edd6766344 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -559,7 +559,8 @@ static void edac_mc_workq_function(struct work_struct *work_req)
  *
  *		called with the mem_ctls_mutex held
  */
-static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
+static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec,
+				bool init)
 {
 	edac_dbg(0, "\n");
 
@@ -567,7 +568,9 @@ static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
 	if (mci->op_state != OP_RUNNING_POLL)
 		return;
 
-	INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+	if (init)
+		INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+
 	mod_delayed_work(edac_workqueue, &mci->work, msecs_to_jiffies(msec));
 }
 
@@ -611,7 +614,7 @@ void edac_mc_reset_delay_period(unsigned long value)
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		edac_mc_workq_setup(mci, value);
+		edac_mc_workq_setup(mci, value, false);
 	}
 
 	mutex_unlock(&mem_ctls_mutex);
@@ -782,7 +785,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 		/* This instance is NOW RUNNING */
 		mci->op_state = OP_RUNNING_POLL;
 
-		edac_mc_workq_setup(mci, edac_mc_get_poll_msec());
+		edac_mc_workq_setup(mci, edac_mc_get_poll_msec(), true);
 	} else {
 		mci->op_state = OP_RUNNING_INTERRUPT;
 	}
-- 
1.8.5.2.192.g7794a68

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
