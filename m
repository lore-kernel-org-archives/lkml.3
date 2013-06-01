Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3FABgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 21:36:10 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58956 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab3FABfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 21:35:55 -0400
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dongjin Kim <tobetter@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH 3/3] usb: misc: usb3503: Remove 100ms sleep on reset, conform to data sheet
Date: Fri, 31 May 2013 18:34:52 -0700
Message-Id: <1370050492-6046-4-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
References: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb3503 driver sleeps a flat 100ms when resetting the chip, with a
comment about waiting for the reference clock. This seems to be a
board-specific detail that should not hold up boot across all platforms.
This patch reduces the sleep to the 4ms initialization delay that the
chip itself actually requires (as per its data sheet). If certain boards
require more time to set up the reference clock, they should change this
through local patches or add a proper, configurable synchronization
mechanism.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/misc/usb3503.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index a647a2e..a1d509f 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -107,11 +107,9 @@ static int usb3503_reset(int gpio_reset, int state)
 	if (gpio_is_valid(gpio_reset))
 		gpio_set_value(gpio_reset, state);
 
-	/* Wait RefClk when RESET_N is released, otherwise Hub will
-	 * not transition to Hub Communication Stage.
-	 */
+	/* Wait T_HUBINIT == 4ms for hub logic to stabilize */
 	if (state)
-		msleep(100);
+		usleep_range(4000, 10000);
 
 	return 0;
 }
-- 
1.7.12.4

