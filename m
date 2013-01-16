Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3APQmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:42:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab3APQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <levinsasha928@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 116/222] virtio: force vring descriptors to be allocated from lowmem
Date: Wed, 16 Jan 2013 13:55:16 -0200
Message-Id: <1358351822-7675-117-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit b92b1b89a33c172c075edccf6afb0edc41d851fd upstream.

Virtio devices may attempt to add descriptors to a virtqueue from atomic
context using GFP_ATOMIC allocation. This is problematic because such
allocations can fall outside of the lowmem mapping, causing virt_to_phys
to report bogus physical addresses which are subsequently passed to
userspace via the buffers for the virtual device.

This patch masks out __GFP_HIGH and __GFP_HIGHMEM from the requested
flags when allocating descriptors for a virtqueue. If an atomic
allocation is requested and later fails, we will return -ENOSPC which
will be handled by the driver.

Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/virtio/virtio_ring.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5aa43c3..52bfd07 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -132,6 +132,13 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	unsigned head;
 	int i;
 
+	/*
+	 * We require lowmem mappings for the descriptors because
+	 * otherwise virt_to_phys will give us bogus addresses in the
+	 * virtqueue.
+	 */
+	gfp &= ~(__GFP_HIGHMEM | __GFP_HIGH);
+
 	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
 	if (!desc)
 		return -ENOMEM;
-- 
1.7.9.5

