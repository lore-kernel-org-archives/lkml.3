Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3CATqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3CATqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 12/46] ocfs2: fix possible use-after-free with AIO
Date: Fri,  1 Mar 2013 11:45:00 -0800
Message-Id: <20130301194433.554802956@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 9b171e0c74ca0549d0610990a862dd895870f04a upstream.

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -593,9 +593,9 @@ static void ocfs2_dio_end_io(struct kioc
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
 
+	inode_dio_done(inode);
 	if (is_async)
 		aio_complete(iocb, ret, 0);
-	inode_dio_done(inode);
 }
 
 /*


