Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906AbaE2H3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:29:03 -0400
Received: from ozlabs.org ([103.22.144.67]:54500 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657AbaE2H2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:28:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/4] virtio_net: pass well-formed sg to virtqueue_add_inbuf()
Date: Thu, 29 May 2014 16:56:43 +0930
Message-Id: <1401348405-18614-3-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
References: <87oayh6s3s.fsf@rustcorp.com.au>
 <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the only place which doesn't hand virtqueue_add_inbuf or
virtqueue_add_outbuf a well-formed, well-terminated sg.  Fix it,
so we can make virtio_add_* simpler.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/virtio_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8a852b5f215f..63299b04cdf2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -590,6 +590,8 @@ static int add_recvbuf_big(struct receive_queue *rq, gfp_t gfp)
 	offset = sizeof(struct padded_vnet_hdr);
 	sg_set_buf(&rq->sg[1], p + offset, PAGE_SIZE - offset);
 
+	sg_mark_end(&rq->sg[MAX_SKB_FRAGS + 2 - 1]);
+
 	/* chain first in list head */
 	first->private = (unsigned long)list;
 	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
-- 
1.9.1

