Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaK0Lhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:37:35 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:33576 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbaK0Lhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:37:34 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] staging: comedi: adl_pci9118: some dma transfer changes
Date: Thu, 27 Nov 2014 11:37:16 +0000
Message-Id: <1417088239-20460-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For streaming acquisition on the analog input subdevice, this driver
normally uses DMA double buffering into two internal DMA buffers, so it
can switch buffers early after a DMA transfer has completed, while it
processes the completed DMA buffer.

PATCH 1 is just a bit of tidy up.

PATCH 2 avoids switching the DMA double buffer at the end of
acquisition.  For DMA single buffering, it avoids restarting the DMA
transfer if acquisition has ended normally or due to a comedi buffer
overflow error.  (However, for double buffering, the DMA transfer has
already been started on the other DMA buffer and will be stopped soon
after.)

PATCH 3 eliminates a possible defragmentation step in the DMA buffer
contents before they are transferred to the comedi buffer.  Instead, the
DMA buffer fragments are copied directly to the comedi buffer, or is
copied all in one go if the data is not fragmented.

This work is in response to Hartley's "PATCH 4/4] staging: comedi:
adl_pci9118: switch DMA buffers after writing samples", dated Mon, 10
Nov 2014 1959:17 -0500, message ID
<1415667477-28403-5-git-send-email-hsweeten@visionengravers.com>, which
was not applied.

These patches are against Greg's "staging-testing" branch.

1) staging: comedi: adl_pci9118: simplify interrupt_pci9118_ai_dma() a
   bit
2) staging: comedi: adl_pci9118: try and avoid unnecessary DMA restart
3) staging: comedi: adl_pci9118: eliminate DMA buffer defragmentation
   step

 drivers/staging/comedi/drivers/adl_pci9118.c | 157 +++++++++++++++++++++------
 1 file changed, 121 insertions(+), 36 deletions(-)
