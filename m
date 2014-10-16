Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaJPVAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:00:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47772 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaJPVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:00:48 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com
Cc: cl@linux.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        boris.ostrovsky@oracle.com
Subject: [PATCH] xen/time: Fix incorrect per_cpu accessor in xen_clocksource_read()
Date: Thu, 16 Oct 2014 17:02:15 -0400
Message-Id: <1413493335-6110-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 89cbc76768c2 ("x86: Replace __get_cpu_var uses") replaced
__get_cpu_var() with this_cpu_ptr() in xen_clocksource_read() in such a
way that instead of accessing a structure pointed to by a per-cpu pointer
we are trying to get to a per-cpu structure.

__this_cpu_read() of the pointer is the more appropriate accessor.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index a1d430b..f473d26 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -158,7 +158,7 @@ cycle_t xen_clocksource_read(void)
 	cycle_t ret;
 
 	preempt_disable_notrace();
-	src = this_cpu_ptr(&xen_vcpu->time);
+	src = &__this_cpu_read(xen_vcpu)->time;
 	ret = pvclock_clocksource_read(src);
 	preempt_enable_notrace();
 	return ret;
-- 
1.8.1.4

