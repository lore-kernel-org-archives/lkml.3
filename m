Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3KHNrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:47:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3KHNrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:47:35 -0500
Date: Fri, 8 Nov 2013 14:48:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the akpm-current tree with the vfs
	tree
Message-ID: <20131108134859.GA4461@redhat.com>
References: <20131108183001.2564151a619f8f6df3db543a@canb.auug.org.au> <20131108125915.GA1000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108125915.GA1000@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Oleg Nesterov wrote:
>
> On 11/08, Stephen Rothwell wrote:
> >
> > Hi Andrew,
> >
> > Today's linux-next merge of the akpm-current tree got a conflict in
> > fs/anon_inodes.c between commit 24b0303e9532 ("take anon inode allocation
> > to libfs.c") from the vfs tree and commit 02f3ac4386d9 ("anon_inodefs:
> > forbid open via /proc") from the akpm-current tree.
> >
> > I just dropped the akpm-current changes for today - they should probably
> > be applied to fs/libfs.c.
>
> Well, this probably means that
>
> 	anon_inodefs-forbid-open-via-proc.patch
>
> should be dropped. I'll rediff this patch against vfs.git

24b0303e9532 also removes anon_inode_fops. It seems that it was not really
needed anyway, inode_init_always() does inode->i_fop = empty_fops...

So probably we can simply change empty_fops but I need to recheck.

Oleg.

--- x/fs/inode.c
+++ x/fs/inode.c
@@ -114,6 +114,11 @@ int proc_nr_inodes(ctl_table *table, int
 }
 #endif
 
+static int empty_open(struct inode *inode, struct file *file)
+{
+	return -ENXIO;
+}
+
 /**
  * inode_init_always - perform inode structure intialisation
  * @sb: superblock inode belongs to
@@ -125,7 +130,9 @@ int proc_nr_inodes(ctl_table *table, int
 int inode_init_always(struct super_block *sb, struct inode *inode)
 {
 	static const struct inode_operations empty_iops;
-	static const struct file_operations empty_fops;
+	static const struct file_operations empty_fops = {
+		.open = empty_open,
+	};
 	struct address_space *const mapping = &inode->i_data;
 
 	inode->i_sb = sb;

