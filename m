Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaKXNU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:20:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbaKXNUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:20:53 -0500
Date: Mon, 24 Nov 2014 14:21:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
In-Reply-To: <alpine.DEB.2.11.1411241209050.6439@nanos>
Message-ID: <alpine.LNX.2.00.1411241414280.23174@pobox.suse.cz>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.DEB.2.11.1411241209050.6439@nanos>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Thomas Gleixner wrote:

> > This commit introduces code for the live patching core.  It implements
> > an ftrace-based mechanism and kernel interface for doing live patching
> > of kernel and kernel module functions.
> > 
> > It represents the greatest common functionality set between kpatch and
> > kgraft and can accept patches built using either method.
> > 
> > This first version does not implement any consistency mechanism that
> > ensures that old and new code do not run together.  In practice, ~90% of
> > CVEs are safe to apply in this way, since they simply add a conditional
> > check.  However, any function change that can not execute safely with
> > the old version of the function can _not_ be safely applied in this
> > version.
> 
> To be honest this sounds frightening.
> 
> How is determined whether a change can be applied w/o a consistency
> mechanism or not?

By a human being producing the "live patch" code.

If the semantics of the patch requires consistency mechanism to be applied 
(such as "old and new function must not run in parallel, because locking 
rules would be violated", or "return value from a function that is being 
called in a loop is changing its meaning", etc.), then this first naive 
implementation simply can't be used.

For simple things though, such as "add a missing bounds check to sys_foo() 
prologue and return -EINVAL if out-of-bounds", this is sufficient.

It's being designed in a way that more advanced consistency models (such 
as the ones kgraft and kpatch are currently implementing) can be built on 
top of it.

The person writing the patch would always need to understand what he is 
doing to be able to pick correct consistency model to be used. I 
personally think this is a good thing -- this is nothing where we should 
be relying on any kinds of tools.

Thanks,

-- 
Jiri Kosina
SUSE Labs
