Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3JRWJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:09:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:32924 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab3JRWJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:09:48 -0400
Date: Fri, 18 Oct 2013 17:09:41 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 0/2] rsxx: Two important bug fixes for the rsxx block driver.
Message-ID: <20131018220941.GA1278@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101822-0320-0000-0000-0000016D6451
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The incoming patches are for the rsxx driver (drivers/block/rsxx)

Patch1:
This patch fixes a bug in which discards were always
calling pci_unmap_page. Discards should never call the
pci_unmap_page function call because they are never mapped.

This caused a race condition on PowerPC systems when issuing
discards, writes, and reads all at the same time. The
pci_map_page function would eventually map logical address
0 for a read or write. Discards are always assigned a DMA
address of 0 because they are never mapped. So if
pci_map_page mapped address 0 for a DMA and a discard was
"unmapped" then the address would be freed and would cause 
an EEH event to occur when Hardware accesses the address.

This was injected/uncovered in commit:
b347f9cf0bc8d42ee95ba1d3837fd93045ab336b

The pci_dma_mapping_error function declares -1 a DMA_ERROR
not 0 like initially thought.

This patch should fall on top of commit id:
fc1967bb08a6184ed44ef990e1dd4389901b809c


Patch2:
This patch fixes a possible Kernel Panic on driver load if 
the configuration on the card is messed up or not yet set.
The driver could possible give a 32 bit unsigned all Fs to
the kernel as the device's block size.

Now we only write the block size to the kernel if the
configuration from the card is valid.

Regards,
- Philip Kelleher
	

