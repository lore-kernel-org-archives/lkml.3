Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab3BIUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 15:09:28 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:64117 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932499Ab3BIUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 15:09:27 -0500
Message-ID: <1360440561.1350.27.camel@x61.thuisdomein>
Subject: [PATCH] [SCSI] aacraid: silence two GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 09 Feb 2013 21:09:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Feb 2013 20:09:22.0072 (UTC) FILETIME=[59A5C180:01CE0701]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling src.o for a 32 bit system triggers two GCC warnings:
    drivers/scsi/aacraid/src.c: In function ‘aac_src_deliver_message’:
    drivers/scsi/aacraid/src.c:410:3: warning: right shift count >= width of type [enabled by default]
    drivers/scsi/aacraid/src.c:434:2: warning: right shift count >= width of type [enabled by default]

Silence these warnings by casting the 'address' variable (of type
dma_addr_t) to u64 on those two lines.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) Changing '0L' to 'OUL' might be a bit of cargo cult programming. I
doubt it's necessary. Members of that cult might also change
'0xffffffff' to '0xffffffffUL', but I didn't.

 drivers/scsi/aacraid/src.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..dfa8a37 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		fib->hw_fib_va->header.StructType = FIB_MAGIC2;
 		fib->hw_fib_va->header.SenderFibAddress = (u32)address;
 		fib->hw_fib_va->header.u.TimeStamp = 0;
-		BUG_ON((u32)(address >> 32) != 0L);
+		BUG_ON(((u64)address >> 32) != 0UL);
 		address |= fibsize;
 	} else {
 		/* Calculate the amount to the fibsize bits */
@@ -431,7 +431,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		address |= fibsize;
 	}
 
-	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
+	src_writel(dev, MUnit.IQ_H, ((u64)address >> 32) & 0xffffffff);
 	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
 
 	return 0;
-- 
1.8.1.2

