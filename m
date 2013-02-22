Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3BVEw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:52:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58591 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab3BVEw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:52:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,713,1355068800"; 
   d="scan'208";a="6747735"
Message-ID: <5126F92A.2030007@cn.fujitsu.com>
Date: Fri, 22 Feb 2013 12:50:50 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kexec: avoid freeing NULL pointer in function kimage_crash_alloc
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/22 12:51:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/22 12:51:43,
	Serialize complete at 2013/02/22 12:51:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though there is no error if we free a NULL pointer, I think we could
avoid this behaviour. Change the code a little in kimage_crash_alloc()
could avoid this kind of unnecessary free.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/kexec.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 5e4bd78..4e96fa7 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -310,7 +310,7 @@ static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
 		mend = mstart + image->segment[i].memsz - 1;
 		/* Ensure we are within the crash kernel limits */
 		if ((mstart < crashk_res.start) || (mend > crashk_res.end))
-			goto out;
+			goto out_free;
 	}
 
 	/*
@@ -323,16 +323,15 @@ static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		printk(KERN_ERR "Could not allocate control_code_buffer\n");
-		goto out;
+		goto out_free;
 	}
 
-	result = 0;
-out:
-	if (result == 0)
-		*rimage = image;
-	else
-		kfree(image);
+	*rimage = image;
+	return 0;
 
+out_free:
+	kfree(image);
+out:
 	return result;
 }
 
-- 
1.7.1
