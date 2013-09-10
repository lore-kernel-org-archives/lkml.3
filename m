Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3IJVEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab3IJVEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:04:32 -0400
Date: Tue, 10 Sep 2013 17:04:25 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lock held returning to user space (i_mutex_dir_key)
Message-ID: <20130910210425.GB15371@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130910210237.GA15371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910210237.GA15371@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:02:37PM -0400, Dave Jones wrote:
 > ================================================
 > [ BUG: lock held when returning to user space! ]
 > 3.11.0+ #64 Not tainted
 > ------------------------------------------------
 > trinity-child2/8333 is leaving the kernel with locks still held!
 > 1 lock held by trinity-child2/8333:
 >  #0:  (&type->i_mutex_dir_key#3){+.+.+.}, at: [<ffffffff811c7fce>] mountpoint_last+0x4e/0x1a0

This perhaps ?


-- 

Add missing unlocks to error paths of mountpoint_last.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/fs/namei.c b/fs/namei.c
index 409a441..5a91474 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2271,12 +2271,15 @@ mountpoint_last(struct nameidata *nd, struct path *path)
 		dentry = d_alloc(dir, &nd->last);
 		if (!dentry) {
 			error = -ENOMEM;
+			mutex_unlock(&dir->d_inode->i_mutex);
 			goto out;
 		}
 		dentry = lookup_real(dir->d_inode, dentry, nd->flags);
 		error = PTR_ERR(dentry);
-		if (IS_ERR(dentry))
+		if (IS_ERR(dentry)) {
+			mutex_unlock(&dir->d_inode->i_mutex);
 			goto out;
+		}
 	}
 	mutex_unlock(&dir->d_inode->i_mutex);
 
