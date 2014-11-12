Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbaKLBme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:42:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965104AbaKLBm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:42:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 100/203] ext4: fix mmap data corruption when blocksize < pagesize
Date: Wed, 12 Nov 2014 10:16:10 +0900
Message-Id: <20141112011547.272507658@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit d6320cbfc92910a3e5f10c42d98c231c98db4f60 upstream.

Use truncate_isize_extended() when hole is being created in a file so that
->page_mkwrite() will get called for the partial tail page if it is
mmaped (see the first patch in the series for details).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4645,8 +4645,12 @@ int ext4_setattr(struct dentry *dentry,
 				ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
-		} else
+		} else {
+			loff_t oldsize = inode->i_size;
+
 			i_size_write(inode, attr->ia_size);
+			pagecache_isize_extended(inode, oldsize, inode->i_size);
+		}
 
 		/*
 		 * Blocks are going to be removed from the inode. Wait


