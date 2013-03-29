Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3C2LUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:20:54 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3415 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3C2LUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:20:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] solo6x10: The size of the thresholds ioctls was too large.
Date: Fri, 29 Mar 2013 12:20:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc1-durdane; KDE/4.8.4; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303291220.36090.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix the build failure in linux-next.

[PATCH] solo6x10: The size of the thresholds ioctls was too large.

On powerpc the maximum size for the ioctl argument is 8191, and it was
8192. However, the 64x64 array of threshold values is more than is actually
needed in practice for PAL and NTSC formats. A 45x45 array will do just fine.

So change the size accordingly to fix this problem.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10-disp.c |    3 ++-
 drivers/staging/media/solo6x10/solo6x10.h      |    8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-disp.c b/drivers/staging/media/solo6x10/solo6x10-disp.c
index 78070c8..32d9953 100644
--- a/drivers/staging/media/solo6x10/solo6x10-disp.c
+++ b/drivers/staging/media/solo6x10/solo6x10-disp.c
@@ -205,10 +205,11 @@ int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
 		const struct solo_motion_thresholds *thresholds)
 {
 	u32 off = SOLO_MOT_FLAG_AREA + ch * SOLO_MOT_THRESH_SIZE * 2;
-	u16 buf[SOLO_MOTION_SZ];
+	u16 buf[64];
 	int x, y;
 	int ret = 0;
 
+	memset(buf, 0, sizeof(buf));
 	for (y = 0; y < SOLO_MOTION_SZ; y++) {
 		for (x = 0; x < SOLO_MOTION_SZ; x++)
 			buf[x] = cpu_to_le16(thresholds->thresholds[y][x]);
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 3526d6b..6f91d2e 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -113,8 +113,14 @@
  * each sample representing 16x16 pixels of the source. In
  * effect, 44x30 samples are used for NTSC, and 44x36 for PAL.
  * The 5th sample on the 10th row is (10*64)+5 = 645.
+ *
+ * Using a 64x64 array will result in a problem on some architectures like
+ * the powerpc where the size of the argument is limited to 13 bits.
+ * Since both PAL and NTSC do not use the full table anyway I've chosen
+ * to limit the array to 45x45 (45*16 = 720, which is the maximum PAL/NTSC
+ * width).
  */
-#define SOLO_MOTION_SZ (64)
+#define SOLO_MOTION_SZ (45)
 struct solo_motion_thresholds {
 	__u16	thresholds[SOLO_MOTION_SZ][SOLO_MOTION_SZ];
 };
-- 
1.7.10.4

