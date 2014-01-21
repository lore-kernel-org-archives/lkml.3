Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaAUWHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:07:11 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47461 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaAUWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:07:08 -0500
Message-ID: <52DEEF88.8090709@gmail.com>
Date: Tue, 21 Jan 2014 14:07:04 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com> <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com> <52DAE2BF.7020208@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com> <20140120181442.GA5545@xanatos> <063D6719AE5E284EB5DD2968C1650D6D4609BF@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D4609BF@AcuExch.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 01:51 AM, David Laight wrote:
> From: Sarah Sharp
>> On Mon, Jan 20, 2014 at 11:21:14AM +0000, David Laight wrote:
> ...
>>> A guess...
>>>
>>> In queue_bulk_sg_tx() try calling xhci_v1_0_td_remainder() instead
>>> of xhci_td_remainder().
>>
>> Why?  Walt has a 0.96 xHCI host controller, and the format for how to
>> calculate the TD remainder changed between the 0.96 and the 1.0 spec.
>> That's why we have xhci_v1_0_td_remainder() and xhci_td_remainder().
> 
> I just wonder how many of those differences are just differences in the
> specification, rather than differences in the hardware implementation.
> In some cases it might be that the old hardware just ignored the value.
> 
> I know that the xhci hardware on my ivy bridge cpu does look at that
> value (at least checking for zero), since things failed in subtle ways
> when I got it wrong.
> 
> In this case it was just something easy to change that might be worth
> trying.  I didn't necessarily expect it to make a positive difference.

David, I tried the one-liner below, which changed nothing AFAICS, but
then I'm not sure it's the change you intended:

--- xhci-ring.c.orig	2014-01-21 13:28:36.396278813 -0800
+++ xhci-ring.c	2014-01-21 13:35:11.410312814 -0800
@@ -3335,7 +3335,7 @@
 		}
 
 		/* Set the TRB length, TD size, and interrupter fields. */
-		if (xhci->hci_version < 0x100) {
+		if (xhci->hci_version > 0x100) {
 			remainder = xhci_td_remainder(
 					urb->transfer_buffer_length -
 					running_total);

