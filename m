Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaFZNpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:45:01 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63541 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaFZNpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:45:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-scsi@vger.kernel.org
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        jbottomley@parallels.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [SCSI] hpsa: fix non-x86 builds
Date: Thu, 26 Jun 2014 15:44:52 +0200
Message-ID: <6003317.KPlAy1USkq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5Cg076d5BoYboukCtZcLH7t6NRqcJCnlEUlPrhqFEXm
 avTIHDrn8HWFIpmASwzjQIvEU2YJEIcBzNVkUBP+WtVMEq7iVt
 aPQhtoKP165Xay3xFuEMmGqtWeoQssCwO5Vak6S9ioEv2dr5DC
 8aZdNQlZqJ4rLHlAVLmZcRecM3eT+U6sCEW7y9e3T/Q4jihAIz
 ZgPr+/eiuUcF3Hs1ZpTEYu8lYbpOKvXviyGtCMUAl3UKmwieoZ
 0/pvrBPUAHRLiMpi64QwvJflRZxyClD1gqFw9OZaKkDCExKgdV
 mZXrfutiwuq21c4q4sukFWYqdwoGR/oNx3VGhxZ9nQoll3e4oJ
 r0Nod96SeN+2TCRDk99g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 28e134464734 "[SCSI] hpsa: enable unit attention reporting"
turns on unit attention notifications, but got the change wrong for
all architectures other than x86, which now store an uninitialized
value into the device register.

Gcc helpfully warns about this:

../drivers/scsi/hpsa.c: In function 'hpsa_set_driver_support_bits':
../drivers/scsi/hpsa.c:6373:17: warning: 'driver_support' is used uninitialized in this function [-Wuninitialized]
  driver_support |= ENABLE_UNIT_ATTN;
                 ^

This moves the #ifdef so only the prefetch-enable is conditional
on x86, not also reading the initial register contents. 


Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 28e134464734 "[SCSI] hpsa: enable unit attention reporting"
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org # v3.14+

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 31184b3..d0e487c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6365,9 +6365,9 @@ static inline void hpsa_set_driver_support_bits(struct ctlr_info *h)
 {
 	u32 driver_support;
 
-#ifdef CONFIG_X86
-	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
 	driver_support = readl(&(h->cfgtable->driver_support));
+	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
+#ifdef CONFIG_X86
 	driver_support |= ENABLE_SCSI_PREFETCH;
 #endif
 	driver_support |= ENABLE_UNIT_ATTN;

