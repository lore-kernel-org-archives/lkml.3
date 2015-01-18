Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbbARRXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 12:23:48 -0500
Received: from a8-93.smtp-out.amazonses.com ([54.240.8.93]:45169 "EHLO
	a8-93.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbbARRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 12:23:45 -0500
X-Greylist: delayed 3579 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2015 12:23:45 EST
Message-ID: <0000014afdcc643d-a943b494-4c10-4fa0-a85b-d36e89d6b09a-000000@email.amazonses.com>
Date: Sun, 18 Jan 2015 16:07:18 +0000
From: Jim Keir <jimkeir@oracledbadirect.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org, jkosina@suse.cz
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 001/001] usbhid: Fix initialisation and force effect modifications
 for the Microsoft Sidewinder Force Feedback Pro 2 joystick
References: <54BBD8BA.7090906@yahoo.co.uk>
In-Reply-To: <54BBD8BA.7090906@yahoo.co.uk>
X-Forwarded-Message-Id: <54BBD8BA.7090906@yahoo.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2015.01.18-54.240.8.93
Feedback-ID: us-east-1.amlta2VpckBvcmFjbGVkYmFkaXJlY3QuY29t:AmazonSES
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Keir <jimkeir@yahoo.co.uk>
Signed-off-by: Jim Keir <jimkeir@yahoo.co.uk>

Currently the SWFF2 driver fails during initialisation, making the force
capability of the joystick unusable. Further, there is a long-standing
bug in the same driver where commands to update force parameters are
addressed to the last-created force effect instead of the specified one,
making it impossible to modify effects after their creation.

Three bugs are addressed:

1) The FF2 driver (usbhid/hid-pidff.c) sends commands to the stick
during ff_init. However, this is called inside a block where
driver_input_lock is locked, so the results of these initial commands
are discarded. This one is the "killer", without this nothing else works.

ff_init issues commands using "hid_hw_request". This eventually goes to
hid_input_report, which returns -EBUSY because driver_input_lock is
locked. The change is to delay the ff_init call in hid-core.c until
after this lock has been released.

2) The usbhid driver ignores an endpoint stall when sending control
commands, causing the first few commands of the hid-pidff.c
initialisation to get lost.

usbhid/hid-core.c has been modified by copying lines into "hid_ctrl"
from the "hid_irq_in" function in the same file.

3) The FF2 driver (usbhid/hid-pidff.c) does not set the effect ID when
uploading an effect. The result is that the initial upload works but
subsequent uploads to modify effect parameters are all directed at the
last-created effect.

The targeted effect ID must be passed back to the device when effect
parameters are changed. This is done at the start of
"pidff_set_condition_report", "pidff_set_periodic_report" etc. based on
the value of "pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0]".
However, this value is only ever set during pidff_request_effect_upload.
The result is stored in "pidff->pid_id[effect->id]" at the end of
pid_upload_effect, for later use. However, if an effect is modified and
re-sent then this identifier is not being copied back from
pidff->pid_id[effect->id] before sending the command to the device. The
fix is to do this at the start of pidff_upload_effect.

This patch taken against kernel 3.13.0

---

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 905e40a..a608ee6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1546,9 +1546,8 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
          return -ENODEV;
      }

-    if ((hdev->claimed & HID_CLAIMED_INPUT) &&
-            (connect_mask & HID_CONNECT_FF) && hdev->ff_init)
-        hdev->ff_init(hdev);
+    /* Removed ff_init() call from here. It does device I/O but this
+     * is blocked because driver_input_lock is currently locked. */

      len = 0;
      if (hdev->claimed & HID_CLAIMED_INPUT)
@@ -2029,6 +2028,13 @@ static int hid_device_probe(struct device *dev)
  unlock:
      if (!hdev->io_started)
          up(&hdev->driver_input_lock);
+
+    if ((hdev->claimed & HID_CLAIMED_INPUT) && hdev->ff_init) {
+        /* Late init of PID force-feedback drivers moved to after
+         * unlock of driver_input_lock */
+        hdev->ff_init(hdev);
+    }
+
  unlock_driver_lock:
      up(&hdev->driver_lock);
      return ret;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 029965e..5d34dd7 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -505,7 +505,12 @@ static void hid_ctrl(struct urb *urb)
      case -EPROTO:        /* protocol error or unplug */
      case -ECONNRESET:    /* unlink */
      case -ENOENT:
+        break;
      case -EPIPE:        /* report not available */
+        usbhid_mark_busy(usbhid);
+        clear_bit(HID_IN_RUNNING, &usbhid->iofl);
+        set_bit(HID_CLEAR_HALT, &usbhid->iofl);
+        schedule_work(&usbhid->reset_work);
          break;
      default:        /* error */
          hid_warn(urb->dev, "ctrl urb status %d received\n", status);
diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 10b6167..3f8ea63 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -568,6 +568,13 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
      int type_id;
      int error;

+    pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
+
+    if (old && effect) {
+        pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] =
+            pidff->pid_id[effect->id];
+    }
+
      switch (effect->type) {
      case FF_CONSTANT:
          if (!old) {
@@ -701,10 +708,14 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
          return -EINVAL;
      }

-    if (!old)
+    if (!old) {
          pidff->pid_id[effect->id] =
              pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0];

+        hid_dbg(pidff->hid, "Created new effect of type 0x%02x with h/w ID %d, driver ID %d\n",
+            effect->type, pidff->pid_id[effect->id], effect->id);
+    }
+
      hid_dbg(pidff->hid, "uploaded\n");

      return 0;



