Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbaIOUoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:44:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaIOTgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@redhat.com>,
        Alex Elder <elder@linaro.org>
Subject: [PATCH 3.16 137/158] libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly
Date: Mon, 15 Sep 2014 12:26:16 -0700
Message-Id: <20140915192546.985023487@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/messenger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -900,7 +900,7 @@ static void ceph_msg_data_pages_cursor_i
 	BUG_ON(page_count > (int)USHRT_MAX);
 	cursor->page_count = (unsigned short)page_count;
 	BUG_ON(length > SIZE_MAX - cursor->page_offset);
-	cursor->last_piece = (size_t)cursor->page_offset + length <= PAGE_SIZE;
+	cursor->last_piece = cursor->page_offset + cursor->resid <= PAGE_SIZE;
 }
 
 static struct page *


