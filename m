Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab3FCWVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:21:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab3FCWMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:02 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=g6B7yjg1ZWsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tc8F063L6NoA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=Op-mwl0xAAAA:8 a=vmLDa1wCAAAA:8 a=YtyL8ewWos7s99GDt2kA:9 a=9RRF0ttvEvMA:10 a=d4CUUju0HPYA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221155.960103825@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Drake <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [22/65] mwifiex: clear is_suspended flag when interrupt is received early
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0022-mwifiex-clear-is_suspended-flag-when-interrupt-is-re.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

[ Upstream commit 48795424acff7215d5eac0b52793a2c1eb3a6283 ]

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

Cc: <stable@vger.kernel.org>
Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 95382f1..31d641b 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1159,6 +1159,7 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 	adapter->if_ops.wakeup(adapter);
 	adapter->hs_activated = false;
 	adapter->is_hs_configured = false;
+	adapter->is_suspended = false;
 	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
 						    MWIFIEX_BSS_ROLE_ANY),
 				   false);
-- 
1.7.10.4


