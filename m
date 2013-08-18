Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3HRUk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:40:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab3HRUfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 37/45] PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()
Date: Sun, 18 Aug 2013 13:36:26 -0700
Message-Id: <20130818203623.570687116@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 40fea92ffb5fa0ef26d10ae0fe5688bc8e61c791 upstream.

pm_qos_update_request_timeout() updates a qos and then schedules
a delayed work item to bring the qos back down to the default
after the timeout. When the work item runs, pm_qos_work_fn() will
call pm_qos_update_request() and deadlock because it tries to
cancel itself via cancel_delayed_work_sync(). Future callers of
that qos will also hang waiting to cancel the work that is
canceling itself. Let's extract the little bit of code that does
the real work of pm_qos_update_request() and call it from the
work function so that we don't deadlock.

Before ed1ac6e (PM: don't use [delayed_]work_pending()) this didn't
happen because the work function wouldn't try to cancel itself.

[backport to 3.10 - gregkh]

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/qos.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -293,6 +293,15 @@ int pm_qos_request_active(struct pm_qos_
 }
 EXPORT_SYMBOL_GPL(pm_qos_request_active);
 
+static void __pm_qos_update_request(struct pm_qos_request *req,
+			   s32 new_value)
+{
+	if (new_value != req->node.prio)
+		pm_qos_update_target(
+			pm_qos_array[req->pm_qos_class]->constraints,
+			&req->node, PM_QOS_UPDATE_REQ, new_value);
+}
+
 /**
  * pm_qos_work_fn - the timeout handler of pm_qos_update_request_timeout
  * @work: work struct for the delayed work (timeout)
@@ -305,7 +314,7 @@ static void pm_qos_work_fn(struct work_s
 						  struct pm_qos_request,
 						  work);
 
-	pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
+	__pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
 }
 
 /**
@@ -365,6 +374,8 @@ void pm_qos_update_request(struct pm_qos
 		pm_qos_update_target(
 			pm_qos_array[req->pm_qos_class]->constraints,
 			&req->node, PM_QOS_UPDATE_REQ, new_value);
+
+	__pm_qos_update_request(req, new_value);
 }
 EXPORT_SYMBOL_GPL(pm_qos_update_request);
 


