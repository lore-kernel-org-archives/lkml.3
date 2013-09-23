Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3IWMzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:55:47 -0400
Received: from cc-smtpout1.netcologne.de ([89.1.8.211]:50805 "EHLO
	cc-smtpout1.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3IWMzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:55:45 -0400
X-AuthUser: garloff@garloff.de
Message-ID: <52403A4B.6070606@garloff.de>
Date: Mon, 23 Sep 2013 14:55:39 +0200
From: Kurt Garloff <kurt@garloff.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb/core/devio.c:tolerate wrong direction flag in control
 endpoints
References: <Pine.LNX.4.44L0.1309222206520.7047-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1309222206520.7047-100000@netrider.rowland.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 09/23/2013 04:28 AM, Alan Stern wrote:
> On Sun, 22 Sep 2013, Kurt Garloff wrote:
>
>> Well, this seems to be a question of terminology, no?
>> I saw the endpoint byte as consisting of endpoint index plus the direction bit.
> See the entry for "Endpoint Address" in Chapter 2 (Terms and 
> Abbreviations) of the USB 2.0 specification.  The definition says:
>
> 	The combination of an endpoint number and an endpoint direction
> 	on a USB device. Each endpoint address supports data transfer
> 	in one direction.

OK. This definitely helps me to use the correct terminology.
>> OK, you certainly know the USB specs better than I do.
>>
>> If the message is not according to spec because the windex byte (which
>> should reference the endpoint) has the endpoint direction flag wrong,
>> then the question may become whether the kernel should reject it or
>> leave that to the device.
>> Rejecting by the kernel has the risk that somewhat non-compliant devices
>> with somewhat non-compliant (userspace) drivers are prevented from working.
>> While not rejecting has the risk that overly sensitive devices might freak out
>> on receiving a non-compliant transfer. The fact that Win does not not seem to
>> filter here however might make that risk rather small.
>> (Long years have taught us that companies don't test against the spec but this
>>  "OS" from Redmond.)
> This is a good explanation of why the patch should be accepted.
OK, I added it into the patch header.
>> It seems to interpret wIndex differently indeed. Not sure whether
>> that qualifies as a bug or not. Maybe it should not claim to be a
>> HID device then?
> Maybe not.  This particular combination of bRequestType and bRequest 
> values (0x22, 0x09) is not defined in the HID 1.11 spec.  Do you know 
> if it is defined somewhere else?
These are custom commands, somewhat described at
http://pegatech.com/_Uploads/Downloads/Documents/Protocol_Definition_Rev_1.12.pdf
>> Hmmm, none of the devices I have show this.
>> My impression was that the EP byte is composed of 
>>   ep = epindex | (dir==in? 0x80: 0)
>> and that index alone must be unique already. But then again, I'm in no
>> way an expert in USB specs and may just have jumped to conclusions
>> from the wording.
> The spec is pretty clear about this.  For example, it says that in
> addition to endpoint 0, a device can have up to 15 input endpoints and 
> up to 15 output endpoints (section 5.3.1.2).
>
>> (And again the behavior might not be enforced by the spec, but maybe
>> by Windows?)
> More likely the behavior isn't enforced at all.  The device may simply 
> be buggy.
With behavior here I referred to the fact that I have not yet seen a USB
device that
has two endpoints with the same endpoint number (but different direction).
Anyway, that's not relevant to the patch ... We don't change the value of
wIndex, we just decide to let the transfer through and let the device
deal with it.
>> Based on the observation that uurb.endpoint = 0 (see above), I have
>> changed my code in the Linux program (at [2]) to use 0x00 as wIndex 
>> instead of 0x81 (or formerly 0x01). It still worked.
>> So it's questionable, whether wIndex should even point to an EP ...
>> and the hardware might just ignore it.
> It looks that way.  The request claims to be class-specific, so it 
> would be nice to know which class document defines the request's 
> format.
I guess none ...
I just dropped the (or 00), as it's not reflected in the code ...
>> Thanks for the review! I will submit a new patch.
> Good.

Find it here.
(Let me know if it should be sent again separately for some reason.)

Let me try inline insert (by c'n'p: I switched from mutt to Thunderbird
recently and lack
experience whether this breaks formatting or so ...)

8<--------

From: Kurt Garloff <kurt@garloff.de>
Date: Mon, 23 Sep 2013 14:19:02 +0200
Subject: Tolerate wrong direction bit in endpoint address for control
messages
   
Trying to read data from the Pegasus Technologies NoteTaker (0e20:0101)
[1] with the Windows App (EasyNote) works natively but fails when
Windows is running under KVM (and the USB device handed to KVM).
   
The reason is a USB control message
 usb 4-2.2: control urb: bRequestType=22 bRequest=09 wValue=0200
wIndex=0001 wLength=0008
This goes to endpoint address 0x01 (wIndex); however, endpoint number 1
is an input endpoint and thus has endpoint address 0x81.
   
The kernel thus rejects the IO and thus we see the failure.
   
Apparently, Linux is more strict here than Windows ... we can't change
the Win app easily, so that's a problem.

It seems that the Win app/driver is buggy here and the driver does not
behave fully according to the USB HID class that it claims to belong to.
The device seems to happily deal with that though (and seems to not
really care about this value much).

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
 usb 4-2.2: check_ctrlrecip: process 13073 (qemu-kvm) requesting ep 01
but needs 81 (or 00)
   
I suspect this will mostly affect apps in virtual environments; as on
Linux the apps would have been adapted to the stricter handling of the
kernel. I have done that for mine[2].
 
[1] http://www.pegatech.com/
[2] https://sourceforge.net/projects/notetakerpen/

Signed-off-by: Kurt Garloff <kurt@garloff.de>
Cc: stable@vger.kernel.or
---
 drivers/usb/core/devio.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 737e3c1..4ff61f9 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -742,6 +742,22 @@ static int check_ctrlrecip(struct dev_state *ps,
unsigned int requesttype,
         if ((index & ~USB_DIR_IN) == 0)
             return 0;
         ret = findintfep(ps->dev, index);
+        if (ret < 0) {
+            /*
+             * Some not fully compliant Win apps seem to get
+             * ndex wrong and have the endpoint number here
+             * rather than the endpoint address (with the
+             * correct direction). Win does let this through,
+             * so we'll give it a second try as well (to not
+             * break KVM) -- but warn.
+             */
+            ret = findintfep(ps->dev, index ^ 0x80);
+            if (ret >= 0)
+                dev_info(&ps->dev->dev ,
+                    "%s: process %i (%s) requesting ep %02x but needs
%02x\n",
+                    __func__, task_pid_nr(current),
+                    current->comm, index, index ^ 0x80);
+        }
         if (ret >= 0)
             ret = checkintf(ps, ret);
         break;




-- 
Kurt Garloff <kurt@garloff.de>
Cologne, Germany

