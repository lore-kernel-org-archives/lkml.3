Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842Ab3IDPnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:43:08 -0400
Received: from relay2.sgi.com ([192.48.179.30]:45084 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964828Ab3IDPnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:43:05 -0400
Date: Wed, 4 Sep 2013 10:43:01 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Robin Holt <robinmholt@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
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
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/8] THP: Use real address for NUMA policy
Message-ID: <20130904154301.GA2975@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
 <1376663644-153546-2-git-send-email-athorlton@sgi.com>
 <520E672C.3080102@intel.com>
 <20130816181728.GQ26093@sgi.com>
 <20130816185212.GA3568@shutemov.name>
 <20130827165039.GC2886@sgi.com>
 <CAPp3RGqifK=tum94nGKcqSmDpzj3ceC_ZDo7KNLOz4KHjqv5mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPp3RGqifK=tum94nGKcqSmDpzj3ceC_ZDo7KNLOz4KHjqv5mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:01:01PM -0500, Robin Holt wrote:
> Alex,
> 
> Although the explanation seems plausible, have you verified this is
> actually possible?  You could make a simple pthread test case which
> allocates a getpagesize() * <number-of-threads> area, prints its
> address and then each thread migrate and reference their page.  Have
> the task then sleep(<long-time>) before exit.  Look at the physical
> address space with dlook for those virtual addresses in both the THP
> and non-THP cases.
> 
> Thanks,
> Robin

Robin,

I tweaked one of our other tests to behave pretty much exactly as I
described, and I can see a very significant increase in performance with
THP turned off.  The test behaves as follows:

- malloc a large array
- Spawn a specified number of threads
- Have each thread touch small, evenly spaced chunks of the array (e.g.
  for 128 threads, the array is divided into 128 chunks, and each thread
  touches 1/128th of each chunk, dividing the array into 16,384 pieces)

With THP off, the majority of each thread's pages are node local.  With
THP on, most of the pages end up as THPs on the first thread's nodes,
since it is touching chunks that are close enough together to be
collapsed into THPs which will, of course, remain on the first node for
the duration of the test.

Here are some timings for 128 threads, allocating a total of 64gb:

THP on:

real	1m6.394s
user	16m1.160s
sys	75m25.232s

THP off:

real	0m35.251s
user	26m37.316s
sys	3m28.472s

The performance hit here isn't as severe as shown with the SPEC workload
that we originally used, but it still appears to consistently take about
twice as long with THP enabled.
