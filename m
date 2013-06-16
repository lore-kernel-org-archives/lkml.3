Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3FPEqJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:46:09 -0400
Received: from ozlabs.org ([203.10.76.45]:59387 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab3FPEqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:46:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH 4/9] acpi: Replace weird use of PTR_RET.
Date: Sun, 16 Jun 2013 14:12:43 +0930
Message-Id: <1371357768-4968-4-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au>
 <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functions is really weird.  It sets rc to -ENOMEM, then overrides
it.  It was converted to PTR_RET in a1458187 when it should have
simply been rewritten.

This version makes it more explicit, with a single IS_ERR() test.

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/acpi/acpi_pad.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 27bb6a9..46e0b3c 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -231,16 +231,19 @@ static struct task_struct *ps_tsks[NR_CPUS];
 static unsigned int ps_tsk_num;
 static int create_power_saving_task(void)
 {
-	int rc = -ENOMEM;
+	int rc;
 
 	ps_tsks[ps_tsk_num] = kthread_run(power_saving_thread,
 		(void *)(unsigned long)ps_tsk_num,
 		"acpi_pad/%d", ps_tsk_num);
-	rc = PTR_RET(ps_tsks[ps_tsk_num]);
-	if (!rc)
-		ps_tsk_num++;
-	else
+
+	if (IS_ERR(ps_tsks[ps_tsk_num])) {
+		rc = PTR_ERR(ps_tsks[ps_tsk_num]);
 		ps_tsks[ps_tsk_num] = NULL;
+	} else {
+		rc = 0;
+		ps_tsk_num++;
+	}
 
 	return rc;
 }
-- 
1.8.1.2

