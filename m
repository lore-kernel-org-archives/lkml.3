Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbaGXMWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:22:35 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41359 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714AbaGXMWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:22:33 -0400
Date: Thu, 24 Jul 2014 13:22:23 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Message-ID: <20140724122223.GA31798@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724075815.GD15127@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2: Fix incorrectly named variable.

Some block devices (such as Hyper-V passthrough SSDs) support logical
block provisioning (e.g. via UNMAP) but don't set lbpme thus disabling
discard. If the try_lbp quirk is in use skip lbpme checks that lead up
to the logical block provisioning tests.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8249e51..8bf34bc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2559,7 +2559,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
 
-		if (!sdkp->lbpme)
+		if (!sdkp->lbpme && !sdkp->device->try_lbp)
 			goto out;
 
 		lba_count = get_unaligned_be32(&buffer[20]);
@@ -2633,7 +2633,7 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 	unsigned char *buffer;
 	const int vpd_len = 8;
 
-	if (sdkp->lbpme == 0)
+	if (sdkp->lbpme == 0 && sdkp->device->try_lbp == 0)
 		return;
 
 	buffer = kmalloc(vpd_len, GFP_KERNEL);
-- 
1.9.3
