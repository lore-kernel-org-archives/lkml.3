Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbaJXR3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:29:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:3987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbaJXR3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,781,1406617200"; 
   d="scan'208";a="610739371"
From: Imre Deak <imre.deak@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] PM / Sleep: fix async suspend_late/freeze_late error handling
Date: Fri, 24 Oct 2014 20:29:09 +0300
Message-Id: <1414171750-6858-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1414137549-30005-1-git-send-email-imre.deak@intel.com>
References: <1414137549-30005-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an asynchronous suspend_late or freeze_late callback fails
during the SUSPEND, FREEZE or QUIESCE phases we don't propagate the
corresponding error correctly, in effect ignoring the error and
continuing the suspend-to-ram/hibernation. During suspend-to-ram this
could leave some devices without a valid saved context, leading to a
failure to reinitialize them during resume. During hibernation this
could leave some devices active interfeering with the creation /
restoration of the hibernation image. Also this could leave the
corresponding devices without a valid saved context and failure to
reinitialize them during resume.

v3 (added to patchset):
- split out this fix into a separate patch (Rafael)

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/base/power/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 4497319..9717d5f 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1266,6 +1266,8 @@ int dpm_suspend_late(pm_message_t state)
 	}
 	mutex_unlock(&dpm_list_mtx);
 	async_synchronize_full();
+	if (!error)
+		error = async_error;
 	if (error) {
 		suspend_stats.failed_suspend_late++;
 		dpm_save_failed_step(SUSPEND_SUSPEND_LATE);
-- 
1.8.4

