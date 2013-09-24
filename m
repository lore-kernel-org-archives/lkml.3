Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3IXMN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:13:57 -0400
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:58156 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3IXMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:13:54 -0400
Date: Tue, 24 Sep 2013 14:13:48 +0200
From: Kurt Garloff <kurt@garloff.de>
To: Linux USB list <linux-usb@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <GregKH@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] usb/core/devio.c: Don't reject control message to endpoint
 with wrong direction bit
Message-ID: <20130924121348.GB32287@nehalem.garloff.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 3.0.96-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this has been discussed on linux-usb and Alan Stern provided very
helpful feedback.

Please merge this patch ...


From: Kurt Garloff <kurt@garloff.de>
Date: Mon, 23 Sep 2013 14:19:02 +0200
Subject: Tolerate wrong direction bit in endpoint address for control messages
    
Trying to read data from the Pegasus Technologies NoteTaker (0e20:0101)
[1] with the Windows App (EasyNote) works natively but fails when
Windows is running under KVM (and the USB device handed to KVM).
    
The reason is a USB control message
 usb 4-2.2: control urb: bRequestType=22 bRequest=09 wValue=0200 wIndex=0001 wLength=0008
This goes to endpoint address 0x01 (wIndex); however, endpoint address 
0x01 does not exist. There is an endpoint 0x81 though (same number,
but other direction); the app may have meant that endpoint instead.
 
The kernel thus rejects the IO and thus we see the failure.
    
Apparently, Linux is more strict here than Windows ... we can't change
the Win app easily, so that's a problem.

It seems that the Win app/driver is buggy here and the driver does not
behave fully according to the USB HID class spec that it claims to 
belong to.  The device seems to happily deal with that though (and 
seems to not really care about this value much).

So the question is whether the Linux kernel should filter here.
Rejecting has the risk that somewhat non-compliant userspace apps/
drivers (most likely in a virtual machine) are prevented from working.
Not rejecting has the risk of confusing an overly sensitive device with
such a transfer. Given the fact that Windows does not filter it makes
this risk rather small though.

The patch makes the kernel more tolerant: If the endpoint address in
wIndex does not exist, but an endpoint with toggled direction bit does,
it will let the transfer through. (It does NOT change the message.)

With attached patch, the app in Windows in KVM works.
 usb 4-2.2: check_ctrlrecip: process 13073 (qemu-kvm) requesting ep 01 but needs 81
    
I suspect this will mostly affect apps in virtual environments; as on
Linux the apps would have been adapted to the stricter handling of the
kernel. I have done that for mine[2].
 
[1] http://www.pegatech.com/
[2] https://sourceforge.net/projects/notetakerpen/

Signed-off-by: Kurt Garloff <kurt@garloff.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
---
 drivers/usb/core/devio.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 737e3c1..71dc5d7 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -742,6 +742,22 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 		if ((index & ~USB_DIR_IN) == 0)
 			return 0;
 		ret = findintfep(ps->dev, index);
+		if (ret < 0) {
+			/*
+			 * Some not fully compliant Win apps seem to get
+			 * index wrong and have the endpoint number here
+			 * rather than the endpoint address (with the
+			 * correct direction). Win does let this through,
+			 * so we'll not reject it here but leave it to
+			 * the device to not break KVM. But we warn.
+			 */
+			ret = findintfep(ps->dev, index ^ 0x80);
+			if (ret >= 0)
+				dev_info(&ps->dev->dev,
+					"%s: process %i (%s) requesting ep %02x but needs %02x\n",
+					__func__, task_pid_nr(current),
+					current->comm, index, index ^ 0x80);
+		}
 		if (ret >= 0)
 			ret = checkintf(ps, ret);
 		break;


-- 
Kurt Garloff <kurt@garloff.de>  [Koeln, Germany]

