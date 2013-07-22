Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab3GVQNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:13:24 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43177 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab3GVQNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:15 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Keith Mannthey <keith.mannthey@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 41/48] staging/lustre/llite: error of listxattr when buffer is small
Date: Tue, 23 Jul 2013 00:07:02 +0800
Message-Id: <1374509230-3324-42-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Mannthey <keith.mannthey@intel.com>

According to the standard, listxattr(2) should return -1
and errno should be set to ERANGE if the size of the list
buffer is too small to hold the result. However ll_listxattr()
will return a value bigger than the size of buffer in some cases.

Let's assume listxattr(2) returns SIZE when it is called with a
large enough list buffer. If it's called again with a list buffer
whose size is smaller than SIZE but bigger than (SIZE - 12), then
listxattr(2) will return SIZE too. This patch fixes the problem.
Original patch by Li Xi <pkuelelixi@gmail.com>

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3403
Lustre-change: http://review.whamcloud.com/6463
Signed-off-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Li Xi <pkuelelixi@gmail.com>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/xattr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 0a11902..2e3ff6d 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -564,7 +564,12 @@ ssize_t ll_listxattr(struct dentry *dentry, char *buffer, size_t size)
 		const size_t name_len   = sizeof("lov") - 1;
 		const size_t total_len  = prefix_len + name_len + 1;
 
-		if (buffer && (rc + total_len) <= size) {
+		if (((rc + total_len) > size) && (buffer != NULL)) {
+			ptlrpc_req_finished(request);
+			return -ERANGE;
+		}
+
+		if (buffer != NULL) {
 			buffer += rc;
 			memcpy(buffer, XATTR_LUSTRE_PREFIX, prefix_len);
 			memcpy(buffer + prefix_len, "lov", name_len);
-- 
1.7.9.5

