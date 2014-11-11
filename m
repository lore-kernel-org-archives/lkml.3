Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaKKLLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaKKLLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 136/170] PM / Sleep: fix recovery during resuming from hibernation
Date: Tue, 11 Nov 2014 11:08:15 +0000
Message-Id: <1415704129-12709-137-git-send-email-luis.henriques@canonical.com>
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

commit 94fb823fcb4892614f57e59601bb9d4920f24711 upstream.

If a device's dev_pm_ops::freeze callback fails during the QUIESCE
phase, we don't rollback things correctly calling the thaw and complete
callbacks. This could leave some devices in a suspended state in case of
an error during resuming from hibernation.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/power/hibernate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index fcc2611d3f14..286ef6072714 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -505,8 +505,14 @@ int hibernation_restore(int platform_mode)
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
 		error = resume_target_kernel(platform_mode);
-		dpm_resume_end(PMSG_RECOVER);
+		/*
+		 * The above should either succeed and jump to the new kernel,
+		 * or return with an error. Otherwise things are just
+		 * undefined, so let's be paranoid.
+		 */
+		BUG_ON(!error);
 	}
+	dpm_resume_end(PMSG_RECOVER);
 	pm_restore_gfp_mask();
 	ftrace_start();
 	resume_console();
-- 
2.1.0

