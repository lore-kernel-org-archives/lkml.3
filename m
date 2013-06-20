Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3FTFjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:39:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39129 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab3FTFjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:39:31 -0400
From: Andrey Vagin <avagin@openvz.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Vagin <avagin@openvz.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] virtio-pci: fix leaks of msix_affinity_masks
Date: Thu, 20 Jun 2013 09:36:50 +0400
Message-Id: <1371706610-12028-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <20130619182809.GC15017@redhat.com>
References: <20130619182809.GC15017@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>

vp_dev->msix_vectors should be initialized before allocating
msix_affinity_masks, otherwise vp_free_vectors will not free these
objects.

unreferenced object 0xffff88010f969d88 (size 512):
  comm "systemd-udevd", pid 158, jiffies 4294673645 (age 80.545s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816e455e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff811aa7f1>] kmem_cache_alloc_node_trace+0x141/0x2c0
    [<ffffffff8133ba23>] alloc_cpumask_var_node+0x23/0x80
    [<ffffffff8133ba8e>] alloc_cpumask_var+0xe/0x10
    [<ffffffff813fdb3d>] vp_try_to_find_vqs+0x25d/0x810
    [<ffffffff813fe171>] vp_find_vqs+0x81/0xb0
    [<ffffffffa00d2a05>] init_vqs+0x85/0x120 [virtio_balloon]
    [<ffffffffa00d2c29>] virtballoon_probe+0xf9/0x1a0 [virtio_balloon]
    [<ffffffff813fb61e>] virtio_dev_probe+0xde/0x140
    [<ffffffff814452b8>] driver_probe_device+0x98/0x3a0
    [<ffffffff8144566b>] __driver_attach+0xab/0xb0
    [<ffffffff814432f4>] bus_for_each_dev+0x94/0xb0
    [<ffffffff81444f4e>] driver_attach+0x1e/0x20
    [<ffffffff81444910>] bus_add_driver+0x200/0x280
    [<ffffffff81445c14>] driver_register+0x74/0x160
    [<ffffffff813fb7d0>] register_virtio_driver+0x20/0x40

v2: change msix_vectors uncoditionaly in vp_free_vectors

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 drivers/virtio/virtio_pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index a7ce730..1aba255 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -289,9 +289,9 @@ static void vp_free_vectors(struct virtio_device *vdev)
 
 		pci_disable_msix(vp_dev->pci_dev);
 		vp_dev->msix_enabled = 0;
-		vp_dev->msix_vectors = 0;
 	}
 
+	vp_dev->msix_vectors = 0;
 	vp_dev->msix_used_vectors = 0;
 	kfree(vp_dev->msix_names);
 	vp_dev->msix_names = NULL;
@@ -309,6 +309,8 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 	unsigned i, v;
 	int err = -ENOMEM;
 
+	vp_dev->msix_vectors = nvectors;
+
 	vp_dev->msix_entries = kmalloc(nvectors * sizeof *vp_dev->msix_entries,
 				       GFP_KERNEL);
 	if (!vp_dev->msix_entries)
@@ -336,7 +338,6 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 		err = -ENOSPC;
 	if (err)
 		goto error;
-	vp_dev->msix_vectors = nvectors;
 	vp_dev->msix_enabled = 1;
 
 	/* Set the vector used for configuration */
-- 
1.8.1.4

