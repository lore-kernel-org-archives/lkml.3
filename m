Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaLEJWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:22:30 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:35687 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaLEJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:22:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,521,1413270000"; 
   d="scan'208";a="52190502"
Message-ID: <5481794E.4050406@broadcom.com>
Date: Fri, 5 Dec 2014 10:22:22 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: using DMA-API on ARM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

For our brcm80211 development we are working on getting brcmfmac driver
up and running on a Broadcom ARM-based platform. The wireless device is
a PCIe device, which is hooked up to the system behind a PCIe host
bridge, and we transfer information between host and device using a
descriptor ring buffer allocated using dma_alloc_coherent(). We mostly
tested on x86 and seen no issue. However, on this ARM platform
(single-core A9) we detect occasionally that the descriptor content is
invalid. When this occurs we do a dma_sync_single_for_cpu() and this is
retried a number of times if the problem persists. Actually, found out
that someone made a mistake by using virt_to_dma(va) to get the
dma_handle parameter. So probably we only provided a delay in the retry
loop. After fixing that a single call to dma_sync_single_for_cpu() is
sufficient. The DMA-API-HOWTO clearly states that:

"""
the hardware should guarantee that the device and the CPU can access the
data in parallel and will see updates made by each other without any
explicit software flushing.
"""

So it seems incorrect that we would need to do a dma_sync for this
memory. That we do need it seems like this memory can end up in
cache(?), or whatever happens, in some rare condition. Is there anyway
to investigate this situation either through DMA-API or some low-level
ARM specific functions.

Regards,
Arend
