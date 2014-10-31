Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaJaJ1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:27:20 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49733 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaJaJ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:27:18 -0400
Date: Fri, 31 Oct 2014 10:27:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vince@deater.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141031092713.GA23124@gmail.com>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
 <20141031072109.GD12706@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031072109.GD12706@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Oct 30, 2014 at 09:16:36PM -0400, Vince Weaver wrote:
> > On Thu, 30 Oct 2014, Peter Zijlstra wrote:
> > 
> > > So would something simple, like an offset into the struct 
> > > perf_event_attr pointing at the current field we're trying 
> > > to process make sense? Maybe with negative offsets to 
> > > indicate the syscall arguments?
> > > 
> > > That would narrow down the 'WTF is wrong noaw' a lot I 
> > > think. But then, I've not actually done a lot of userspace 
> > > the last few years, so maybe I'm just dreaming things.
> > 
> > well, as someone who spends a lot of time in userspace trying 
> > to help people who report probems like 'perf_event_open() 
> > returns EINVAL, what's wrong' I can say pretty much anything 
> > will be an improvement.
> 
> Right, the situation is dire indeed :/
> 
> > What would really help is if we could somehow return the 
> > filename/line-number of whatever source code file that's 
> > setting errno.
> > 
> > Even if perf_event_open() told me that hey, we're getting 
> > EOPNOTSUPP due to the precise_ip parameter (something that 
> > happened just yesterday) it's still a lot of grepping and 
> > poking around source files to find out what's going on.  It 
> > would be much better if it just told me the issue was at 
> > kernel/events/core.c line 995 or so, but I'm not sure how you 
> > could pass that back to the user, and one could argue it 
> > wouldn't help much the average user without a kernel tree 
> > lying around.
> 
> Would an additional bit mask help? With that we'd be able to 
> finger the exact flag that causes pain.

Well, I don't really like bitmasks nor __LINE__/__FILE__ 
obscurity, those are non-starters because they are user 
unfriendly.

What would work best is something like:

 - user-space could request 'extended error code' passing from
   kernel to user-space via a (default off) feature bit in 
   perf_attr, plus a user-space provided pointer to a string 
   buffer, and a maximum length value.

 - old user-space or user-space that does not want it would not
   be unaffected by the new 'extended error code' facility

 - user-space gets back the regular errno (-EOPNOTSUPP or -ENOSYS
   or -EINVAL, etc.) and a string. Strings are really the most 
   helpful information, because tools can just print that. They 
   can also match on specific strings and programmatically react 
   to them if they want to: we can promise to not arbitrarily 
   change error strings once they are introduced. (but even if 
   they change, user-space can still print them out.)

 - in the kernel, instead of doing:

	return -EOPNOTSUPP;

   we'd do something like:

	return perf_errno(-EOPNOTSUPP, "BTS not supported by this CPU architecture");

   here the kernel would in the regular case just ignore the 
   string, but if user-space requested the 'extended errno' 
   facility, it would copy the (zero-delimited) error string to
   perf_attr->errno_str, taking errno_len into account.

   If no extended string was written then user-space can detect 
   this through the string not having been written to. (it can 
   initialize it to a zero string.)

Note the various advantages of this approach:

 - it's hard to get the facility wrong on the user-space side: in 
   the simplest usage user-space simply prints out the error, 
   which will be obvious to the user in most cases.

 - it's hard to get it wrong on the kernel side: it's really 
   similar to what we do today, plus a descriptive error string. 
   Developers should take care to use descriptive and unique 
   messages (but even duplicate messages will help in informing 
   the user).

 - it's infinitely extensible, does not involve magic numbers nor
   ever changing __LINE__ numbers and obscure source code file
   names.

 - it's really _easy_ to add good error information on the kernel
   side: just add a perf_err() string passing method instead of a
   dumb return -EINVAL. Also, the information is in a single
   place, exactly where the problem occurs, so it will be easily
   maintainable going forward.

Thanks,

	Ingo
