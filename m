Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3HDR0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 13:26:38 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:33447 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3HDR0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 13:26:36 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ondrej Zajicek <santiago@crfreenet.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] fbdev: suppress warning when assigning vga-save/restore base
Date: Sun,  4 Aug 2013 19:25:41 +0200
Message-Id: <1375637141-2878-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If drivers use "struct resource" objects to retrieve the vga-base, they
must correctly cast the integer to pointer. With x86+PAE we have 32bit
pointers but 64bit resource_size_t. Hence, cast it to "unsigned long"
before casting to "void*" to suppress warnings due to size differences.

As IO addresses are always low addresses, we can safely drop the higher
part of the address. This is what these drivers did before, anyway.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Reported-by: H. Peter Anvin <hpa@zytor.com>
---
Hi

hpa reported build-warnings on i386+PAE:
/home/hpa/kernel/distwork/drivers/video/arkfb.c:1019:23: warning: cast to
    pointer from integer of different size [-Wint-to-pointer-cast]
    par->state.vgabase = (void __iomem *) vga_res.start;
                         ^
/home/hpa/kernel/distwork/drivers/video/s3fb.c: In function ‘s3_pci_probe’:
/home/hpa/kernel/distwork/drivers/video/s3fb.c:1186:23: warning: cast to pointer
    from integer of different size [-Wint-to-pointer-cast]
    par->state.vgabase = (void __iomem *) vga_res.start;
                         ^

This is due to resource_size_t being 64bit but "void*" 32bit. This patch tries
to suppress these warnings but I am not really comfortable fixing this. I have
no idea whether my assumption (IO address are 32bit) is right. Please verify.

 @David: The following 3 commits of yours presumably introduced the warnings. I
would be glad if you could review this:

commit 94c322c30bd14ae6cdd369cb4a1f94c5c3809ac9
Author: David Miller <davem@davemloft.net>
Date:   Tue Jan 11 23:54:21 2011 +0000

    s3fb: Compute VGA base iomem pointer explicitly.

commit 892c24ca40ffebf6d0ca4cc1454e58db131a4f5a
Author: David Miller <davem@davemloft.net>
Date:   Tue Jan 11 23:54:35 2011 +0000

    arkfb: Compute VGA base iomem pointer explicitly.

commit 6a2f6d5e970afbc1b8b08bafae9d9138a3206960
Author: David Miller <davem@davemloft.net>
Date:   Tue Jan 11 23:55:17 2011 +0000

    vt8623fb: Compute VGA base iomem pointer explicitly.

Cheers
David

 drivers/video/arkfb.c    | 2 +-
 drivers/video/s3fb.c     | 2 +-
 drivers/video/vt8623fb.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
index 94a51f1..a4e487c 100644
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -1016,7 +1016,7 @@ static int ark_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *)(unsigned long) vga_res.start;
 
 	/* FIXME get memsize */
 	regval = vga_rseq(par->state.vgabase, 0x10);
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index 47ca86c..fc2208b 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -1183,7 +1183,7 @@ static int s3_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *)(unsigned long) vga_res.start;
 
 	/* Unlock regs */
 	cr38 = vga_rcrt(par->state.vgabase, 0x38);
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index e9557fa..3039d82 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -729,7 +729,7 @@ static int vt8623_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *)(unsigned long) vga_res.start;
 
 	/* Find how many physical memory there is on card */
 	memsize1 = (vga_rseq(par->state.vgabase, 0x34) + 1) >> 1;
-- 
1.8.3.4

