Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaHVIAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:00:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaHVIAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:00:08 -0400
Date: Fri, 22 Aug 2014 03:00:06 -0500 (CDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hawkes <hawkes@google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [GIT PULL] HID
In-Reply-To: <20140822074030.GA297@x4>
Message-ID: <alpine.LNX.2.00.1408220257050.23162@pobox.suse.cz>
References: <alpine.LNX.2.00.1408211146110.23162@pobox.suse.cz> <20140822074030.GA297@x4>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Markus Trippelsdorf wrote:

> >       HID: logitech: perform bounds checking on device_id early enough
> 
> The commit above (ad3e14d7c5268c2e) causes the bounds checking to always
> fail on my monolithic kernel (without modules):
> 
> ...
> [    2.922617] usb 4-2: new full-speed USB device number 2 using ohci-pci
> [    2.996587] udevd[98]: starting eudev version 1.0
> [    3.071203] random: nonblocking pool is initialized
> [    3.108360] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
> [    3.163208] input: Logitech Unifying Device. Wireless PID:4026 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.2/0003:046D:C52B.0003/0003:046D:C52B.0004/input/input2
> [    3.163511] logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4026] on usb-0000:00:12.1-2:1
> [    3.164121] logitech-djreceiver 0003:046D:C52B.0003: logi_dj_raw_event: invalid device index:0
> [    3.289261] usb 3-1: new low-speed USB device number 2 using ohci-pci
> [    3.457606] input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/0003:046A:0011.0005/input/input3
> [    3.457794] hid-generic 0003:046A:0011.0005: input,hidraw2: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.0-1/input0
> [    3.712886] Switched to clocksource tsc

Thanks a lot for a timely report.

I am travelling till next week and don't unfortunately have the hardware 
here with me to test momentarily, so please take this with a lot of grains 
of salt (maybe Benjamin would be able to look into this before I'd be able 
to on monday ... ?).

Does the shot-in-the-dakr patch below put things back in shape for you?


diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index b7ba829..d9ae77f 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -861,7 +861,7 @@ static void logi_dj_remove(struct hid_device *hdev)
 	 * have finished and no more raw_event callbacks should arrive after
 	 * the remove callback was triggered so no locks are put around the
 	 * code below */
-	for (i = 0; i < (DJ_MAX_PAIRED_DEVICES + DJ_DEVICE_INDEX_MIN); i++) {
+	for (i = 0; i < (DJ_MAX_PAIRED_DEVICES + DJ_DEVICE_INDEX_MIN + 1); i++) {
 		dj_dev = djrcv_dev->paired_dj_devices[i];
 		if (dj_dev != NULL) {
 			hid_destroy_device(dj_dev->hdev);
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
index 4a40003..1f630e4 100644
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -27,8 +27,8 @@
 
 #define DJ_MAX_PAIRED_DEVICES			6
 #define DJ_MAX_NUMBER_NOTIFICATIONS		8
-#define DJ_DEVICE_INDEX_MIN 			1
-#define DJ_DEVICE_INDEX_MAX 			6
+#define DJ_DEVICE_INDEX_MIN 			0
+#define DJ_DEVICE_INDEX_MAX 			5
 
 #define DJREPORT_SHORT_LENGTH			15
 #define DJREPORT_LONG_LENGTH			32
@@ -97,7 +97,7 @@ struct dj_report {
 struct dj_receiver_dev {
 	struct hid_device *hdev;
 	struct dj_device *paired_dj_devices[DJ_MAX_PAIRED_DEVICES +
-					    DJ_DEVICE_INDEX_MIN];
+					    DJ_DEVICE_INDEX_MIN + 1];
 	struct work_struct work;
 	struct kfifo notif_fifo;
 	spinlock_t lock;

-- 
Jiri Kosina
SUSE Labs
