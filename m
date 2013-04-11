Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765334Ab3DKU2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:28:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120Ab3DKU0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:20 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7Smb_611F0MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TIiEESmxbPIA:10 a=6zZ5Uxn1AAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=QwnTS9JGZEsA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202554.363249873@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Julia Lemire <jlemire@matrox.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 050/171 ] drm/mgag200: Bug fix: Modified pll algorithm for EH project
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0050-drm-mgag200-Bug-fix-Modified-pll-algorithm-for-EH-pr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Julia Lemire <jlemire@matrox.com>

[ Upstream commit 260b3f1291a75a580d22ce8bfb1499c617272716 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index b69642d..0a5daaa 100644
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
1.7.10.4


