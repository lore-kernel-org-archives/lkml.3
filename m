Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab3IFRvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab3IFRvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:51:31 -0400
Date: Fri, 6 Sep 2013 19:51:18 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, linux-arch@vger.kernel.org,
        arnd@arndb.de, mgahagan@redhat.com, agospoda@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2 4/4] kernel: add support for init_array constructors
Message-ID: <20130906175118.GB2332@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
 <1378305776-3644-5-git-send-email-fhrbata@redhat.com>
 <87vc2e66kr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc2e66kr.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 11:43:08AM +0930, Rusty Russell wrote:
> Frantisek Hrbata <fhrbata@redhat.com> writes:
> > This adds the .init_array section as yet another section with constructors. This
> > is needed because gcc could add __gcov_init calls to .init_array or .ctors
> > section, depending on gcc version.
> >
> > v2: - reuse mod->ctors for .init_array section for modules, because gcc uses
> >       .ctors or .init_array, but not both at the same time
> >
> > Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> 
> Might be nice to document which gcc version changed this, so people can
> choose whether to cherry-pick this change?

Thank you for pointing this out. As per gcc git this was introduced by commit
ef1da80 and released in 4.7 version.

$ git describe --contains ef1da80
gcc-4_7_0-release~4358

Do you want me to post v3 with this info included in the descrition?

> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Many thanks

> 
> > ---
> >  include/asm-generic/vmlinux.lds.h | 1 +
> >  kernel/module.c                   | 3 +++
> >  2 files changed, 4 insertions(+)
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
> >  			VMLINUX_SYMBOL(__ctors_end) = .;
> >  #else
> >  #define KERNEL_CTORS()
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 2069158..bbbd953 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2760,6 +2760,9 @@ static void find_module_sections(struct module *mod, struct load_info *info)
> >  #ifdef CONFIG_CONSTRUCTORS
> >  	mod->ctors = section_objs(info, ".ctors",
> >  				  sizeof(*mod->ctors), &mod->num_ctors);
> > +	if (!mod->ctors)
> > +		mod->ctors = section_objs(info, ".init_array",
> > +				sizeof(*mod->ctors), &mod->num_ctors);
> >  #endif
> >  
> >  #ifdef CONFIG_TRACEPOINTS
> > -- 
> > 1.8.3.1

-- 
Frantisek Hrbata
