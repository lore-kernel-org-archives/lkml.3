Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaGORCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:02:46 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62265 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaGORCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:17 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Andreas Mohr <andi@lisas.de>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 58/94] i8k: Fix non-SMP operation
Date: Tue, 15 Jul 2014 20:01:13 +0300
Message-Id: <1405443709-15288-58-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

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
Cc: Andreas Mohr <andi@lisas.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/char/i8k.c |    4 +++-
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
1.7.10.4

