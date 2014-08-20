Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaHTL5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:57:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58991 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cedric Le Goater <clg@fr.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/104] offb: Little endian fixes
Date: Wed, 20 Aug 2014 13:43:30 +0200
Message-Id: <0d9f529a9b7d7f00b5441a39bbf97df0fee367cb.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Le Goater <clg@fr.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 212c0cbd5be721a39ef3e2f723e0c78008f9e955 upstream.

The "screen" properties : depth, width, height, linebytes need
to be converted to the host endian order when read from the device
tree.

The offb_init_palette_hacks() routine also made assumption on the
host endian order.

Signed-off-by: Cédric Le Goater <clg@fr.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/offb.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/video/offb.c b/drivers/video/offb.c
index 0c4f34311eda..9a0109b664c5 100644
--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -301,7 +301,7 @@ static struct fb_ops offb_ops = {
 static void __iomem *offb_map_reg(struct device_node *np, int index,
 				  unsigned long offset, unsigned long size)
 {
-	const u32 *addrp;
+	const __be32 *addrp;
 	u64 asize, taddr;
 	unsigned int flags;
 
@@ -369,7 +369,11 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 		}
 		of_node_put(pciparent);
 	} else if (dp && of_device_is_compatible(dp, "qemu,std-vga")) {
-		const u32 io_of_addr[3] = { 0x01000000, 0x0, 0x0 };
+#ifdef __BIG_ENDIAN
+		const __be32 io_of_addr[3] = { 0x01000000, 0x0, 0x0 };
+#else
+		const __be32 io_of_addr[3] = { 0x00000001, 0x0, 0x0 };
+#endif
 		u64 io_addr = of_translate_address(dp, io_of_addr);
 		if (io_addr != OF_BAD_ADDR) {
 			par->cmap_adr = ioremap(io_addr + 0x3c8, 2);
@@ -536,7 +540,7 @@ static void __init offb_init_nodriver(struct device_node *dp, int no_real_node)
 	unsigned int flags, rsize, addr_prop = 0;
 	unsigned long max_size = 0;
 	u64 rstart, address = OF_BAD_ADDR;
-	const u32 *pp, *addrp, *up;
+	const __be32 *pp, *addrp, *up;
 	u64 asize;
 	int foreign_endian = 0;
 
@@ -552,25 +556,25 @@ static void __init offb_init_nodriver(struct device_node *dp, int no_real_node)
 	if (pp == NULL)
 		pp = of_get_property(dp, "depth", &len);
 	if (pp && len == sizeof(u32))
-		depth = *pp;
+		depth = be32_to_cpup(pp);
 
 	pp = of_get_property(dp, "linux,bootx-width", &len);
 	if (pp == NULL)
 		pp = of_get_property(dp, "width", &len);
 	if (pp && len == sizeof(u32))
-		width = *pp;
+		width = be32_to_cpup(pp);
 
 	pp = of_get_property(dp, "linux,bootx-height", &len);
 	if (pp == NULL)
 		pp = of_get_property(dp, "height", &len);
 	if (pp && len == sizeof(u32))
-		height = *pp;
+		height = be32_to_cpup(pp);
 
 	pp = of_get_property(dp, "linux,bootx-linebytes", &len);
 	if (pp == NULL)
 		pp = of_get_property(dp, "linebytes", &len);
 	if (pp && len == sizeof(u32) && (*pp != 0xffffffffu))
-		pitch = *pp;
+		pitch = be32_to_cpup(pp);
 	else
 		pitch = width * ((depth + 7) / 8);
 
-- 
2.0.4

