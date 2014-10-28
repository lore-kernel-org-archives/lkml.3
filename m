Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaJ1TJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:09:14 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46528 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaJ1TJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:09:13 -0400
Message-ID: <544FE9BE.6040503@gmail.com>
Date: Tue, 28 Oct 2014 12:08:46 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lauraa@codeaurora.org, gioh.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        mina86@mina86.com, m.szyprowski@samsung.com, akpm@linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: DMA allocations from CMA and fatal_signal_pending check
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While debugging why some dma_alloc_coherent() allocations where
returning NULL on our brcmstb platform, specifically with
drivers/net/ethernet/broadcom/bcmcsysport.c, I came across the
fatal_signal_pending() check in mm/page_alloc.c which is there.

This driver calls dma_alloc_coherent(, GFP_KERNEL) which ends up making
a coherent allocation from a CMA region on our platform. Since that
allocation is allowed to sleep, and because we are in bcm_syport_open(),
executed from process context, a pending signal makes
dma_alloc_coherent() return NULL.

There are two ways I could fix this:

- use a GFP_ATOMIC allocation, which would avoid this sensitivity to a
pending signal being fatal (we suffer from the same issue in
bcm_sysport_resume)

- move the DMA coherent allocation before bcm_sysport_open(), in the
driver's probe function, but if the network interface is never used, we
would be waisting precious DMA coherent memory for nothing (it is only 4
bytes times 32 but still

Now the general problem that I see with this fatal_signal_pending()
check is that any driver that calls dma_alloc_coherent() and which does
this in a process context (network drivers are frequently doing this in
their ndo_open callback) and also happens to get its allocation serviced
from CMA can now fail, instead of failing on really hard OOM conditions.
--
Florian
