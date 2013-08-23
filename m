Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3HWQzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:55:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3HWQzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:55:50 -0400
Date: Fri, 23 Aug 2013 18:55:28 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: Re: [RFC PATCH 4/4] kernel: add support for init_array constructors
Message-ID: <20130823165528.GC2336@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com>
 <1377247176-13537-5-git-send-email-fhrbata@redhat.com>
 <52177C1B.60107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52177C1B.60107@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:13:31PM +0200, Peter Oberparleiter wrote:
> On 23.08.2013 10:39, Frantisek Hrbata wrote:
> > This adds the .init_array section as yet another section with constructors. This
> > is needed because gcc is adding __gcov_init calls to .init_array.
> > 
> > Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> > ---
> >  include/asm-generic/vmlinux.lds.h | 1 +
> >  include/linux/module.h            | 2 ++
> >  kernel/module.c                   | 6 ++++++
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index 69732d2..c55d8d9 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -468,6 +468,7 @@
> >  #define KERNEL_CTORS()	. = ALIGN(8);			   \
> >  			VMLINUX_SYMBOL(__ctors_start) = .; \
> >  			*(.ctors)			   \
> > +			*(.init_array)			   \
> 
> This is exactly how I (would) have done it.
> 
> >  			VMLINUX_SYMBOL(__ctors_end) = .;
> >  #else
> >  #define KERNEL_CTORS()
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 46f1ea0..89ff829 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -374,6 +374,8 @@ struct module
> >  	/* Constructor functions. */
> >  	ctor_fn_t *ctors;
> >  	unsigned int num_ctors;
> > +	ctor_fn_t *init_array;
> > +	unsigned int num_init_array;
> 
> I think it would be safe to re-use the ctors-related fields here. Each GCC
> version will only ever create either of .ctors or .init_array, but never
> both. 
> The only case where separate fields would be required, would be when
> linking a kernel module from multiple object files compiled with different
> versions of GCC.

Ah ok, I was not aware of this.

> 
> >  #endif
> >  };
> >  #ifndef MODULE_ARCH_INIT
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 2069158..581ae89 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2760,6 +2760,9 @@ static void find_module_sections(struct module *mod, struct load_info *info)
> >  #ifdef CONFIG_CONSTRUCTORS
> >  	mod->ctors = section_objs(info, ".ctors",
> >  				  sizeof(*mod->ctors), &mod->num_ctors);
> 
> When reusing mod->ctors, you could check for mod->ctors == NULL here and
> fill in the values from section_objs(".init_array").

Yes, in the case that we only have .ctors or .init_array section, this sounds
as the right approach.

> 
> > +	mod->init_array = section_objs(info, ".init_array",
> > +				  sizeof(*mod->init_array),
> > +				  &mod->num_init_array);
> >  #endif
> > 
> >  #ifdef CONFIG_TRACEPOINTS
> > @@ -3024,6 +3027,9 @@ static void do_mod_ctors(struct module *mod)
> > 
> >  	for (i = 0; i < mod->num_ctors; i++)
> >  		mod->ctors[i]();
> > +
> > +	for (i = 0; i < mod->num_init_array; i++)
> > +		mod->init_array[i]();
> >  #endif
> >  }
> > 
> 
> -- 
> Peter Oberparleiter
> Linux on System z Development - IBM Germany
> 

-- 
Frantisek Hrbata
