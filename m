Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaIZJqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbaIZJqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ilya Dryomov <ilya.dryomov@inktank.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 104/142] libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly
Date: Fri, 26 Sep 2014 11:45:15 +0200
Message-Id: <a06a29de94fb5f3a8e59b207ca5c4662b092371d.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilya Dryomov <ilya.dryomov@inktank.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ceph/messenger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index ce83d07eb419..94e21b9b1c87 100644
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
2.1.0

