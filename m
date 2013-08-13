Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3HMVMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:12:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58591 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3HMVMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:12:43 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH] PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()
Date: Tue, 13 Aug 2013 14:12:40 -0700
Message-Id: <1376428360-12560-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc2.15.g96cb27a
In-reply-to: <4423040.Ds5TZlivfo@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_qos_update_request_timeout() updates a qos and then schedules
a delayed work item to bring the qos back down to the default
after the timeout. When the work item runs, pm_qos_work_fn() will
call pm_qos_update_request() and deadlock because it tries to
cancel itself via cancel_delayed_work_sync(). Future callers of
that qos will also hang waiting to cancel the work that is
canceling itself. Let's extract the little bit of code that does
the real work of pm_qos_update_request() and call it from the
work function so that we don't deadlock.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/power/qos.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 06fe285..a394297 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -296,6 +296,17 @@ int pm_qos_request_active(struct pm_qos_request *req)
 }
 EXPORT_SYMBOL_GPL(pm_qos_request_active);
 
+static void __pm_qos_update_request(struct pm_qos_request *req,
+			   s32 new_value)
+{
+	trace_pm_qos_update_request(req->pm_qos_class, new_value);
+
+	if (new_value != req->node.prio)
+		pm_qos_update_target(
+			pm_qos_array[req->pm_qos_class]->constraints,
+			&req->node, PM_QOS_UPDATE_REQ, new_value);
+}
+
 /**
  * pm_qos_work_fn - the timeout handler of pm_qos_update_request_timeout
  * @work: work struct for the delayed work (timeout)
@@ -308,7 +319,7 @@ static void pm_qos_work_fn(struct work_struct *work)
 						  struct pm_qos_request,
 						  work);
 
-	pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
+	__pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
 }
 
 /**
@@ -364,12 +375,7 @@ void pm_qos_update_request(struct pm_qos_request *req,
 	}
 
 	cancel_delayed_work_sync(&req->work);
-
-	trace_pm_qos_update_request(req->pm_qos_class, new_value);
-	if (new_value != req->node.prio)
-		pm_qos_update_target(
-			pm_qos_array[req->pm_qos_class]->constraints,
-			&req->node, PM_QOS_UPDATE_REQ, new_value);
+	__pm_qos_update_request(req, new_value);
 }
 EXPORT_SYMBOL_GPL(pm_qos_update_request);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

