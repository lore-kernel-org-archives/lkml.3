Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3K1JlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:41:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3K1JlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:41:05 -0500
Message-ID: <52970FAE.8020104@redhat.com>
Date: Thu, 28 Nov 2013 10:41:02 +0100
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] kobject: fix memory leak in kobject_set_name_vargs
References: <1385630354-6109-1-git-send-email-mlombard@redhat.com>
In-Reply-To: <1385630354-6109-1-git-send-email-mlombard@redhat.com>
X-Forwarded-Message-Id: <1385630354-6109-1-git-send-email-mlombard@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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



