Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3IROeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:34:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab3IROeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:34:01 -0400
Date: Wed, 18 Sep 2013 11:33:46 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [RFC] Full syscall argument decode in "perf trace"
Message-ID: <20130918143346.GB3891@infradead.org>
References: <20130917190606.GB3918@infradead.org>
 <52398FF1.5020502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52398FF1.5020502@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 18, 2013 at 01:35:13PM +0200, Denys Vlasenko escreveu:
> On 09/17/2013 09:06 PM, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Sep 17, 2013 at 05:10:55PM +0200, Denys Vlasenko escreveu:
> >> I'm trying to figure out how to extend "perf trace".
> >  
> >> Currently, it shows syscall names and arguments, and only them.
> >> Meaning that syscalls such as open(2) are shown as:
> >  
> >>     open(filename: 140736118412184, flags: 0, mode: 140736118403776) = 3
> >  
> >> The problem is, of course, that user wants to see the filename
> >> per se, not the address of its first byte.
> >  
> >> To improve that, we need to fetch the pointed-to data.
> >> There are two approaches to this: extending
> >> "raw_syscalls:sys_{enter,exit}" tracepoint so that it returns this data,
> >> or selectively stopping the traced process when it reaches the thacepoint.
> > 
> > We don't want to stop the process at all, this is one of the major
> > advantages of 'perf trace' over 'strace'.
> 
> This is a worthy goal. strace is so slow exactly because it stops
> traced process so often. strace developers do want to avoid
> as many of these stops as possible.
> 
> I'm not sure that "not stopping ever" is achievable, though.
> There are cases where stopping is necessary.

Can't we try first to achieve what is possible with existing
infrastructure so that we can, out of the combo 'perf trace' and
'strace' have something that is better than plain 'strace'?

> For example, after clone() call, depending on the tracer needs,
> there may be operations which must be done on the new child
> before it is allowed to run.
> 
> strace used to use hideous, unsafe workarounds to catch children,
> until ptrace was augmented with features which made children stop
> immediately.
> 
> Do you think you can work around that? I just don't see how.

I haven't even thought about it 8-)
 
> > Look at the tmp.perf/trace2 branch in my git repo, tglx and Ingo added a
> > tracepoint to vfs_getname to use that.
> 
> I know that this is the way how to fetch syscall args without stopping,
> yes.
> 
> The problem: ~100 more tracepoints need to be added merely to get
> to the point where strace already is, wrt quality of syscall decoding.
> strace has nearly 300 separate custom syscall formatting functions,
> some of them quite complex.
> 
> If we need to add syscall stopping feature (which, as I said above,
> will be necessary anyway IMO), then syscall decoding can be as good
> as strace *already*. Then, gradually more tracepoints are added
> to make it faster.
> 
> I am thinking about going into this direction.
> 
> Therefore my question should be restated as:
> 
> Would perf developers accept the "syscall pausing" feature,
> or it won't be accepted?

Do you have some patch for us to try?

- Arnaldo
