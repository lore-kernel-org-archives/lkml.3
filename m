Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaLBRTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:19:16 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:45665 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLBRTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:19:14 -0500
Date: Tue, 2 Dec 2014 12:19:11 -0500
From: Tejun Heo <tj@kernel.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [PATCH percpu/for-3.18-fixes] s390: fix machine check regression
 caused by the conversion from __get_cpu_var() to this_cpu_ptr()
Message-ID: <20141202171911.GD10918@htj.dyndns.org>
References: <alpine.LFD.2.11.1411281544190.1648@denkbrett>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1411281544190.1648@denkbrett>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1bb43105791dae7e9d4d1b1047729b12c5d5c3be Mon Sep 17 00:00:00 2001
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Date: Fri, 28 Nov 2014 16:03:14 +0100

Commit eb7e7d766326 ("s390: Replace __get_cpu_var uses") broke machine
check handling.

We copy machine check information from per-cpu to a stack variable for
local processing. Next we should zap the per-cpu variable, not the
stack variable.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Fixes: eb7e7d766326 ("s390: Replace __get_cpu_var uses")
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Sorry about the delay.  Was on vacation.

Patch applied to percpu/for-3.18-fixes w/ minor updates to the patch
subject and description.  Will push out to Linus soon.

Thanks.

 arch/s390/kernel/nmi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index dd1c24c..3f51cf4 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -54,12 +54,8 @@ void s390_handle_mcck(void)
 	 */
 	local_irq_save(flags);
 	local_mcck_disable();
-	/*
-	 * Ummm... Does this make sense at all? Copying the percpu struct
-	 * and then zapping it one statement later?
-	 */
-	memcpy(&mcck, this_cpu_ptr(&cpu_mcck), sizeof(mcck));
-	memset(&mcck, 0, sizeof(struct mcck_struct));
+	mcck = *this_cpu_ptr(&cpu_mcck);
+	memset(this_cpu_ptr(&cpu_mcck), 0, sizeof(mcck));
 	clear_cpu_flag(CIF_MCCK_PENDING);
 	local_mcck_enable();
 	local_irq_restore(flags);
-- 
2.1.0

