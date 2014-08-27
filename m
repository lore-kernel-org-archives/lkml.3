Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbaH0VCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:02:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935499AbaH0VCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:02:15 -0400
Message-ID: <1409173278.9919.29.camel@deneb.redhat.com>
Subject: Re: [PATCHv7 3/5] common: dma-mapping: Introduce common remapping
 functions
From: Mark Salter <msalter@redhat.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: James Hogan <james.hogan@imgtec.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        David Riley <davidriley@chromium.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Date: Wed, 27 Aug 2014 17:01:18 -0400
In-Reply-To: <53FCBCC3.5040901@codeaurora.org>
References: <1407800431-21566-1-git-send-email-lauraa@codeaurora.org>
		<1407800431-21566-4-git-send-email-lauraa@codeaurora.org>
	 <CAAG0J99=wrz4+c49HeDvL0W9rDZKk2HNLdVtHv4ZJxU4-OjewA@mail.gmail.com>
	 <53FCBCC3.5040901@codeaurora.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-26 at 09:58 -0700, Laura Abbott wrote:
> On 8/26/2014 3:05 AM, James Hogan wrote:
> > On 12 August 2014 00:40, Laura Abbott <lauraa@codeaurora.org> wrote:
> >>
> >> For architectures without coherent DMA, memory for DMA may
> >> need to be remapped with coherent attributes. Factor out
> >> the the remapping code from arm and put it in a
> >> common location to reduce code duplication.
> >>
> >> As part of this, the arm APIs are now migrated away from
> >> ioremap_page_range to the common APIs which use map_vm_area for remapping.
> >> This should be an equivalent change and using map_vm_area is more
> >> correct as ioremap_page_range is intended to bring in io addresses
> >> into the cpu space and not regular kernel managed memory.
> >>
> >> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> >> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> > 
> > This commit in linux-next () breaks the build for metag:
> > 
> > drivers/base/dma-mapping.c: In function ‘dma_common_contiguous_remap’:
> > drivers/base/dma-mapping.c:294: error: implicit declaration of
> > function ‘dma_common_pages_remap’
> > drivers/base/dma-mapping.c:294: warning: assignment makes pointer from
> > integer without a cast
> > drivers/base/dma-mapping.c: At top level:
> > drivers/base/dma-mapping.c:308: error: conflicting types for
> > ‘dma_common_pages_remap’
> > drivers/base/dma-mapping.c:294: error: previous implicit declaration
> > of ‘dma_common_pages_remap’ was here
> > 
> > Looks like metag isn't alone either:
> > 
> > $ git grep -L dma-mapping-common arch/*/include/asm/dma-mapping.h
> > arch/arc/include/asm/dma-mapping.h
> > arch/avr32/include/asm/dma-mapping.h
> > arch/blackfin/include/asm/dma-mapping.h
> > arch/c6x/include/asm/dma-mapping.h
> > arch/cris/include/asm/dma-mapping.h
> > arch/frv/include/asm/dma-mapping.h
> > arch/m68k/include/asm/dma-mapping.h
> > arch/metag/include/asm/dma-mapping.h
> > arch/mn10300/include/asm/dma-mapping.h
> > arch/parisc/include/asm/dma-mapping.h
> > arch/xtensa/include/asm/dma-mapping.h
> > 
> > I've checked a couple of these arches (blackfin, xtensa) which don't
> > include dma-mapping-common.h and their builds seem to be broken too.
> > 
> > Cheers
> > James
> > 
> 
> Thanks for the report. Would you mind giving the following patch
> a test (this is theoretical only but I think it should work)

There's a further problem with c6x (no  MMU):

drivers/built-in.o: In function `dma_common_pages_remap':
(.text+0x220c4): undefined reference to `get_vm_area_caller'
drivers/built-in.o: In function `dma_common_pages_remap':
(.text+0x22108): undefined reference to `map_vm_area'
drivers/built-in.o: In function `dma_common_free_remap':
(.text+0x22278): undefined reference to `find_vm_area'



