Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbbAUUGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:06:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbAUUGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:06:34 -0500
Date: Wed, 21 Jan 2015 20:06:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121200626.GR29656@ZenIV.linux.org.uk>
References: <1528536.jyty2pu4Mz@sifl>
 <20150121004117.GM29656@ZenIV.linux.org.uk>
 <54BF1292.2080902@roeck-us.net>
 <20150121033600.GN29656@ZenIV.linux.org.uk>
 <54BF2496.4000807@roeck-us.net>
 <20150121043637.GO29656@ZenIV.linux.org.uk>
 <20150121110539.GA8924@kria>
 <54BFAA5D.4040108@roeck-us.net>
 <20150121182905.GQ29656@ZenIV.linux.org.uk>
 <54BFF8B3.6060802@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BFF8B3.6060802@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:06:27AM -0800, Guenter Roeck wrote:
> On 01/21/2015 10:29 AM, Al Viro wrote:
> >On Wed, Jan 21, 2015 at 05:32:13AM -0800, Guenter Roeck wrote:
> >>Another data point (though I have no idea if it is useful or what it means):
> >>
> >>In the working case, path_init sets nd->flags to 0x50 or 0x51.
> >>In the non-working case (ie for all files with a '/' in the name),
> >>it sets nd->flags to 0x10 or 0x11, even though it is always called
> >>with the LOOKUP_RCU bit set in flags.
> >
> >Umm...  Are those path_init() succeeding or failing?  Note that path_init()
> >includes "walk everything except for the last component", so your non-working
> >case is "have it walk anything at all".  What's failing there?  path_init()
> >or handling the remaining component?
> >
> path_init() returns -2. Guess that explains the unexpected flags ;-).
> The failuere is from
> 	link_path_walk()
> 		walk_component()

Which is to say, lookup gave it a negative dentry.  OK, let's just make
vfs_mkdir() and walk_component() print what they are doing; on top of
linux-next

diff --git a/fs/namei.c b/fs/namei.c
index 323957f..8a4e22f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1586,8 +1586,11 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
 		inode = path->dentry->d_inode;
 	}
 	err = -ENOENT;
-	if (!inode || d_is_negative(path->dentry))
+	if (!inode || d_is_negative(path->dentry)) {
+		printk(KERN_ERR "walk_component[%p,%pd4] -> negative\n",
+			path->dentry, path->dentry);
 		goto out_path_put;
+	}
 
 	if (should_follow_link(path->dentry, follow)) {
 		if (nd->flags & LOOKUP_RCU) {
@@ -3521,6 +3524,7 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	error = dir->i_op->mkdir(dir, dentry, mode);
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
+	printk(KERN_ERR "mkdir[%p,%pd4] => %d\n", dentry, dentry, error);
 	return error;
 }
 EXPORT_SYMBOL(vfs_mkdir);
