Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbbA2DGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:06:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46996 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965091AbbA2Ch0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 024/139] [media] af9005: fix kernel panic on init if compiled without IR
Date: Wed, 28 Jan 2015 14:19:27 -0800
Message-Id: <1422483682-15393-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Schaefer <fschaefer.oss@googlemail.com>

commit 2279948735609d0d17d7384e776b674619f792ef upstream.

This patches fixes an ancient bug in the dvb_usb_af9005 driver, which
has been reported at least in the following threads:
https://lkml.org/lkml/2009/2/4/350
https://lkml.org/lkml/2014/9/18/558

If the driver is compiled in without any IR support (neither
DVB_USB_AF9005_REMOTE nor custom symbols), the symbol_request calls in
af9005_usb_module_init() return pointers != NULL although the IR
symbols are not available.

This leads to the following oops:
...
[    8.529751] usbcore: registered new interface driver dvb_usb_af9005
[    8.531584] BUG: unable to handle kernel paging request at 02e00000
[    8.533385] IP: [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9d
[    8.535613] *pde = 00000000
[    8.536416] Oops: 0000 [#1] PREEMPT PREEMPT DEBUG_PAGEALLOCDEBUG_PAGEALLOC
[    8.537863] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc6-00151-ga5c075c #1
[    8.539827] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    8.541519] task: 89c9a670 ti: 89c9c000 task.ti: 89c9c000
[    8.541519] EIP: 0060:[<7d9d67c6>] EFLAGS: 00010206 CPU: 0
[    8.541519] EIP is at af9005_usb_module_init+0x6b/0x9d
[    8.541519] EAX: 02e00000 EBX: 00000000 ECX: 00000006 EDX: 00000000
[    8.541519] ESI: 00000000 EDI: 7da33ec8 EBP: 89c9df30 ESP: 89c9df2c
[    8.541519]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    8.541519] CR0: 8005003b CR2: 02e00000 CR3: 05a54000 CR4: 00000690
[    8.541519] Stack:
[    8.541519]  7d9d675b 89c9df90 7d992a49 7d7d5914 89c9df4c 7be3a800 7d08c58c 8a4c3968
[    8.541519]  89c9df80 7be3a966 00000192 00000006 00000006 7d7d3ff4 8a4c397a 00000200
[    8.541519]  7d6b1280 8a4c3979 00000006 000009a6 7da32db8 b13eec81 00000006 000009a6
[    8.541519] Call Trace:
[    8.541519]  [<7d9d675b>] ? ttusb2_driver_init+0x16/0x16
[    8.541519]  [<7d992a49>] do_one_initcall+0x77/0x106
[    8.541519]  [<7be3a800>] ? parameqn+0x2/0x35
[    8.541519]  [<7be3a966>] ? parse_args+0x113/0x25c
[    8.541519]  [<7d992bc2>] kernel_init_freeable+0xea/0x167
[    8.541519]  [<7cf01070>] kernel_init+0x8/0xb8
[    8.541519]  [<7cf27ec0>] ret_from_kernel_thread+0x20/0x30
[    8.541519]  [<7cf01068>] ? rest_init+0x10c/0x10c
[    8.541519] Code: 08 c2 c7 05 44 ed f9 7d 00 00 e0 02 c7 05 40 ed f9 7d 00 00 e0 02 c7 05 3c ed f9 7d 00 00 e0 02 75 1f b8 00 00 e0 02 85 c0 74 16 <a1> 00 00 e0 02 c7 05 54 84 8e 7d 00 00 e0 02 a3 58 84 8e 7d eb
[    8.541519] EIP: [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9d SS:ESP 0068:89c9df2c
[    8.541519] CR2: 0000000002e00000
[    8.541519] ---[ end trace 768b6faf51370fc7 ]---

The prefered fix would be to convert the whole IR code to use the kernel IR
infrastructure (which wasn't available at the time this driver had been created).

Until anyone who still has this old hardware steps up an does the conversion,
fix it by not calling the symbol_request calls if the driver is compiled in
without the default IR symbols (CONFIG_DVB_USB_AF9005_REMOTE).
Due to the IR related pointers beeing NULL by default, IR support will then be disabled.

The downside of this solution is, that it will no longer be possible to
compile custom IR symbols (not using CONFIG_DVB_USB_AF9005_REMOTE) in.

Please note that this patch has NOT been tested with all possible cases.
I don't have the hardware and could only verify that it fixes the reported
bug.

Reported-by: Fengguag Wu <fengguang.wu@intel.com>
Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Luca Olivetti <luca@ventoso.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/dvb-usb/af9005.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/af9005.c b/drivers/media/usb/dvb-usb/af9005.c
index af176b6..e6d3561 100644
--- a/drivers/media/usb/dvb-usb/af9005.c
+++ b/drivers/media/usb/dvb-usb/af9005.c
@@ -1081,9 +1081,12 @@ static int __init af9005_usb_module_init(void)
 		err("usb_register failed. (%d)", result);
 		return result;
 	}
+#if IS_MODULE(CONFIG_DVB_USB_AF9005) || defined(CONFIG_DVB_USB_AF9005_REMOTE)
+	/* FIXME: convert to todays kernel IR infrastructure */
 	rc_decode = symbol_request(af9005_rc_decode);
 	rc_keys = symbol_request(rc_map_af9005_table);
 	rc_keys_size = symbol_request(rc_map_af9005_table_size);
+#endif
 	if (rc_decode == NULL || rc_keys == NULL || rc_keys_size == NULL) {
 		err("af9005_rc_decode function not found, disabling remote");
 		af9005_properties.rc.legacy.rc_query = NULL;
-- 
1.9.1

