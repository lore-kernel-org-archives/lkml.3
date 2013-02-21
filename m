Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3BULkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:40:04 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:57189 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab3BULkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:40:01 -0500
Message-ID: <1361446784.1341.41.camel@x61.thuisdomein>
Subject: [PATCH v2] [SCSI] aacraid: suppress two GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Date: Thu, 21 Feb 2013 12:39:44 +0100
In-Reply-To: <1361358077.1341.14.camel@x61.thuisdomein>
References: <1360440561.1350.27.camel@x61.thuisdomein>
	 <1361356823.2581.43.camel@dabdike.int.hansenpartnership.com>
	 <1361358077.1341.14.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Feb 2013 11:39:50.0102 (UTC) FILETIME=[284A5760:01CE1028]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building src.o for a 32 bit system triggers two GCC warnings:
    drivers/scsi/aacraid/src.c: In function ‘aac_src_deliver_message’:
    drivers/scsi/aacraid/src.c:410:3: warning: right shift count >= width of type [enabled by default]
    drivers/scsi/aacraid/src.c:434:2: warning: right shift count >= width of type [enabled by default]

These warnings are caused by a right shift of 32. Use upper_32_bits() to
suppress them.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Instead of a cast to u64, this version uses upper_32_bits() as James
suggested. I also stopped changing 0L to 0UL, because I keep having
doubts about the cargo cult.

1) Still compile tested only, but now on v3.8.

 drivers/scsi/aacraid/src.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..e2e3492 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		fib->hw_fib_va->header.StructType = FIB_MAGIC2;
 		fib->hw_fib_va->header.SenderFibAddress = (u32)address;
 		fib->hw_fib_va->header.u.TimeStamp = 0;
-		BUG_ON((u32)(address >> 32) != 0L);
+		BUG_ON(upper_32_bits(address) != 0L);
 		address |= fibsize;
 	} else {
 		/* Calculate the amount to the fibsize bits */
@@ -431,7 +431,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		address |= fibsize;
 	}
 
-	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
+	src_writel(dev, MUnit.IQ_H, upper_32_bits(address) & 0xffffffff);
 	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
 
 	return 0;
-- 
1.8.1.2

