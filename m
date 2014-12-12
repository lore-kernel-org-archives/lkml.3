Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbaLLG6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:58:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51729 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758621AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Maciej Matraszek" <m.matraszek@samsung.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.934757449@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 015/164] [media] v4l2-common: fix overflow in
 v4l_bound_align_image()
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Matraszek <m.matraszek@samsung.com>

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/v4l2-common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -487,16 +487,13 @@ static unsigned int clamp_align(unsigned
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
 

