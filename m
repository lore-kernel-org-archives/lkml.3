Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaJ0F1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:27:54 -0400
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:37713 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752756AbaJ0FZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:4321:4823:5007:6261:8957:10004:10848:11026:11658:11914:12043:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: meat91_4c3b3036d0e17
X-Filterd-Recvd-Size: 1953
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Subject: [PATCH 03/11] aiptek: Fix probable mask then right shift defects
Date: Sun, 26 Oct 2014 22:24:59 -0700
Message-Id: <8c6687a4d568c853ab649ba03d2477ee24bc6ff6.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Here the shifts are unnecessary and a non-zero value can be used
as the test to set 1 or zero.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/tablet/aiptek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index e7f966d..dee2bb9 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -489,9 +489,9 @@ static void aiptek_irq(struct urb *urb)
 			 */
 			jitterable = data[1] & 0x07;
 
-			left = (data[1] & aiptek->curSetting.mouseButtonLeft >> 2) != 0 ? 1 : 0;
-			right = (data[1] & aiptek->curSetting.mouseButtonRight >> 2) != 0 ? 1 : 0;
-			middle = (data[1] & aiptek->curSetting.mouseButtonMiddle >> 2) != 0 ? 1 : 0;
+			left = data[1] & aiptek->curSetting.mouseButtonLeft ? 1 : 0;
+			right = data[1] & aiptek->curSetting.mouseButtonRight ? 1 : 0;
+			middle = data[1] & aiptek->curSetting.mouseButtonMiddle ? 1 : 0;
 
 			input_report_key(inputdev, BTN_LEFT, left);
 			input_report_key(inputdev, BTN_MIDDLE, middle);
-- 
2.1.2

