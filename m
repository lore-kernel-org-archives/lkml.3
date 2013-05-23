Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab3EWXfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 19:35:46 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:63818 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759788Ab3EWXfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 19:35:44 -0400
Date: Thu, 23 May 2013 19:40:12 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <20130523152611.GE23650@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu> <20130523152611.GE23650@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013, Peter Zijlstra wrote:

> On Thu, May 23, 2013 at 10:10:36AM -0400, Vince Weaver wrote:
> > 
> > I can confirm your patch avoids the oops on my machine.
> > 
> > It does lead to interesting behavior if I run the sample program
> > multiple times (with added printfs):
> > 
> > vince@core2:~$ ./perf_mmap_close_bug 
> > mmap1=0x7f06a6e90000
> > mmap2=0x7f06a6e7f000
> > vince@core2:~$ ./perf_mmap_close_bug 
> > mmap1=0x7f878a138000
> > mmap2=0x7f878a127000
> > vince@core2:~$ ./perf_mmap_close_bug 
> > mmap1=0xffffffffffffffff
> > Error opening fd2 Invalid argument
> > 
> > and then it never successfully completes again.  Is this unexpected 
> > behavior?  
> 
> Sounds weird to me, I'll see if I can reproduce/understand.

I tracked this down in case you haven't already.

The problem is that in the kernel patched 
with your patch locked_vm is getting decremented twice in the sample code 
and going negative.  I'm not sure why this isn't a problem until the 
third time through.  Here are my crude debug printk 
results from kernel/events/core.c

[   28.684862] user_extra: 17 user_lock_limit: 129
[   28.698458] user_locked: 17 locked_vm: 0 user_extra 17
[   28.713853] locked: 0 locked_vm: 0 pinned_vm: 0 extra: 0 lock_limit: 16
[   28.733728] perf_mmap: locked_vm: 17
[   28.744509] mmap_close: locked_vm=0
[   28.754939] mmap_close: locked_vm=-17
[   29.472741] user_extra: 17 user_lock_limit: 129
[   29.486332] user_locked: 0 locked_vm: -17 user_extra 17
[   29.501996] locked: 0 locked_vm: 0 pinned_vm: 0 extra: 0 lock_limit: 16
[   29.521874] perf_mmap: locked_vm: 0
[   29.532400] mmap_close: locked_vm=-17
[   29.543352] mmap_close: locked_vm=-34
[   30.028236] user_extra: 17 user_lock_limit: 129
[   30.041835] user_locked: -17 locked_vm: -34 user_extra 17
[   30.058018] extra: -275 user_locked: -17 user_lock_limit: 258
[   30.075232] locked: -275 locked_vm: 0 pinned_vm: 0 extra: -275 lock_limit: 16

Vince
