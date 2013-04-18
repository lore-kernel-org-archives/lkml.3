Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966152Ab3DRHco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:32:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1141 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965799Ab3DRHcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:32:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,499,1363104000"; 
   d="scan'208";a="7085469"
Message-ID: <516FA134.6000203@cn.fujitsu.com>
Date: Thu, 18 Apr 2013 15:31:00 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        majianpeng <majianpeng@gmail.com>
Subject: [PATCH]fs/block_dev.c: fix the inaccurate judgement in function blkdev_aio_read
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/18 15:31:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/18 15:31:15,
	Serialize complete at 2013/04/18 15:31:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function blkdev_aio_read(), the judgement of 'size', if it is equal or greater than
the target count we request(iocb->ki_left), there is no need to call iov_shorten() to
reduce number of segments and the iovec's length.
So the judgement should be changed to 'if (size < iocb->ki_left)' instead.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/block_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index aae187a..f0328f1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1559,7 +1559,7 @@ static ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
                return 0;
 
        size -= pos;
-       if (size < INT_MAX)
+       if (size < iocb->ki_left)
                nr_segs = iov_shorten((struct iovec *)iov, nr_segs, size);
        return generic_file_aio_read(iocb, iov, nr_segs, pos);
 }
-- 
1.7.7


