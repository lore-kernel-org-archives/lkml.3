Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaKCRLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:11:34 -0500
Received: from smtpauth13.mfg.siteprotect.com ([64.26.60.145]:57201 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752358AbaKCRLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:11:31 -0500
Date: Mon, 3 Nov 2014 12:12:18 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Arnaldo Carvalho de Melo <acme@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
In-Reply-To: <20141103170059.GC18464@kernel.org>
Message-ID: <alpine.DEB.2.10.1411031205070.16230@pianoman.cluster.toy>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net> <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy> <20141031072109.GD12706@worktop.programming.kicks-ass.net> <20141031092713.GA23124@gmail.com> <20141031122824.GZ12020@console-pimps.org>
 <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com> <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy> <20141103162548.GB18464@kernel.org> <20141103165019.GY10501@worktop.programming.kicks-ass.net>
 <20141103170059.GC18464@kernel.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.5457B742.01E4,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Arnaldo Carvalho de Melo wrote:

> Em Mon, Nov 03, 2014 at 05:50:19PM +0100, Peter Zijlstra escreveu:
> > On Mon, Nov 03, 2014 at 02:25:48PM -0200, Arnaldo Carvalho de Melo wrote:
>  
> > > The way that peterz suggested, i.e. returning information about which
> > > perf_event_attr and which of the parameters was invalid/had issues could
> > > help with fallbacking/capability querying, i.e. tooling may want to use
> > > some features if available automagically, fallbacking to something else
> > > when that fails.
>  
> > > We already do that to some degree in various cases, but for some if the
> > > only way that becomes available to disambiguate some EINVAL return is a
> > > string, code will start having strcmps :-\
> 
> > OK, so how about we do both, the offset+mask for the tools and the
> > string for the humans?
> 
> Yeah, tooling tries to provide the best it can with the offset+mask, and
> if doesn't manage to do anything smart with it, just show the string and
> hope that helps the user to figure out what is happening.

I don't know if having an offset/mask helps much.  Knowing your EINVAL
comes from ->config is nice to know, but if there's 30 different ways
to get an EINVAL from an improper config then you still can waste a lot
of time narrowing things down.

The string solution might be nice, but it is going to take major changes 
to the code and increase the size a bit.  For example:

$ cat arch/x86/kernel/cpu/perf* kernel/events/* | grep EINVAL | wc -l
100

And some of the code is passing the return values back through various
long callchains (and overloaded pointers via casts) where it's not clear 
how you could also pass a string value.

Vince
