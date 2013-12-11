Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3LKPEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:04:50 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:45791 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3LKPEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:04:49 -0500
Message-ID: <52A87E84.3030804@rosalab.ru>
Date: Wed, 11 Dec 2013 19:02:28 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: uhci_hcd: Possible corruption of DMA pool uhci->td_pool
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On ROSA Linux with kernel 3.10.21 with DMA debug options enabled, the 
kernel sometimes issues a warning about DMA pool corruption (see the log 
below).

That happens sometimes, when the system boots or resumes from 
hibernation with Samson C01U USB microphone attached.

The affected DMA pool is 'uhci->td_pool', uhci_alloc_td() from 
drivers/usb/host/uhci-hcd.c makes the relevant dma_pool_alloc() calls.

Any ideas about how to find what causes this and how to fix it?

Here is the relevant part of the system log:
----------------------------
[   22.264332] usb 2-1: new full-speed USB device number 2 using uhci_hcd
[   22.450609] usb 2-1: New USB device found, idVendor=17a0, idProduct=0001
[   22.450626] usb 2-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   22.450639] usb 2-1: Product: Samson C01U
[   22.450649] usb 2-1: Manufacturer: Samson Technologies
<...>
[  280.703483] retire_capture_urb: 4494 callbacks suppressed
[  284.961087] uhci_hcd 0000:00:1d.1: dma_pool_alloc uhci_td, efb7b060 
(corruped)
[  284.961087] 00000000: 00 06 00 00 af 00 00 03 a7 a7 a7 a7 a7 a7 a7 a7 
  ................
[  284.961087] 00000010: a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 
  ................
[  284.961087] 00000020: a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 
  ................
[  284.961087] retire_capture_urb: 4343 callbacks suppressed
[  284.961087] uhci_hcd 0000:00:1d.1: dma_pool_alloc uhci_td, efb7b5d0 
(corruped)
[  284.961087] 00000000: 00 06 00 00 af 00 00 03 a7 a7 a7 a7 a7 a7 a7 a7 
  ................
[  284.961087] 00000010: a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 
  ................
[  284.961087] 00000020: a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 a7 
  ................
[  284.961087] cannot submit urb (err = -27)
[  284.961087] cannot submit urb (err = -27)
[  284.961087] cannot submit urb (err = -27)
[  284.961087] cannot submit urb (err = -27)
[  284.961087] cannot submit urb (err = -27)
[  284.961087] cannot submit urb (err = -27)
[  284.961087] cannot submit urb (err = -27)
[  284.961087] cannot submit urb (err = -27)
----------------------------

0xa7 is POOL_POISON_FREED. The memory pages to be allocated from the 
pool should be filled with such bytes.

Each time I observed this problem, the first 8 bytes of the listed 
memory area were overwritten, with different data each time.

Regards,
Eugene

-- 
Eugene Shatokhin, ROSA Laboratory.
www.rosalab.com
