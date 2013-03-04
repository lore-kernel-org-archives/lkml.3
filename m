Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3CDEEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:04:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32843 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293Ab3CDDnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:32 -0500
Message-Id: <20130304033716.989555237@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 095/153] fs: Fix possible use-after-free with AIO
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 54c807e71d5ac59dee56c685f2b66e27cd54c475 upstream.

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>
CC: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -304,9 +304,9 @@ static ssize_t dio_complete(struct dio *
 		dio->end_io(dio->iocb, offset, transferred,
 			    dio->private, ret, is_async);
 	} else {
+		inode_dio_done(dio->inode);
 		if (is_async)
 			aio_complete(dio->iocb, ret, 0);
-		inode_dio_done(dio->inode);
 	}
 
 	return ret;


