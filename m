Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaKRO5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:57:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbaKROJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Maciej Matraszek <m.matraszek@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/206] media: v4l2-common: fix overflow in v4l_bound_align_image()
Date: Tue, 18 Nov 2014 15:07:32 +0100
Message-Id: <c04a0fa72b628335a12aefa707f46a1a85010225.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Matraszek <m.matraszek@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3bacc10cd4a85bc70bc0b6c001d3bf995c7fe04c upstream.

Fix clamp_align() used in v4l_bound_align_image() to prevent overflow
when passed large value like UINT32_MAX.

 In the current implementation:
    clamp_align(UINT32_MAX, 8, 8192, 3)

returns 8, because in line:

    x = (x + (1 << (align - 1))) & mask;

x overflows to (-1 + 4) & 0x7 = 3, while expected value is 8192.

v4l_bound_align_image() is heavily used in VIDIOC_S_FMT and
VIDIOC_SUBDEV_S_FMT ioctls handlers, and documentation of the latter
explicitly states that:

"The modified format should be as close as possible to the original
request."
  -- http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-subdev-g-fmt.html

Thus one would expect, that passing UINT32_MAX as format width and
height will result in setting maximum possible resolution for the
device. Particularly, when the driver doesn't support
VIDIOC_ENUM_FRAMESIZES ioctl, which is common in the codebase.

Fixes changeset: b0d3159be9a3

Signed-off-by: Maciej Matraszek <m.matraszek@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/v4l2-core/v4l2-common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 037d7a55aa8c..767abc9e5581 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -431,16 +431,13 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
 	/* Bits that must be zero to be aligned */
 	unsigned int mask = ~((1 << align) - 1);
 
+	/* Clamp to aligned min and max */
+	x = clamp(x, (min + ~mask) & mask, max & mask);
+
 	/* Round to nearest aligned value */
 	if (align)
 		x = (x + (1 << (align - 1))) & mask;
 
-	/* Clamp to aligned value of min and max */
-	if (x < min)
-		x = (min + ~mask) & mask;
-	else if (x > max)
-		x = max & mask;
-
 	return x;
 }
 
-- 
2.1.3

