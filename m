Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaCaA07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:26:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36271 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matt Turner" <mattst88@gmail.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.329551007@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 070/200] alpha: fix broken network checksum
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/alpha/lib/csum_partial_copy.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/alpha/lib/csum_partial_copy.c
+++ b/arch/alpha/lib/csum_partial_copy.c
@@ -373,6 +373,11 @@ csum_partial_copy_from_user(const void _
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

