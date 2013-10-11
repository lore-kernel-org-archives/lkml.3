Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab3JKLBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:01:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab3JKKnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kurt Garloff <kurt@garloff.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 046/100] usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit
Date: Fri, 11 Oct 2013 11:41:16 +0100
Message-Id: <1381488130-30235-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Garloff <kurt@garloff.de>

commit 831abf76643555a99b80a3b54adfa7e4fa0a3259 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/devio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index f70b887..ea97827 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -684,6 +684,22 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
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
1.8.3.2

