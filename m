Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235AbaE2Oct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:32:49 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:60047 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933649AbaE2Ocr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:32:47 -0400
Message-ID: <5387450C.7030207@dev.rtsoft.ru>
Date: Thu, 29 May 2014 18:32:44 +0400
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
References: <Pine.LNX.4.44L0.1405281014320.1552-100000@iolanthe.rowland.org> <5386C6F9.7070202@dev.rtsoft.ru>
In-Reply-To: <5386C6F9.7070202@dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> I think problem is caused by access to OHCI regs from PCI quirks - before
>>> driver was initialized. ULI1553 southbridge chip could be in strange state
>>> at this point.
>>
>> If that is the cause, we ought to be able to see it from the values
>> printed out by the debugging statements.  And if that is so, it's a
>> serious problem.  The southbridge chip really should be working at this
>> point, because the quirk_usb_handoff_* routines need to be able to
>> communicate with the host controllers.
> 
> In this case, communication looks possible.
> However, read of OHCI_FMINTERVAL register somehow breaks it.

I realized that source of the problem is elsewhere.

P2020DS board's USB connectors are not connected to ULI1553 USB.
These are connected to P2020 SOC's USB, handled by fsl-ehci driver (even
for USB 1.1 devices)
As for ULI1553 USB - it is not wired.
But - due to hardware misfeature - ULI1553 USB is not hardware-masked,
and with mainline kernel it visible on the bus:

root@freescale-p2020ds:~# lspci
0000:00:00.0 PCI bridge: Freescale Semiconductor Inc P2020E (rev 10)
0001:02:00.0 PCI bridge: Freescale Semiconductor Inc P2020E (rev 10)
0001:03:00.0 PCI bridge: ULi Electronics Inc. M5249 HTT to PCI Bridge
0001:04:1c.0 USB controller: ULi Electronics Inc. USB 1.1 Controller (rev 03)
0001:04:1c.1 USB controller: ULi Electronics Inc. USB 1.1 Controller (rev 03)
0001:04:1c.2 USB controller: ULi Electronics Inc. USB 1.1 Controller (rev 03)
0001:04:1c.3 USB controller: ULi Electronics Inc. USB 2.0 Controller (rev 01)
0001:04:1e.0 ISA bridge: ULi Electronics Inc. M1575 South Bridge
0001:04:1e.1 Bridge: ULi Electronics Inc. M7101 Power Management Controller [PMU]
0001:04:1f.0 IDE interface: ULi Electronics Inc. M5229 IDE (rev c8)
0001:04:1f.1 IDE interface: ULi Electronics Inc. ULi M5288 SATA (rev 10)
0002:05:00.0 PCI bridge: Freescale Semiconductor Inc P2020E (rev 10)

I forgot about that when checking our local tree for mainlineable commits.
Sorry.

I don't know how linux usb subsystem should behave against such
"half-existing" hardware. Perhaps hanging is not the best idea...
but maybe it should be fixed elsewhere, e.g. by masking non-wired
devices in platform PCI setup. Perhaps controlled by some device-tree
key.

Nikita
