Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954AbaKLBrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:47:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921AbaKLBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:47:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 180/203] PM / Sleep: fix recovery during resuming from hibernation
Date: Wed, 12 Nov 2014 10:17:30 +0900
Message-Id: <20141112011550.942216322@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 94fb823fcb4892614f57e59601bb9d4920f24711 upstream.

If a device's dev_pm_ops::freeze callback fails during the QUIESCE
phase, we don't rollback things correctly calling the thaw and complete
callbacks. This could leave some devices in a suspended state in case of
an error during resuming from hibernation.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/hibernate.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -492,8 +492,14 @@ int hibernation_restore(int platform_mod
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


