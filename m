Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbaLKLa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:30:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555AbaLKLa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:30:27 -0500
Date: Thu, 11 Dec 2014 12:30:24 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] livepatch v5: clean up usage of the old and new
 addresses
Message-ID: <20141211113023.GB16567@dhcp128.suse.cz>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
 <1418148307-21434-7-git-send-email-pmladek@suse.cz>
 <20141209192009.GB3955@treble.redhat.com>
 <20141210135054.GD2454@pathway.suse.cz>
 <20141210153309.GB32670@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210153309.GB32670@treble.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-12-10 09:33:09, Josh Poimboeuf wrote:
> On Wed, Dec 10, 2014 at 02:50:54PM +0100, Petr Mladek wrote:
> > On Tue 2014-12-09 13:20:09, Josh Poimboeuf wrote:
> > > On Tue, Dec 09, 2014 at 07:05:07PM +0100, Petr Mladek wrote:
> > > > The situation with variables storing the address of the old and new code
> > > > is not ideal. One is called "func" and the other is called "addr".
> > > > The one is pointer and the other is unsigned long. It makes sense
> > > > from the point of how the values are defined. But it might make problems
> > > > to understand the code when the values are used.
> > > >
> > > > This patch introduces two new variables "old_ip" and "new_ip".
> > > > They have the same type and the name is symmetric.
> > > 
> > > I agree that the naming of addr vs func is a little weird, but I find
> > > that this patch makes the code more confusing.  Now we have "func",
> > > "addr" and "ip", all different words meaning "function address".
> > >
> > > Adding to the confusion is the existence of four variables instead of
> > > two.
> > 
> > Yup, I am not super happy about it as well. This is why I made this
> > change in the last patch, so that it is easier to ignore or rework.
> > 
> > Another solution would be to rename either new_func -> new_addr or
> > old_addr -> old_func. In this case, they should have the same type.
> > 
> > "unsigned long" is used on most locations, so I would prefer this
> > type. And it better fits with the *_addr names.
> > 
> > The problem is that it would mean to cast the pointer to the new
> > function in hand-made patches. But we could hide this under some macro
> > that would be handy anyway.
> > 
> > Ot we could leave it as is for now. I do not have strong opinion
> > about it.
> 
> Ok, I'd rather leave it as it is for now.

Fine with me.

> > > > They are supposed to carry the address of the mcount call-site that
> > > > ftrace framework operates with. The value is the same as the function
> > > > address on x86 but it might be different on another architectures.
> > >
> > > I didn't know the mcount call site address can differ from the function
> > > address for some architectures.  Can you give more details about this?
> > 
> > Only fentry is put at the beginning of the functions. The classic
> > mcount call is put after the function prologue.
> > 
> > AFAIK, fentry is supported only on x86_64. There is another usable
> > feature on s390x that can be enabled by -mhotpatch gcc option but
> > we do not use it with kGraft. Vojtech/JiriK told me that the important
> > code is at the beginning of the function on PPC. But I am pretty
> > sure that there will be architectures where the code won't be at
> > the beginning.
> > 
> > The current implementation supports only x86_64. s390 and PPC seems
> > to be solvable without the shifted address. I am not sure if we
> > want to make it ready for other architectures or keep is simple for
> > now.
> 
> Yeah, I'd say let's keep the code simple for now until we need the added
> complexity.

OK, I am fine with it.

> [...]
> > > > +	func->new_ip = ftrace_location((unsigned long)func->new_func);
> > > > +	if (!func->old_ip) {
> > > > +		pr_err("function at the address '%p' can not be used for patching\n",
> > > > +		       func->new_func);
> > > > +		return -EINVAL;
> > > > +	}
> > > 
> > > Why does the new function need to have an mcount call site?  And why do
> > > we want to use that address rather than the real function address?
>
> I think you missed this question, but it doesn't matter since we can
> skip this patch for now anyway.

Yeah, good question. To be honest, I did not work on kGraft when this
part was discussed. My intuitive understanding is that if
klp_ftrace_handler() is called after the function prologue,
we would need to skip the prologue from the new function as well.

So, if we start supporting some architecture where the patched code
won't be on the beginning, we would need to somehow handle the
already proceed code.

Best Regards,
Petr
