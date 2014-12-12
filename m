Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967582AbaLLMCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:02:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:48735 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966268AbaLLMCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:02:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,563,1413270000"; 
   d="scan'208";a="636635432"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        aduggan@synaptics.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] HID: i2c-hid: Do not free buffers in i2c_hid_stop()
Date: Fri, 12 Dec 2014 14:01:49 +0200
Message-Id: <1418385709-223977-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a hid driver that uses i2c-hid as transport is unloaded, the hid core
will call i2c_hid_stop() which releases all the buffers associated with the
device. This includes also the command buffer.

Now, when the i2c-hid driver itself is unloaded it tries to power down the
device by sending it PWR_SLEEP command. Since the command buffer is already
released we get following crash:

 [   79.691459] BUG: unable to handle kernel NULL pointer dereference at           (null)
 [   79.691532] IP: [<ffffffffa05bc049>] __i2c_hid_command+0x49/0x310 [i2c_hid]
 ...
 [   79.693467] Call Trace:
 [   79.693494]  [<ffffffff810424e1>] ? __unmask_ioapic+0x21/0x30
 [   79.693537]  [<ffffffff81042855>] ? unmask_ioapic+0x25/0x40
 [   79.693581]  [<ffffffffa05bc35b>] ? i2c_hid_set_power+0x4b/0xa0 [i2c_hid]
 [   79.693632]  [<ffffffffa05bc3cf>] ? i2c_hid_runtime_resume+0x1f/0x30 [i2c_hid]
 [   79.693689]  [<ffffffff814c08fb>] ? __rpm_callback+0x2b/0x70
 [   79.693733]  [<ffffffff814c0961>] ? rpm_callback+0x21/0x90
 [   79.693776]  [<ffffffff814c0dec>] ? rpm_resume+0x41c/0x600
 [   79.693820]  [<ffffffff814c1e1c>] ? __pm_runtime_resume+0x4c/0x80
 [   79.693868]  [<ffffffff814b8588>] ? __device_release_driver+0x28/0x100
 [   79.693917]  [<ffffffff814b8d90>] ? driver_detach+0xa0/0xb0
 [   79.693959]  [<ffffffff814b82cc>] ? bus_remove_driver+0x4c/0xb0
 [   79.694006]  [<ffffffff810d1cfd>] ? SyS_delete_module+0x11d/0x1d0
 [   79.694054]  [<ffffffff8165f107>] ? int_signal+0x12/0x17
 [   79.694095]  [<ffffffff8165ee69>] ? system_call_fastpath+0x12/0x17

Fix this so that we only free buffers when the i2c-hid driver itself is
removed.

Fixes: 34f439e4afcd ("HID: i2c-hid: add runtime PM support")
Reported-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 747d54421e73..a58c6a8d4f93 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -702,12 +702,7 @@ static int i2c_hid_start(struct hid_device *hid)
 
 static void i2c_hid_stop(struct hid_device *hid)
 {
-	struct i2c_client *client = hid->driver_data;
-	struct i2c_hid *ihid = i2c_get_clientdata(client);
-
 	hid->claimed = 0;
-
-	i2c_hid_free_buffers(ihid);
 }
 
 static int i2c_hid_open(struct hid_device *hid)
-- 
2.1.3

