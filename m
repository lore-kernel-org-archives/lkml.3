Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaHIFkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:40:11 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:51143 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbaHIFkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:40:09 -0400
Message-ID: <53E5B41B.3030009@vmware.com>
Date: Sat, 9 Aug 2014 07:39:39 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mario Kleiner <mario.kleiner.de@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Hellstrom <thellstrom@vmware.com>, <kamal@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>, <ben@decadent.org.uk>,
        <m.szyprowski@samsung.com>
Subject: Re: CONFIG_DMA_CMA causes ttm performance problems/hangs.
References: <53E50C1B.9080507@gmail.com>
In-Reply-To: <53E50C1B.9080507@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.246]
X-ClientProxiedBy: EX13-CAS-013.vmware.com (10.113.191.65) To
 EX13-MBX-024.vmware.com (10.113.191.44)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

IIRC I don't think the TTM DMA pool allocates coherent pages more than
one page at a time, and _if that's true_ it's pretty unnecessary for the
dma subsystem to route those allocations to CMA. Maybe Konrad could shed
some light over this?

/Thomas


On 08/08/2014 07:42 PM, Mario Kleiner wrote:
> Hi all,
>
> there is a rather severe performance problem i accidentally found when
> trying to give Linux 3.16.0 a final test on a x86_64 MacBookPro under
> Ubuntu 14.04 LTS with nouveau as graphics driver.
>
> I was lazy and just installed the Ubuntu precompiled mainline kernel.
> That kernel happens to have CONFIG_DMA_CMA=y set, with a default CMA
> (contiguous memory allocator) size of 64 MB. Older Ubuntu kernels
> weren't compiled with CMA, so i only observed this on 3.16, but
> previous kernels would likely be affected too.
>
> After a few minutes of regular desktop use like switching workspaces,
> scrolling text in a terminal window, Firefox with multiple tabs open,
> Thunderbird etc. (tested with KDE/Kwin, with/without desktop
> composition), i get chunky desktop updates, then multi-second freezes,
> after a few minutes the desktop hangs for over a minute on almost any
> GUI action like switching windows etc. --> Unuseable.
>
> ftrace'ing shows the culprit being this callchain (typical good/bad
> example ftrace snippets at the end of this mail):
>
> ...ttm dma coherent memory allocations, e.g., from
> __ttm_dma_alloc_page() ... --> dma_alloc_coherent() --> platform
> specific hooks ... -> dma_generic_alloc_coherent() [on x86_64] -->
> dma_alloc_from_contiguous()
>
> dma_alloc_from_contiguous() is a no-op without CONFIG_DMA_CMA, or when
> the machine is booted with kernel boot cmdline parameter "cma=0", so
> it triggers the fast alloc_pages_node() fallback at least on x86_64.
>
> With CMA, this function becomes progressively more slow with every
> minute of desktop use, e.g., runtimes going up from < 0.3 usecs to
> hundreds or thousands of microseconds (before it gives up and
> alloc_pages_node() fallback is used), so this causes the
> multi-second/minute hangs of the desktop.
>
> So it seems ttm memory allocations quickly fragment and/or exhaust the
> CMA memory area, and dma_alloc_from_contiguous() tries very hard to
> find a fitting hole big enough to satisfy allocations with a retry
> loop (see
> http://lxr.free-electrons.com/source/drivers/base/dma-contiguous.c#L339)
> that takes forever.
>
> This is not good, also not for other devices which actually need a
> non-fragmented CMA for DMA, so what to do? I doubt most current gpus
> still need physically contiguous dma memory, maybe with exception of
> some embedded gpus?
>
> My naive approach would be to add a new gfp_t flag a la
> ___GFP_AVOIDCMA, and make callers of dma_alloc_from_contiguous()
> refrain from doing so if they have some fallback for getting memory.
> And then add that flag to ttm's ttm_dma_populate() gfp_flags, e.g.,
> around here:
> http://lxr.free-electrons.com/source/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c#L884
>
> However i'm not familiar enough with memory management, so likely
> greater minds here have much better ideas on how to deal with this?
>
> thanks,
> -mario
>
> Typical snippet from an example trace of a badly stalling desktop with
> CMA (alloc_pages_node() fallback may have been missing in this traces
> ftrace_filter settings):
>
> 1)               |                          ttm_dma_pool_get_pages
> [ttm]() {
>  1)               | ttm_dma_page_pool_fill_locked [ttm]() {
>  1)               | ttm_dma_pool_alloc_new_pages [ttm]() {
>  1)               | __ttm_dma_alloc_page [ttm]() {
>  1)               | dma_generic_alloc_coherent() {
>  1) ! 1873.071 us | dma_alloc_from_contiguous();
>  1) ! 1874.292 us |                                  }
>  1) ! 1875.400 us |                                }
>  1)               | __ttm_dma_alloc_page [ttm]() {
>  1)               | dma_generic_alloc_coherent() {
>  1) ! 1868.372 us | dma_alloc_from_contiguous();
>  1) ! 1869.586 us |                                  }
>  1) ! 1870.053 us |                                }
>  1)               | __ttm_dma_alloc_page [ttm]() {
>  1)               | dma_generic_alloc_coherent() {
>  1) ! 1871.085 us | dma_alloc_from_contiguous();
>  1) ! 1872.240 us |                                  }
>  1) ! 1872.669 us |                                }
>  1)               | __ttm_dma_alloc_page [ttm]() {
>  1)               | dma_generic_alloc_coherent() {
>  1) ! 1888.934 us | dma_alloc_from_contiguous();
>  1) ! 1890.179 us |                                  }
>  1) ! 1890.608 us |                                }
>  1)   0.048 us    | ttm_set_pages_caching [ttm]();
>  1) ! 7511.000 us |                              }
>  1) ! 7511.306 us |                            }
>  1) ! 7511.623 us |                          }
>
> The good case (with cma=0 kernel cmdline, so
> dma_alloc_from_contiguous() no-ops,)
>
> 0)               |                          ttm_dma_pool_get_pages
> [ttm]() {
>  0)               | ttm_dma_page_pool_fill_locked [ttm]() {
>  0)               | ttm_dma_pool_alloc_new_pages [ttm]() {
>  0)               | __ttm_dma_alloc_page [ttm]() {
>  0)               | dma_generic_alloc_coherent() {
>  0)   0.171 us    | dma_alloc_from_contiguous();
>  0)   0.849 us    | __alloc_pages_nodemask();
>  0)   3.029 us    |                                  }
>  0)   3.882 us    |                                }
>  0)               | __ttm_dma_alloc_page [ttm]() {
>  0)               | dma_generic_alloc_coherent() {
>  0)   0.037 us    | dma_alloc_from_contiguous();
>  0)   0.163 us    | __alloc_pages_nodemask();
>  0)   1.408 us    |                                  }
>  0)   1.719 us    |                                }
>  0)               | __ttm_dma_alloc_page [ttm]() {
>  0)               | dma_generic_alloc_coherent() {
>  0)   0.035 us    | dma_alloc_from_contiguous();
>  0)   0.153 us    | __alloc_pages_nodemask();
>  0)   1.454 us    |                                  }
>  0)   1.720 us    |                                }
>  0)               | __ttm_dma_alloc_page [ttm]() {
>  0)               | dma_generic_alloc_coherent() {
>  0)   0.036 us    | dma_alloc_from_contiguous();
>  0)   0.112 us    | __alloc_pages_nodemask();
>  0)   1.211 us    |                                  }
>  0)   1.541 us    |                                }
>  0)   0.035 us    | ttm_set_pages_caching [ttm]();
>  0) + 10.902 us   |                              }
>  0) + 11.577 us   |                            }
>  0) + 11.988 us   |                          }
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

