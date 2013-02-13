Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab3BMO0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:26:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39709 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934076Ab3BMO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:26:13 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Pawel Moll <pawel.moll@arm.com>
Subject: [RFC PATCH] virt_mmio: fix signature checking for BE guests
Date: Wed, 13 Feb 2013 14:25:38 +0000
Message-Id: <1360765538-18097-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.1.2
X-OriginalArrivalTime: 13 Feb 2013 14:26:10.0044 (UTC) FILETIME=[117EA3C0:01CE09F6]
X-MC-Unique: 113021314261115101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1DEQQRV030575

Using readl() to read the magic value and then memcmp() to check it
fails on BE, as bytes will be the other way around (by virtue of
the registers to follow the endianess of the guest).

Fix it by encoding the magic as an integer instead of a string.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
So I'm not completely sure this is the right fix, and I can imagine
other ways to cure the problem:
- Reading the MAGIC register byte by byte. Is that allowed? The spec
  only says it is 32bit wide.
- Using __raw_readl() instead. Is that a generic enough API?

 drivers/virtio/virtio_mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 31f966f..3811e94 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -470,7 +470,7 @@ static int virtio_mmio_probe(struct platform_device *pdev)
 
 	/* Check magic value */
 	magic = readl(vm_dev->base + VIRTIO_MMIO_MAGIC_VALUE);
-	if (memcmp(&magic, "virt", 4) != 0) {
+	if (magic != ('v' | 'i' << 8 | 'r' << 16 | 't' << 24)) {
 		dev_warn(&pdev->dev, "Wrong magic value 0x%08lx!\n", magic);
 		return -ENODEV;
 	}
-- 
1.8.1.2


