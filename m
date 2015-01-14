Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbbANOP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:15:26 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:53740 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbANOPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:15:25 -0500
Date: Wed, 14 Jan 2015 15:15:21 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <74756708.20150114151521@eikelenboom.it>
To: David Vrabel <david.vrabel@citrix.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: 3.19-rc4: Xen pci-passthrough regression, bisected to commit cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 "x86, irq: Keep balance of IOAPIC pin reference count"
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerry / David / Konrad,

Some more testing uncovered another issue under Xen, this time with PCI-passthrough.

I have bisected it to the following commit: 
cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 "x86, irq: Keep balance of IOAPIC pin reference count"

It causes these symptoms:

- On Intel
  - Running on Xen with pci devices seized on host boot with xen-pciback.hide= parameter
  - Running a HVM guest with PCI passthrough of two devices (NIC + wireless NIC)
  - While the driver loads fine, the device isn't working properly, looking in /proc/interrupts in the guest
    shows that it doesn't receive any interrupts.
  - Reverting this particular commit (in the dom0 kernel only) makes the device receive interrupts and work properly again.

- On AMD (more subtle symptom) 
  - Running on Xen with pci devices seized on host boot with xen-pciback.hide= parameter
  - Running a HVM guest with PCI passthrough of one devices (videograbber)
  - While the driver loads fine and the device looks like it's working, the videostream isn't stable and it skips or repeats frames.
  - Reverting this particular commit (in the dom0 kernel only) makes the device work properly again with a stable videostream.

--
Sander

