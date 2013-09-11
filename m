Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3IKCVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:21:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42925 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3IKCVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:21:40 -0400
From: Vaughan Cao <vaughan.cao@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: vaughan.cao@oracle.com
Subject: [PATCH v2] block: register_blkdev doesn't check name against NULL
Date: Wed, 11 Sep 2013 10:24:10 +0800
Message-Id: <1378866250-22679-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378809614-17490-1-git-send-email-vaughan.cao@oracle.com>
References: <1378809614-17490-1-git-send-email-vaughan.cao@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_blkdev(0, NULL) can result kernel Oops by copying from NULL
in strlcpy(). Fix it by checking NULL pointer at the beginning and
WARN when encountered in unregister_blkdev.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 block/genhd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index dadf42b..cca13e9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -287,6 +287,9 @@ int register_blkdev(unsigned int major, const char *name)
 	struct blk_major_name **n, *p;
 	int index, ret = 0;
 
+	if (!name)
+		return -EINVAL;
+
 	mutex_lock(&block_class_lock);
 
 	/* temporary */
@@ -348,7 +351,7 @@ void unregister_blkdev(unsigned int major, const char *name)
 	for (n = &major_names[index]; *n; n = &(*n)->next)
 		if ((*n)->major == major)
 			break;
-	if (!*n || strcmp((*n)->name, name)) {
+	if (!*n || !name || strcmp((*n)->name, name)) {
 		WARN_ON(1);
 	} else {
 		p = *n;
-- 
1.8.3.1

