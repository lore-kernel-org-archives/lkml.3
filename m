Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaAXCI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:08:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaAXCIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:08:02 -0500
Date: Thu, 23 Jan 2014 21:07:56 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Miller <davem@davemloft.net>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] ia64: validate user arguments in
 csum_partial_copy_from_user
In-Reply-To: <alpine.LRH.2.02.1401232047560.16873@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401232053400.16873@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401232043320.16873@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401232044180.16873@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401232045350.16873@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401232046500.16873@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401232047560.16873@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64: validate user arguments in csum_partial_copy_from_user

csum_partial_copy_from_user needs to validate that the argument points to
userspace and not kernelspace (see for example commit
3ddc5b46a8e90f3c9251338b60191d0a804b0d92). Consequently, we need to use
copy_from_user instead of __copy_from_user.

We also need to change csum_partial_copy_nocheck - this function is called
with src pointing to kernel space, so we call set_fs(KERNEL_DS) to prevent
copy_from_user from failing.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 arch/ia64/lib/csum_partial_copy.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6-ia64/arch/ia64/lib/csum_partial_copy.c
===================================================================
--- linux-2.6-ia64.orig/arch/ia64/lib/csum_partial_copy.c	2014-01-24 02:40:10.000000000 +0100
+++ linux-2.6-ia64/arch/ia64/lib/csum_partial_copy.c	2014-01-24 03:05:26.000000000 +0100
@@ -116,8 +116,12 @@ csum_partial_copy_from_user(const void _
 	 * scared.
 	 */
 
-	if (__copy_from_user(dst, src, len) != 0 && errp)
-		*errp = -EFAULT;
+	if (copy_from_user(dst, src, len) != 0) {
+		if (*errp)
+			*errp = -EFAULT;
+		memset(dst, 0, len);
+		return psum;
+	}
 
 	result = do_csum(dst, len);
 
@@ -133,8 +137,13 @@ EXPORT_SYMBOL(csum_partial_copy_from_use
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
 {
-	return csum_partial_copy_from_user((__force const void __user *)src,
-					   dst, len, sum, NULL);
+	__wsum checksum;
+	mm_segment_t oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	checksum = csum_partial_copy_from_user((__force const void __user *)src,
+					       dst, len, sum, NULL);
+	set_fs(oldfs);
+	return checksum;
 }
 
 EXPORT_SYMBOL(csum_partial_copy_nocheck);
