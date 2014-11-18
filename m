Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaKROXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:23:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbaKROKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 185/206] PM / Sleep: fix recovery during resuming from hibernation
Date: Tue, 18 Nov 2014 15:09:00 +0100
Message-Id: <f40d14580cb56b248d3e744b94c9324778983c19.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 94fb823fcb4892614f57e59601bb9d4920f24711 upstream.

If a device's dev_pm_ops::freeze callback fails during the QUIESCE
phase, we don't rollback things correctly calling the thaw and complete
callbacks. This could leave some devices in a suspended state in case of
an error during resuming from hibernation.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/power/hibernate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 0121dab83f43..7ef5244c3164 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -491,8 +491,14 @@ int hibernation_restore(int platform_mode)
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
2.1.3

