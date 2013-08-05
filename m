Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3HEC7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:59:14 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39773 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3HEC7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:59:12 -0400
Message-ID: <51FF14F8.7000204@ozlabs.ru>
Date: Mon, 05 Aug 2013 12:59:04 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Santosh Rastapur <santosh@chelsio.com>, Divy Le Ray <divy@chelsio.com>
CC: Jay Fenlason <fenlason@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG cxgb3: Check and handle the dma mapping errors
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Recently I started getting multiple errors like this:

cxgb3 0006:01:00.0: iommu_alloc failed, tbl c000000003067980 vaddr
c000001fbdaaa882 npages 1
cxgb3 0006:01:00.0: iommu_alloc failed, tbl c000000003067980 vaddr
c000001fbdaaa882 npages 1
cxgb3 0006:01:00.0: iommu_alloc failed, tbl c000000003067980 vaddr
c000001fbdaaa882 npages 1
cxgb3 0006:01:00.0: iommu_alloc failed, tbl c000000003067980 vaddr
c000001fbdaaa882 npages 1
cxgb3 0006:01:00.0: iommu_alloc failed, tbl c000000003067980 vaddr
c000001fbdaaa882 npages 1
cxgb3 0006:01:00.0: iommu_alloc failed, tbl c000000003067980 vaddr
c000001fbdaaa882 npages 1
cxgb3 0006:01:00.0: iommu_alloc failed, tbl c000000003067980 vaddr
c000001fbdaaa882 npages 1
... and so on

This is all happening on a PPC64 "powernv" platform machine. To trigger the
error state, it is enough to _flood_ ping CXGB3 card from another machine
(which has Emulex 10Gb NIC + Cisco switch). Just do "ping -f 172.20.1.2"
and wait 10-15 seconds.


The messages are coming from arch/powerpc/kernel/iommu.c and basically
mean that the driver requested more pages than the DMA window has which is
normally 1GB (there could be another possible source of errors -
ppc_md.tce_build callback - but on powernv platform it always succeeds).


The patch after which it broke is:
commit f83331bab149e29fa2c49cf102c0cd8c3f1ce9f9
Author: Santosh Rastapur <santosh@chelsio.com>
Date:   Tue May 21 04:21:29 2013 +0000
cxgb3: Check and handle the dma mapping errors

Any quick ideas? Thanks!


-- 
Alexey
