Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaG3Dma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:42:30 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43340 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbaG3Dm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:42:28 -0400
MIME-Version: 1.0
In-Reply-To: <5059148.8xZUvoce2l@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<4843763.ps2D25LEeM@wuerfel>
	<CAFiDJ582FiLAS=B13O3PV_d-FkR31j=5bN_LcXBSWkrGsHK_Gw@mail.gmail.com>
	<5059148.8xZUvoce2l@wuerfel>
Date: Wed, 30 Jul 2014 11:42:27 +0800
X-Google-Sender-Auth: cw9Sq14dhPfS_bUoE9TjOfAGUmY
Message-ID: <CAFiDJ59GxBRtDw3bnGRMbq=NF3TwbZbXq1ROUwXn26SDV=-agg@mail.gmail.com>
Subject: Re: [PATCH v2 13/29] nios2: DMA mapping API
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 8:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> I have spent some times look at other architectures and below is what
>> I found. Please correct me if I am wrong, especially
>> for_device():DMA_FROM_DEVICE.
>>
>> _for_cpu():
>> case DMA_BIDIRECTIONAL:
>> case DMA_FROM_DEVICE:
>>      /* invalidate cache */
>> break;
>> case DMA_TO_DEVICE:
>>    /* do nothing */
>> break;
>
> This seems fine: for a FROM_DEVICE mapping, we have flushed all
> dirty entries during the _for_device or the map operation,
> so if any clean entries are around, they need to be invalidated
> in order to read the data from the device.
>
> for TO_DEVICE, we don't care about the cache, because we are
> going to overwrite the data, and we don't need to do anything.
Okay.

>
>> -------------------------
>> _for_device():
>> case DMA_BIDIRECTIONAL:
>> case DMA_TO_DEVICE:
>>      /* flush and invalidate cache */
>> break;
>> case DMA_FROM_DEVICE:
>>  /* should we invalidate cache or do nothing? */
>> break;
>
> You actually don't need to invalidate the TO_DEVICE mappings
> in both _for_device and _for_cpu. You have to flush them
> in for_device, and you have to invalidate them at least once,
> but don't need to invalidate them again in for_cpu if you have
> done that already in for_device and your CPU does not do any
> speculative prefetches that might populate the dcache.
Nios2 processor doesn't have flush-cache-only instruction. Its flush
instruction will do 2 operations, flush and invalidate cache.


> In case of for_device FROM_DEVICE, you have to invalidate or
> flush the caches to ensure that no dirty cache lines are
> written to memory, but only if your CPU has a write-back
> cache rather than write-through.
Nios2 has a write-back cache. So, will do invalidate cache here.

> For bidirectional mappings, you may have to flush and invalidate.
To confirm, do you mean bidirectional for both for_device and for_cpu?

Thanks.

Regards
Ley Foon
