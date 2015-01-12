Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbbALSFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbbALSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 034/216] dcache: fix kmemcheck warning in switch_names
Date: Mon, 12 Jan 2015 18:02:31 +0000
Message-Id: <1421085933-32536-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 08d4f7722268755ee34ed1c9e8afee7dfff022bb upstream.

This patch fixes kmemcheck warning in switch_names. The function
switch_names swaps inline names of two dentries. It swaps full arrays
d_iname, no matter how many bytes are really used by the strings. Reading
data beyond string ends results in kmemcheck warning.

We fix the bug by marking both arrays as fully initialized.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/dcache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 1d8b6a310822..e43ac3ca37e6 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2436,6 +2436,8 @@ static void switch_names(struct dentry *dentry, struct dentry *target,
 			 */
 			unsigned int i;
 			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
+			kmemcheck_mark_initialized(dentry->d_iname, DNAME_INLINE_LEN);
+			kmemcheck_mark_initialized(target->d_iname, DNAME_INLINE_LEN);
 			if (!exchange) {
 				memcpy(dentry->d_iname, target->d_name.name,
 						target->d_name.len + 1);
-- 
2.1.4

