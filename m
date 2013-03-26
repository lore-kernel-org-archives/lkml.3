Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3CZWtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:49:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3CZWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Zach Brown <zab@redhat.com>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 79/98] nfsd: fix bad offset use
Date: Tue, 26 Mar 2013 15:43:08 -0700
Message-Id: <20130326224250.682583251@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <koverstreet@google.com>

commit e49dbbf3e770aa590a8a464ac4978a09027060b9 upstream.

vfs_writev() updates the offset argument - but the code then passes the
offset to vfs_fsync_range(). Since offset now points to the offset after
what was just written, this is probably not what was intended

Introduced by face15025ffdf664de95e86ae831544154d26c9c "nfsd: use
vfs_fsync_range(), not O_SYNC, for stable writes".

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Zach Brown <zab@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/vfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1013,6 +1013,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	int			host_err;
 	int			stable = *stablep;
 	int			use_wgather;
+	loff_t			pos = offset;
 
 	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
@@ -1025,7 +1026,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
-	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &offset);
+	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &pos);
 	set_fs(oldfs);
 	if (host_err < 0)
 		goto out_nfserr;


