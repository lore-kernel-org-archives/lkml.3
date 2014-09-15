Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbaIOWf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:35:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaIOWTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 172/187] libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly
Date: Mon, 15 Sep 2014 15:09:42 -0700
Message-Id: <1410818997-9432-173-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <ilya.dryomov@inktank.com>

commit 5f740d7e1531099b888410e6bab13f68da9b1a4d upstream.

Determining ->last_piece based on the value of ->page_offset + length
is incorrect because length here is the length of the entire message.
->last_piece set to false even if page array data item length is <=
PAGE_SIZE, which results in invalid length passed to
ceph_tcp_{send,recv}page() and causes various asserts to fire.

    # cat pages-cursor-init.sh
    #!/bin/bash
    rbd create --size 10 --image-format 2 foo
    FOO_DEV=$(rbd map foo)
    dd if=/dev/urandom of=$FOO_DEV bs=1M &>/dev/null
    rbd snap create foo@snap
    rbd snap protect foo@snap
    rbd clone foo@snap bar
    # rbd_resize calls librbd rbd_resize(), size is in bytes
    ./rbd_resize bar $(((4 << 20) + 512))
    rbd resize --size 10 bar
    BAR_DEV=$(rbd map bar)
    # trigger a 512-byte copyup -- 512-byte page array data item
    dd if=/dev/urandom of=$BAR_DEV bs=1M count=1 seek=5

The problem exists only in ceph_msg_data_pages_cursor_init(),
ceph_msg_data_pages_advance() does the right thing.  The size_t cast is
unnecessary.

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Reviewed-by: Sage Weil <sage@redhat.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/messenger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index ce83d07..94e21b9 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -904,7 +904,7 @@ static void ceph_msg_data_pages_cursor_init(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(page_count > (int)USHRT_MAX);
 	cursor->page_count = (unsigned short)page_count;
 	BUG_ON(length > SIZE_MAX - cursor->page_offset);
-	cursor->last_piece = (size_t)cursor->page_offset + length <= PAGE_SIZE;
+	cursor->last_piece = cursor->page_offset + cursor->resid <= PAGE_SIZE;
 }
 
 static struct page *
-- 
1.9.1

