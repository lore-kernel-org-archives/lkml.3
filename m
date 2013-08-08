Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966332Ab3HHUOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:14:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44765 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966197Ab3HHUOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:01 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH] PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()
Date: Thu,  8 Aug 2013 13:13:57 -0700
Message-Id: <1375992837-1673-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc1.21.gfb56570
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_qos_update_request_timeout() updates a qos and then schedules
a delayed work item to bring the qos back down to the default
after the timeout. When the work item runs, pm_qos_work_fn() will
call pm_qos_update_request() and deadlock because it tries to
cancel itself via cancel_delayed_work_sync(). Future callers of
that qos will also hang waiting to cancel the work that is
canceling itself. Before ed1ac6e (PM: don't use
[delayed_]work_pending(), 2013-01-11) this didn't happen because
the work function wouldn't try to cancel itself.

Let's just do the little bit of pm_qos_update_request() here so
that we don't deadlock.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/power/qos.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 06fe285..d52d314 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -308,7 +308,11 @@ static void pm_qos_work_fn(struct work_struct *work)
 						  struct pm_qos_request,
 						  work);
 
-	pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
+	if (PM_QOS_DEFAULT_VALUE != req->node.prio)
+		pm_qos_update_target(
+				pm_qos_array[req->pm_qos_class]->constraints,
+				&req->node, PM_QOS_UPDATE_REQ,
+				PM_QOS_DEFAULT_VALUE);
 }
 
 /**
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

