Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaFUPJM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 11:09:12 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58957 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaFUPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:09:11 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/5] i8k: Fix non-SMP operation
Date: Sat, 21 Jun 2014 08:08:08 -0700
Message-Id: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f36fdb9f0266 (i8k: Force SMM to run on CPU 0) adds support
for multi-core CPUs to the driver. Unfortunately, that causes it
to fail loading if compiled without SMP support, at least on
32 bit kernels. Kernel log shows "i8k: unable to get SMM Dell
signature", and function i8k_smm is found to return -EINVAL.

Testing revealed that the culprit is the missing return value check
of set_cpus_allowed_ptr.

Fixes: f36fdb9f0266 (i8k: Force SMM to run on CPU 0)
Reported-by: Jim Bos <jim876@xs4all.nl>
Tested-by: Jim Bos <jim876@xs4all.nl>
Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index d915707..93dcad0 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -138,7 +138,9 @@ static int i8k_smm(struct smm_regs *regs)
 	if (!alloc_cpumask_var(&old_mask, GFP_KERNEL))
 		return -ENOMEM;
 	cpumask_copy(old_mask, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current, cpumask_of(0));
+	rc = set_cpus_allowed_ptr(current, cpumask_of(0));
+	if (rc)
+		goto out;
 	if (smp_processor_id() != 0) {
 		rc = -EBUSY;
 		goto out;
-- 
1.9.1

