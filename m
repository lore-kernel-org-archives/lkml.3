Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab3GSOjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:39:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40042 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308Ab3GSOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:39:11 -0400
Message-ID: <51E94F7C.9090302@canonical.com>
Date: Fri, 19 Jul 2013 10:38:52 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>, jkosina@suse.cz,
        benjamin.tissoires@gmail.com, adlr@chromium.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing Unifying
 device issue""
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com> <51E84FD1.4050400@hurleysoftware.com> <20130718220936.GA8025@xanatos> <51E87C1F.1090301@hurleysoftware.com>
In-Reply-To: <51E87C1F.1090301@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 07:37 PM, Peter Hurley wrote:
> On 07/18/2013 06:09 PM, Sarah Sharp wrote:
>> On Thu, Jul 18, 2013 at 04:28:01PM -0400, Peter Hurley wrote:
>>> [ +cc Sarah Sharp, linux-usb ]
>>>
>>> On 07/18/2013 09:21 AM, Nestor Lopez Casado wrote:
>>>> This reverts commit 8af6c08830b1ae114d1a8b548b1f8b056e068887.
>>>>
>>>> This patch re-adds the workaround introduced by 596264082f10dd4
>>>> which was reverted by 8af6c08830b1ae114.
>>>>
>>>> The original patch 596264 was needed to overcome a situation where
>>>> the hid-core would drop incoming reports while probe() was being
>>>> executed.
>>>>
>>>> This issue was solved by c849a6143bec520af which added
>>>> hid_device_io_start() and hid_device_io_stop() that enable a specific
>>>> hid driver to opt-in for input reports while its probe() is being
>>>> executed.
>>>>
>>>> Commit a9dd22b730857347 modified hid-logitech-dj so as to use the
>>>> functionality added to hid-core. Having done that, workaround 596264
>>>> was no longer necessary and was reverted by 8af6c08.
>>>>
>>>> We now encounter a different problem that ends up 'again' thwarting
>>>> the Unifying receiver enumeration. The problem is time and usb
>>>> controller
>>>> dependent. Ocasionally the reports sent to the usb receiver to start
>>>> the paired devices enumeration fail with -EPIPE and the receiver never
>>>> gets to enumerate the paired devices.
>>>>
>>>> With dcd9006b1b053c7b1c the problem was "hidden" as the call to the
>>>> usb
>>>> driver became asynchronous and none was catching the error from the
>>>> failing URB.
>>>>
>>>> As the root cause for this failing SET_REPORT is not understood yet,
>>>> -possibly a race on the usb controller drivers or a problem with the
>>>> Unifying receiver- reintroducing this workaround solves the problem.
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
> Sarah,
>
> I forwarded your usbmon capture request to the OP in the bug report
> (I don't have an email address for the reporter).
>
> As far as getting printk output from a custom kernel, I think that may
> be beyond the reporter's capability. Perhaps one of the Ubuntu devs
> triaging this bug could provide a test kernel for the OP with those
> options on.
>
> Joseph, would you be willing to do that?

Sure thing.  I'll build a kernel and request that the bug reporter
collect usbmon data.

Thanks everyone for the feedback!

>
> Regards,
> Peter Hurley

