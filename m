Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaJ0R47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:56:59 -0400
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:57737 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751565AbaJ0R46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:56:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:1:41:69:355:379:541:599:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2639:2693:2737:2828:2914:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:4823:5007:6117:6119:6261:7903:7904:8828:8957:9592:10004:10848:11026:11232:11233:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:12740:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stove18_598b66ca4111e
X-Filterd-Recvd-Size: 14239
Message-ID: <1414432614.18896.1.camel@perches.com>
Subject: Re: [PATCH 03/11] aiptek: Fix probable mask then right shift defects
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Date: Mon, 27 Oct 2014 10:56:54 -0700
In-Reply-To: <20141027144411.GA7594@dtor-ws>
References: <cover.1414387334.git.joe@perches.com>
	 <8c6687a4d568c853ab649ba03d2477ee24bc6ff6.1414387334.git.joe@perches.com>
	 <20141027144411.GA7594@dtor-ws>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 07:44 -0700, Dmitry Torokhov wrote:
> Hi Joe,

Hello Dmitry.

> On Sun, Oct 26, 2014 at 10:24:59PM -0700, Joe Perches wrote:
> > Precedence of & and >> is not the same and is not left to right.
> > shift has higher precedence and should be done after the mask.
> 
> Looking at the protocol description the current code is exactly right.
> We want to "move" button bits first as in packet type 1 they are in a
> different place than in other packets.
> 
> I'll take a patch that adds parenthesis around shifts to make clear it
> is intended.

I think it's more sensible to do the shift first to a
temporary then direct comparisons.

Perhaps something like this cleanup that also uses
a temporary for aiptek->curSetting and
!!(foo & mask) instead of ((foo & mask) != 0) ? 1 : 0;
---
 drivers/input/tablet/aiptek.c | 149 ++++++++++++++++++++----------------------
 1 file changed, 72 insertions(+), 77 deletions(-)

diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index e7f966d..9c46618 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -433,6 +433,7 @@ static const char *map_val_to_str(const struct aiptek_map *map, int val)
 static void aiptek_irq(struct urb *urb)
 {
 	struct aiptek *aiptek = urb->context;
+	struct aiptek_settings *settings = &aiptek->curSetting;
 	unsigned char *data = aiptek->data;
 	struct input_dev *inputdev = aiptek->inputdev;
 	struct usb_interface *intf = aiptek->intf;
@@ -472,26 +473,31 @@ static void aiptek_irq(struct urb *urb)
 	 * tool generated the event.
 	 */
 	if (data[0] == 1) {
-		if (aiptek->curSetting.coordinateMode ==
+		if (settings->coordinateMode ==
 		    AIPTEK_COORDINATE_ABSOLUTE_MODE) {
 			aiptek->diagnostic =
 			    AIPTEK_DIAGNOSTIC_SENDING_RELATIVE_IN_ABSOLUTE;
 		} else {
-			x = (signed char) data[2];
-			y = (signed char) data[3];
-
-			/* jitterable keeps track of whether any button has been pressed.
-			 * We're also using it to remap the physical mouse button mask
-			 * to pseudo-settings. (We don't specifically care about it's
-			 * value after moving/transposing mouse button bitmasks, except
+			/*
+			 * Shift buttons pressed to the curSettings location.
+			 * jitterable keeps track of whether any button has
+			 * been pressed.  We're also using it to remap the
+			 * physical mouse button mask to pseudo-settings.
+			 * (We don't specifically care about it's value after
+			 * moving/transposing mouse button bitmasks, except
 			 * that a non-zero value indicates that one or more
 			 * mouse button was pressed.)
 			 */
+			unsigned char buttons = data[1] << 2;
+
+			x = (signed char)data[2];
+			y = (signed char)data[3];
+
 			jitterable = data[1] & 0x07;
 
-			left = (data[1] & aiptek->curSetting.mouseButtonLeft >> 2) != 0 ? 1 : 0;
-			right = (data[1] & aiptek->curSetting.mouseButtonRight >> 2) != 0 ? 1 : 0;
-			middle = (data[1] & aiptek->curSetting.mouseButtonMiddle >> 2) != 0 ? 1 : 0;
+			left = !!(buttons & settings->mouseButtonLeft);
+			right = !!(buttons & settings->mouseButtonRight);
+			middle = !!(buttons & settings->mouseButtonMiddle);
 
 			input_report_key(inputdev, BTN_LEFT, left);
 			input_report_key(inputdev, BTN_MIDDLE, middle);
@@ -505,10 +511,10 @@ static void aiptek_irq(struct urb *urb)
 			/* Wheel support is in the form of a single-event
 			 * firing.
 			 */
-			if (aiptek->curSetting.wheel != AIPTEK_WHEEL_DISABLE) {
+			if (settings->wheel != AIPTEK_WHEEL_DISABLE) {
 				input_report_rel(inputdev, REL_WHEEL,
-						 aiptek->curSetting.wheel);
-				aiptek->curSetting.wheel = AIPTEK_WHEEL_DISABLE;
+						 settings->wheel);
+				settings->wheel = AIPTEK_WHEEL_DISABLE;
 			}
 			if (aiptek->lastMacro != -1) {
 			        input_report_key(inputdev,
@@ -522,26 +528,26 @@ static void aiptek_irq(struct urb *urb)
 	 * absolute coordinates.
 	 */
 	else if (data[0] == 2) {
-		if (aiptek->curSetting.coordinateMode == AIPTEK_COORDINATE_RELATIVE_MODE) {
+		if (settings->coordinateMode == AIPTEK_COORDINATE_RELATIVE_MODE) {
 			aiptek->diagnostic = AIPTEK_DIAGNOSTIC_SENDING_ABSOLUTE_IN_RELATIVE;
 		} else if (!AIPTEK_POINTER_ALLOW_STYLUS_MODE
-			    (aiptek->curSetting.pointerMode)) {
+			    (settings->pointerMode)) {
 				aiptek->diagnostic = AIPTEK_DIAGNOSTIC_TOOL_DISALLOWED;
 		} else {
 			x = get_unaligned_le16(data + 1);
 			y = get_unaligned_le16(data + 3);
 			z = get_unaligned_le16(data + 6);
 
-			dv = (data[5] & 0x01) != 0 ? 1 : 0;
-			p = (data[5] & 0x02) != 0 ? 1 : 0;
-			tip = (data[5] & 0x04) != 0 ? 1 : 0;
+			dv = !!(data[5] & 0x01);
+			p = !!(data[5] & 0x02);
+			tip = !!(data[5] & 0x04);
 
 			/* Use jitterable to re-arrange button masks
 			 */
 			jitterable = data[5] & 0x18;
 
-			bs = (data[5] & aiptek->curSetting.stylusButtonLower) != 0 ? 1 : 0;
-			pck = (data[5] & aiptek->curSetting.stylusButtonUpper) != 0 ? 1 : 0;
+			bs = !!(data[5] & settings->stylusButtonLower);
+			pck = !!(data[5] & settings->stylusButtonUpper);
 
 			/* dv indicates 'data valid' (e.g., the tablet is in sync
 			 * and has delivered a "correct" report) We will ignore
@@ -552,14 +558,14 @@ static void aiptek_irq(struct urb *urb)
 				 * tool key, and set the new one.
 				 */
 				if (aiptek->previousToolMode !=
-				    aiptek->curSetting.toolMode) {
+				    settings->toolMode) {
 				        input_report_key(inputdev,
 							 aiptek->previousToolMode, 0);
 					input_report_key(inputdev,
-							 aiptek->curSetting.toolMode,
+							 settings->toolMode,
 							 1);
 					aiptek->previousToolMode =
-					          aiptek->curSetting.toolMode;
+					          settings->toolMode;
 				}
 
 				if (p != 0) {
@@ -571,27 +577,25 @@ static void aiptek_irq(struct urb *urb)
 					input_report_key(inputdev, BTN_STYLUS, bs);
 					input_report_key(inputdev, BTN_STYLUS2, pck);
 
-					if (aiptek->curSetting.xTilt !=
-					    AIPTEK_TILT_DISABLE) {
+					if (settings->xTilt != AIPTEK_TILT_DISABLE) {
 						input_report_abs(inputdev,
 								 ABS_TILT_X,
-								 aiptek->curSetting.xTilt);
+								 settings->xTilt);
 					}
-					if (aiptek->curSetting.yTilt != AIPTEK_TILT_DISABLE) {
+					if (settings->yTilt != AIPTEK_TILT_DISABLE) {
 						input_report_abs(inputdev,
 								 ABS_TILT_Y,
-								 aiptek->curSetting.yTilt);
+								 settings->yTilt);
 					}
 
 					/* Wheel support is in the form of a single-event
 					 * firing.
 					 */
-					if (aiptek->curSetting.wheel !=
-					    AIPTEK_WHEEL_DISABLE) {
+					if (settings->wheel != AIPTEK_WHEEL_DISABLE) {
 						input_report_abs(inputdev,
 								 ABS_WHEEL,
-								 aiptek->curSetting.wheel);
-						aiptek->curSetting.wheel = AIPTEK_WHEEL_DISABLE;
+								 settings->wheel);
+						settings->wheel = AIPTEK_WHEEL_DISABLE;
 					}
 				}
 				input_report_abs(inputdev, ABS_MISC, p | AIPTEK_REPORT_TOOL_STYLUS);
@@ -607,10 +611,10 @@ static void aiptek_irq(struct urb *urb)
 	/* Report 3's come from the mouse in absolute mode.
 	 */
 	else if (data[0] == 3) {
-		if (aiptek->curSetting.coordinateMode == AIPTEK_COORDINATE_RELATIVE_MODE) {
+		if (settings->coordinateMode == AIPTEK_COORDINATE_RELATIVE_MODE) {
 			aiptek->diagnostic = AIPTEK_DIAGNOSTIC_SENDING_ABSOLUTE_IN_RELATIVE;
 		} else if (!AIPTEK_POINTER_ALLOW_MOUSE_MODE
-			(aiptek->curSetting.pointerMode)) {
+			(settings->pointerMode)) {
 			aiptek->diagnostic = AIPTEK_DIAGNOSTIC_TOOL_DISALLOWED;
 		} else {
 			x = get_unaligned_le16(data + 1);
@@ -618,25 +622,25 @@ static void aiptek_irq(struct urb *urb)
 
 			jitterable = data[5] & 0x1c;
 
-			dv = (data[5] & 0x01) != 0 ? 1 : 0;
-			p = (data[5] & 0x02) != 0 ? 1 : 0;
-			left = (data[5] & aiptek->curSetting.mouseButtonLeft) != 0 ? 1 : 0;
-			right = (data[5] & aiptek->curSetting.mouseButtonRight) != 0 ? 1 : 0;
-			middle = (data[5] & aiptek->curSetting.mouseButtonMiddle) != 0 ? 1 : 0;
+			dv = !!(data[5] & 0x01);
+			p = !!(data[5] & 0x02);
+			left = !!(data[5] & settings->mouseButtonLeft);
+			right = !!(data[5] & settings->mouseButtonRight);
+			middle = !!(data[5] & settings->mouseButtonMiddle);
 
 			if (dv != 0) {
 				/* If the selected tool changed, reset the old
 				 * tool key, and set the new one.
 				 */
 				if (aiptek->previousToolMode !=
-				    aiptek->curSetting.toolMode) {
+				    settings->toolMode) {
 				        input_report_key(inputdev,
 							 aiptek->previousToolMode, 0);
 					input_report_key(inputdev,
-							 aiptek->curSetting.toolMode,
+							 settings->toolMode,
 							 1);
 					aiptek->previousToolMode =
-					          aiptek->curSetting.toolMode;
+					          settings->toolMode;
 				}
 
 				if (p != 0) {
@@ -650,11 +654,11 @@ static void aiptek_irq(struct urb *urb)
 					/* Wheel support is in the form of a single-event
 					 * firing.
 					 */
-					if (aiptek->curSetting.wheel != AIPTEK_WHEEL_DISABLE) {
+					if (settings->wheel != AIPTEK_WHEEL_DISABLE) {
 						input_report_abs(inputdev,
 								 ABS_WHEEL,
-								 aiptek->curSetting.wheel);
-						aiptek->curSetting.wheel = AIPTEK_WHEEL_DISABLE;
+								 settings->wheel);
+						settings->wheel = AIPTEK_WHEEL_DISABLE;
 					}
 				}
 				input_report_abs(inputdev, ABS_MISC, p | AIPTEK_REPORT_TOOL_MOUSE);
@@ -672,11 +676,11 @@ static void aiptek_irq(struct urb *urb)
 	else if (data[0] == 4) {
 		jitterable = data[1] & 0x18;
 
-		dv = (data[1] & 0x01) != 0 ? 1 : 0;
-		p = (data[1] & 0x02) != 0 ? 1 : 0;
-		tip = (data[1] & 0x04) != 0 ? 1 : 0;
-		bs = (data[1] & aiptek->curSetting.stylusButtonLower) != 0 ? 1 : 0;
-		pck = (data[1] & aiptek->curSetting.stylusButtonUpper) != 0 ? 1 : 0;
+		dv = !!(data[1] & 0x01);
+		p = !!(data[1] & 0x02);
+		tip = !!(data[1] & 0x04);
+		bs = !!(data[1] & settings->stylusButtonLower);
+		pck = !!(data[1] & settings->stylusButtonUpper);
 
 		macro = dv && p && tip && !(data[3] & 1) ? (data[3] >> 1) : -1;
 		z = get_unaligned_le16(data + 4);
@@ -685,15 +689,12 @@ static void aiptek_irq(struct urb *urb)
 		        /* If the selected tool changed, reset the old
 			 * tool key, and set the new one.
 			 */
-		        if (aiptek->previousToolMode !=
-			    aiptek->curSetting.toolMode) {
+		        if (aiptek->previousToolMode != settings->toolMode) {
 			        input_report_key(inputdev,
 						 aiptek->previousToolMode, 0);
 				input_report_key(inputdev,
-						 aiptek->curSetting.toolMode,
-						 1);
-				aiptek->previousToolMode =
-				        aiptek->curSetting.toolMode;
+						 settings->toolMode, 1);
+				aiptek->previousToolMode = settings->toolMode;
 			}
 		}
 
@@ -715,24 +716,23 @@ static void aiptek_irq(struct urb *urb)
 	else if (data[0] == 5) {
 		jitterable = data[1] & 0x1c;
 
-		dv = (data[1] & 0x01) != 0 ? 1 : 0;
-		p = (data[1] & 0x02) != 0 ? 1 : 0;
-		left = (data[1]& aiptek->curSetting.mouseButtonLeft) != 0 ? 1 : 0;
-		right = (data[1] & aiptek->curSetting.mouseButtonRight) != 0 ? 1 : 0;
-		middle = (data[1] & aiptek->curSetting.mouseButtonMiddle) != 0 ? 1 : 0;
+		dv = !!(data[1] & 0x01);
+		p = !!(data[1] & 0x02);
+		left = !!(data[1]& settings->mouseButtonLeft);
+		right = !!(data[1] & settings->mouseButtonRight);
+		middle = !!(data[1] & settings->mouseButtonMiddle);
 		macro = dv && p && left && !(data[3] & 1) ? (data[3] >> 1) : 0;
 
 		if (dv) {
 		        /* If the selected tool changed, reset the old
 			 * tool key, and set the new one.
 			 */
-		        if (aiptek->previousToolMode !=
-			    aiptek->curSetting.toolMode) {
+		        if (aiptek->previousToolMode != settings->toolMode) {
 		                input_report_key(inputdev,
 						 aiptek->previousToolMode, 0);
 			        input_report_key(inputdev,
-						 aiptek->curSetting.toolMode, 1);
-			        aiptek->previousToolMode = aiptek->curSetting.toolMode;
+						 settings->toolMode, 1);
+			        aiptek->previousToolMode = settings->toolMode;
 			}
 		}
 
@@ -770,15 +770,10 @@ static void aiptek_irq(struct urb *urb)
 		/* If the selected tool changed, reset the old
 		   tool key, and set the new one.
 		*/
-		if (aiptek->previousToolMode !=
-		    aiptek->curSetting.toolMode) {
-		        input_report_key(inputdev,
-					 aiptek->previousToolMode, 0);
-			input_report_key(inputdev,
-					 aiptek->curSetting.toolMode,
-					 1);
-			aiptek->previousToolMode =
-				aiptek->curSetting.toolMode;
+		if (aiptek->previousToolMode != settings->toolMode) {
+		        input_report_key(inputdev, aiptek->previousToolMode, 0);
+			input_report_key(inputdev, settings->toolMode, 1);
+			aiptek->previousToolMode = settings->toolMode;
 		}
 
 		input_report_key(inputdev, macroKeyEvents[macro], 1);
@@ -802,9 +797,9 @@ static void aiptek_irq(struct urb *urb)
 	 */
 
 	if (aiptek->previousJitterable != jitterable &&
-	    aiptek->curSetting.jitterDelay != 0 && aiptek->inDelay != 1) {
+	    settings->jitterDelay != 0 && aiptek->inDelay != 1) {
 		aiptek->endDelay = jiffies +
-		    ((aiptek->curSetting.jitterDelay * HZ) / 1000);
+			((settings->jitterDelay * HZ) / 1000);
 		aiptek->inDelay = 1;
 	}
 	aiptek->previousJitterable = jitterable;


