Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183AbaFKQBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:01:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53786 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaFKQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:01:40 -0400
Date: Wed, 11 Jun 2014 17:01:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [pre 3.16-rc1] Oops at spin_trylock(&inode->i_lock)
Message-ID: <20140611160133.GX18016@ZenIV.linux.org.uk>
References: <201406102104.FAG04640.MVJFSQOHtOFOFL@I-love.SAKURA.ne.jp>
 <20140610143425.GL4581@linux.vnet.ibm.com>
 <201406112035.ADB51545.QFVMLJOtFOHSOF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201406112035.ADB51545.QFVMLJOtFOHSOF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 08:35:44PM +0900, Tetsuo Handa wrote:
> I also confirmed that the command line which triggers this oops is
> 
>   mount -n -o ro,remount sysfs /sys
> 
> in /etc/init.d/halt script in CentOS 6.5.
> Manually executing the command line from login shell triggers this oops.
> 
> I don't know why but commit 59a3d4c363 revealed a refcount bug
> in sysfs (or maybe in vfs)?

Try to check if this helps:

diff --git a/fs/dcache.c b/fs/dcache.c
index be2bea8..e99c6f5 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -532,10 +532,12 @@ static inline struct dentry *lock_parent(struct dentry *dentry)
 	struct dentry *parent = dentry->d_parent;
 	if (IS_ROOT(dentry))
 		return NULL;
+	if (unlikely((int)dentry->d_lockref.count < 0))
+		return NULL;
 	if (likely(spin_trylock(&parent->d_lock)))
 		return parent;
-	spin_unlock(&dentry->d_lock);
 	rcu_read_lock();
+	spin_unlock(&dentry->d_lock);
 again:
 	parent = ACCESS_ONCE(dentry->d_parent);
 	spin_lock(&parent->d_lock);
