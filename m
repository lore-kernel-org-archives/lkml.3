Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3KGO0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:26:02 -0500
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:43116 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753685Ab3KGOZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:25:58 -0500
Date: Thu, 7 Nov 2013 09:27:54 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
In-Reply-To: <20131107082122.GC32438@gmail.com>
Message-ID: <alpine.DEB.2.02.1311070918440.19262@pianoman.cluster.toy>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net> <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org> <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy> <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106144456.GI26785@twins.programming.kicks-ass.net> <20131106160720.GK26785@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1311061223290.28798@pianoman.cluster.toy> <20131106182437.GJ16117@laptop.programming.kicks-ass.net>
 <20131107082122.GC32438@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020209.527BA2F5.0036,ss=1,re=0.100,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013, Ingo Molnar wrote:

> I don't want a library that is external and under-tested: for example 
> quite a few of the PAPI breakages were found very late, after a new kernel 
> has been released - that's the big disadvantage of librarization and 
> decentralization. The decentralized library model might work if all you 
> want to create is a second-class also-ran GUI, but it just doesn't work 
> very well for actively developed kernel code.

I would argue that PAPI's problem was because it was trying to use 
perf_event_open() which is a complex, poorly documented kernel interface 
with a lot of code churn.  Usually it's the job of the kernel not to break 
user-space, not the other way around.

It's too late on the decentralized library issue.  PAPI has to support 
kernels going back to 2.6.32 so it's going to have its own copy of the 
mmap parsing code even if a new syscall gets introduced.

There are a lot of tools out there now that open-code a perf_event 
interface.  I don't think it's really possible to say "anyone using
the syscall without using our kernel library is unsupported".


This current issue with the locking doesn't really matter much because as 
far as I can tell it's an obscure potential corner case that no one has 
seen in practice yet.  So the easiest solution might just be to ignore the 
whole issue, which is a lot easier than trying to write a custom portable 
cross-platform license-agnostic memory barrier library.

We do try to keep the papi mmap reading code as close to perf's as 
possible though just because we know you aren't going to notice or care if 
you break it for other users.

Vince
