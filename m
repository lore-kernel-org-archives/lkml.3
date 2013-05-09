Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab3EIWyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:54:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab3EIWdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Namjae Jeon <namjae.jeon@samsung.com>, Jens Axboe <axboe@kernel.dk>
Subject: [ 30/73] block: fix max discard sectors limit
Date: Thu,  9 May 2013 15:31:53 -0700
Message-Id: <20130509222801.248505114@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 871dd9286e25330c8a581e5dacfa8b1dfe1dd641 upstream.

linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9
(block: add plug for blkdev_issue_discard )

For example,
1) DISCARD rq-1 with size size 4GB
2) DISCARD rq-2 with size size 1GB

If these 2 discard requests get merged, final request size will be 5GB.

In this case, request's __data_len field may overflow as it can store
max 4GB(unsigned int).

This issue was observed while doing mkfs.f2fs on 5GB SD card:
https://lkml.org/lkml/2013/4/1/292

Info: sector size = 512
Info: total sectors = 11370496 (in 512bytes)
Info: zone aligned segment0 blkaddr: 512
[  257.789764] blk_update_request: bio idx 0 >= vcnt 0

mkfs process gets stuck in D state and I see the following in the dmesg:

[  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
[  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
[  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len
1526726656
[  257.789764] blk_update_request: bio idx 0 >= vcnt 0
[  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
[  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
[  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len
1526726656

This patch fixes this issue.

Reported-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Tested-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/blkdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -836,7 +836,7 @@ static inline unsigned int blk_queue_get
 						     unsigned int cmd_flags)
 {
 	if (unlikely(cmd_flags & REQ_DISCARD))
-		return q->limits.max_discard_sectors;
+		return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
 	if (unlikely(cmd_flags & REQ_WRITE_SAME))
 		return q->limits.max_write_same_sectors;


