Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbaLBMXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:23:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556AbaLBMXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:23:54 -0500
Date: Tue, 2 Dec 2014 13:24:07 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/3] kernel: add support for live patching
In-Reply-To: <20141201170718.GA12633@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1412021140290.28820@pobox.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <1416935709-404-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411261451570.10866@pobox.suse.cz> <20141126154042.GB29079@treble.hsd1.ky.comcast.net> <alpine.LNX.2.00.1412011416110.23443@pobox.suse.cz>
 <20141201170718.GA12633@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014, Josh Poimboeuf wrote:

> On Mon, Dec 01, 2014 at 02:31:35PM +0100, Miroslav Benes wrote:
> > On Wed, 26 Nov 2014, Josh Poimboeuf wrote:
> > 
> > > Hi Miroslav,
> > > 
> > > Just addressing one of your comments below.  I'll let Seth respond to
> > > the others :-)
> > > 
> > > On Wed, Nov 26, 2014 at 03:19:17PM +0100, Miroslav Benes wrote:
> > > > > +/**
> > > > > + * struct klp_func - function structure for live patching
> > > > > + * @old_name:	name of the function to be patched
> > > > > + * @new_func:	pointer to the patched function code
> > > > > + * @old_addr:	a hint conveying at what address the old function
> > > > > + *		can be found (optional, vmlinux patches only)
> > > > > + */
> > > > > +struct klp_func {
> > > > > +	/* external */
> > > > > +	const char *old_name;
> > > > > +	void *new_func;
> > > > > +	/*
> > > > > +	 * The old_addr field is optional and can be used to resolve
> > > > > +	 * duplicate symbol names in the vmlinux object.  If this
> > > > > +	 * information is not present, the symbol is located by name
> > > > > +	 * with kallsyms. If the name is not unique and old_addr is
> > > > > +	 * not provided, the patch application fails as there is no
> > > > > +	 * way to resolve the ambiguity.
> > > > > +	 */
> > > > > +	unsigned long old_addr;
> > > > 
> > > > I wonder if we really need old_addr as an external field. I assume that 
> > > > userspace tool in kpatch use it as a "hint" for kernel part and thus 
> > > > kallsyms is not needed there (and it solves ambiguity problem as well). 
> > > > But I am not sure if it is gonna be the same in upstream. When kernel is 
> > > > randomized (CONFIG_RANDOMIZE_BASE is set to 'y', though default is 'n') 
> > > > old_addr is not usable (and we throw it away in the code). Without 
> > > > old_addr being set by the user we could spare some of code (calls to 
> > > > klp_verify_vmlinux_symbol and such). 
> > > 
> > > Even with CONFIG_RANDOMIZE_BASE, the function offsets will be the same
> > > regardless of the base address.  So we could still use old_addr to
> > > determine the offset.
> > > 
> > > > So the question is whether future userspace tool in upstream would need it 
> > > > and would use it. Please note that I do not mean it as a kpatch or kgraft 
> > > > way to do things, I'm just not sure about old_addr being "public" and want 
> > > > do discuss the options.
> > > > 
> > > > The ambiguity of symbols was discussed in some other thread in lkml in 
> > > > october (I guess) with no conclusion IIRC...
> > > 
> > > We need to resolve ambiguity somehow, and old_addr is a way to do that.
> > > Do you have any other ideas?
> > 
> > Unfortunately I don't.
> > 
> > But similarly we don't deal with ambiguity in modules either. And it is 
> > (at least theoretically) possible. Two static functions of the same name 
> > in two different .c files which the final module is linked from. You have 
> > to use kallsyms and it would get confused. Maybe this sounds odd but it 
> > could happen. 
> 
> True, this is a remote possibility, but we haven't run into this issue
> yet.  If it becomes a problem, we can try to come up with another way to
> resolve duplicates.
>
> Here's one idea: since the symbols are always listed in the same order
> in kallsyms (per-object), instead of old_addr we could have sym_idx.  A
> sym_idx of 2 could mean "I want the 2nd occurence of foo in the object's
> kallsyms list".

This sounds crazy and I hope we won't be forced to implement it after all 
:)
 
> However I'd rather keep our current old_addr scheme for now, since it's
> what we have implemented already.  And there are plenty of more
> important things we need to do first.

Agreed

> > Thus the old_addr value is not general protection (as modules are still 
> > affected) and it is questionable whether the user should use it.
> 
> It's not really protection, since even if you don't specify old_addr and
> you rely on kallsyms, klp_find_symbol will return an error if there are
> any duplicates.
> 
> It's really just a way to increase the size of the set of functions
> which can be patched (duplicately named functions).
> 
> We also rely on something similar for relocations: klp_reloc.src.  It's
> even more important there, since duplicately named static objects are
> more common than duplicately named functions.

I understand. So let's settle for leaving it as it is. 

Thanks
Mira

> > I do not have strong opinion on this and if no one else shares my 
> > thoughts, I am not against.
> > 
> > Mira
> 
> -- 
> Josh
> 

--
Miroslav Benes
SUSE Labs
