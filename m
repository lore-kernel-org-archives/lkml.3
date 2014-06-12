Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaFLFQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 01:16:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:51179 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaFLFQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:16:48 -0400
From: <Wei.Yang@windriver.com>
To: <horms@verge.net.au>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <wei.yang@windriver.com>
Subject: [PATCH v1] fs2dt: Refine kdump device_tree sort
Date: Thu, 12 Jun 2014 13:16:08 +0800
Message-ID: <1402550168-7826-1-git-send-email-Wei.Yang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Wei <Wei.Yang@windriver.com>

The commit b02d735bf was to rearrange the device-tree entries, and
assumed that these entries are sorted in the ascending order. but
acctually when I was validating kexec and kdump, the order of
serial node still is changed. We should not only compare the length
of directory name, but also compare the directory name, it would
ensure that the order of device node is really in ascending order.

Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
---
 kexec/fs2dt.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

		It is validated on Freescale t4240qds.

diff --git a/kexec/fs2dt.c b/kexec/fs2dt.c
index 1e5f074..0bffaf5 100644
--- a/kexec/fs2dt.c
+++ b/kexec/fs2dt.c
@@ -479,6 +479,9 @@ static int comparefunc(const struct dirent **dentry1,
 {
 	char *str1 = (*(struct dirent **)dentry1)->d_name;
 	char *str2 = (*(struct dirent **)dentry2)->d_name;
+	char* ptr1 = strchr(str1, '@');
+	char* ptr2 = strchr(str2, '@');
+	int len1, len2;
 
 	/*
 	 * strcmp scans from left to right and fails to idetify for some
@@ -486,9 +489,13 @@ static int comparefunc(const struct dirent **dentry1,
 	 * Therefore, we get the wrong sorted order like memory@10000000 and
 	 * memory@f000000.
 	 */
-	if (strchr(str1, '@') && strchr(str2, '@') &&
-		(strlen(str1) > strlen(str2)))
-		return 1;
+	if (ptr1 && ptr2) {
+		len1 = ptr1 - str1;
+		len2 = ptr2 - str2;
+		if (!strncmp(str1, str2, len1 >len2 ? len1: len2) &&
+					(strlen(str1) > strlen(str2)))
+				return 1;
+	}
 
 	return strcmp(str1, str2);
 }
-- 
1.7.9.5

