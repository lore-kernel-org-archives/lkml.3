Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JBOaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:30:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab3JBO3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:29:01 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH 01/26] cris: Convert cryptocop to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:42 +0200
Message-Id: <1380724087-13927-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: linux-cris-kernel@axis.com
CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 arch/cris/arch-v32/drivers/cryptocop.c | 35 ++++++++++------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index 877da1908234..df7ceeff1086 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -2716,43 +2716,28 @@ static int cryptocop_ioctl_process(struct inode *inode, struct file *filp, unsig
 		}
 	}
 
-	/* Acquire the mm page semaphore. */
-	down_read(&current->mm->mmap_sem);
-
-	err = get_user_pages(current,
-			     current->mm,
-			     (unsigned long int)(oper.indata + prev_ix),
-			     noinpages,
-			     0,  /* read access only for in data */
-			     0, /* no force */
-			     inpages,
-			     NULL);
+	err = get_user_pages_fast((unsigned long)(oper.indata + prev_ix),
+				  noinpages,
+				  0,  /* read access only for in data */
+				  inpages);
 
 	if (err < 0) {
-		up_read(&current->mm->mmap_sem);
 		nooutpages = noinpages = 0;
-		DEBUG_API(printk("cryptocop_ioctl_process: get_user_pages indata\n"));
+		DEBUG_API(printk("cryptocop_ioctl_process: get_user_pages_fast indata\n"));
 		goto error_cleanup;
 	}
 	noinpages = err;
 	if (oper.do_cipher){
-		err = get_user_pages(current,
-				     current->mm,
-				     (unsigned long int)oper.cipher_outdata,
-				     nooutpages,
-				     1, /* write access for out data */
-				     0, /* no force */
-				     outpages,
-				     NULL);
-		up_read(&current->mm->mmap_sem);
+		err = get_user_pages_fast((unsigned long)oper.cipher_outdata,
+					  nooutpages,
+					  1, /* write access for out data */
+					  outpages);
 		if (err < 0) {
 			nooutpages = 0;
-			DEBUG_API(printk("cryptocop_ioctl_process: get_user_pages outdata\n"));
+			DEBUG_API(printk("cryptocop_ioctl_process: get_user_pages_fast outdata\n"));
 			goto error_cleanup;
 		}
 		nooutpages = err;
-	} else {
-		up_read(&current->mm->mmap_sem);
 	}
 
 	/* Add 6 to nooutpages to make room for possibly inserted buffers for storing digest and
-- 
1.8.1.4

