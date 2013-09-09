Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3IIQ2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab3IIQ2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:28:48 -0400
Date: Mon, 9 Sep 2013 18:28:14 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, linux-arch@vger.kernel.org,
        arnd@arndb.de, mgahagan@redhat.com, agospoda@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2 4/4] kernel: add support for init_array constructors
Message-ID: <20130909162814.GA2288@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
 <1378305776-3644-5-git-send-email-fhrbata@redhat.com>
 <87vc2e66kr.fsf@rustcorp.com.au>
 <20130906175118.GB2332@localhost.localdomain>
 <20130906180751.GD25882@merlin.infradead.org>
 <87d2oi6bl0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2oi6bl0.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:44:03AM +0930, Rusty Russell wrote:
> Kyle McMartin <kyle@infradead.org> writes:
> > On Fri, Sep 06, 2013 at 07:51:18PM +0200, Frantisek Hrbata wrote:
> >> > > v2: - reuse mod->ctors for .init_array section for modules, because gcc uses
> >> > >       .ctors or .init_array, but not both at the same time
> >> > >
> >> > > Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> >> > 
> >> > Might be nice to document which gcc version changed this, so people can
> >> > choose whether to cherry-pick this change?
> >> 
> >> Thank you for pointing this out. As per gcc git this was introduced by commit
> >> ef1da80 and released in 4.7 version.
> >> 
> >> $ git describe --contains ef1da80
> >> gcc-4_7_0-release~4358
> >> 
> >> Do you want me to post v3 with this info included in the descrition?
> >> 
> >
> > It actually depends on the combination of binutils/ld and gcc you use, not
> > simply which gcc version you use. :/
> 
> Indeed, and seems it was binutils 20110507 which actually handled it
> properly.
> 
> AFAICT it's theoretically possible to have .ctors and .init_array in a
> module.  Unlikely, but the patch should check for both and refuse to
> load the module in that case.  Otherwise weird things would happen.

I'm not sure if coexistence of .ctors and .init_array sections should result in
denial of module, but I for sure know nothing about this :). Could you maybe
privide one example of the "weird thing"?

Anyway many thanks for taking time to look at this. Below is my attepmt to
implement the check you proposed. 

untested/uncompiled

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 83e2c31..bc2121f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -473,6 +473,7 @@
 #define KERNEL_CTORS()	. = ALIGN(8);			   \
 			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
+			*(.init_array)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
 #define KERNEL_CTORS()
diff --git a/include/linux/module.h b/include/linux/module.h
index 05f2447..e775b41 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -380,6 +380,8 @@ struct module
 	/* Constructor functions. */
 	ctor_fn_t *ctors;
 	unsigned int num_ctors;
+	ctor_fn_t *init_array;
+	unsigned int num_init_array;
 #endif
 };
 #ifndef MODULE_ARCH_INIT
diff --git a/kernel/module.c b/kernel/module.c
index dc58274..831b92d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2768,6 +2768,9 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 #ifdef CONFIG_CONSTRUCTORS
 	mod->ctors = section_objs(info, ".ctors",
 				  sizeof(*mod->ctors), &mod->num_ctors);
+	mod->init_array = section_objs(info, ".init_array",
+				  sizeof(*mod->init_array),
+				  &mod->num_init_array);
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
@@ -2808,6 +2811,18 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 				   sizeof(*info->debug), &info->num_debug);
 }
 
+static void check_module_sections(struct module *mod)
+{
+#ifdef CONFIG_CONSTRUCTORS
+	if (mod->ctors && mod->init_array) {
+		pr_err("%s: .ctors and .init_array sections mishmash\n",
+				mod->name);
+		return -EINVAL;
+	}
+#endif
+	return 0;
+}
+
 static int move_module(struct module *mod, struct load_info *info)
 {
 	int i;
@@ -3032,6 +3047,9 @@ static void do_mod_ctors(struct module *mod)
 
 	for (i = 0; i < mod->num_ctors; i++)
 		mod->ctors[i]();
+
+	for (i = 0; i < mod->num_init_array; i++)
+		mod->init_array[i]();
 #endif
 }
 
@@ -3265,6 +3283,10 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	 * find optional sections. */
 	find_module_sections(mod, info);
 
+	err = check_module_sections(mod);
+	if (err)
+		goto free_unload;
+
 	err = check_module_license_and_versions(mod);
 	if (err)
 		goto free_unload;
-- 
1.8.3.1

> 
> Cheers,
> Rusty.

-- 
Frantisek Hrbata
