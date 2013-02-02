Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3BBJfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 04:35:42 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:33149 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3BBJfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 04:35:39 -0500
MIME-Version: 1.0
X-Originating-IP: [111.65.28.14]
Date: Sat, 2 Feb 2013 17:35:38 +0800
Message-ID: <CAMVG2sumi56v4ceVrdHqj+20TmMTHqqNVF_E7GPLSVvvj9AKZQ@mail.gmail.com>
Subject: [3.8.0-rc6] xhci NULL deref
From: Daniel J Blueman <daniel@quora.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB <linux-usb-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a couple of communication devices attached [1] on 3.8.0-rc6, XHCI
ran into a zero-page access [2].

A quick check of the code [3,4] suggests that struct xhci_virt_device
dev was NULL.

I'll see if I can have netconsole enabled for when it occurs again, to
catch any related error information.

Thanks,
  Daniel

--- [1]

$ lsusb
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 003 Device 004: ID 0424:2412 Standard Microsystems Corp.
Bus 003 Device 003: ID 04e8:6863 Samsung Electronics Co., Ltd
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 05ac:8510 Apple, Inc.
Bus 002 Device 003: ID 0424:2512 Standard Microsystems Corp. USB 2.0 Hub
Bus 003 Device 005: ID 0403:6010 Future Technology Devices
International, Ltd FT2232C Dual USB-UART/FIFO IC
Bus 002 Device 008: ID 05ac:8286 Apple, Inc.
Bus 002 Device 004: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub
(part of BCM2046 Bluetooth)
Bus 002 Device 005: ID 05ac:0262 Apple, Inc.

--- [2]

Unable to handle NULL pointer dereference 000000000000000508

RAX: 00000000000000500
RBX: 00000000000000000
RCX: 00000000000000508
RDX: 00000000000000000
RSI: 00000000000000006
RDI: 00000000000000000
RBP: ffff88026f203dc8

xhci_stream_id_to_ring+0x40
handle_cmd_completion+0x16a
? rebalance_domains+0x96
xhci_irq+0x27b

--- [3]

(gdb) disassemble xhci_stream_id_to_ring+0x40
   0xffffffff813384e0 <+0>:	mov    %esi,%esi
   0xffffffff813384e2 <+2>:	push   %rbp
   0xffffffff813384e3 <+3>:	lea    (%rsi,%rsi,2),%rax
   0xffffffff813384e7 <+7>:	mov    %rsp,%rbp
   0xffffffff813384ea <+10>:	lea    (%rsi,%rax,4),%rax
   0xffffffff813384ee <+14>:	shl    $0x4,%rax
   0xffffffff813384f2 <+18>:	test   %edx,%edx
   0xffffffff813384f4 <+20>:	lea    0x20(%rdi,%rax,1),%rax
   0xffffffff813384f9 <+25>:	lea    0x8(%rax),%rcx
   0xffffffff813384fd <+29>:	je     0xffffffff81338520
<xhci_stream_id_to_ring+64>
   0xffffffff813384ff <+31>:	mov    0x8(%rcx),%rax
   0xffffffff81338503 <+35>:	test   %rax,%rax
   0xffffffff81338506 <+38>:	je     0xffffffff81338530
<xhci_stream_id_to_ring+80>
   0xffffffff81338508 <+40>:	cmp    0x8(%rax),%edx // deref

--- [4]

struct xhci_ring *xhci_stream_id_to_ring(
		struct xhci_virt_device *dev,
		unsigned int ep_index,
		unsigned int stream_id)
{
	struct xhci_virt_ep *ep = &dev->eps[ep_index];

	if (stream_id == 0)
		return ep->ring; // deref
	if (!ep->stream_info)
		return NULL;

	if (stream_id > ep->stream_info->num_streams)
		return NULL;
	return ep->stream_info->stream_rings[stream_id];
}
-- 
Daniel J Blueman
