Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaAJK0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:26:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaAJK0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:26:21 -0500
Date: Fri, 10 Jan 2014 10:26:17 +0000
From: Mel Gorman <mgorman@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, athorlton@sgi.com,
        Rik van Riel <riel@redhat.com>, chegu_vinod@hp.com,
        Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Idle power fix regresses ebizzy performance (was 3.12-stable
 backport of NUMA balancing patches)
Message-ID: <20140110102617.GX27046@suse.de>
References: <1389103248-17617-1-git-send-email-mgorman@suse.de>
 <20140107141715.GA32491@kroah.com>
 <20140107185440.GA7844@kroah.com>
 <20140107203012.GA27046@suse.de>
 <20140108104340.GC27046@suse.de>
 <20140108134858.GF27046@suse.de>
 <CAJvTdKmR90tsOWgo-2t9neNFTE15SOYtPN7zgjGKDvafWfk0TA@mail.gmail.com>
 <CAJvTdK=vJxYgtLOYZZPrwGNgYQrFVeCq18RwzEfh5n_tZyeP9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJvTdK=vJxYgtLOYZZPrwGNgYQrFVeCq18RwzEfh5n_tZyeP9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 01:04:55AM -0500, Len Brown wrote:
> Hi Mel,
> 
> I downloaded ebizzy and ran on an 80-thread WSM-EX.

Default parameters? If so, the default is 2xNR_CPUs. My initial tests only
ran up to NR_CPUs but I was seeing regressions throughout so I doubt it
levelled out for higher numbers of clients.

I used mmtests to run ebizzy based on the
configs/config-global-dhp__pagealloc-performance config file with the
following relevant lines changed just for the bisection itself

export MMTESTS="ebizzy"
export EBIZZY_MAX_THREADS=5
export EBIZZY_DURATION=20
export EBIZZY_ITERATIONS=3

Even though the test ran up to 5 threads, I only was using the result
for 4 threads for the bisection.

> But I got quite different number than you, so I'm wondering if there is
> something
> special I need to get the same results you see.  I generally see scores
> around 6900 - 7000.
> my reference kernel is built on top of
> b0031f227e47919797dc0e1c1990f3ef151ff0cc
> which is upstream on 12/17, which is when i wrote that patch -- if it
> matters.
> 
> But worse, I don't see any difference in ebizzy performance with/without
> the CLFLUSH patch.
> 
> Please let me know what I can do to reproduce the results you see.
> 

You could try running within mmtests and see what falls out? I don't think
I am doing anything weird in there but it wouldn't be the first time there
was a mistake in testing methodology that led to inconsistent results
between testers.

git clone https://github.com/gormanm/mmtests
cd mmtests
vi configs/config-global-dhp__pagealloc-performance
# edit file to set the lines above to match my bisection
./run-mmtests.sh --no-monitor --config configs/config-global-dhp__pagealloc-performance baseline
# boot new kernel
./run-mmtests.sh --no-monitor --config configs/config-global-dhp__pagealloc-performance patched
cd work/log
../../compare-kernels.sh

Of course, we could also be differing on kernel config in some relevant
way or it might be some other unfortunate timing issue.

> Also, can you try this attached incremental patch to see if it helps?

I'll fire it up after pushing send on this mail.

Thanks

-- 
Mel Gorman
SUSE Labs
