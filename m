Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3JZN6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:58:46 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36318 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3JZN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:58:45 -0400
Date: Sat, 26 Oct 2013 09:58:09 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131026135809.GA28375@neilslaptop.think-freely.org>
References: <20131017003421.GA31470@hmsreliant.think-freely.org>
 <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018165034.GC4019@hmsreliant.think-freely.org>
 <1382116835.3284.23.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018201133.GD4019@hmsreliant.think-freely.org>
 <1382130952.3284.43.camel@edumazet-glaptop.roam.corp.google.com>
 <20131021192116.GB4154@hmsreliant.think-freely.org>
 <1382384645.3284.86.camel@edumazet-glaptop.roam.corp.google.com>
 <20131021201958.GC4154@hmsreliant.think-freely.org>
 <20131026120108.GC24067@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026120108.GC24067@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 02:01:08PM +0200, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > On Mon, Oct 21, 2013 at 12:44:05PM -0700, Eric Dumazet wrote:
> > > On Mon, 2013-10-21 at 15:21 -0400, Neil Horman wrote:
> > > 
> > > > 
> > > > Ok, so I ran the above code on a single cpu using taskset, and set irq affinity
> > > > such that no interrupts (save for local ones), would occur on that cpu.  Note
> > > > that I had to convert csum_partial_opt to csum_partial, as the _opt variant
> > > > doesn't exist in my tree, nor do I see it in any upstream tree or in the history
> > > > anywhere.
> > > 
> > > This csum_partial_opt() was a private implementation of csum_partial()
> > > so that I could load the module without rebooting the kernel ;)
> > > 
> > > > 
> > > > base results:
> > > > 53569916
> > > > 43506025
> > > > 43476542
> > > > 44048436
> > > > 45048042
> > > > 48550429
> > > > 53925556
> > > > 53927374
> > > > 53489708
> > > > 53003915
> > > > 
> > > > AVG = 492 ns
> > > > 
> > > > prefetching only:
> > > > 53279213
> > > > 45518140
> > > > 49585388
> > > > 53176179
> > > > 44071822
> > > > 43588822
> > > > 44086546
> > > > 47507065
> > > > 53646812
> > > > 54469118
> > > > 
> > > > AVG = 488 ns
> > > > 
> > > > 
> > > > parallel alu's only:
> > > > 46226844
> > > > 44458101
> > > > 46803498
> > > > 45060002
> > > > 46187624
> > > > 37542946
> > > > 45632866
> > > > 46275249
> > > > 45031141
> > > > 46281204
> > > > 
> > > > AVG = 449 ns
> > > > 
> > > > 
> > > > both optimizations:
> > > > 45708837
> > > > 45631124
> > > > 45697135
> > > > 45647011
> > > > 45036679
> > > > 39418544
> > > > 44481577
> > > > 46820868
> > > > 44496471
> > > > 35523928
> > > > 
> > > > AVG = 438 ns
> > > > 
> > > > 
> > > > We continue to see a small savings in execution time with prefetching (4 ns, or
> > > > about 0.8%), a better savings with parallel alu execution (43 ns, or 8.7%), and
> > > > the best savings with both optimizations (54 ns, or 10.9%).  
> > > > 
> > > > These results, while they've changed as we've modified the test case slightly
> > > > have remained consistent in their sppedup ordinality.  Prefetching helps, but
> > > > not as much as using multiple alu's, and neither is as good as doing both
> > > > together.
> > > > 
> > > > Unless you see something else that I'm doing wrong here.  It seems like a win to
> > > > do both.
> > > > 
> > > 
> > > Well, I only said (or maybe I forgot), that on my machines, I got no
> > > improvements at all with the multiple alu or the prefetch. (I tried
> > > different strides)
> > > 
> > > Only noises in the results.
> > > 
> > I thought you previously said that running netperf gave you a stastically
> > significant performance boost when you added prefetching:
> > http://marc.info/?l=linux-kernel&m=138178914124863&w=2
> > 
> > But perhaps I missed a note somewhere.
> > 
> > > It seems it depends on cpus and/or multiple factors.
> > > 
> > > Last machine I used for the tests had :
> > > 
> > > processor	: 23
> > > vendor_id	: GenuineIntel
> > > cpu family	: 6
> > > model		: 44
> > > model name	: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz
> > > stepping	: 2
> > > microcode	: 0x13
> > > cpu MHz		: 2800.256
> > > cache size	: 12288 KB
> > > physical id	: 1
> > > siblings	: 12
> > > core id		: 10
> > > cpu cores	: 6
> > > 
> > > 
> > > 
> > > 
> > 
> > Thats about what I'm running with:
> > processor       : 0
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 44
> > model name      : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
> > stepping        : 2
> > microcode       : 0x13
> > cpu MHz         : 1600.000
> > cache size      : 12288 KB
> > physical id     : 0
> > siblings        : 8
> > core id         : 0
> > cpu cores       : 4
> > 
> > 
> > I can't imagine what would cause the discrepancy in our results (a 
> > 10% savings in execution time seems significant to me). My only 
> > thought would be that possibly the alu's on your cpu are faster 
> > than mine, and reduce the speedup obtained by preforming operation 
> > in parallel, though I can't imagine thats the case with these 
> > processors being so closely matched.
> 
> You keep ignoring my request to calculate and account for noise of 
> the measurement.
> 
Don't confuse "ignoring" with "haven't gotten there yet".  Sometimes we all have
to wait, Ingo.  I'm working on it now, but I hit a snag on the machine I'm
working with and am trying to figure it out now.

> For example you are talking about a 0.8% prefetch effect while the 
> noise in the results is obviously much larger than that, with a 
> min/max distance of around 5%:
> 
> > > > 43476542
> > > > 53927374
> 
> so the noise of 10 measurements would be around 5-10%. (back of the 
> envelope calculation)
> 
> So you might be right in the end, but the posted data does not 
> support your claims, statistically.
> 
> It's your responsibility to come up with convincing measurements and 
> results, not of those who review your work.
> 
Be patient, I'm getting there

Thanks
Neil

