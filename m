Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab3KHVQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 16:16:43 -0500
Received: from [77.240.181.54] ([77.240.181.54]:46723 "EHLO
	dhcp-27-189.brq.redhat.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757794Ab3KHVQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 16:16:40 -0500
X-Greylist: delayed 3589 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Nov 2013 16:16:39 EST
From: Maurizio Lombardi <mlombard@redhat.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kobject: fix memory leak in kobject_set_name_vargs
Date: Fri,  8 Nov 2013 15:28:25 +0100
Message-Id: <1383920905-13281-1-git-send-email-mlombard@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the call to kvasprintf fails then the old name of the object will be leaked,
this patch fixes the bug by restoring the old name before returning ENOMEM.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 lib/kobject.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 5b4b888..c2cb934 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -247,8 +247,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
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
Maurizio Lombardi

