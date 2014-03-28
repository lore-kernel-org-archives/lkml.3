Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaC1TOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 15:14:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:37367 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaC1TN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 15:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,752,1389772800"; 
   d="scan'208";a="509197734"
Message-ID: <1396034036.10059.147.camel@empanada>
Subject: Re: [PATCH 5/5] tracing: Add 'hash' event trigger command
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Mar 2014 14:13:56 -0500
In-Reply-To: <87lhvunu00.fsf@tassilo.jf.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
	 <b81b0860d2915c0b562863fce889249dad080922.1395894625.git.tom.zanussi@linux.intel.com>
	 <87lhvunu00.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 09:54 -0700, Andi Kleen wrote:
> Tom Zanussi <tom.zanussi@linux.intel.com> writes:
> 
> > Hash triggers allow users to continually hash events which can then be
> > dumped later by simply reading the trigger file.  This is done
> > strictly via one-liners and without any kind of programming language.
> 
> I read through the whole thing. I think I got it somewhere near the end,
> but it was quite difficult. What really confuses me is your
> use of the "hash" term. I believe the established term for these
> kind of data operations is "histogram". How about calling it that.
> 

Yeah, there are a lot of equivalent terms for the same thing - Python
calls them dictionaries, Perl calls them hashes or associative arrays,
dtrace and systemtap call them aggregations - I just happened to use the
term that seemed the simplest and most direct to me.

> Overall it seems useful, but it's not fully clear to me why it needs
> to be done in the kernel and not an analysis tool?
> 

It doesn't necessarily need to be done in the kernel - you could instead
dump the entire trace stream to userspace and analyze it there.  That's
basically the idea behind the perl and python scripting interfaces in
perf, which makes a lot of sense if you have a relatively low event rate
and/or the operations you need to perform are non-trivial.

It seems to me though that if you have a relatively simple operation
like hashing an event, which you're going to be doing in your analysis
tool anyway, it makes more sense and may be cheaper to just do it in the
kernel instead of sending it to userspace.

Of course, tools like systemtap also do their associative
arrays/aggregations in the kernel - I guess you could think of this as
something like the equivalent of their aggregation 'runtime'.

And there's also a middle ground e.g. think of a long-running trace that
it wouldn't make sense to continuously stream to userspace, but that
would quickly fill up a hash table in the kernel if left untended - in
cases like that it would make sense to periodically dump an
'aggregation' of it to userspace. [1]

For the embedded systems I've been working on, it's just really so much
more convenient to be able to directly cat a file and get essentially
that same information without having to go through some unnecessary
language runtime and additional userspace tooling.

It just seems to me that you get so much mileage out of implementing
this single simple concept, built on top of the trigger and trace event
formats already in the kernel, that it's worthwhile to expose it as a
tool that stands on its own as well as something that could probably be
reused as a component of higher-level tools. 

Tom

[1] http://cygwin.com/ml/systemtap/2005-q3/msg00550.html


> -Andi
> 


