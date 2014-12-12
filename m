Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbaLLGd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:33:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758029AbaLLGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Imre Deak" <imre.deak@intel.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.997828066@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 087/164] PM / Sleep: fix recovery during resuming from
 hibernation
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 94fb823fcb4892614f57e59601bb9d4920f24711 upstream.

If a device's dev_pm_ops::freeze callback fails during the QUIESCE
phase, we don't rollback things correctly calling the thaw and complete
callbacks. This could leave some devices in a suspended state in case of
an error during resuming from hibernation.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/power/hibernate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -503,8 +503,14 @@ int hibernation_restore(int platform_mod
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

