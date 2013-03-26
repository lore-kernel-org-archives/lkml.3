Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554Ab3CZPnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:43:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab3CZPXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julia Lemire <jlemire@matrox.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 092/150] drm/mgag200: Bug fix: Modified pll algorithm for EH project
Date: Tue, 26 Mar 2013 15:19:51 +0000
Message-Id: <1364311249-14454-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lemire <jlemire@matrox.com>

commit 260b3f1291a75a580d22ce8bfb1499c617272716 upstream.

While testing the mgag200 kms driver on the HP ProLiant Gen8, a
bug was seen.  Once the bootloader would load the selected kernel,
the screen would go black.  At first it was assumed that the
mgag200 kms driver was hanging.  But after setting up the grub
serial output, it was seen that the driver was being loaded
properly.  After trying serval monitors, one finaly displayed
the message "Frequency Out of Range".  By comparing the kms pll
algorithm with the previous mgag200 xorg driver pll algorithm,
discrepencies were found.  Once the kms pll algorithm was
modified, the expected pll values were produced.  This fix was
tested on several monitors of varying native resolutions.

Signed-off-by: Julia Lemire <jlemire@matrox.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 0201d1d..505a917 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -383,19 +383,19 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 	m = n = p = 0;
 	vcomax = 800000;
 	vcomin = 400000;
-	pllreffreq = 3333;
+	pllreffreq = 33333;
 
 	delta = 0xffffffff;
 	permitteddelta = clock * 5 / 1000;
 
-	for (testp = 16; testp > 0; testp--) {
+	for (testp = 16; testp > 0; testp >>= 1) {
 		if (clock * testp > vcomax)
 			continue;
 		if (clock * testp < vcomin)
 			continue;
 
 		for (testm = 1; testm < 33; testm++) {
-			for (testn = 1; testn < 257; testn++) {
+			for (testn = 17; testn < 257; testn++) {
 				computed = (pllreffreq * testn) /
 					(testm * testp);
 				if (computed > clock)
@@ -405,11 +405,11 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 				if (tmpdelta < delta) {
 					delta = tmpdelta;
 					n = testn - 1;
-					m = (testm - 1) | ((n >> 1) & 0x80);
+					m = (testm - 1);
 					p = testp - 1;
 				}
 				if ((clock * testp) >= 600000)
-					p |= 80;
+					p |= 0x80;
 			}
 		}
 	}
-- 
1.8.1.2

