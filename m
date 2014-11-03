Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaKCQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:25:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:40931 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbaKCQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:25:53 -0500
Date: Mon, 3 Nov 2014 14:25:48 -0200
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141103162548.GB18464@kernel.org>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
 <20141031072109.GD12706@worktop.programming.kicks-ass.net>
 <20141031092713.GA23124@gmail.com>
 <20141031122824.GZ12020@console-pimps.org>
 <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
 <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Nov 01, 2014 at 01:30:39AM -0400, Vince Weaver escreveu:
> On Fri, 31 Oct 2014, Stephane Eranian wrote:
> 
> > On Fri, Oct 31, 2014 at 1:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
> > >
> > > I guess we'd run into a problem if userspace doesn't want to just print
> > > the kernel string but instead wants to parse it in some fashion.
 
> If the string interface went in it would be a help when debugging 
> perf_event_open().

The way that peterz suggested, i.e. returning information about which
perf_event_attr and which of the parameters was invalid/had issues could
help with fallbacking/capability querying, i.e. tooling may want to use
some features if available automagically, fallbacking to something else
when that fails.

We already do that to some degree in various cases, but for some if the
only way that becomes available to disambiguate some EINVAL return is a
string, code will start having strcmps :-\
 
> Support would probably get added to PAPI, but PAPI has its own error 
> reporting issues and it's not always easy to pass a string the whole way 
> back to the user.

Having the last resort being an string instead of EINVAL is indeed much
better than what we have now.
 
> Also with PAPI many of the users reporting obscure perf_event_open() 
> problems are often running 2.6.32-vendor-patched kernels, so sadly it will 
> be years before any improved error handling filters down to many of the 
> users.
 
> This proposal also doesn't help with other weird failure modes in the 
> interface, the most annoying of which is the watchdog stealing a counter 
> so event groups perf_event_open() and start just fine but fail at read 
> time.
 
> > > That may or may not be a problem in practice, Vince can probably comment
> > > on that. I'm just thinking along the lines of making the perf syscall
> > > interface as useful as possible for tools other than tools/perf.

> > Maybe I missed something in the earlier thread, but I am trying to understand
> > why perf_event_open() would need such extended error retrieval system when
> > no other syscall does.
 
> well perf_event_open() is so complex, with it's 40+ different parameters.  
> Having a wrong value in any one of those (or one of the combinations of 
> those) can trigger EINVAL and it's not clear where the issue is.  
> I think other system calls tend to have slighly more straightforward 
> interfaces.

Yes, it is a PITA to figure out which codepath returned -EINVAL.

Its just a "No comprendo", we're left wondering what is it that is not
being understood or accepted...

- Arnaldo
