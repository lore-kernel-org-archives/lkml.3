Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaCCTNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:13:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaCCS5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:57:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 24/67] power: max17040: Fix NULL pointer dereference when there is no platform_data
Date: Mon,  3 Mar 2014 10:55:12 -0800
Message-Id: <1393872955-28810-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit ac323d8d807060f7c95a685a9fe861e7b6300993 upstream.

Fix NULL pointer dereference of "chip->pdata" if platform_data was not
supplied to the driver.

The driver during probe stored the pointer to the platform_data:
	chip->pdata = client->dev.platform_data;
Later it was dereferenced in max17040_get_online() and
max17040_get_status().

If platform_data was not supplied, the NULL pointer exception would
happen:

[    6.626094] Unable to handle kernel  of a at virtual address 00000000
[    6.628557] pgd = c0004000
[    6.632868] [00000000] *pgd=66262564
[    6.634636] Unable to handle kernel paging request at virtual address e6262000
[    6.642014] pgd = de468000
[    6.644700] [e6262000] *pgd=00000000
[    6.648265] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    6.653552] Modules linked in:
[    6.656598] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted 3.10.14-02717-gc58b4b4 #505
[    6.664334] Workqueue: events max17040_work
[    6.668488] task: dfa11b80 ti: df9f6000 task.ti: df9f6000
[    6.673873] PC is at show_pte+0x80/0xb8
[    6.677687] LR is at show_pte+0x3c/0xb8
[    6.681503] pc : [<c001b7b8>]    lr : [<c001b774>]    psr: 600f0113
[    6.681503] sp : df9f7d58  ip : 600f0113  fp : 00000009
[    6.692965] r10: 00000000  r9 : 00000000  r8 : dfa11b80
[    6.698171] r7 : df9f7ea0  r6 : e6262000  r5 : 00000000  r4 : 00000000
[    6.704680] r3 : 00000000  r2 : e6262000  r1 : 600f0193  r0 : c05b3750
[    6.711194] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    6.718485] Control: 10c53c7d  Table: 5e46806a  DAC: 00000015
[    6.724218] Process kworker/0:1 (pid: 31, stack limit = 0xdf9f6238)
[    6.730465] Stack: (0xdf9f7d58 to 0xdf9f8000)
[    6.914325] [<c001b7b8>] (show_pte+0x80/0xb8) from [<c047107c>] (__do_kernel_fault.part.9+0x44/0x74)
[    6.923425] [<c047107c>] (__do_kernel_fault.part.9+0x44/0x74) from [<c001bb7c>] (do_page_fault+0x2c4/0x360)
[    6.933144] [<c001bb7c>] (do_page_fault+0x2c4/0x360) from [<c0008400>] (do_DataAbort+0x34/0x9c)
[    6.941825] [<c0008400>] (do_DataAbort+0x34/0x9c) from [<c000e5d8>] (__dabt_svc+0x38/0x60)
[    6.950058] Exception stack(0xdf9f7ea0 to 0xdf9f7ee8)
[    6.955099] 7ea0: df0c1790 00000000 00000002 00000000 df0c1794 df0c1790 df0c1790 00000042
[    6.963271] 7ec0: df0c1794 00000001 00000000 00000009 00000000 df9f7ee8 c0306268 c0306270
[    6.971419] 7ee0: a00f0113 ffffffff
[    6.974902] [<c000e5d8>] (__dabt_svc+0x38/0x60) from [<c0306270>] (max17040_work+0x8c/0x144)
[    6.983317] [<c0306270>] (max17040_work+0x8c/0x144) from [<c003f364>] (process_one_work+0x138/0x440)
[    6.992429] [<c003f364>] (process_one_work+0x138/0x440) from [<c003fa64>] (worker_thread+0x134/0x3b8)
[    7.001628] [<c003fa64>] (worker_thread+0x134/0x3b8) from [<c00454bc>] (kthread+0xa4/0xb0)
[    7.009875] [<c00454bc>] (kthread+0xa4/0xb0) from [<c000eb28>] (ret_from_fork+0x14/0x2c)
[    7.017943] Code: e1a03005 e2422480 e0826104 e59f002c (e7922104)
[    7.024017] ---[ end trace 73bc7006b9cc5c79 ]---

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: c6f4a42de60b981dd210de01cd3e575835e3158e
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/power/max17040_battery.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 22cfe9c..64de769 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -148,7 +148,7 @@ static void max17040_get_online(struct i2c_client *client)
 {
 	struct max17040_chip *chip = i2c_get_clientdata(client);
 
-	if (chip->pdata->battery_online)
+	if (chip->pdata && chip->pdata->battery_online)
 		chip->online = chip->pdata->battery_online();
 	else
 		chip->online = 1;
@@ -158,7 +158,8 @@ static void max17040_get_status(struct i2c_client *client)
 {
 	struct max17040_chip *chip = i2c_get_clientdata(client);
 
-	if (!chip->pdata->charger_online || !chip->pdata->charger_enable) {
+	if (!chip->pdata || !chip->pdata->charger_online
+			|| !chip->pdata->charger_enable) {
 		chip->status = POWER_SUPPLY_STATUS_UNKNOWN;
 		return;
 	}
-- 
1.8.3.2

