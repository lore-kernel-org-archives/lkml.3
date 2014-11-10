Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaKJNy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:54:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:53779 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaKJNyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:54:15 -0500
Date: Mon, 10 Nov 2014 10:54:09 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141110135409.GR18464@kernel.org>
References: <20141031092713.GA23124@gmail.com>
 <20141031122824.GZ12020@console-pimps.org>
 <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
 <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy>
 <20141103162548.GB18464@kernel.org>
 <20141103165019.GY10501@worktop.programming.kicks-ass.net>
 <20141103170059.GC18464@kernel.org>
 <20141110102725.GA19309@gmail.com>
 <20141110121527.GQ18464@kernel.org>
 <20141110122446.GA21503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110122446.GA21503@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 10, 2014 at 01:24:47PM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > Em Mon, Nov 10, 2014 at 11:27:25AM +0100, Ingo Molnar escreveu:
> > > * Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > > > Em Mon, Nov 03, 2014 at 05:50:19PM +0100, Peter Zijlstra escreveu:
> > > > > OK, so how about we do both, the offset+mask for the tools 
> > > > > and the string for the humans?

It looks like machines don't have problems with strings 8-)

> > > > Yeah, tooling tries to provide the best it can with the 
> > > > offset+mask, and if doesn't manage to do anything smart with 
> > > > it, just show the string and hope that helps the user to figure 
> > > > out what is happening.

> > > Almost: tooling should generally always consider the string as 
> > > well, for the (not so uncommon) case where there can be multiple 
> > > problems with the same field.

> > > Really, I think the string will give the most bang for the buck, 
> > > because it's really simple and straightforward on the kernel side 
> > > (so that we have a good chance of achieving full coverage 
> > > relatively quickly), and later on we could still complicate it 
> > > all with offset+mask if there's really a need.

> > > So lets start with an error string...

> > I don't have a problem with the order of introduction of new 
> > error reporting mechanisms, or at least I can't think of one 
> > right now.

> > So if we introduce strings now then tools/perf/ will trow them 
> > to the user when it still don't have fallbacks or any other UI 
> > indication of such an error.

> > I wonder tho if we have any previous experience on some other 
> > project (or even in the kernel?) and how userspace ended up 
> > using it, if just presenting those strings to the user or if 
> > trying to parse it, etc, anybody?

> I'm not aware of any such efforts in the Linux space - subsystems 
> with administrative interfaces generally just tend to printk() a 
> reason - that's obviously suboptimal in several ways.
 
> Programmatic use in user-spaec is very simple - go with my 
> initial example, tooling can either just display the error string 
> and bail out, or do:
 
>   if (unlikely(error)) {
> 	if (!strcmp(attr->error_str, "x86/bts: BTS not supported by this CPU architecture")) {
> 		fprintf(stderr, "x86/BTS: No hardware support falling back to branch sampling\n");
> 		activate_x86_bts_fallback_code();
> 		goto out;
> 	}
> 	if (!strcmp(attr->error_str, "x86/lbr: LBR not supported by this CPU architecture"))
> 		goto out_err;
>   }
 
> or it may do any number of other things, such as convert it to 
> its internal error code. Note that the error messages should have 
> some minimal structure (the 'x86/bts:' and 'x86/lbr' prefixes) to 
> organize things nicely and to make string clashes less likely.

Right, focus on the string format: Can we just have this two level
thing, first part separated by a slash, followed by colon, to identify
the origin of the message, and then a message, that can have further,
unspecified at this time, parser tokens as the need arises?
 
> as this is a slowpath the performance of strcmp() doesn't matter, 
> and in any case it's hardware accelerated or optimized well on 
> most platforms.

- Arnaldo
