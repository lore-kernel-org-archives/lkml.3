Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3JOHcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:32:54 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:41847 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3JOHcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:32:52 -0400
Date: Tue, 15 Oct 2013 09:32:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131015073248.GA25493@gmail.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <20131012172124.GA18241@gmail.com>
 <20131014202854.GH26880@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131014202854.GH26880@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> On Sat, Oct 12, 2013 at 07:21:24PM +0200, Ingo Molnar wrote:
> > 
> > * Neil Horman <nhorman@tuxdriver.com> wrote:
> > 
> > > Sébastien Dugué reported to me that devices implementing ipoib (which 
> > > don't have checksum offload hardware were spending a significant amount 
> > > of time computing checksums.  We found that by splitting the checksum 
> > > computation into two separate streams, each skipping successive elements 
> > > of the buffer being summed, we could parallelize the checksum operation 
> > > accros multiple alus.  Since neither chain is dependent on the result of 
> > > the other, we get a speedup in execution (on hardware that has multiple 
> > > alu's available, which is almost ubiquitous on x86), and only a 
> > > negligible decrease on hardware that has only a single alu (an extra 
> > > addition is introduced).  Since addition in commutative, the result is 
> > > the same, only faster
> > 
> > This patch should really come with measurement numbers: what performance 
> > increase (and drop) did you get on what CPUs.
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> 
> 
> So, early testing results today.  I wrote a test module that, allocated 
> a 4k buffer, initalized it with random data, and called csum_partial on 
> it 100000 times, recording the time at the start and end of that loop.  

It would be nice to stick that testcase into tools/perf/bench/, see how we 
are able to benchmark the kernel's mempcy and memset implementation there:

 $ perf bench mem memcpy -r help
 # Running 'mem/memcpy' benchmark:
 Unknown routine:help
 Available routines...
        default ... Default memcpy() provided by glibc
        x86-64-unrolled ... unrolled memcpy() in arch/x86/lib/memcpy_64.S
        x86-64-movsq ... movsq-based memcpy() in arch/x86/lib/memcpy_64.S
        x86-64-movsb ... movsb-based memcpy() in arch/x86/lib/memcpy_64.S

In a similar fashion we could build the csum_partial() code as well and do 
measurements. (We could change arch/x86/ code as well to make such 
embedding/including easier, as long as it does not change performance.)

Thanks,

	Ingo
