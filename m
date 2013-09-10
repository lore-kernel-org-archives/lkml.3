Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3IJHry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:47:54 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:46074 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3IJHrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:47:52 -0400
Date: Tue, 10 Sep 2013 09:47:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Robin Holt <robinmholt@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
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
Subject: [benchmark] THP performance testcase
Message-ID: <20130910074748.GA2971@gmail.com>
References: <1376663644-153546-2-git-send-email-athorlton@sgi.com>
 <520E672C.3080102@intel.com>
 <20130816181728.GQ26093@sgi.com>
 <20130816185212.GA3568@shutemov.name>
 <20130827165039.GC2886@sgi.com>
 <CAPp3RGqifK=tum94nGKcqSmDpzj3ceC_ZDo7KNLOz4KHjqv5mw@mail.gmail.com>
 <20130904154301.GA2975@sgi.com>
 <20130904171528.GB2975@sgi.com>
 <20130905111510.GC23362@gmail.com>
 <20130909164823.GD12435@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909164823.GD12435@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


( Changed the subject line to make it stand out better on lkml. Mail with 
  link & results quoted below. )

* Alex Thorlton <athorlton@sgi.com> wrote:

> [...] Here's a pointer to the test I wrote:
> 
> ftp://shell.sgi.com/collect/appsx_test/pthread_test.tar.gz
> 
> Everything to compile the test should be there (just run make in the 
> thp_pthread directory).  To run the test use something like:
> 
> time ./thp_pthread -C 0 -m 0 -c <max_cores> -b <memory>
> 
> I ran:
> 
> time ./thp_pthread -C 0 -m 0 -c 128 -b 128g
> 
> On a 256 core machine, with ~500gb of memory and got these results:
> 
> THP off:
> 
> real	0m57.797s
> user	46m22.156s
> sys	6m14.220s
> 
> THP on:
> 
> real	1m36.906s
> user	0m2.612s
> sys	143m13.764s
> 
> I snagged some code from another test we use, so I can't vouch for the
> usefulness/accuracy of all the output (actually, I know some of it is
> wrong).  I've mainly been looking at the total run time.
> 
> Don't want to bloat this e-mail up with too many test results, but I
> found this one really interesting.  Same machine, using all the cores,
> with the same amount of memory.  This means that each cpu is actually
> doing *less* work, since the chunk we reserve gets divided up evenly
> amongst the cpus:
> 
> time ./thp_pthread -C 0 -m 0 -c 256 -b 128g
> 
> THP off:
> 
> real	1m1.028s
> user	104m58.448s
> sys	8m52.908s
> 
> THP on:
> 
> real	2m26.072s
> user	60m39.404s
> sys	337m10.072s
> 
> Seems that the test scales really well in the THP off case, but, once
> again, with THP on, we really see the performance start to degrade.
> 
> I'm planning to start investigating possible ways to split up THPs, if
> we detect that that majority of the references to a THP are off-node.
> I've heard some horror stories about migrating pages in this situation
> (i.e., process switches cpu and then all the pages follow it), but I
> think we might be able to get some better results if we can cleverly
> determine an appropriate time to split up pages.  I've heard a bit of
> talk about doing something similar to this from a few people, but
> haven't seen any code/test results.  If anybody has any input on that
> topic, it would be greatly appreciated.

