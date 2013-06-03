Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab3FCMov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:44:51 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33558 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3FCMos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:44:48 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
Date: Mon,  3 Jun 2013 14:44:43 +0200
Message-Id: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-27049-1370263483-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-27049-1370263483-0001

Check that dma_ops are initialized correctly.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Functions dma_mmap_attrs(), dma_get_sgtable_attrs()
already have this checking.

---
 include/asm-generic/dma-mapping-common.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index de8bf89..d430cab 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -16,6 +16,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 	dma_addr_t addr;

 	kmemcheck_mark_initialized(ptr, size);
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	addr = ops->map_page(dev, virt_to_page(ptr),
 			     (unsigned long)ptr & ~PAGE_MASK, size,
@@ -33,6 +34,7 @@ static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
 		ops->unmap_page(dev, addr, size, dir, attrs);
@@ -49,6 +51,7 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,

 	for_each_sg(sg, s, nents, i)
 		kmemcheck_mark_initialized(sg_virt(s), s->length);
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	ents = ops->map_sg(dev, sg, nents, dir, attrs);
 	debug_dma_map_sg(dev, sg, nents, ents, dir);
@@ -62,6 +65,7 @@ static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	debug_dma_unmap_sg(dev, sg, nents, dir);
 	if (ops->unmap_sg)
@@ -76,6 +80,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	dma_addr_t addr;

 	kmemcheck_mark_initialized(page_address(page) + offset, size);
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	addr = ops->map_page(dev, page, offset, size, dir, NULL);
 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
@@ -88,6 +93,7 @@ static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
 		ops->unmap_page(dev, addr, size, dir, NULL);
@@ -100,6 +106,7 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr, size, dir);
@@ -112,6 +119,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
 		ops->sync_single_for_device(dev, addr, size, dir);
@@ -126,6 +134,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr + offset, size, dir);
@@ -140,6 +149,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
 		ops->sync_single_for_device(dev, addr + offset, size, dir);
@@ -152,6 +162,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
@@ -164,6 +175,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);

+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_device)
 		ops->sync_sg_for_device(dev, sg, nelems, dir);
--
1.8.2.3


--=_mimegpg-monstr-desktop-27049-1370263483-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsj7sACgkQykllyylKDCF+BwCfcGw7D+F0LY0QF1D+qM5u7+ZG
vkUAoJpumEj7S5dkgR5NCQ+QIaoI6yWd
=PNeh
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-27049-1370263483-0001--
