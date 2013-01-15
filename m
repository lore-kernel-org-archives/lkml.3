Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117Ab3AOWzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:55:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:47675 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab3AOWy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:54:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 09/71] SCSI: mvsas: fix undefined bit shift
Date: Tue, 15 Jan 2013 14:54:06 -0800
Message-Id: <20130115225341.084883094@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit beecadea1b8d67f591b13f7099559f32f3fd601d upstream.

The macro bit(n) is defined as ((u32)1 << n), and thus it doesn't work
with n >= 32, such as in mvs_94xx_assign_reg_set():

	if (i >= 32) {
		mvi->sata_reg_set |= bit(i);
		...
	}

The shift ((u32)1 << n) with n >= 32 also leads to undefined behavior.
The result varies depending on the architecture.

This patch changes bit(n) to do a 64-bit shift.  It also simplifies
mv_ffc64() using __ffs64(), since invoking ffz() with ~0 is undefined.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Acked-by: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mvsas/mv_94xx.h |   14 ++------------
 drivers/scsi/mvsas/mv_sas.h  |    2 +-
 2 files changed, 3 insertions(+), 13 deletions(-)

--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -193,21 +193,11 @@ struct mvs_prd {
 #define SPI_ADDR_VLD_94XX         	(1U << 1)
 #define SPI_CTRL_SpiStart_94XX     	(1U << 0)
 
-#define mv_ffc(x)   ffz(x)
-
 static inline int
 mv_ffc64(u64 v)
 {
-	int i;
-	i = mv_ffc((u32)v);
-	if (i >= 0)
-		return i;
-	i = mv_ffc((u32)(v>>32));
-
-	if (i != 0)
-		return 32 + i;
-
-	return -1;
+	u64 x = ~v;
+	return x ? __ffs64(x) : -1;
 }
 
 #define r_reg_set_enable(i) \
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -73,7 +73,7 @@ extern struct kmem_cache *mvs_task_list_
 #define DEV_IS_EXPANDER(type)	\
 	((type == EDGE_DEV) || (type == FANOUT_DEV))
 
-#define bit(n) ((u32)1 << n)
+#define bit(n) ((u64)1 << n)
 
 #define for_each_phy(__lseq_mask, __mc, __lseq)			\
 	for ((__mc) = (__lseq_mask), (__lseq) = 0;		\


