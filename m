Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762495Ab3DDPxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:53:47 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54649 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762404Ab3DDPxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:53:46 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH resend] fs/proc: Move kfree outside pde_unload_lock
Date: Thu,  4 Apr 2013 10:53:39 -0500
Message-Id: <1365090819-25448-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <515D9F8A.2060505@sgi.com>
References: <515D9F8A.2060505@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves a kfree outside a spinlock to help scaling on larger (512 core)
systems.  This should be some relief until we can move the section to use
the rcu.

I ran a simple test which just reads from /proc/cpuinfo.
Lower is better, as you can see the worst case scenario is improved.

	baseline	moved kfree
tasks	read-sec	read-sec
1	0.0141		0.0141
2	0.0140		0.0140
4	0.0140		0.0141
8	0.0145		0.0145
16	0.0553		0.0548
32	0.1688		0.1622
64	0.5017		0.3856
128	1.7005		0.9710
256	5.2513		2.6519
512	8.0529		6.2976

Cc: "Eric W. Biederman" <ebiederm@xmission.com> 
Cc: Andrew Morton <akpm@linux-foundation.org> 
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@vger.kernel.org>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 fs/proc/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 439ae688..863608b 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -403,11 +403,10 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	}
 	pde->pde_users++;
 	release = pde->proc_fops->release;
-	if (pdeo) {
+	if (pdeo)
 		list_del(&pdeo->lh);
-		kfree(pdeo);
-	}
 	spin_unlock(&pde->pde_unload_lock);
+	kfree(pdeo);
 
 	if (release)
 		rv = release(inode, file);
-- 
1.8.1.2

