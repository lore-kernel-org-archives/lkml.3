Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3AQU2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:28:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58696 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab3AQU2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:28:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Soeren Moch <smoch@web.de>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
Date: Thu, 17 Jan 2013 20:26:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <201301171049.30415.arnd@arndb.de> <50F800EB.6040104@web.de>
In-Reply-To: <50F800EB.6040104@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301172026.45514.arnd@arndb.de>
X-Provags-ID: V02:K0:QibfHb/ih/cXuBq+/jOT21lQ/3GTRUrdXQI9q5vkgpX
 LLBWPXMiXYnO7EEuAAC1fRQtAOLBt3TRwlJ49D1C+EOgeQd9v7
 RjxAqul/vHtvpT7PUaKXtkZ/SREXRjAvZQKa7IFfJHJoMARIAc
 rJ96BthU095HCUajZCEWiuyqrkZIwj2aUFXyxMYzvK3qIDbrZl
 vIhPnHX6rbhCo0rLCXzvnLYrWux56U1bp3r1ep2i4Svy67seX7
 XDMv64xIsfnDw1F1sEoR82WaFdllyj7dR97f/u29mfL65malno
 TWbxnoFabmtxl4MVVRe+4uw29etyBVEh/vuW+5lunqVaZt5x61
 n4FNW+52oD7D+BiAI7Eo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2013, Soeren Moch wrote:
> On 17.01.2013 11:49, Arnd Bergmann wrote:
> > On Wednesday 16 January 2013, Soeren Moch wrote:
> >>>> I will see what I can do here. Is there an easy way to track the buffer
> >>>> usage without having to wait for complete exhaustion?
> >>>
> >>> DMA_API_DEBUG
> >>
> >> OK, maybe I can try this.
> >>>
> >
> > Any success with this? It should at least tell you if there is a
> > memory leak in one of the drivers.
> 
> Not yet, sorry. I have to do all the tests in my limited spare time.
> Can you tell me what to search for in the debug output?

Actually now that I've looked closer, you can't immediately see
all the mappings as I thought.

But please try enabling DMA_API_DEBUG in combination with this
one-line patch:

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 6b2fb87..3df74ac 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -497,6 +497,7 @@ static void *__alloc_from_pool(size_t size, struct page **ret_page)
 		pr_err_once("ERROR: %u KiB atomic DMA coherent pool is too small!\n"
 			    "Please increase it with coherent_pool= kernel parameter!\n",
 			    (unsigned)pool->size / 1024);
+		debug_dma_dump_mappings(NULL);
 	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
That will show every single allocation that is currently active. This lets
you see where all the memory went, and if there is a possible leak or
excessive fragmentation.

	Arnd
