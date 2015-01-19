Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbbASI6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:58:35 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:54488 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751194AbbASI6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:58:34 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2015 03:58:33 EST
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Federico <federicotg@gmail.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH v2] pci: Fix infinite loop with ROM image of size 0
Date: Mon, 19 Jan 2015 17:53:20 +0900
Message-Id: <1421657600-31561-1-git-send-email-michel@daenzer.net>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <CAFUqUc6JPgSK4tTP7KuJ8TmVLZR6Abaf9uHUTRZA+OJhv8DoBA@mail.gmail.com>
References: <CAFUqUc6JPgSK4tTP7KuJ8TmVLZR6Abaf9uHUTRZA+OJhv8DoBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Dänzer <michel.daenzer@amd.com>

If the image size would ever read as 0, pci_get_rom_size could keep
processing the same image over and over again.

Reported-by: Federico <federicotg@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
---

v2:
* Use unsigned instead of u16 for the local length variable (not sure if
  the multiplication by 512 could overflow otherwise)
* Integrate length condition into while statement
* Add stable tag

 drivers/pci/rom.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index f955edb..eb0ad53 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -71,6 +71,7 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
 {
 	void __iomem *image;
 	int last_image;
+	unsigned length;
 
 	image = rom;
 	do {
@@ -93,9 +94,9 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
 		if (readb(pds + 3) != 'R')
 			break;
 		last_image = readb(pds + 21) & 0x80;
-		/* this length is reliable */
-		image += readw(pds + 16) * 512;
-	} while (!last_image);
+		length = readw(pds + 16);
+		image += length * 512;
+	} while (length && !last_image);
 
 	/* never return a size larger than the PCI resource window */
 	/* there are known ROMs that get the size wrong */
-- 
2.1.4

