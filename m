Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaKYREd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:04:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaKYREb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:04:31 -0500
Date: Tue, 25 Nov 2014 18:04:31 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Seth Jennings <sjenning@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
Message-ID: <20141125170431.GE22487@pathway.suse.cz>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com>
 <546EA5DC.6000207@hitachi.com>
 <20141125163942.GD22487@pathway.suse.cz>
 <20141125115210.4d7cfca3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125115210.4d7cfca3@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-25 11:52:10, Steven Rostedt wrote:
> On Tue, 25 Nov 2014 17:39:43 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > On Fri 2014-11-21 11:39:24, Masami Hiramatsu wrote:
> > > (2014/11/21 7:29), Seth Jennings wrote:
> > > > This commit introduces code for the live patching core.  It implements
> > > > an ftrace-based mechanism and kernel interface for doing live patching
> > > > of kernel and kernel module functions.
> > > > 
> > > > It represents the greatest common functionality set between kpatch and
> > > > kgraft and can accept patches built using either method.
> > > > 
> > > > This first version does not implement any consistency mechanism that
> > > > ensures that old and new code do not run together.  In practice, ~90% of
> > > > CVEs are safe to apply in this way, since they simply add a conditional
> > > > check.  However, any function change that can not execute safely with
> > > > the old version of the function can _not_ be safely applied in this
> > > > version.
> > > 
> > > Thanks for updating :)
> > > 
> > > BTW, this still have some LPC_XXX macros, those should be KLP_XXX.
> > > 
> > > Also, as I sent a series of IPMODIFY patches (just now), could you consider
> > > to use the flag? :)
> > 
> > Hmm, it would cause problems with the current LivePatch, kGraft
> > implementation, and probably also with kPatch. They register more
> > than one ftrace handler with IPMODIFY at the same time.
> 
> But are they hooked to the same functions? That would be a big problem,
> and should be avoided. Why would you want too ftrace_ops returning two
> different IPs for one function? That causes a paradox. Why would you
> want that?

We does not mind which one wins. The two functions are registered only
temporarily. It is guaranteed that they both sets the same regs->ip
address during this time frame.


> > They pass pointer to the func-related structure via the "private" field
> > in struct ftrace_ops. The structure provides information where the old
> > and new code is.
> > 
> > They need to update the structure when new patch for the same functions
> > appears. It is done by registering a new ftrace function related to the
> > new patch and unregistering an old ftrace function from the old patch.
> > 
> > We would need to maintain some patch-independent list of ftrace_ops
> > and the related private fields to avoid the double registration.
> 
> Yes, that would make sense.
> 
> You could create one ftrace_ops per function. That would be ideal
> because then you get to take advantage of having your own trampoline
> per function and no need to worry about what function needs to go with
> another function.

I adds some complexity but I think that we will need to go this way.
The check for IPMODIFY conflicts makes sense. It helps to avoid any
misuse.

My main intention was to point out the problem and that we would need
to handle it somehow  J

Best Regards,
Petr
