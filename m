Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3LMQKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:10:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30125 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3LMQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:10:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        gordan@bobich.net
Subject: [RFC PATCH] Xen PCI back - do slot and bus reset (v0).
Date: Fri, 13 Dec 2013 11:09:33 -0500
Message-Id: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

While I was trying to narrow down the state of GPU passthrough
(still not finished) and figuring what needs to be done I realized
that Xen PCIback did not reset my GPU properly (when I crashed the
Windows guest by mistake). It does an FLR reset or Power one - if
the device supports it. But it seems that some of these GPUs
are liars and actually don't do the power part properly.

One way to fix this is by doing a slot (aka device) and bus reset.
Of course to do that - you need to make sure that all of the
functions of a device are under the ownership of xen-pciback.
Otherwise you might accidently reset your sound card while it is
being used.

These RFC patches cleanup pci back a bit and also make it possible
for Xen pciback to do the whole gamma of 'reset' for PCI devices:
FLR, power management, AER, slot and bus reset if neccessary.

Thanks go to Gordan Bobic for educating me on how to "reprogram"
and GFX460 in a Quardro 4000M and also reporting oddities when
a PCI device was reset but it looked like it was not reset.


 drivers/xen/xen-pciback/pci_stub.c | 142 +++++++++++++++++++++++++++++++------
 drivers/xen/xen-pciback/xenbus.c   |   5 +-
 2 files changed, 124 insertions(+), 23 deletions(-)


Konrad Rzeszutek Wilk (5):
      xen-pciback: Cleanup up pcistub_put_pci_dev
      xen-pciback: First reset, then free.
      xen-pciback: Document when we FLR an PCI device.
      xen/pciback: Move the FLR code to a function.
      xen/pciback: PCI reset slot or bus

