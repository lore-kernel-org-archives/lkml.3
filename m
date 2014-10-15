Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaJOPrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:47:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42443 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaJOPre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:47:34 -0400
From: "Denis V. Lunev" <den@openvz.org>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Raushaniya Maksudova <rmaksudova@parallels.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 1/2] virtio_balloon: return the amount of freed memory from leak_balloon()
Date: Wed, 15 Oct 2014 19:47:43 +0400
Message-Id: <1413388064-5354-2-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413388064-5354-1-git-send-email-den@openvz.org>
References: <1413388064-5354-1-git-send-email-den@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raushaniya Maksudova <rmaksudova@parallels.com>

This value would be useful in the next patch to provide the amount of
the freed memory for OOM killer.

Signed-off-by: Raushaniya Maksudova <rmaksudova@parallels.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index f893148..66cac10 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -168,8 +168,9 @@ static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
 	}
 }
 
-static void leak_balloon(struct virtio_balloon *vb, size_t num)
+static unsigned leak_balloon(struct virtio_balloon *vb, size_t num)
 {
+	unsigned num_freed_pages;
 	struct page *page;
 	struct balloon_dev_info *vb_dev_info = &vb->vb_dev_info;
 
@@ -186,6 +187,7 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
 	}
 
+	num_freed_pages = vb->num_pfns;
 	/*
 	 * Note that if
 	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
@@ -195,6 +197,7 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 		tell_host(vb, vb->deflate_vq);
 	mutex_unlock(&vb->balloon_lock);
 	release_pages_by_pfn(vb->pfns, vb->num_pfns);
+	return num_freed_pages;
 }
 
 static inline void update_stat(struct virtio_balloon *vb, int idx,
-- 
1.9.1

