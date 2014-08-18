Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaHRXUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 19:20:33 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55200 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbaHRXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:20:32 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andreas Mohr <andi@lisas.de>
Subject: i8k: Don't revert affinity in i8k_smm
Date: Tue, 19 Aug 2014 09:19:55 +1000
Message-ID: <1454445.ErZ3u1p0yH@hex>
User-Agent: KMail/4.13.3 (Linux/3.16.0-ck1; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1405443709-15288-58-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com> <1405443709-15288-58-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a followup to this discussion:

On Tue, 15 Jul 2014 08:01:13 PM Sam Asadi wrote:
> Commit f36fdb9f0266 (i8k: Force SMM to run on CPU 0) adds support
> for multi-core CPUs to the driver. Unfortunately, that causes it
> to fail loading if compiled without SMP support, at least on
> 32 bit kernels. Kernel log shows "i8k: unable to get SMM Dell
> signature", and function i8k_smm is found to return -EINVAL.
> 
> Testing revealed that the culprit is the missing return value check
> of set_cpus_allowed_ptr.

It appears that the original commit f36fdb9f0266 changes the affinity for the 
duration of i8k_smm function and then unconditionally reverts the affinity to 
the old cpu mask regardless of whether the function succeeds or fails. As this 
must run on CPU 0 at all times it does not make sense to revert the affinity at 
the end of the function. Proposed patch attached.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 drivers/char/i8k.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-3.16-ck1/drivers/char/i8k.c
===================================================================
--- linux-3.16-ck1.orig/drivers/char/i8k.c	2014-08-12 14:07:49.000000000 +1000
+++ linux-3.16-ck1/drivers/char/i8k.c	2014-08-19 09:09:57.939056696 +1000
@@ -132,12 +132,8 @@ static int i8k_smm(struct smm_regs *regs
 {
 	int rc;
 	int eax = regs->eax;
-	cpumask_var_t old_mask;
 
 	/* SMM requires CPU 0 */
-	if (!alloc_cpumask_var(&old_mask, GFP_KERNEL))
-		return -ENOMEM;
-	cpumask_copy(old_mask, &current->cpus_allowed);
 	rc = set_cpus_allowed_ptr(current, cpumask_of(0));
 	if (rc)
 		goto out;
@@ -203,8 +199,6 @@ static int i8k_smm(struct smm_regs *regs
 		rc = -EINVAL;
 
 out:
-	set_cpus_allowed_ptr(current, old_mask);
-	free_cpumask_var(old_mask);
 	return rc;
 }
 

-- 
-ck
