Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab3G2QqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:46:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47894 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab3G2QpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:45:16 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 2/3] Input: omap-keypad: errata i689: Correct debounce time
Date: Mon, 29 Jul 2013 19:45:10 +0300
Message-ID: <1375116311-13999-3-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com>
References: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Haslam <axelhaslam@ti.com>

Set debounce time value to 12ms to workaround the errata.

ERRATA DESCRIPTION:
When a key is released for a time shorter than the debounce time,
in-between 2 key press (KP1 and KP2), the keyboard state machine will go to
idle mode and will never detect the key release (after KP1,and also after KP2),
and thus will never generate a new IRQ indicating the key release.
>From the operating system standpoint, only a key press as been detected,
and the key will keep on being printed on the screen until another or
the same key is pressed again.When the failing state has been reached,
the KBD_STATEMACHINE register will show "idle state" and the KBD_FULLCODE
register won't be empty, this is the signature of the bug.There is no impact
on the power consumption of the system as the state machine goes to IDLE state.

WORKAROUND:
First thing is to program the debounce time correctly:
If X (us) is the maximum time of bounces when a key is pressed or released,
and Y (us) is the minimum time of a key release that is expected to be detected,
then the debounce time should be set to a value inbetween X and Y.

In case it is still possible to get shorter than debounce time key-release
events, then the only solution is to implement a software workaround:

Before printing a second character on the screen, the software must check if
the keyboard has hit the failing condition (cf signature of the bug above)
or if the key is still really pressed and then take the appropriate actions.

Silicon revisions impacted: OMAP4430 ES 1.0,2.0,2.1,2.2,2.3
                            OMAP4460 ES 1.0,1.1
                            OMAP5430 ES 1.0

Signed-off-by: Axel Haslam <axelhaslam@ti.com>
Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 Based on top of v3.11-rc3

 Depends on:
 Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded values
 https://patchwork.kernel.org/patch/2832913/

 drivers/input/keyboard/omap4-keypad.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index feab00f..e8bdc76 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -62,8 +62,10 @@
 
 /* OMAP4 values */
 #define OMAP4_VAL_IRQDISABLE		0x0
-#define OMAP4_VAL_DEBOUNCINGTIME	0x7
-#define OMAP4_VAL_PVT			0x7
+
+/* Errata i689: set debounce time value to 12ms */
+#define OMAP4_VAL_DEBOUNCINGTIME	0x2
+#define OMAP4_VAL_PVT			0x6
 
 enum {
 	KBD_REVISION_OMAP4 = 0,
-- 
1.7.9.5

