Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3CZXim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:38:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3CZWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julia Lemire <jlemire@matrox.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 59/98] drm/mgag200: Bug fix: Modified pll algorithm for EH project
Date: Tue, 26 Mar 2013 15:42:48 -0700
Message-Id: <20130326224248.651684753@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -382,19 +382,19 @@ static int mga_g200eh_set_plls(struct mg
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
@@ -404,11 +404,11 @@ static int mga_g200eh_set_plls(struct mg
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


