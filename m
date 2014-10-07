Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaJGX1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:27:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbaJGXUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@fb.com>, Jeff Moyer <jmoyer@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 32/37] mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT
Date: Tue,  7 Oct 2014 16:19:49 -0700
Message-Id: <20141007231828.043339438@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit 7fcbbaf18392f0b17c95e2f033c8ccf87eecde1d upstream.

In some testing I ran today (some fio jobs that spread over two nodes),
we end up spending 40% of the time in filemap_check_errors().  That
smells fishy.  Looking further, this is basically what happens:

blkdev_aio_read()
    generic_file_aio_read()
        filemap_write_and_wait_range()
            if (!mapping->nr_pages)
                filemap_check_errors()

and filemap_check_errors() always attempts two test_and_clear_bit() on
the mapping flags, thus dirtying it for every single invocation.  The
patch below tests each of these bits before clearing them, avoiding this
issue.  In my test case (4-socket box), performance went from 1.7M IOPS
to 4.0M IOPS.

Signed-off-by: Jens Axboe <axboe@fb.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/filemap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -192,9 +192,11 @@ static int filemap_check_errors(struct a
 {
 	int ret = 0;
 	/* Check for outstanding write errors */
-	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+	if (test_bit(AS_ENOSPC, &mapping->flags) &&
+	    test_and_clear_bit(AS_ENOSPC, &mapping->flags))
 		ret = -ENOSPC;
-	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+	if (test_bit(AS_EIO, &mapping->flags) &&
+	    test_and_clear_bit(AS_EIO, &mapping->flags))
 		ret = -EIO;
 	return ret;
 }


