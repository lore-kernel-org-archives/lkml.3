Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422874AbaKNXhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:37:32 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58844 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935407AbaKNXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:36:47 -0500
From: Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Alekseev <igor.alekseev@itep.ru>
Subject: [PATCH 3/3] vme: tsi148: Master windows support USERx and CR/CSR accesses, not slaves
Date: Sat, 15 Nov 2014 02:36:18 +0300
Message-Id: <1416008178-9393-4-git-send-email-dmitry.kalinkin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416008178-9393-1-git-send-email-dmitry.kalinkin@gmail.com>
References: <1416008178-9393-1-git-send-email-dmitry.kalinkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martyn Welch <martyn.welch@ge.com>

The tsi148 driver is registering the slave images as supporting the "USER"
access modes and CR/CSR access mode rather than the master images as it
should.

Remove the incorrect case entries for these modes from the
tsi148_slave_set() function, stop registering slave_images as supporting
these modes and instead register master windows as supporting these modes.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>
Acked-by: Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
---
 drivers/vme/bridges/vme_tsi148.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index e07cfa8..895c2a3 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -587,11 +587,6 @@ static int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
 		granularity = 0x10000;
 		addr |= TSI148_LCSR_ITAT_AS_A64;
 		break;
-	case VME_CRCSR:
-	case VME_USER1:
-	case VME_USER2:
-	case VME_USER3:
-	case VME_USER4:
 	default:
 		dev_err(tsi148_bridge->parent, "Invalid address space\n");
 		return -EINVAL;
@@ -2471,7 +2466,8 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		master_image->locked = 0;
 		master_image->number = i;
 		master_image->address_attr = VME_A16 | VME_A24 | VME_A32 |
-			VME_A64;
+			VME_A64 | VME_CRCSR | VME_USER1 | VME_USER2 |
+			VME_USER3 | VME_USER4;
 		master_image->cycle_attr = VME_SCT | VME_BLT | VME_MBLT |
 			VME_2eVME | VME_2eSST | VME_2eSSTB | VME_2eSST160 |
 			VME_2eSST267 | VME_2eSST320 | VME_SUPER | VME_USER |
@@ -2500,8 +2496,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		slave_image->locked = 0;
 		slave_image->number = i;
 		slave_image->address_attr = VME_A16 | VME_A24 | VME_A32 |
-			VME_A64 | VME_CRCSR | VME_USER1 | VME_USER2 |
-			VME_USER3 | VME_USER4;
+			VME_A64;
 		slave_image->cycle_attr = VME_SCT | VME_BLT | VME_MBLT |
 			VME_2eVME | VME_2eSST | VME_2eSSTB | VME_2eSST160 |
 			VME_2eSST267 | VME_2eSST320 | VME_SUPER | VME_USER |
-- 
1.9.1

