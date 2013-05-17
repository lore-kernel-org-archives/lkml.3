Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab3EQWG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:06:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab3EQVrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Drake <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 18/50] mwifiex: clear is_suspended flag when interrupt is received early
Date: Fri, 17 May 2013 14:46:53 -0700
Message-Id: <20130517213844.592597303@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 48795424acff7215d5eac0b52793a2c1eb3a6283 upstream.

When the XO-4 with 8787 wireless is woken up due to wake-on-WLAN
mwifiex is often flooded with "not allowed while suspended" messages
and the interface is unusable.

[  202.171609] int: sdio_ireg = 0x1
[  202.180700] info: mwifiex_process_hs_config: auto cancelling host
               sleep since there is interrupt from the firmware
[  202.201880] event: wakeup device...
[  202.211452] event: hs_deactivated
[  202.514638] info: --- Rx: Data packet ---
[  202.514753] data: 4294957544 BSS(0-0): Data <= kernel
[  202.514825] PREP_CMD: device in suspended state
[  202.514839] data: dequeuing the packet ec7248c0 ec4869c0
[  202.514886] mwifiex_write_data_sync: not allowed while suspended
[  202.514886] host_to_card, write iomem (1) failed: -1
[  202.514917] mwifiex_write_data_sync: not allowed while suspended
[  202.514936] host_to_card, write iomem (2) failed: -1
[  202.514949] mwifiex_write_data_sync: not allowed while suspended
[  202.514965] host_to_card, write iomem (3) failed: -1
[  202.514976] mwifiex_write_data_async failed: 0xFFFFFFFF

This can be readily reproduced when putting the XO-4 in a loop where
it goes to sleep due to inactivity, but then wakes up due to an
incoming ping. The error is hit within an hour or two.

This issue happens when an interrupt comes in early while host sleep
is still activated. Driver handles this case by auto cancelling host
sleep. However is_suspended flag is still set which prevents any cmd
or data from being sent to firmware. Fix it by clearing is_suspended
flag in this path.

Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/cmdevt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1084,6 +1084,7 @@ mwifiex_process_hs_config(struct mwifiex
 	adapter->if_ops.wakeup(adapter);
 	adapter->hs_activated = false;
 	adapter->is_hs_configured = false;
+	adapter->is_suspended = false;
 	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
 						    MWIFIEX_BSS_ROLE_ANY),
 				   false);


