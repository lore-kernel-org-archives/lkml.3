Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbaE2Fez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:34:55 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:56161 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933267AbaE2Few (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 01:34:52 -0400
Message-ID: <5386C6F9.7070202@dev.rtsoft.ru>
Date: Thu, 29 May 2014 09:34:49 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
References: <Pine.LNX.4.44L0.1405281014320.1552-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1405281014320.1552-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would help to print the value of fminterval.
> And here to print the value obtained by the readl().

I've checked these... all values read as 0xffffffff - which does not
look correct

readl(base + OHCI_CONTROL) several lines before returns 0x00000000
Read of HcRevision register (base + 0x0) at the same point returns
0x00000110.

If I comment out access to OHCI_FMINTERVAL, then, after writing OHCI_HCR
to CMDSTATUS, read of OHCI_CMDSTATUS immediately returns zero, and
routine succeeds.

>> irq 26: nobody cared (try booting with the "irqpoll" option)
>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc6-dirty #5
>> Call Trace:
>> [effe5ed0] [c000726c] show_stack+0x48/0x15c (unreliable)
>> [effe5f10] [c05eece4] dump_stack+0x78/0xa0
>> [effe5f20] [c0087acc] __report_bad_irq+0x38/0x100
>> [effe5f40] [c0088060] note_interrupt+0x224/0x280
>> [effe5f70] [c008563c] handle_irq_event_percpu+0xc8/0x178
>> [effe5fa0] [c0085730] handle_irq_event+0x44/0x74
>> [effe5fc0] [c0088f88] handle_fasteoi_irq+0xd4/0x1d0
>> [effe5fd0] [c0084d20] generic_handle_irq+0x30/0x50
>> [effe5fe0] [c00048d0] __do_irq+0x2c/0x70
>> [effe5ff0] [c000d9a0] call_do_irq+0x24/0x3c
>> [ef047d10] [c00049a0] do_IRQ+0x8c/0xf8
>> [ef047d30] [c000f598] ret_from_except+0x0/0x18
>> --- Exception: 501 at quirk_usb_early_handoff+0x794/0x85c
>>     LR = quirk_usb_early_handoff+0x788/0x85c
> 
> That exception looks very suspicious.  Do you know what it means?

This is just what powerpc backtraces show for hardware interrupt.
I.e. hardware interrupt happened at quirk_usb_early_handoff+0x794/0x85c

> 
> It looks like this IRQ 26 stuff has no connection with OHCI, right?

26 is a virtual number, assigned by irq_of_parse_and_map() call.
Physically it is MPIC internal IRQ 9, which is PCI Express port 2 IRQ.
(ULI1553 southbridge is connected to PCI Express port 2).
This is not interrupt from PCI/PCIe device, but interrupt from
controller itself. However, per code in fsl_pci_pme_handle(), none of
bits in status register are set (otherwise it won't return IRQ_NONE, and
kernel won't claim that "nobody cared"). Looks bogus.

>> A2
>> A3
>> A4
>> A5
>> A4
>> A5
>> A4
>> A5
>> A4
>> A5
>> A4
>>
>> and hang.
> 
> Meaning that it stops completely, not that it goes into an infinite 
> loop?

Yes, it hangs.


>> I think problem is caused by access to OHCI regs from PCI quirks - before
>> driver was initialized. ULI1553 southbridge chip could be in strange state
>> at this point.
> 
> If that is the cause, we ought to be able to see it from the values
> printed out by the debugging statements.  And if that is so, it's a
> serious problem.  The southbridge chip really should be working at this
> point, because the quirk_usb_handoff_* routines need to be able to
> communicate with the host controllers.

In this case, communication looks possible.
However, read of OHCI_FMINTERVAL register somehow breaks it.

Nikita
