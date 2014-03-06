Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaCFV0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:26:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbaCFVZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:25:59 -0500
Message-ID: <1394141110.5094.37.camel@deneb.redhat.com>
Subject: Re: [PATCH 2/5] mm: create generic early_ioremap() support
From: Mark Salter <msalter@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, patches@linaro.org
Date: Thu, 06 Mar 2014 16:25:10 -0500
In-Reply-To: <20140305142953.669fd030495e802b2e03879c@linux-foundation.org>
References: <1393963738-9210-1-git-send-email-msalter@redhat.com>
	 <1393963738-9210-3-git-send-email-msalter@redhat.com>
	 <20140305142953.669fd030495e802b2e03879c@linux-foundation.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 14:29 -0800, Andrew Morton wrote:
> On Tue,  4 Mar 2014 15:08:55 -0500 Mark Salter <msalter@redhat.com> wrote:
> 
> > This patch creates a generic implementation of early_ioremap() support
> > based on the existing x86 implementation. early_ioremp() is useful for
> > early boot code which needs to temporarily map I/O or memory regions
> > before normal mapping functions such as ioremap() are available.
> > 
> > Some architectures have optional MMU. In the no-MMU case, the remap
> > functions simply return the passed in physical address and the unmap
> > functions do nothing.
> > 
> >
> > ....
> >
> > --- /dev/null
> > +++ b/mm/early_ioremap.c
> > @@ -0,0 +1,271 @@
> > +/*
> > + * Provide common bits of early_ioremap() support for architectures needing
> > + * temporary mappings during boot before ioremap() is available.
> > + *
> > + * This is mostly a direct copy of the x86 early_ioremap implementation.
> > + *
> > + * (C) Copyright 1995 1996, 2014 Linus Torvalds
> > + *
> > + */
> 
> I suppose one should include linux/kernel.h.

Okay.

> 
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/mm.h>
> > +#include <linux/vmalloc.h>
> > +#include <asm/fixmap.h>
> > +
> > +#ifdef CONFIG_MMU
> > +static int early_ioremap_debug __initdata;
> > +
> > +static int __init early_ioremap_debug_setup(char *str)
> > +{
> > +	early_ioremap_debug = 1;
> > +
> > +	return 0;
> > +}
> > +early_param("early_ioremap_debug", early_ioremap_debug_setup);
> 
> Should be documented somewhere.  Documentation/kernel-parameters.txt?

Okay.

> 
> > +static int after_paging_init __initdata;
> > +
> > +void __init __attribute__((weak)) early_ioremap_shutdown(void)
> 
> __weak
> 
> Do __init and __weak work together?  They should, but I don't recall
> seeing it.

Yes. Will use __weak here and clean up the uses of WARN/WARN_ON
as noted.

Thanks.


