Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaBGLbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:31:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41176 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaBGLZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:25:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Matt Turner <mattst88@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 75/88] alpha: fix broken network checksum
Date: Fri,  7 Feb 2014 11:23:12 +0000
Message-Id: <1391772205-22239-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0ef38d70d4118b2ce1a538d14357be5ff9dc2bbd upstream.

The patch 3ddc5b46a8e90f3c9251338b60191d0a804b0d92 breaks networking on
alpha (there is a follow-up fix 5cfe8f1ba5eebe6f4b6e5858cdb1a5be4f3272a6,
but networking is still broken even with the second patch).

The patch 3ddc5b46a8e90f3c9251338b60191d0a804b0d92 makes
csum_partial_copy_from_user check the pointer with access_ok. However,
csum_partial_copy_from_user is called also from csum_partial_copy_nocheck
and csum_partial_copy_nocheck is called on kernel pointers and it is
supposed not to check pointer validity.

This bug results in ssh session hangs if the system is loaded and bulk
data are printed to ssh terminal.

This patch fixes csum_partial_copy_nocheck to call set_fs(KERNEL_DS), so
that access_ok in csum_partial_copy_from_user accepts kernel-space
addresses.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/alpha/lib/csum_partial_copy.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/lib/csum_partial_copy.c b/arch/alpha/lib/csum_partial_copy.c
index 40736da..1d2ef5a 100644
--- a/arch/alpha/lib/csum_partial_copy.c
+++ b/arch/alpha/lib/csum_partial_copy.c
@@ -373,6 +373,11 @@ csum_partial_copy_from_user(const void __user *src, void *dst, int len,
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
 {
-	return csum_partial_copy_from_user((__force const void __user *)src,
-			dst, len, sum, NULL);
+	__wsum checksum;
+	mm_segment_t oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	checksum = csum_partial_copy_from_user((__force const void __user *)src,
+						dst, len, sum, NULL);
+	set_fs(oldfs);
+	return checksum;
 }
-- 
1.8.3.2

