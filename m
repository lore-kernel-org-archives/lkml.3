Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538Ab3GSIgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:36:08 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:45516 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760003Ab3GSIgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <51E87C1F.1090301@hurleysoftware.com>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
	<51E84FD1.4050400@hurleysoftware.com>
	<20130718220936.GA8025@xanatos>
	<51E87C1F.1090301@hurleysoftware.com>
Date: Fri, 19 Jul 2013 10:35:57 +0200
Message-ID: <CAN+gG=HKe0eNBmwaf=h6nzR9U3DPC-Hvb1W-uwVqjih5AiKUuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing
 Unifying device issue""
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        joseph.salisbury@canonical.com,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jiri Kosina <jkosina@suse.cz>, Andrew de los Reyes <adlr@chromium.org>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, wujun zhou <zwj.echo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

thanks for forwarding this to the appropriate people & mailing list.

Hi Sarah,

thanks for starting investigating this :)

On Fri, Jul 19, 2013 at 1:37 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>>
>>>
>>>
>>> Before we revert to using the workaround, I'd like to suggest that
>>> this new "hidden" problem may be an interaction with the xhci_hcd host
>>> controller driver only.
>>>
>>> Looking at the related bug, the OP indicates the machine only has
>>> USB3 ports. Additionally, comments #7, #100, and #104 of the original
>>> bug report [1] add additional information that would seem to confirm
>>> this suspicion.

Definitively, this is a USB3 problem. However, it is not generic (I
can not reproduce it with my USB3 boards.)

>>
>>
>> Question: does this USB device need a control transfer to reset its
>> endpoints when the endpoints are not actually halted?  If so, yes, that
>> is a known xHCI driver bug that needs to be fixed.  The xHCI host will
>> not accept a Reset Endpoint command when the endpoints are not actually
>> halted, but the USB core will send the control transfer to reset the
>> endpoint.  That means the device and host toggles will be out of sync,
>> and all messages will start to fail with -EPIPE.
>>
>> Can the OP capture a usbmon trace when the device starts failing?  That
>> will reveal whether this actually is the issue.  dmesg output with
>> CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING turned on would also
>> be helpful.
>

Here is another linux-input thread were you have the usbmon traces:
http://www.spinics.net/lists/linux-input/msg26542.html
Wujun Zhou already did one test of a kernel patch for me (which did
not solve the problem, because I was not at the USB level), so I bet
he will be able to do some testings for you.

In the logs he posted (logitech_work.pcapng.gz), the interesting part
is starting from the capture #45:

#45: SET_REPORT request to switch the receiver to the "DJ" mode (the
receiver stops sending regular HID events, but goes into its
proprietary protocol)
#47: SET_REPORT response -> all good
#48: SET_REPORT request to ask the receiver to enumerate all of his
devices (it is called right after we received the previous response)
#49: SET_REPORT response -> -EPIPE
#50: URB_INTERRUPT_IN (~3 seconds later) -> the device is working normally

The weird thing is that only the first enumeration message failed with
-EPIPE: the device answers later control transfer correctly (#54 /
#55).

>
> Sarah,
>
> I forwarded your usbmon capture request to the OP in the bug report
> (I don't have an email address for the reporter).
>

Here are some other helpful information:
the first "fix" we have done is dcd9006b1b053c7b1c. It is linked to
several bugs:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072082
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039143
https://bugzilla.redhat.com/show_bug.cgi?id=840391
https://bugzilla.kernel.org/show_bug.cgi?id=49781

Most of them are people complaining, but in one of the comments,
adding a 500ms wait between the two control transfer (switch to DJ +
enumerate) fixed the -EPIPE problem. I interpreted it as a scheduled
problem (using direct call to usb_control_msg() vs use the scheduled
one usbhid_submit_message()) but it was just delaying the problem out
of the probe. Unfortunately, I missed that as I did not asked for the
usbmon traces at that time.

One last thing, I understood that Linus is also experiencing this
problem... Adding him in CC to let him know of the progress.

Cheers,
Benjamin
