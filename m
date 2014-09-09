Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaIIPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:16:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23596 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaIIPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:16:55 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-05-540f19e4207d
From: Maciej Matraszek <m.matraszek@samsung.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: stable@vger.kernel.org, Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Maciej Matraszek <m.matraszek@samsung.com>
Subject: [PATCH] [media] v4l2-common: fix overflow in v4l_bound_align_image()
Date: Tue, 09 Sep 2014 17:16:41 +0200
Message-id: <1410275801-17627-1-git-send-email-m.matraszek@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t/xq7pPJPlDDKbf4LfYOGM9q8WSn7uY
	LF6/MLRYMnk+q8XlXXPYLHo2bGW1uLhO3uLki8uMFofftLNaLNj4iNGBy2PK742sHkveHGL1
	6NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyNv+awF8zhr9i7fD9jA+Nyni5GTg4JAROJBctP
	skHYYhIX7q0Hsrk4hASWMkp0r7gK5fQySVy/spEZpIpNwEBi879+FpCEiMBrRomJHbcZQRxm
	gfWMEtu7W9lBqoQFfCU+LL4JZrMIqEqsafsMtoNXwF1i7u3nUPvkJE4em8w6gZF7ASPDKkbR
	1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ0Pm6g3HpMatDjAIcjEo8vBPL+EKEWBPLiitzDzFK
	cDArifBavwAK8aYkVlalFuXHF5XmpBYfYmTi4JRqYGzKSO1f6H6lQa0t3i6w63DyXcuEN4tK
	Vrb1H42xkz3vdfbB9zWC5fuyHls8y3Lwfj7zqvbdqmVLu/eGTp9w+LhF45rdj+oav0qHs2yY
	qeKSEhZYumXut6UeXS9lH36OEZWMO6SzJ2lF+POiXAapxk1HYmfZHIk9kh+5+5pR1jEGvpfL
	Xde9E1BiKc5INNRiLipOBAAioTfL+wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix clamp_align() used in v4l_bound_align_image() to prevent overflow when
passed large value like UINT32_MAX. In the current implementation:
    clamp_align(UINT32_MAX, 8, 8192, 3)
returns 8, because in line:
    x = (x + (1 << (align - 1))) & mask;
x overflows to (-1 + 4) & 0x7 = 3, while expected value is 8192.

v4l_bound_align_image() is heavily used in VIDIOC_S_FMT
and VIDIOC_SUBDEV_S_FMT ioctls handlers, and documentation of the latter
explicitly states that:

"The modified format should be as close as possible to the original request."
  -- http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-subdev-g-fmt.html

Thus one would expect, that passing UINT32_MAX as format width and height
will result in setting maximum possible resolution for the device.
Particularly, when the driver doesn't support VIDIOC_ENUM_FRAMESIZES ioctl,
which is common in the codebase.

Fixes: b0d3159be9a3 ("V4L/DVB (11901): v4l2: Create helper function for bounding and aligning images")
Signed-off-by: Maciej Matraszek <m.matraszek@samsung.com>
---
 drivers/media/v4l2-core/v4l2-common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index ccaa38f65cf1..506cf8b7763b 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -435,16 +435,13 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
 	/* Bits that must be zero to be aligned */
 	unsigned int mask = ~((1 << align) - 1);
 
+	/* Clamp to aligned min and max */
+	x = clamp_t(unsigned int, x, (min + ~mask) & mask, max & mask);
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
1.9.1

