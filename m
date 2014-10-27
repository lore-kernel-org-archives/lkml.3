Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaJ0FZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:25:32 -0400
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:37718 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752778AbaJ0FZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:560:800:960:973:988:989:1260:1345:1359:1437:1534:1544:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:4250:4321:4605:5007:6119:6261:7903:10004:10848:11026:11473:11657:11658:11914:12043:12517:12519:12555:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coat47_4cd7656d6b321
X-Filterd-Recvd-Size: 4933
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        ivtv-devel@ivtvdriver.org
Subject: [PATCH 05/11] cx25840/cx18: Use standard ordering of mask and shift
Date: Sun, 26 Oct 2014 22:25:01 -0700
Message-Id: <0f1e7b544283cd5d8ef1ca6f759af5e208dbc2fd.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

This use has a mask then shift which is not the normal style.

Move the shift before the mask to match nearly all the other
uses in kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 12 ++++++------
 drivers/media/pci/cx18/cx18-av-core.c    | 16 ++++++++--------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index e453a3f..0327032 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -879,7 +879,7 @@ void cx25840_std_setup(struct i2c_client *client)
 	/* Sets horizontal blanking delay and active lines */
 	cx25840_write(client, 0x470, hblank);
 	cx25840_write(client, 0x471,
-			0xff & (((hblank >> 8) & 0x3) | (hactive << 4)));
+		      (((hblank >> 8) & 0x3) | (hactive << 4)) & 0xff);
 	cx25840_write(client, 0x472, hactive >> 4);
 
 	/* Sets burst gate delay */
@@ -888,13 +888,13 @@ void cx25840_std_setup(struct i2c_client *client)
 	/* Sets vertical blanking delay and active duration */
 	cx25840_write(client, 0x474, vblank);
 	cx25840_write(client, 0x475,
-			0xff & (((vblank >> 8) & 0x3) | (vactive << 4)));
+		      (((vblank >> 8) & 0x3) | (vactive << 4)) & 0xff);
 	cx25840_write(client, 0x476, vactive >> 4);
 	cx25840_write(client, 0x477, vblank656);
 
 	/* Sets src decimation rate */
-	cx25840_write(client, 0x478, 0xff & src_decimation);
-	cx25840_write(client, 0x479, 0xff & (src_decimation >> 8));
+	cx25840_write(client, 0x478, src_decimation & 0xff);
+	cx25840_write(client, 0x479, (src_decimation >> 8) & 0xff);
 
 	/* Sets Luma and UV Low pass filters */
 	cx25840_write(client, 0x47a, luma_lpf << 6 | ((uv_lpf << 4) & 0x30));
@@ -904,8 +904,8 @@ void cx25840_std_setup(struct i2c_client *client)
 
 	/* Sets SC Step*/
 	cx25840_write(client, 0x47c, sc);
-	cx25840_write(client, 0x47d, 0xff & sc >> 8);
-	cx25840_write(client, 0x47e, 0xff & sc >> 16);
+	cx25840_write(client, 0x47d, (sc >> 8) & 0xff);
+	cx25840_write(client, 0x47e, (sc >> 16) & 0xff);
 
 	/* Sets VBI parameters */
 	if (std & V4L2_STD_625_50) {
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index 2d3afe0..45be26c 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -490,8 +490,8 @@ void cx18_av_std_setup(struct cx18 *cx)
 
 	/* Sets horizontal blanking delay and active lines */
 	cx18_av_write(cx, 0x470, hblank);
-	cx18_av_write(cx, 0x471, 0xff & (((hblank >> 8) & 0x3) |
-						(hactive << 4)));
+	cx18_av_write(cx, 0x471,
+		      (((hblank >> 8) & 0x3) | (hactive << 4)) & 0xff);
 	cx18_av_write(cx, 0x472, hactive >> 4);
 
 	/* Sets burst gate delay */
@@ -499,14 +499,14 @@ void cx18_av_std_setup(struct cx18 *cx)
 
 	/* Sets vertical blanking delay and active duration */
 	cx18_av_write(cx, 0x474, vblank);
-	cx18_av_write(cx, 0x475, 0xff & (((vblank >> 8) & 0x3) |
-						(vactive << 4)));
+	cx18_av_write(cx, 0x475,
+		      (((vblank >> 8) & 0x3) | (vactive << 4)) & 0xff);
 	cx18_av_write(cx, 0x476, vactive >> 4);
 	cx18_av_write(cx, 0x477, vblank656);
 
 	/* Sets src decimation rate */
-	cx18_av_write(cx, 0x478, 0xff & src_decimation);
-	cx18_av_write(cx, 0x479, 0xff & (src_decimation >> 8));
+	cx18_av_write(cx, 0x478, src_decimation & 0xff);
+	cx18_av_write(cx, 0x479, (src_decimation >> 8) & 0xff);
 
 	/* Sets Luma and UV Low pass filters */
 	cx18_av_write(cx, 0x47a, luma_lpf << 6 | ((uv_lpf << 4) & 0x30));
@@ -516,8 +516,8 @@ void cx18_av_std_setup(struct cx18 *cx)
 
 	/* Sets SC Step*/
 	cx18_av_write(cx, 0x47c, sc);
-	cx18_av_write(cx, 0x47d, 0xff & sc >> 8);
-	cx18_av_write(cx, 0x47e, 0xff & sc >> 16);
+	cx18_av_write(cx, 0x47d, (sc >> 8) & 0xff);
+	cx18_av_write(cx, 0x47e, (sc >> 16) & 0xff);
 
 	if (std & V4L2_STD_625_50) {
 		state->slicer_line_delay = 1;
-- 
2.1.2

