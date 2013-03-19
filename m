Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3CSGt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:49:29 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:59584 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3CSGt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:49:28 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH][RESEND] lib/kobject: save old kobject name when rename failure 
Date: Tue, 19 Mar 2013 14:49:16 +0800
Message-Id: <1363675756-31528-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031906-2966-0000-0000-000007093876
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Hao <haodong@linux.vnet.ibm.com>

Function kobject_set_name_vargs() was implemented to rename the existing kobject.
It depends on kvasprintf() which might return NULL, so it's possible that kobject name
becomes NULL and in that case we will lose the old name.

This patch restores the old name when kvasprintf() returns NULL.

Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
---
 lib/kobject.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index f7d9f31..6e0186f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -220,8 +220,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return 0;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	if (!kobj->name) {
+		kobj->name = old_name;
 		return -ENOMEM;
+	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))
-- 
1.7.9.5

