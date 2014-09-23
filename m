Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaIWLBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:01:14 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40542 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbaIWLBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:01:12 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] ALSA: ctxfi: sparse warning
Date: Tue, 23 Sep 2014 16:30:24 +0530
Message-Id: <1411470024-25244-5-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411470024-25244-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411470024-25244-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning of incorrect type (different address spaces) in
cthw20k1.c and cthw20k2.c which was being actually caused as mem_base
was of the type unsigned long.

Again as mem_base was previously unsigned long , so it required many
typecasts in the code to convert interger to pointer.

Now after giving the correct type of mem_base as void __iomem *
we can also remove those typecasts maintaining the same functionality
and logic of the code.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/cthardware.h |  2 +-
 sound/pci/ctxfi/cthw20k1.c   |  6 +++---
 sound/pci/ctxfi/cthw20k2.c   | 12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/pci/ctxfi/cthardware.h b/sound/pci/ctxfi/cthardware.h
index 940bbd0..0be24f7 100644
--- a/sound/pci/ctxfi/cthardware.h
+++ b/sound/pci/ctxfi/cthardware.h
@@ -188,7 +188,7 @@ struct hw {
 	struct snd_card *card; /* pointer to this card */
 	int irq;
 	unsigned long io_base;
-	unsigned long mem_base;
+	void __iomem *mem_base;
 
 	enum CHIPTYP chip_type;
 	enum CTCARDS model;
diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
index b807391..b425aa8 100644
--- a/sound/pci/ctxfi/cthw20k1.c
+++ b/sound/pci/ctxfi/cthw20k1.c
@@ -1803,7 +1803,7 @@ static int uaa_to_xfi(struct pci_dev *pci)
 	unsigned int is_uaa;
 	unsigned int data[4] = {0};
 	unsigned int io_base;
-	void *mem_base;
+	void __iomem *mem_base;
 	int i;
 	const u32 CTLX = CTLBITS('C', 'T', 'L', 'X');
 	const u32 CTL_ = CTLBITS('C', 'T', 'L', '-');
@@ -1987,9 +1987,9 @@ static int hw_card_shutdown(struct hw *hw)
 	hw->irq	= -1;
 
 	if (hw->mem_base)
-		iounmap((void *)hw->mem_base);
+		iounmap(hw->mem_base);
 
-	hw->mem_base = (unsigned long)NULL;
+	hw->mem_base = NULL;
 
 	if (hw->io_base)
 		pci_release_regions(hw->pci);
diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index 144fab6..253899d 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -2050,8 +2050,8 @@ static int hw_card_start(struct hw *hw)
 			goto error1;
 
 		hw->io_base = pci_resource_start(hw->pci, 2);
-		hw->mem_base = (unsigned long)ioremap(hw->io_base,
-					pci_resource_len(hw->pci, 2));
+		hw->mem_base = ioremap(hw->io_base,
+				       pci_resource_len(hw->pci, 2));
 		if (!hw->mem_base) {
 			err = -ENOENT;
 			goto error2;
@@ -2112,9 +2112,9 @@ static int hw_card_shutdown(struct hw *hw)
 	hw->irq	= -1;
 
 	if (hw->mem_base)
-		iounmap((void *)hw->mem_base);
+		iounmap(hw->mem_base);
 
-	hw->mem_base = (unsigned long)NULL;
+	hw->mem_base = NULL;
 
 	if (hw->io_base)
 		pci_release_regions(hw->pci);
@@ -2234,12 +2234,12 @@ static int hw_resume(struct hw *hw, struct card_conf *info)
 
 static u32 hw_read_20kx(struct hw *hw, u32 reg)
 {
-	return readl((void *)(hw->mem_base + reg));
+	return readl(hw->mem_base + reg);
 }
 
 static void hw_write_20kx(struct hw *hw, u32 reg, u32 data)
 {
-	writel(data, (void *)(hw->mem_base + reg));
+	writel(data, hw->mem_base + reg);
 }
 
 static struct hw ct20k2_preset = {
-- 
1.8.1.2

