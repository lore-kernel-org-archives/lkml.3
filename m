Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab3CUW3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:29:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab3CUW3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:29:19 -0400
Date: Thu, 21 Mar 2013 18:29:15 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321222915.GA2756@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130321190653.GA15479@redhat.com>
 <20130321192935.GY21522@ZenIV.linux.org.uk>
 <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
 <20130321202635.GA16406@redhat.com>
 <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321221256.GA30620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321221256.GA30620@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 06:12:56PM -0400, Dave Jones wrote:
 > On Thu, Mar 21, 2013 at 02:18:15PM -0700, Linus Torvalds wrote:
 >  > On Thu, Mar 21, 2013 at 2:02 PM, Dave Jones <davej@redhat.com> wrote:
 >  > >
 >  > > here we go...
 >  > >
 >  > > WARNING: at fs/namei.c:2335 lock_rename+0x156/0x160()
 >  > > p1=irda p2=irda
 >  > 
 >  > Ok, good. I ssupect it's /proc or /sys, we do have that entry there.
 >  > 
 >  > But in fact I suspect we do want the parent name after all, because I
 >  > think we have multiple "irda" directories. There's the one in
 >  > /proc/net/ (added by net/irda/irproc.c), and there's a sysctl  CTL_DIR
 >  > "irda" directory (kernel/sysctl_binary.c). And there might even be a
 >  > few other ones in /sys too, thanks to the ldisc called "irda" etc.
 >  > 
 >  > I don't see where the shared inode comes from, but I suspect that
 >  > would be easier to guess if we actually see which particular case it
 >  > ends up being..
 > 
 > it's not just irda fwiw..
 > 
 > p1=rpc p2=rpc p1parent=net p2parent=net
 > 
 > not sure why the printk with Al's last debugging info didn't print out..
 > Investigating..

missing \n meant it didn't go over serial..
on screen however was..

path1: path2: proc 0 0

sanity check ?

 
diff --git a/fs/namei.c b/fs/namei.c
index 57ae9c8..5afffe1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2282,6 +2332,26 @@ struct dentry *lock_rename(struct dentry *p1, struct dentry *p2)
 		return NULL;
 	}
 
+	if (WARN_ON_ONCE(p1->d_inode == p2->d_inode)) {
+		static char path1[4096];
+		static char path2[4096];
+
+		printk(KERN_ERR "p1=%s p2=%s p1parent=%s p2parent=%s\n", p1->d_name.name, p2->d_name.name,
+				p1->d_parent->d_name.name,
+				p2->d_parent->d_name.name);
+
+		dentry_path(p1, path1, 4096);
+		dentry_path(p2, path2, 4096);
+
+		printk(KERN_ERR "path1:%s path2:%s %s %d %d\n",
+	                path1, path2, p1->d_sb->s_type->name, d_unlinked(p1), d_unlinked(p2));
+
+
+		mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
+		return NULL;
+	}
+
+
 	mutex_lock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
 
 	p = d_ancestor(p2, p1);

@@ -2306,7 +2376,8 @@ struct dentry *lock_rename(struct dentry *p1, struct dentry *p2)
 void unlock_rename(struct dentry *p1, struct dentry *p2)
 {
 	mutex_unlock(&p1->d_inode->i_mutex);
-	if (p1 != p2) {
+
+	if (p1->d_inode != p2->d_inode) {
 		mutex_unlock(&p2->d_inode->i_mutex);
 		mutex_unlock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
 	}

