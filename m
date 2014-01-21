Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaAUHdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 02:33:42 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:33921 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaAUHde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 02:33:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1401210747120.12934@twin.jikos.cz>
References: <CA+BWVUTkaUt8Ys_40r7zFV_wBtY7iWTTmUUL+bHj=e3NwAtgNg@mail.gmail.com>
 <alpine.LRH.2.00.1401210747120.12934@twin.jikos.cz>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Tue, 21 Jan 2014 01:33:13 -0600
Message-ID: <CA+BWVUQnyZ=YP95V25BoiM9QLBaL78Hd0fC8DOrSfoH60cvD3A@mail.gmail.com>
Subject: Re: [PATCH] Add HID's to hid-microsoft driver of Surface Type/Touch
 Cover 2 to fix bug
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 12:47 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 20 Jan 2014, Reyad Attiyat wrote:
>
>> The below patch fixes a bug 64811
>> (https://bugzilla.kernel.org/show_bug.cgi?id=64811) of the Microsoft
>> Surface Type/Touch cover 2 devices being detected as a multitouch
>> device.
>> The fix adds the HID of the two devices to hid-microsoft driver. This
>> ensures that hid-input will eventually be used for the device and not
>> hid-multitouch.
>
> Hi,
>
> your patch is missing hid_have_special_driver[] entry, therefore correct
> driver binding is not guaranteed.
>
> --
> Jiri Kosina
> SUSE Labs
>

Hi,

Thanks for reminding me of hid_have_special_driver[]. I noticed that
this device has the HID_DG_CONTACTID and in the comment of the
hid_have_sepcial_driver[]

* Please note that for multitouch devices (driven by hid-multitouch driver),
* there is a proper autodetection and autoloading in place (based on presence
* of HID_DG_CONTACTID), so those devices don't need to be added to this list,
* as we are doing the right thing in hid_scan_usage().

This device should not be driven by hid-multitouch as it does not
handle keyboard/mouse input devices.
I submitted a new patch below with it added. I believe it should still
be part of this array, in case this kind of implementation is
fixed/updated.

>From 291742873dcf181faf9657b41279487f31302c73 Mon Sep 17 00:00:00 2001
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Tue, 21 Jan 2014 01:22:25 -0600
Subject: [PATCH 1/1] Added in HID's for Microsoft Surface Type/Touch cover 2.
 This is to fix bug 64811 where this device is detected as a multitouch device

---
 drivers/hid/hid-core.c      | 3 +++
 drivers/hid/hid-ids.h       | 4 +++-
 drivers/hid/hid-microsoft.c | 4 ++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 253fe23..88eb4a6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1778,6 +1778,9 @@ static const struct hid_device_id
hid_have_special_driver[] = {
     { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_MS_PRESENTER_8K_USB) },
     { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K) },
     { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_MS_TOUCH_COVER_2) },
+
     { HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
     { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
     { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f9304cb..b523a8b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -611,7 +611,9 @@
 #define USB_DEVICE_ID_MS_PRESENTER_8K_USB    0x0713
 #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K    0x0730
 #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500    0x076c
-
+#define USB_DEVICE_ID_MS_TOUCH_COVER_2 0x07a7
+#define USB_DEVICE_ID_MS_TYPE_COVER_2  0x07a9
+
 #define USB_VENDOR_ID_MOJO        0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER    0x3201

diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 551795b..2599de8 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -207,6 +207,10 @@ static const struct hid_device_id ms_devices[] = {
         .driver_data = MS_NOGET },
     { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_MS_COMFORT_MOUSE_4500),
         .driver_data = MS_DUPLICATE_USAGES },
+    { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2),
+        .driver_data = 0 },
+    { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2),
+        .driver_data = 0 },

     { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT,
USB_DEVICE_ID_MS_PRESENTER_8K_BT),
         .driver_data = MS_PRESENTER },
-- 
1.8.4.2
