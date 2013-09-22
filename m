Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3IVUxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:53:48 -0400
Received: from cc-smtpout1.netcologne.de ([89.1.8.211]:59410 "EHLO
	cc-smtpout1.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3IVUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:53:46 -0400
X-AuthUser: garloff@garloff.de
User-Agent: K-9 Mail for Android
In-Reply-To: <Pine.LNX.4.44L0.1309221216380.32270-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1309221216380.32270-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usb/core/devio.c:tolerate wrong direction flag in control endpoints
From: Kurt Garloff <kurt@garloff.de>
Date: Sun, 22 Sep 2013 22:53:39 +0200
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <2dd04636-8439-4823-9383-a82583849b53@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

thanks for your review and your constructive comments!



Alan Stern <stern@rowland.harvard.edu> schrieb:
>On Sun, 22 Sep 2013, Kurt Garloff wrote:
>
>> Hi,
>> 
>> USB devio rejects control messages when the index does not have the
>> direction bit set correctly.
>
>I wouldn't describe it that way.  It would be more accurate to say that
>the message is rejected when wIndex contains an invalid endpoint
>address.

Well, this seems to be a question of terminology, no?
I saw the endpoint byte as consisting of endpoint index plus the direction bit.

>> This breaks windows apps in KVM -- and might be overly strict
>according
>> to my reading of USB HID spec.
>
>It is not overly strict.

OK, you certainly know the USB specs better than I do.

If the message is not according to spec because the windex byte (which
should reference the endpoint) has the endpoint direction flag wrong,
then the question may become whether the kernel should reject it or
leave that to the device.
Rejecting by the kernel has the risk that somewhat non-compliant devices
with somewhat non-compliant (userspace) drivers are prevented from working.
While not rejecting has the risk that overly sensitive devices might freak out
on receiving a non-compliant transfer. The fact that Win does not not seem to
filter here however might make that risk rather small.
(Long years have taught us that companies don't test against the spec but this
 "OS" from Redmond.)

>> Attached patch makes the kernel tolerant against it and makes the app
>> work for me.
>> 
>> More details in the patch header.
>> 
>> USB experts: Please review this and judge whether this is correct,
>> applies more generically,
>> or maybe needs to be special cased (only for USB HID devices?) or
>> implemented as quirk
>> or module/kernel parameter.
>
>The patch seems reasonable enough, although the description needs 
>improvement and a couple of minor things should be fixed.  More 
>comments below.
>
>In the future, please put patches inline with the rest of the email
>message.  Don't make them attachments unless you have to; that way they
>become harder to read and comment on.

Seems I have not sent a patch for too long, so I failed to remember this
longstanding rule when sending. Sorry for this!

>> Once in the final form, this *might* be stable material.
>
>Yes, it should be.
>
>> commit bc1e4e1ae1d5a4f9b2d263f22c651dd5ba4f8ff9
>> Author: Kurt Garloff <kurt@garloff.de>
>> Date:   Sun Sep 22 11:54:59 2013 +0200
>> 
>>     From: Kurt Garloff <kurt@garloff.de>
>>     Subject: Tolerate wrong direction bit endpoint index for control messages
>>     Signed-off-by: Kurt Garloff <kurt@garloff.de>
>>     
>>     Trying to read data from the Pegasus Technologies NoteTaker (0e20:0101)
>>     [1] with the Windows App (EasyNote) works natively but fails when
>>     WIndows is running under KVM (and the USB device handed to KVM).
>>     
>>     The reason is a USB control message
>>      usb 4-2.2: control urb: bRequestType=22 bRequest=09 wValue=0200 wIndex=0001 wLength=0008
>>     This goes to endpoint 1 (wIndex), however, the endpoint is an input
>>     endpoint and thus enumerated 0x81.
>>     
>>     The kernel thus rejects the IO and thus we see the failure.
>>     
>>     Apparently, Linux is more strict here than Windows ... we can't change
>>     the Win app easily, so that's a problem.
>
>Indeed, this indicates that the device itself is also buggy.  If it 
>worked correctly, it would reject the incorrect control message.

It seems to interpret wIndex differently indeed. Not sure whether
that qualifies as a bug or not. Maybe it should not claim to be a
HID device then?
Looking at the code, it seems that printers do something strange
here, and it might be that the device in question here is not 100%
HID in that it also assumes a non-standard meaning to this byte.

Strange enough, the app does want to talk to the control interface it seems:
Sep 19 09:47:21 nehalem kernel: [44539.730269] usb 4-2.2: usbdev_do_ioctl: SUBMITURB
Sep 19 09:47:21 nehalem kernel: [44539.730276] usb 4-2.2: proc_submiturb: URB 02 00 0 00000000 0000000001a83420 16 0
Sep 19 09:47:21 nehalem kernel: [44539.730280] usb 4-2.2: control urb: bRequestType=22 bRequest=09 wValue=0200 wIndex=0001 wLength=0008
Sep 19 09:47:21 nehalem kernel: [44539.730285] usb 4-2.2: check_ctrlrecip: process 13073 (qemu-kvm) requesting ep 01 but needs 81 (or 00)
Sep 19 09:47:21 nehalem kernel: [44539.730290] usb 4-2.2: userurb 0000000001b56f00, ep0 ctrl-out, length 8
Sep 19 09:47:21 nehalem kernel: [44539.730294] data: 02 01 b5 00 00 00 00 00                                                                          ........
Sep 19 09:47:21 nehalem kernel: [44539.730301] usb 4-2.2: proc_submiturb: return 0

The second line here comes from instrumentation I have inserted in proc_submiturb():

        snoop(&ps->dev->dev, "%s: URB %02x %02x %i %08x %p %i %i\n",
                __func__, uurb.type, uurb.endpoint, uurb.status,
                uurb.flags, uurb.buffer, uurb.buffer_length,
                uurb.actual_length);

and it shows that uurb.endpoint actually is set to 0.

>>     However, the app might not even be buggy here.  Browsing the USB HID
>>     spec, there's a note that the bit for direction is ignored for control
>>     endpoints ... so Linux might be overly strict?
>
>No, Linux is correct.  While it is true that the direction bit is 
>ignored for control endpoints, in this case we are talking about 
>endpoint 1, which is not a control endpoint.  In an HID device, it is 
>almost certainly an interrupt endpoint.

Indeed, the device has EPs 0x81 and 0x82, both of which are 
interrupt EPs.

>>     With attached patch, everything works.
>>      usb 4-2.2: check_ctrlrecip: process 13073 (qemu-kvm) requesting ep 01 but needs 81 (or 00)
>>     
>>     Notes:
>>     - I have not checked whether the ignorance of the direction bit for
>>       control endpoints only applies to USB HID devices, thus I have not
>>       special-cased depending on the device type.
>
>It applies to all devices, but it isn't relevant here.
>
>>     - We do output a warning into the kernel log, as this might still be
>>       caused by an application error.
>> 
>>     - We don't risk sending to a wrong endpoint, as there can't be two
>>       endpoints with same index and just different direction.
>
>Of course there can be.  It is entirely possible to have one endpoint
>with address 0x01 and another with address 0x81.

Hmmm, none of the devices I have show this.
My impression was that the EP byte is composed of 
  ep = epindex | (dir==in? 0x80: 0)
and that index alone must be unique already. But then again, I'm in no
way an expert in USB specs and may just have jumped to conclusions
from the wording.
(And again the behavior might not be enforced by the spec, but maybe
by Windows?)

>However, your patch doesn't run into this problem.  If both endpoints
>exist, the routine will use the one with the address given by wIndex
>and ignore the other -- your new code won't run at all.

Yep.

>>     - I suspect this will mostly affect apps in virtual environments; as on
>>       Linux the apps would have been adapted to the stricter handling of the
>>       kernel. I have done that for mine[2], although delaying the release by
>>       two years ....
>>     
>>     [1} http://www.pegatech.com/
>>     [2] https://sourceforge.net/projects/notetakerpen/
>> 
>> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
>> index c2f62a3..8acbc2f 100644
>> --- a/drivers/usb/core/devio.c
>> +++ b/drivers/usb/core/devio.c
>> @@ -623,6 +623,19 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
>>  	switch (requesttype & USB_RECIP_MASK) {
>>  	case USB_RECIP_ENDPOINT:
>>  		ret = findintfep(ps->dev, index);
>> +		if (ret < 0) {
>> +			/* OK, give it a second try -- user might have confused
>> +			 * direction -- this happens from virtualized win apps 
>> +			 * e.g. -- warn, but be graceful */
>
>	/*
>	 * The accepted format for multiline comments
>	 * looks like this.
>	 */

OK, thanks for pointing this out!

>> +			ret = findintfep(ps->dev, index ^ 0x80);
>> +			if (ret >= 0)
>> +				dev_info(&ps->dev->dev , 
>> +					"%s: process %i (%s) requesting ep %02x but needs %02x (or
>00)\n",
>
>Why do you have the "(or 00)" part?  It doesn't seem to make any sense.

Based on the observation that uurb.endpoint = 0 (see above), I have
changed my code in the Linux program (at [2]) to use 0x00 as wIndex 
instead of 0x81 (or formerly 0x01). It still worked.
So it's questionable, whether wIndex should even point to an EP ...
and the hardware might just ignore it.

>> +					__func__, 
>> +					task_pid_nr(current),
>> +					current->comm,
>> +				       	index, index ^ 0x80);
>> +		}
>>  		if (ret >= 0)
>>  			ret = checkintf(ps, ret);
>>  		break;

Thanks for the review! I will submit a new patch.
-- 
Kurt Garloff <kurt@garloff.de>
