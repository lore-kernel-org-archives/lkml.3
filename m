Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3IVMqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 08:46:35 -0400
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:57246 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3IVMqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 08:46:34 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Sep 2013 08:46:34 EDT
X-AuthUser: garloff@garloff.de
Message-ID: <523EC4BE.6000509@garloff.de>
Date: Sun, 22 Sep 2013 12:21:50 +0200
From: Kurt Garloff <kurt@garloff.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.or
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] usb/core/devio.c:tolerate wrong direction flag in control
 endpoints
X-Enigmail-Version: 1.5.2
Content-Type: multipart/mixed;
 boundary="------------020109060805010008020201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020109060805010008020201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

USB devio rejects control messages when the index does not have the
direction bit set correctly.
This breaks windows apps in KVM -- and might be overly strict according
to my reading of USB HID spec.
Attached patch makes the kernel tolerant against it and makes the app
work for me.

More details in the patch header.

USB experts: Please review this and judge whether this is correct,
applies more generically,
or maybe needs to be special cased (only for USB HID devices?) or
implemented as quirk
or module/kernel parameter.

Once in the final form, this *might* be stable material.

Please keep me in copy for the discussion, my participation on LKML is
mostly reading summaries
from Jonathan and Thorsten these days, unfortunately.

-- 
Kurt Garloff <kurt@garloff.de>
Cologne, Germany


--------------020109060805010008020201
Content-Type: text/x-patch;
 name="usb_devio_tolerate_wrong_ep_dir3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usb_devio_tolerate_wrong_ep_dir3.diff"

commit bc1e4e1ae1d5a4f9b2d263f22c651dd5ba4f8ff9
Author: Kurt Garloff <kurt@garloff.de>
Date:   Sun Sep 22 11:54:59 2013 +0200

    From: Kurt Garloff <kurt@garloff.de>
    Subject: Tolerate wrong direction bit endpoint index for control messages
    Signed-off-by: Kurt Garloff <kurt@garloff.de>
    
    Trying to read data from the Pegasus Technologies NoteTaker (0e20:0101)
    [1] with the Windows App (EasyNote) works natively but fails when
    WIndows is running under KVM (and the USB device handed to KVM).
    
    The reason is a USB control message
     usb 4-2.2: control urb: bRequestType=22 bRequest=09 wValue=0200 wIndex=0001 wLength=0008
    This goes to endpoint 1 (wIndex), however, the endpoint is an input
    endpoint and thus enumerated 0x81.
    
    The kernel thus rejects the IO and thus we see the failure.
    
    Apparently, Linux is more strict here than Windows ... we can't change
    the Win app easily, so that's a problem.
    
    However, the app might not even be buggy here.  Browsing the USB HID
    spec, there's a note that the bit for direction is ignored for control
    endpoints ... so Linux might be overly strict?
    
    With attached patch, everything works.
     usb 4-2.2: check_ctrlrecip: process 13073 (qemu-kvm) requesting ep 01 but needs 81 (or 00)
    
    Notes:
    - I have not checked whether the ignorance of the direction bit for
      control endpoints only applies to USB HID devices, thus I have not
      special-cased depending on the device type.
    - We do output a warning into the kernel log, as this might still be
      caused by an application error.
    - We don't risk sending to a wrong endpoint, as there can't be two
      endpoints with same index and just different direction.
    - I suspect this will mostly affect apps in virtual environments; as on
      Linux the apps would have been adapted to the stricter handling of the
      kernel. I have done that for mine[2], although delaying the release by
      two years ....
    
    [1} http://www.pegatech.com/
    [2] https://sourceforge.net/projects/notetakerpen/

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index c2f62a3..8acbc2f 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -623,6 +623,19 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
 		ret = findintfep(ps->dev, index);
+		if (ret < 0) {
+			/* OK, give it a second try -- user might have confused
+			 * direction -- this happens from virtualized win apps 
+			 * e.g. -- warn, but be graceful */
+			ret = findintfep(ps->dev, index ^ 0x80);
+			if (ret >= 0)
+				dev_info(&ps->dev->dev , 
+					"%s: process %i (%s) requesting ep %02x but needs %02x (or 00)\n",
+					__func__, 
+					task_pid_nr(current),
+					current->comm,
+				       	index, index ^ 0x80);
+		}
 		if (ret >= 0)
 			ret = checkintf(ps, ret);
 		break;

--------------020109060805010008020201--
