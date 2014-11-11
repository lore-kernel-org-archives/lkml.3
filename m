Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaKKLLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaKKLLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 135/170] PM / Sleep: fix async suspend_late/freeze_late error handling
Date: Tue, 11 Nov 2014 11:08:14 +0000
Message-Id: <1415704129-12709-136-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 246ef766743618a7cab059d6c4993270075b173e upstream.

If an asynchronous suspend_late or freeze_late callback fails
during the SUSPEND, FREEZE or QUIESCE phases, we don't propagate the
corresponding error correctly, in effect ignoring the error and
continuing the suspend-to-ram/hibernation. During suspend-to-ram this
could leave some devices without a valid saved context, leading to a
failure to reinitialize them during resume. During hibernation this
could leave some devices active interfeering with the creation /
restoration of the hibernation image. Also this could leave the
corresponding devices without a valid saved context and failure to
reinitialize them during resume.

Fixes: de377b397272 (PM / sleep: Asynchronous threads for suspend_late)
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/power/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bf412961a934..1f6da3ad6db0 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1262,6 +1262,8 @@ static int dpm_suspend_late(pm_message_t state)
 	}
 	mutex_unlock(&dpm_list_mtx);
 	async_synchronize_full();
+	if (!error)
+		error = async_error;
 	if (error) {
 		suspend_stats.failed_suspend_late++;
 		dpm_save_failed_step(SUSPEND_SUSPEND_LATE);
-- 
2.1.0

