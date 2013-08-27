Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3H0Qum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:50:42 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36343 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab3H0Quk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:50:40 -0400
Date: Tue, 27 Aug 2013 11:50:39 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <robinmholt@gmail.com>
Subject: Re: [PATCH 1/8] THP: Use real address for NUMA policy
Message-ID: <20130827165039.GC2886@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
 <1376663644-153546-2-git-send-email-athorlton@sgi.com>
 <520E672C.3080102@intel.com>
 <20130816181728.GQ26093@sgi.com>
 <20130816185212.GA3568@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816185212.GA3568@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's more up-to-date version: https://lkml.org/lkml/2012/8/20/337

These don't seem to give us a noticeable performance change either:

With THP:

real	22m34.279s
user	10797m35.984s
sys	39m18.188s

Without THP:

real	4m48.957s
user	2118m23.208s
sys	113m12.740s

Looks like we got a few minutes faster on the with THP case, but it's
still significantly slower, and that could just be a fluke result; we're
still floating at about a 5x performance degradation.

I talked with one of our performance/benchmarking experts last week and
he's done a bit more research into the actual problem here, so I've got
a bit more information:

The real performance hit, based on our testing, seems to be coming from
the increased latency that comes into play on large NUMA systems when a
process has to go off-node to read from/write to memory.

To give an extreme example, say we have a 16 node system with 8 cores
per node. If we have a job that shares a 2MB data structure between 128
threads, with THP on, the first thread to touch the structure will 
allocate all 2MB of space for that structure in a 2MB page, local to its
socket.  This means that all the memory accessses for the other 120
threads will be remote acceses.  With THP off, each thread could locally
allocate a number of 4K pages sufficient to hold the chunk of the
structure on which it needs to work, significantly reducing the number
of remote accesses that each thread will need to perform.

So, with that in mind, do we agree that a per-process tunable (or
something similar) to control THP seems like a reasonable method to
handle this issue?

Just want to confirm that everyone likes this approach before moving
forward with another revision of the patch.  I'm currently in favor of
moving this to a per-mm tunable, since that seems to make more sense
when it comes to threaded jobs. Also, a decent chunk of the code I've
already written can be reused with this approach, and prctl will still
be an appropriate place from which to control the behavior. Andrew
Morton suggested possibly controlling this through the ELF header, but
I'm going to lean towards the per-mm route unless anyone has a major
objection to it.

- Alex
