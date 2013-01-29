Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3A2XU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:20:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35212 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3A2XU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:20:26 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] PM / Hibernate: remove duplicate disable_nonboot_cpus()
Date: Tue, 29 Jan 2013 16:20:15 -0700
Message-Id: <1359501615-16435-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Within hibernate.c, hibernation_platform_enter() is only called from
power_down(), which in turn is only called by hibernate() after having
called hibernation_snapshot(), which in turn calls create_image() which
in turn calls disable_nonboot_cpus().

Elsewhere, snapshot_ioctl() allows hibernation_snapshot() and
hibernation_platform_enter() to be invoked via separate IOCTLs, but I
assume the rule is that SNAPSHOT_CREATE_IMAGE must be executed before
IOCTL SNAPSHOT_POWER_OFF, and hence the same ordering applies.

This means that disable_nonboot_cpus() must have been called already
before hibernation_platform_enter() is entered, and hence the call there
is redundant, so remove it.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: I have compile-tested this on x86-64, but have not attempted to test
it in any way; I'm proposing this patch following code inspection.
---
 kernel/power/hibernate.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b26f5f1..4ddeacc 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -537,10 +537,6 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Platform_finish;
 
-	error = disable_nonboot_cpus();
-	if (error)
-		goto Platform_finish;
-
 	local_irq_disable();
 	syscore_suspend();
 	if (pm_wakeup_pending()) {
@@ -555,7 +551,6 @@ int hibernation_platform_enter(void)
  Power_up:
 	syscore_resume();
 	local_irq_enable();
-	enable_nonboot_cpus();
 
  Platform_finish:
 	hibernation_ops->finish();
-- 
1.7.10.4

