Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbaBDVYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:24:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934691AbaBDVMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 3.13 123/140] alpha: fix broken network checksum
Date: Tue,  4 Feb 2014 13:11:50 -0800
Message-Id: <20140204211040.481103126@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/alpha/lib/csum_partial_copy.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/alpha/lib/csum_partial_copy.c
+++ b/arch/alpha/lib/csum_partial_copy.c
@@ -378,6 +378,11 @@ csum_partial_copy_from_user(const void _
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


