Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaKJRbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:31:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbaKJRba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:31:30 -0500
Date: Mon, 10 Nov 2014 11:31:23 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141110173123.GB11119@treble.hsd1.ky.comcast.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411101101470.4454@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411101101470.4454@pobox.suse.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:08:00AM +0100, Jiri Kosina wrote:
> On Thu, 6 Nov 2014, Seth Jennings wrote:
> 
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > new file mode 100644
> > index 0000000..b32dbb5
> > --- /dev/null
> > +++ b/kernel/livepatch/core.c
> 
> [ ... snip ... ]
> 
> > +/****************************************
> > + * dynamic relocations (load-time linker)
> > + ****************************************/
> > +
> > +/*
> > + * external symbols are located outside the parent object (where the parent
> > + * object is either vmlinux or the kmod being patched).
> > + */
> > +static int lpc_find_external_symbol(struct module *pmod, const char *name,
> > +					unsigned long *addr)
> > +{
> > +	const struct kernel_symbol *sym;
> > +
> > +	/* first, check if it's an exported symbol */
> > +	preempt_disable();
> > +	sym = find_symbol(name, NULL, NULL, true, true);
> > +	preempt_enable();
> > +	if (sym) {
> > +		*addr = sym->value;
> > +		return 0;
> > +	}
> > +
> > +	/* otherwise check if it's in another .o within the patch module */
> > +	return lpc_find_symbol(pmod->name, name, addr);
> > +}
> > +
> > +static int lpc_write_object_relocations(struct module *pmod,
> > +					struct lpc_object *obj)
> > +{
> > +	int ret, size, readonly = 0, numpages;
> > +	struct lp_dynrela *dynrela;
> > +	u64 loc, val;
> > +	unsigned long core = (unsigned long)pmod->module_core;
> > +	unsigned long core_ro_size = pmod->core_ro_size;
> > +	unsigned long core_size = pmod->core_size;
> > +
> > +	for (dynrela = obj->dynrelas; dynrela->name; dynrela++) {
> > +		if (!strcmp(obj->name, "vmlinux")) {
> > +			ret = lpc_verify_vmlinux_symbol(dynrela->name,
> > +							dynrela->src);
> > +			if (ret)
> > +				return ret;
> > +		} else {
> > +			/* module, dynrela->src needs to be discovered */
> > +			if (dynrela->external)
> > +				ret = lpc_find_external_symbol(pmod,
> > +							       dynrela->name,
> > +							       &dynrela->src);
> > +			else
> > +				ret = lpc_find_symbol(obj->mod->name,
> > +						      dynrela->name,
> > +						      &dynrela->src);
> > +			if (ret)
> > +				return -EINVAL;
> > +		}
> > +
> > +		switch (dynrela->type) {
> > +		case R_X86_64_NONE:
> > +			continue;
> > +		case R_X86_64_PC32:
> > +			loc = dynrela->dest;
> > +			val = (u32)(dynrela->src + dynrela->addend -
> > +				    dynrela->dest);
> > +			size = 4;
> > +			break;
> > +		case R_X86_64_32S:
> > +			loc = dynrela->dest;
> > +			val = (s32)dynrela->src + dynrela->addend;
> > +			size = 4;
> > +			break;
> > +		case R_X86_64_64:
> > +			loc = dynrela->dest;
> > +			val = dynrela->src;
> > +			size = 8;
> > +			break;
> 
> This is x86-specific, so it definitely needs to go to arch/x86. The only 
> hard precondition for arch to support live patching is ftrace with regs 
> saving (we are currently in parallel working on extending the set of 
> architectures that support this), so we shouldn't introduce any x86-isms 
> into the generic code.
> 
> It seems to me that what basically needs to be done is to teach 
> apply_relocate_add() about this kind of relocations and apply them as 
> needed.

Agreed.

-- 
Josh
