Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaIJQvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:51:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16189 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaIJQvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:51:23 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-96-541081884fb2
From: Maciej Matraszek <m.matraszek@samsung.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: stable@vger.kernel.org, Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maciej Matraszek <m.matraszek@samsung.com>
Subject: [PATCH v2] [media] v4l2-common: fix overflow in v4l_bound_align_image()
Date: Wed, 10 Sep 2014 18:51:09 +0200
Message-id: <1410367869-27688-1-git-send-email-m.matraszek@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHJMWRmVeSWpSXmKPExsVy+t/xa7odjQIhBkceyllsnLGe1WLJz11M
	Fq9fGFosmTyf1eLyrjlsFj0btrJaXFwnb3HyxWVGi8Nv2lktPm35xmSxYOMjRgdujym/N7J6
	zDsZ6LHkzSFWj74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL4Mq43fGGtaBVoKJ7anoD4z+eLkZO
	DgkBE4lXHy+zQ9hiEhfurWcDsYUEljJKPHhmBmH3Mklc/WIHYrMJGEhs/tfP0sXIxSEi8JpR
	YmLHbUYQh1ngHqNE05smVpAqYYEAifW7WphBbBYBVYlNszpYQGxeAXeJ85M+MkJsk5M4eWwy
	6wRG7gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQsLoyw7GxcesDjEKcDAq8fAWXuQP
	EWJNLCuuzD3EKMHBrCTC2+QgECLEm5JYWZValB9fVJqTWnyIkYmDU6qBMdmtv2zBs0T+2s3T
	ph1hfrvhcvrW/3mHDOV3Hz5w3aw0dHV64LGQyFfigr2/i4Xa1R1ZOI6G3d7D+T16UeyGHS/2
	PE+v1FKvnre0f+9fyTtsu7qNtPbpOWXHeVgY6x54f65jyg7ZlW2/Fmw2Kt620/7Br7mrF559
	dNl70RFT4ZI3B19Xrp61x1aJpTgj0VCLuag4EQCpHI+dAQIAAA==
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
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

---
v2: use clamp() instead of clamp_t(), as suggested by Sakari

 drivers/media/v4l2-core/v4l2-common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index ccaa38f65cf1..2e9d81f4c1a5 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -435,16 +435,13 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
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
1.9.1

