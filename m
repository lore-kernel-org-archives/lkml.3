Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3BKULh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:11:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759326Ab3BKULf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:11:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ima: Do not try to fix hash if file system does not support security xattr
Date: Mon, 11 Feb 2013 15:11:32 -0500
Message-Id: <1360613493-11969-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfs_getxattr_alloc() returns -EOPNOTSUPP if filesystem does not have
security label enabled. In that case there is no point in continuing
further and try to fix hashes (if ima_appraise=fix was specified) as
that will fail too. Return early

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_appraise.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 2d4beca..3710f44 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -134,6 +134,10 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)&xattr_value,
 				0, GFP_NOFS);
 	if (rc <= 0) {
+		/* File system does not support security xattr */
+		if (rc == -EOPNOTSUPP)
+			return INTEGRITY_UNKNOWN;
+
 		if (rc && rc != -ENODATA)
 			goto out;
 
-- 
1.7.7.6

