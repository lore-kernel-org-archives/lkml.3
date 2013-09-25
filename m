Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3IYAbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:31:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab3IYAUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 079/117] HID: picolcd: Prevent NULL pointer dereference on _remove()
Date: Tue, 24 Sep 2013 17:19:05 -0700
Message-Id: <20130925001749.587844641@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Prémont <bonbons@linux-vserver.org>

commit 1cde501bb4655e98fb832194beb88ac73be5a05d upstream.

When picolcd is switched into bootloader mode (for FW flashing) make
sure not to try to dereference NULL-pointers of feature-devices during
unplug/unbind.

This fixes following BUG:
  BUG: unable to handle kernel NULL pointer dereference at 00000298
  IP: [<f811f56b>] picolcd_exit_framebuffer+0x1b/0x80 [hid_picolcd]
  *pde = 00000000
  Oops: 0000 [#1]
  Modules linked in: hid_picolcd syscopyarea sysfillrect sysimgblt fb_sys_fops
  CPU: 0 PID: 15 Comm: khubd Not tainted 3.11.0-rc7-00002-g50d62d4 #2
  EIP: 0060:[<f811f56b>] EFLAGS: 00010292 CPU: 0
  EIP is at picolcd_exit_framebuffer+0x1b/0x80 [hid_picolcd]
  Call Trace:
   [<f811d1ab>] picolcd_remove+0xcb/0x120 [hid_picolcd]
   [<c1469b09>] hid_device_remove+0x59/0xc0
   [<c13464ca>] __device_release_driver+0x5a/0xb0
   [<c134653f>] device_release_driver+0x1f/0x30
   [<c134603d>] bus_remove_device+0x9d/0xd0
   [<c13439a5>] device_del+0xd5/0x150
   [<c14696a4>] hid_destroy_device+0x24/0x60
   [<c1474cbb>] usbhid_disconnect+0x1b/0x40
   ...

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-picolcd_cir.c |    3 ++-
 drivers/hid/hid-picolcd_fb.c  |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -145,6 +145,7 @@ void picolcd_exit_cir(struct picolcd_dat
 	struct rc_dev *rdev = data->rc_dev;
 
 	data->rc_dev = NULL;
-	rc_unregister_device(rdev);
+	if (rdev)
+		rc_unregister_device(rdev);
 }
 
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -593,10 +593,14 @@ err_nomem:
 void picolcd_exit_framebuffer(struct picolcd_data *data)
 {
 	struct fb_info *info = data->fb_info;
-	struct picolcd_fb_data *fbdata = info->par;
+	struct picolcd_fb_data *fbdata;
 	unsigned long flags;
 
+	if (!info)
+		return;
+
 	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
+	fbdata = info->par;
 
 	/* disconnect framebuffer from HID dev */
 	spin_lock_irqsave(&fbdata->lock, flags);


