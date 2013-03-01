Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3CAUBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:01:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3CATqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 22/46] fs: Fix possible use-after-free with AIO
Date: Fri,  1 Mar 2013 11:45:10 -0800
Message-Id: <20130301194434.577557279@linuxfoundation.org>
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

commit 54c807e71d5ac59dee56c685f2b66e27cd54c475 upstream.

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>
CC: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -305,9 +305,9 @@ static ssize_t dio_complete(struct dio *
 		dio->end_io(dio->iocb, offset, transferred,
 			    dio->private, ret, is_async);
 	} else {
+		inode_dio_done(dio->inode);
 		if (is_async)
 			aio_complete(dio->iocb, ret, 0);
-		inode_dio_done(dio->inode);
 	}
 
 	return ret;


