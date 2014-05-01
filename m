Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaEAUhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:37:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaEAUhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:37:50 -0400
Date: Thu, 1 May 2014 22:37:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 03/16] kgr: initial code
In-Reply-To: <87tx99ckuh.fsf@tassilo.jf.intel.com>
Message-ID: <alpine.LNX.2.00.1405012233510.29834@pobox.suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-4-git-send-email-jslaby@suse.cz> <87tx99ckuh.fsf@tassilo.jf.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Andi Kleen wrote:

> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index 1e96c3628bf2..a03b1e9d2de3 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -615,6 +615,7 @@ GLOBAL(system_call_after_swapgs)
> >  	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
> >  	movq  %rcx,RIP-ARGOFFSET(%rsp)
> >  	CFI_REL_OFFSET rip,RIP-ARGOFFSET
> > +	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
> 
> Better use 4 bytes. This has the potential to cause an expensive
> Length Changing Prefixes Stall on Intel CPUs.

Patch 16/16 converts this to a single bit within TI_flags.

> > +static int kgr_init_ftrace_ops(const struct kgr_patch_fun *patch_fun)
> > +{
> > +	struct kgr_loc_caches *caches;
> > +	unsigned long fentry_loc;
> > +
> > +	/*
> > +	 * Initialize the ftrace_ops->private with pointers to the fentry
> > +	 * sites of both old and new functions. This is used as a
> > +	 * redirection target in the per-arch stubs.
> > +	 *
> > +	 * Beware! -- freeing (once unloading will be implemented)
> > +	 * will require synchronize_sched() etc.
> > +	 */
> > +
> > +	caches = kmalloc(sizeof(*caches), GFP_KERNEL);
> > +	if (!caches) {
> > +		kgr_debug("kgr: unable to allocate fentry caches\n");
> > +		return -ENOMEM;
> > +	}
> 
> All the error paths in this function leak memory.

Gah, good catch, thanks a lot.

-- 
Jiri Kosina
SUSE Labs
