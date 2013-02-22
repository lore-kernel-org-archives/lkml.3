Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3BVEhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:37:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40023 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3BVEhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:37:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,713,1355068800"; 
   d="scan'208";a="6747661"
Message-ID: <5126F5BD.1030602@cn.fujitsu.com>
Date: Fri, 22 Feb 2013 12:36:13 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kexec: fix memory leak in function kimage_normal_alloc
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/22 12:37:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/22 12:37:06,
	Serialize complete at 2013/02/22 12:37:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kimage_normal_alloc() fails to alloc pages for image->swap_page, it
should call kimage_free_page_list() to free allocated pages in
image->control_pages list before it frees image.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/kexec.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 5e4bd78..a57face 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -223,6 +223,8 @@ out:
 
 }
 
+static void kimage_free_page_list(struct list_head *list);
+
 static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 				unsigned long nr_segments,
 				struct kexec_segment __user *segments)
@@ -248,22 +250,22 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		printk(KERN_ERR "Could not allocate control_code_buffer\n");
-		goto out;
+		goto out_free;
 	}
 
 	image->swap_page = kimage_alloc_control_pages(image, 0);
 	if (!image->swap_page) {
 		printk(KERN_ERR "Could not allocate swap buffer\n");
-		goto out;
+		goto out_free;
 	}
 
-	result = 0;
- out:
-	if (result == 0)
-		*rimage = image;
-	else
-		kfree(image);
+	*rimage = image;
+	return 0;
 
+out_free:
+	kimage_free_page_list(&image->control_pages);
+	kfree(image);
+out:
 	return result;
 }
 
-- 
1.7.1
