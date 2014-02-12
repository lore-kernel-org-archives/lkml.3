Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaBLP6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:58:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48827 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaBLP56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:57:58 -0500
Date: Wed, 12 Feb 2014 16:57:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-edac@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac, poll timeout cannot be zero
Message-ID: <20140212155752.GF5121@pd.tnic>
References: <1391457913-881-1-git-send-email-prarit@redhat.com>
 <20140212150748.GE5121@pd.tnic>
 <20140212151657.GL24490@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140212151657.GL24490@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:16:57AM -0500, Tejun Heo wrote:
> No, you don't need to.  All workqueue operations should be able to
> synchronize with each other.

Ok.

> > Or does this mean that once the work is getting queued from the timer
> > callback delayed_work_timer_fn, it cannot be cancelled anymore? Or
> > something else I'm missing...?
> 
> Looking at edac_mc_workq_setup().... it contains INIT_DELAYED_WORK().
> Does this race with other workqueue operations on the work item?  If
> so, it of course breaks.  It's like doing spin_lock_init() while other
> spinlock operations are in progress.

Ha, so this sounds like the issue because the splat happens
when updating /sys/.../edac_mc_poll_msec and it goes and calls
edac_mc_workq_setup()...

And this code is pretty old and edac_mc_workq_setup() is used both
when one inits an edac driver and also when one wants to change the
polling period (edac_mc_reset_delay_period) and thus needs to mod the
workqueue's timeout.

So I'm guessing a simple fix would be to differentiate between the two
paths, something like the diff below.

Or is there a reliable way to check whether a workqueue has been
initialized already, say, something like

	if (work->func)

or so... I.e., what PREPARE_WORK() does?

Thanks!

---
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index e8c9ef03495b..17c51d3a1143 100644
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
 
@@ -611,7 +614,7 @@ void edac_mc_reset_delay_period(int value)
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		edac_mc_workq_setup(mci, (unsigned long) value);
+		edac_mc_workq_setup(mci, (unsigned long) value, false);
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
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
