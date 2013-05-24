Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3EXJVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:21:19 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37687
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab3EXJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:21:17 -0400
Date: Fri, 24 May 2013 11:21:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
Message-ID: <20130524092100.GI23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
 <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 07:40:12PM -0400, Vince Weaver wrote:
> On Thu, 23 May 2013, Peter Zijlstra wrote:
> 
> > On Thu, May 23, 2013 at 10:10:36AM -0400, Vince Weaver wrote:
> > > 
> > > I can confirm your patch avoids the oops on my machine.
> > > 
> > > It does lead to interesting behavior if I run the sample program
> > > multiple times (with added printfs):
> > > 
> > > vince@core2:~$ ./perf_mmap_close_bug 
> > > mmap1=0x7f06a6e90000
> > > mmap2=0x7f06a6e7f000
> > > vince@core2:~$ ./perf_mmap_close_bug 
> > > mmap1=0x7f878a138000
> > > mmap2=0x7f878a127000
> > > vince@core2:~$ ./perf_mmap_close_bug 
> > > mmap1=0xffffffffffffffff
> > > Error opening fd2 Invalid argument
> > > 
> > > and then it never successfully completes again.  Is this unexpected 
> > > behavior?  
> > 
> > Sounds weird to me, I'll see if I can reproduce/understand.
> 
> I tracked this down in case you haven't already.
> 
> The problem is that in the kernel patched 
> with your patch locked_vm is getting decremented twice in the sample code 
> and going negative.  I'm not sure why this isn't a problem until the 
> third time through.  Here are my crude debug printk 
> results from kernel/events/core.c

D'uh I think I see what's happening.. we haev split the mmap state
between the ringbuffer and event objects and since we have two events
and one ringbuffer we're hosed.

Let me try and straighten this out.
