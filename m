Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbbANH07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:26:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbbANH0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:26:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.18 057/150] HID: i2c-hid: Do not free buffers in i2c_hid_stop()
Date: Tue, 13 Jan 2015 23:22:08 -0800
Message-Id: <20150114072058.449596472@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 5b44c53aeb791757072be4a267255cedfff594fd upstream.

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
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/i2c-hid/i2c-hid.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -706,12 +706,7 @@ static int i2c_hid_start(struct hid_devi
 
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


