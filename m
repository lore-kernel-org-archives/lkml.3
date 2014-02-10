Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaBJUDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:03:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34903 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaBJTqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Matt Turner <mattst88@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 107/124] alpha: fix broken network checksum
Date: Mon, 10 Feb 2014 11:40:47 -0800
Message-Id: <1392061264-28124-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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

