Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaKJKil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:38:41 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54354 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaKJKij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:38:39 -0500
Date: Mon, 10 Nov 2014 11:38:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141110103834.GB19309@gmail.com>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
 <20141031072109.GD12706@worktop.programming.kicks-ass.net>
 <20141031092713.GA23124@gmail.com>
 <20141031122824.GZ12020@console-pimps.org>
 <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> Hi,
> 
> On Fri, Oct 31, 2014 at 1:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
> > On Fri, 31 Oct, at 10:27:13AM, Ingo Molnar wrote:
> >>
> >>  - user-space gets back the regular errno (-EOPNOTSUPP or -ENOSYS
> >>    or -EINVAL, etc.) and a string. Strings are really the most
> >>    helpful information, because tools can just print that. They
> >>    can also match on specific strings and programmatically react
> >>    to them if they want to: we can promise to not arbitrarily
> >>    change error strings once they are introduced. (but even if
> >>    they change, user-space can still print them out.)
> >
> > I guess we'd run into a problem if userspace doesn't want to just print
> > the kernel string but instead wants to parse it in some fashion.
> >
> > That may or may not be a problem in practice, Vince can probably comment
> > on that. I'm just thinking along the lines of making the perf syscall
> > interface as useful as possible for tools other than tools/perf.
>
> Maybe I missed something in the earlier thread, but I am trying 
> to understand why perf_event_open() would need such extended 
> error retrieval system when no other syscall does.

Frankly, Linux kind of sucks in the 'error codes and diagnostics' 
area, as we used the old Unix method of returning a single small 
integer and never got around further organizing errors properly, 
for a couple of good (and a handful of bad) reasons.

The good reasons: not having finegrained error codes is just fine 
if you organize your APIs and objects via other means: file 
system structure, split-up system calls, separate fds for 
separate objects, etc.

The perf ABI is complex mostly because it provides bleeding edge 
interfaces to bleeding edge hardware, while trying to be 
transparent to the probed processes: i.e. no 'everything is a 
file' and 'just use poll() to pass events' API simplifications 
are possible, mostly for performance reasons.

A comparable ABI, ptrace, is considered complex as well, while 
perf is much faster, exposes much more hardware capabilities and 
is more capable as well.

But even outside of perf, with 'other' system calls I have 
experienced dozens of incidents where some app failed with a 
-EINVAL in an ambiguous way and it would have been a blessing to 
get more extended error description from the kernel. There's a 
few meaningful error codes like -EIO or -ENOMEM, but there's tons 
of overlapping use of -EINVAL.

The VFS and VM error codes are pretty much self explanatory (and 
that's where we have most of Unix heritage), but for example the 
networking code and various drivers and also perf suffers from 
not giving finegrained enough error explanations.

> In any case, I would go with Ingo's proposal.

Ok, cool!

Thanks,

	Ingo
