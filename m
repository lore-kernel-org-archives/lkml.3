Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3IJN3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab3IJN3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:29:08 -0400
Date: Tue, 10 Sep 2013 15:28:34 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, linux-arch@vger.kernel.org,
        arnd@arndb.de, mgahagan@redhat.com, agospoda@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2 4/4] kernel: add support for init_array constructors
Message-ID: <20130910132834.GF2259@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
 <1378305776-3644-5-git-send-email-fhrbata@redhat.com>
 <87vc2e66kr.fsf@rustcorp.com.au>
 <20130906175118.GB2332@localhost.localdomain>
 <20130906180751.GD25882@merlin.infradead.org>
 <87d2oi6bl0.fsf@rustcorp.com.au>
 <20130909162814.GA2288@localhost.localdomain>
 <878uz544si.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uz544si.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 03:05:57PM +0930, Rusty Russell wrote:
> Frantisek Hrbata <fhrbata@redhat.com> writes:
> > On Mon, Sep 09, 2013 at 10:44:03AM +0930, Rusty Russell wrote:
> >> Kyle McMartin <kyle@infradead.org> writes:
> >> > On Fri, Sep 06, 2013 at 07:51:18PM +0200, Frantisek Hrbata wrote:
> >> >> > > v2: - reuse mod->ctors for .init_array section for modules, because gcc uses
> >> >> > >       .ctors or .init_array, but not both at the same time
> >> >> > >
> >> >> > > Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> >> >> > 
> >> >> > Might be nice to document which gcc version changed this, so people can
> >> >> > choose whether to cherry-pick this change?
> >> >> 
> >> >> Thank you for pointing this out. As per gcc git this was introduced by commit
> >> >> ef1da80 and released in 4.7 version.
> >> >> 
> >> >> $ git describe --contains ef1da80
> >> >> gcc-4_7_0-release~4358
> >> >> 
> >> >> Do you want me to post v3 with this info included in the descrition?
> >> >> 
> >> >
> >> > It actually depends on the combination of binutils/ld and gcc you use, not
> >> > simply which gcc version you use. :/
> >> 
> >> Indeed, and seems it was binutils 20110507 which actually handled it
> >> properly.
> >> 
> >> AFAICT it's theoretically possible to have .ctors and .init_array in a
> >> module.  Unlikely, but the patch should check for both and refuse to
> >> load the module in that case.  Otherwise weird things would happen.
> >
> > I'm not sure if coexistence of .ctors and .init_array sections should result in
> > denial of module, but I for sure know nothing about this :). Could you maybe
> > privide one example of the "weird thing"?
> 
> Well, if we have both ctors and init_array, and we only call the ctors,
> part of the module will be uninitialized.
> 
> I was thinking about something like the following (based on your
> previous patch).
> 
> Thoughts?
> Rusty.

Thank you Rusty, from what I can say it looks ok to me. So I would go with this
version. Is there anything that needs to be done to consider this as the
correct version of the 4/4 patch? Meaning should we repost this as v3 or could
your version of the patch be picked as you posted it?

> 
> From: Frantisek Hrbata <fhrbata@redhat.com>
> Subject: kernel: add support for init_array constructors
> 
> This adds the .init_array section as yet another section with constructors. This
> is needed because gcc could add __gcov_init calls to .init_array or .ctors
> section, depending on gcc (and binutils) version .
> 
> v2: - reuse mod->ctors for .init_array section for modules, because gcc uses
>       .ctors or .init_array, but not both at the same time
> v3: - fail to load if that does happen somehow.
> 
> Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 83e2c31..bc2121f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -473,6 +473,7 @@
>  #define KERNEL_CTORS()	. = ALIGN(8);			   \
>  			VMLINUX_SYMBOL(__ctors_start) = .; \
>  			*(.ctors)			   \
> +			*(.init_array)			   \
>  			VMLINUX_SYMBOL(__ctors_end) = .;
>  #else
>  #define KERNEL_CTORS()
> diff --git a/kernel/module.c b/kernel/module.c
> index dc58274..d3f5a58 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2738,7 +2738,7 @@ static int check_modinfo(struct module *mod, struct load_info *info, int flags)
>  	return 0;
>  }
>  
> -static void find_module_sections(struct module *mod, struct load_info *info)
> +static int find_module_sections(struct module *mod, struct load_info *info)
>  {
>  	mod->kp = section_objs(info, "__param",
>  			       sizeof(*mod->kp), &mod->num_kp);
> @@ -2768,6 +2768,18 @@ static void find_module_sections(struct module *mod, struct load_info *info)
>  #ifdef CONFIG_CONSTRUCTORS
>  	mod->ctors = section_objs(info, ".ctors",
>  				  sizeof(*mod->ctors), &mod->num_ctors);
> +	if (!mod->ctors)
> +		mod->ctors = section_objs(info, ".init_array",
> +				sizeof(*mod->ctors), &mod->num_ctors);
> +	else if (find_sec(info, ".init_array")) {
> +		/*
> +		 * This shouldn't happen with same compiler and binutils
> +		 * building all parts of the module.
> +		 */
> +		printk(KERN_WARNING "%s: has both .ctors and .init_array.\n",
> +		       mod->name);
> +		return -EINVAL;
> +	}
>  #endif
>  
>  #ifdef CONFIG_TRACEPOINTS
> @@ -2806,6 +2818,8 @@ static void find_module_sections(struct module *mod, struct load_info *info)
>  
>  	info->debug = section_objs(info, "__verbose",
>  				   sizeof(*info->debug), &info->num_debug);
> +
> +	return 0;
>  }
>  
>  static int move_module(struct module *mod, struct load_info *info)
> @@ -3263,7 +3277,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  
>  	/* Now we've got everything in the final locations, we can
>  	 * find optional sections. */
> -	find_module_sections(mod, info);
> +	err = find_module_sections(mod, info);
> +	if (err)
> +		goto free_unload;
>  
>  	err = check_module_license_and_versions(mod);
>  	if (err)

-- 
Frantisek Hrbata
