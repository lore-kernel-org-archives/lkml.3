Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbaGOXOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:14:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000AbaGOXNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jim Bos <jim876@xs4all.nl>, Guenter Roeck <linux@roeck-us.net>,
        Andreas Mohr <andi@lisas.de>
Subject: [PATCH 3.14 12/66] i8k: Fix non-SMP operation
Date: Tue, 15 Jul 2014 16:17:06 -0700
Message-Id: <20140715231702.615440815@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231702.156040999@linuxfoundation.org>
References: <20140715231702.156040999@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 6d827fbcc370ca259a2905309f64161ab7b10596 upstream.

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
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Andreas Mohr <andi@lisas.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/i8k.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -138,7 +138,9 @@ static int i8k_smm(struct smm_regs *regs
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


