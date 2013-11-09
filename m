Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab3KIUDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 15:03:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488Ab3KIUDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 15:03:25 -0500
Date: Sat, 9 Nov 2013 21:04:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] fs: forbid to open anon-inode files via /proc
Message-ID: <20131109200452.GB4967@redhat.com>
References: <20131108183001.2564151a619f8f6df3db543a@canb.auug.org.au> <20131108125915.GA1000@redhat.com> <20131108134859.GA4461@redhat.com> <20131109200424.GA4967@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109200424.GA4967@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

open("/proc/pid/$anon-fd") should fail, we can't create the new
file with correctly. Currently this creates the bogus file with
->f_op == empty_fops copied from ->i_fop, this is harmless but
still wrong and misleading.

Now that anon_inode_fops has gone away we can add empty_no_open()
to disallow this. This affects anon_inode_getfile() and the new
aio_private_file().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/inode.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4bcdad3..b7c159c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -114,6 +114,11 @@ int proc_nr_inodes(ctl_table *table, int write,
 }
 #endif
 
+static int empty_no_open(struct inode *inode, struct file *file)
+{
+	return -ENXIO;
+}
+
 /**
  * inode_init_always - perform inode structure intialisation
  * @sb: superblock inode belongs to
@@ -124,8 +129,10 @@ int proc_nr_inodes(ctl_table *table, int write,
  */
 int inode_init_always(struct super_block *sb, struct inode *inode)
 {
+	static const struct file_operations empty_fops = {
+		.open = empty_no_open,
+	};
 	static const struct inode_operations empty_iops;
-	static const struct file_operations empty_fops;
 	struct address_space *const mapping = &inode->i_data;
 
 	inode->i_sb = sb;
-- 
1.5.5.1


