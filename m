Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaA1SWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:22:50 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51163 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755299AbaA1SWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:22:48 -0500
Date: Tue, 28 Jan 2014 18:22:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
Message-ID: <20140128182230.GO15937@n2100.arm.linux.org.uk>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org> <1390590670-25901-4-git-send-email-yinghai@kernel.org> <CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com> <CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com> <CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com> <52E7E776.30909@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E7E776.30909@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:23:02PM -0500, Santosh Shilimkar wrote:
> On Tuesday 28 January 2014 12:12 PM, Yinghai Lu wrote:
> > Index: linux-2.6/include/linux/bootmem.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/bootmem.h
> > +++ linux-2.6/include/linux/bootmem.h
> > @@ -179,6 +179,9 @@ static inline void * __init memblock_vir
> >                                                     NUMA_NO_NODE);
> >  }
> > 
> > +/* Take arch's ARCH_LOW_ADDRESS_LIMIT at first*/
> > +#include <asm/processor.h>
> > +
> >  #ifndef ARCH_LOW_ADDRESS_LIMIT
> >  #define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
> >  #endif
> 
> This won't help mostly since the ARM 32 arch don't set ARCH_LOW_ADDRESS_LIMIT.
> Sorry i couldn't respond to the thread earlier because of travel and
> don't have access to my board to try out the patches.

Let's think about this for a moment, shall we...

What does memblock_alloc_virt*() return?  It returns a virtual address.

How is that virtual address obtained?  ptr = phys_to_virt(alloc);

What is the valid address range for passing into phys_to_virt() ?  Only
lowmem addresses.

Hence, having ARCH_LOW_ADDRESS_LIMIT set to 4GB-1 by default seems to be
completely rediculous - and presumably this also fails on x86_32 if it
returns memory up at 4GB.

So... yes, I think reverting the arch/arm part of this patch is the right
solution, whether the rest of it should be reverted is something I can't
comment on.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
