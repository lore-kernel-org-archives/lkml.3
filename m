Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3D1NSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 09:18:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34798 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3D1NSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 09:18:18 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH usb-next] USB: Improve documentation for usbmon
Date: Sun, 28 Apr 2013 15:18:07 +0200
Message-Id: <1367155087-4938-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a give-back to USB folks who helped me in a USB debug issue.

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 Documentation/usb/usbmon.txt | 87 ++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 32 deletions(-)

diff --git a/Documentation/usb/usbmon.txt b/Documentation/usb/usbmon.txt
index c42bb9c..02f5845 100644
--- a/Documentation/usb/usbmon.txt
+++ b/Documentation/usb/usbmon.txt
@@ -23,35 +23,53 @@ in a text format. This is used for two purposes. First, it serves as a
 common trace exchange format for tools while more sophisticated formats
 are finalized. Second, humans can read it in case tools are not available.
 
-To collect a raw text trace, execute following steps.
+To collect a (raw text) usbmon trace, execute the following steps.
 
-1. Prepare
+Step #1: Prerequisites and preperation
 
-Mount debugfs (it has to be enabled in your kernel configuration), and
-load the usbmon module (if built as module). The second step is skipped
-if usbmon is built into the kernel.
+You should enable the following kernel-config options:
 
-# mount -t debugfs none_debugs /sys/kernel/debug
-# modprobe usbmon
-#
+CONFIG_DEBUG_FS=y   <--- Enable DebugFS
+CONFIG_USB_DEBUG=y  <--- Enable USB debugging
+CONFIG_USB_MON=m    <--- Build usbmon as kernel-module
 
-Verify that bus sockets are present.
+Mount debugfs and load usbmon module:
 
-# ls /sys/kernel/debug/usb/usbmon
-0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
-#
+   # mount -t debugfs none_debugs /sys/kernel/debug
 
-Now you can choose to either use the socket '0u' (to capture packets on all
+   # modprobe -v usbmon
+   insmod /lib/modules/$(uname -r)/kernel/drivers/usb/mon/usbmon.ko
+
+The second step is skipped if usbmon is built into the kernel.
+
+Verify that the bus sockets are present:
+
+   # ls /sys/kernel/debug/usb/usbmon
+   0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
+
+Now, you can choose to either use the socket '0u' (to capture packets on all
 buses), and skip to step #3, or find the bus used by your device with step #2.
 This allows to filter away annoying devices that talk continuously.
 
-2. Find which bus connects to the desired device
+NOTE: The 'lsusb' utiliy might be helpful for hardware diagnosis.
+
+Step #2: Find which bus connects to the desired/affected USB device
+
+How to find the bus which corresponds to the device?
+Usually, you do it by looking for the vendor and product string.
+
+   # dmesg | grep usb | egrep -i 'vendor|product'
 
-Run "cat /sys/kernel/debug/usb/devices", and find the T-line which corresponds
-to the device. Usually you do it by looking for the vendor string. If you have
-many similar devices, unplug one and compare the two
-/sys/kernel/debug/usb/devices outputs. The T-line will have a bus number.
-Example:
+All USB devices are listed here:
+
+   # cat /sys/kernel/debug/usb/devices
+
+The T-line will have a bus number.
+
+If you have many similar devices, unplug one and compare the two
+/sys/kernel/debug/usb/devices outputs.
+
+EXAMPLE:
 
 T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
 D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
@@ -59,33 +77,38 @@ P:  Vendor=0557 ProdID=2004 Rev= 1.00
 S:  Manufacturer=ATEN
 S:  Product=UC100KM V2.00
 
-"Bus=03" means it's bus 3. Alternatively, you can look at the output from
-"lsusb" and get the bus number from the appropriate line. Example:
+"Bus=03" in the T-line means it's bus 3.
+Alternatively, you can look at the output from "lsusb" and get the bus number
+from the appropriate line.
+
+EXAMPLE:
 
 Bus 003 Device 002: ID 0557:2004 ATEN UC100KM V2.00
 
-3. Start 'cat'
+Step #3: Start a usbmon tracing session
+
+To listen on a single bus (here: 3), run:
 
-# cat /sys/kernel/debug/usb/usbmon/3u > /tmp/1.mon.out
+   # cat /sys/kernel/debug/usb/usbmon/3u > /tmp/usbmon-3u.txt
 
-to listen on a single bus, otherwise, to listen on all buses, type:
+Otherwise, to listen on all buses, type:
 
-# cat /sys/kernel/debug/usb/usbmon/0u > /tmp/1.mon.out
+   # cat /sys/kernel/debug/usb/usbmon/0u > /tmp/usbmon-all.txt
 
 This process will be reading until killed. Naturally, the output can be
 redirected to a desirable location. This is preferred, because it is going
 to be quite long.
 
-4. Perform the desired operation on the USB bus
+Step #4: Perform the desired operation on the USB bus
 
-This is where you do something that creates the traffic: plug in a flash key,
-copy files, control a webcam, etc.
+This is where you do something that creates traffic in the logs:
+Plug in a flash key, copy files, control a webcam, do a suspend-and-resume etc.
 
-5. Kill cat
+Step #5: Stop the usbmon tracing session
 
-Usually it's done with a keyboard interrupt (Control-C).
+Usually, it's done with a keyboard interrupt (Control-C).
 
-At this point the output file (/tmp/1.mon.out in this example) can be saved,
+At this point the output file (/tmp/usbmon-3u.txt in this example) can be saved,
 sent by e-mail, or inspected with a text editor. In the last case make sure
 that the file size is not excessive for your favourite editor.
 
@@ -176,7 +199,7 @@ Here is the list of words, from left to right:
   Length counts only the bytes that were received whereas the Data words
   contain the entire transfer buffer).
 
-Examples:
+EXAMPLES:
 
 An input control transfer to get a port status.
 
-- 
1.8.2.2

