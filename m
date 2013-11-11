Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3KKTkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:40:47 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41956 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab3KKTkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:40:39 -0500
Date: Mon, 11 Nov 2013 14:40:20 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
Message-ID: <20131111194020.GB6355@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
 <20131106153429.GA26336@redhat.com>
 <20131106155445.GB6357@neilslaptop.think-freely.org>
 <1383758363.7940.19.camel@joe-AO722>
 <20131108190136.GB16052@hmsreliant.think-freely.org>
 <1383939193.2639.39.camel@joe-AO722>
 <20131108201459.GE16052@hmsreliant.think-freely.org>
 <1383942547.2639.49.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383942547.2639.49.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:29:07PM -0800, Joe Perches wrote:
> On Fri, 2013-11-08 at 15:14 -0500, Neil Horman wrote:
> > On Fri, Nov 08, 2013 at 11:33:13AM -0800, Joe Perches wrote:
> > > On Fri, 2013-11-08 at 14:01 -0500, Neil Horman wrote:
> > > > On Wed, Nov 06, 2013 at 09:19:23AM -0800, Joe Perches wrote:
> > > > > On Wed, 2013-11-06 at 10:54 -0500, Neil Horman wrote:
> > > > > > On Wed, Nov 06, 2013 at 10:34:29AM -0500, Dave Jones wrote:
> > > > > > > On Wed, Nov 06, 2013 at 10:23:19AM -0500, Neil Horman wrote:
> > > > > > >  > do_csum was identified via perf recently as a hot spot when doing
> > > > > > >  > receive on ip over infiniband workloads.  After alot of testing and
> > > > > > >  > ideas, we found the best optimization available to us currently is to
> > > > > > >  > prefetch the entire data buffer prior to doing the checksum
> > > > > []
> > > > > > I'll fix this up and send a v3, but I'll give it a day in case there are more
> > > > > > comments first.
> > > > > 
> > > > > Perhaps a reduction in prefetch loop count helps.
> > > > > 
> > > > > Was capping the amount prefetched and letting the
> > > > > hardware prefetch also tested?
> > > > > 
> > > > > 	prefetch_lines(buff, min(len, cache_line_size() * 8u));
> > > > > 
> > > > 
> > > > Just tested this out:
> > > 
> > > Thanks.
> > > 
> > > Reformatting the table so it's a bit more
> > > readable/comparable for me:
> > > 
> > > len	SetSz	Loops	cycles/byte
> > > 			limited	unlimited
> > > 1500B	64MB	1M	1.3442	1.3605
> > > 1500B	128MB	1M	1.3410	1.3542
> > > 1500B	256MB	1M	1.3536	1.3710
> > > 1500B	512MB	1M	1.3463	1.3536
> > > 9000B	64MB	1M	0.8522	0.8504
> > > 9000B	128MB	1M	0.8528	0.8536
> > > 9000B	256MB	1M	0.8532	0.8520
> > > 9000B	512MB	1M	0.8527	0.8525
> > > 64KB	64MB	1M	0.7686	0.7683
> > > 64KB	128MB	1M	0.7695	0.7686
> > > 64KB	256MB	1M	0.7699	0.7708
> > > 64KB	512MB	1M	0.7799	0.7694
> > > 
> > > This data appears to show some value
> > > in capping for 1500b lengths and noise
> > > for shorter and longer lengths.
> > > 
> > > Any idea what the actual distribution of
> > > do_csum lengths is under various loads?
> > > 
> > I don't have any hard data no, sorry.
> 
> I think you should before you implement this.
> You might find extremely short lengths.
> 
> > I'll cap the prefetch at 1500B for now, since it
> > doesn't seem to hurt or help beyond that
> 
> The table data has a max prefetch of
> 8 * boot_cpu_data.x86_cache_alignment so
> I believe it's always less than 1500 but
> perhaps 4 might be slightly better still.
> 


So, you appear to be correct, I reran my test set with different prefetch
ceilings and got the results below.  There are some cases in which there is a
performance gain, but the gain is small, and occurs at different spots depending
on the input buffer size (though most peak gains appear around 2 cache lines).
I'm guessing it takes about 2 prefetches before hardware prefetching catches up,
at which point we're just spending time issuing instructions that get discarded.
Given the small prefetch limit, and the limited gains (which may also change on
different hardware), I think we should probably just drop the prefetch idea
entirely, and perhaps just take the perf patch so that we can revisit this area
when hardware that supports the avx extensions and/or adcx/adox becomes
available.

Ingo, does that seem reasonable to you?
Neil



1 cache line:
len	| set	| iterations	| cycles/byte
========|=======|===============|=============
1500B   | 64MB  | 1000000       | 1.434190
1500B   | 128MB | 1000000       | 1.431216
1500B   | 256MB | 1000000       | 1.430888
1500B   | 512MB | 1000000       | 1.453422
9000B   | 64MB  | 1000000       | 0.892055
9000B   | 128MB | 1000000       | 0.884050
9000B   | 256MB | 1000000       | 0.880551
9000B   | 512MB | 1000000       | 0.883848
64KB    | 64MB  | 1000000       | 0.813187
64KB    | 128MB | 1000000       | 0.801326
64KB    | 256MB | 1000000       | 0.795643
64KB    | 512MB | 1000000       | 0.793400


2 cache lines:
len	| set	| iterations	| cycles/byte
========|=======|===============|=============
1500B   | 64MB  | 1000000       | 1.430030
1500B   | 128MB | 1000000       | 1.434589
1500B   | 256MB | 1000000       | 1.425430
1500B   | 512MB | 1000000       | 1.451570
9000B   | 64MB  | 1000000       | 0.892369
9000B   | 128MB | 1000000       | 0.885577
9000B   | 256MB | 1000000       | 0.882091
9000B   | 512MB | 1000000       | 0.885201
64KB    | 64MB  | 1000000       | 0.813629
64KB    | 128MB | 1000000       | 0.801377
64KB    | 256MB | 1000000       | 0.795861
64KB    | 512MB | 1000000       | 0.793242

3 cache lines:
len	| set	| iterations	| cycles/byte
========|=======|===============|=============
1500B   | 64MB  | 1000000       | 1.435048
1500B   | 128MB | 1000000       | 1.427103
1500B   | 256MB | 1000000       | 1.431558
1500B   | 512MB | 1000000       | 1.452250
9000B   | 64MB  | 1000000       | 0.893162
9000B   | 128MB | 1000000       | 0.884488
9000B   | 256MB | 1000000       | 0.881314
9000B   | 512MB | 1000000       | 0.884060
64KB    | 64MB  | 1000000       | 0.813185
64KB    | 128MB | 1000000       | 0.801280
64KB    | 256MB | 1000000       | 0.795554
64KB    | 512MB | 1000000       | 0.793670

4 cache lines:
len	| set	| iterations	| cycles/byte
========|=======|===============|=============
1500B   | 64MB  | 1000000       | 1.435013
1500B   | 128MB | 1000000       | 1.428434
1500B   | 256MB | 1000000       | 1.430780
1500B   | 512MB | 1000000       | 1.456285
9000B   | 64MB  | 1000000       | 0.894877
9000B   | 128MB | 1000000       | 0.885387
9000B   | 256MB | 1000000       | 0.883293
9000B   | 512MB | 1000000       | 0.886462
64KB    | 64MB  | 1000000       | 0.815036
64KB    | 128MB | 1000000       | 0.801962
64KB    | 256MB | 1000000       | 0.797618
64KB    | 512MB | 1000000       | 0.795138

6 cache lines:
len	| set	| iterations	| cycles/byte
========|=======|===============|=============
1500B   | 64MB  | 1000000       | 1.439609
1500B   | 128MB | 1000000       | 1.437569
1500B   | 256MB | 1000000       | 1.441776
1500B   | 512MB | 1000000       | 1.455362
9000B   | 64MB  | 1000000       | 0.895242
9000B   | 128MB | 1000000       | 0.886149
9000B   | 256MB | 1000000       | 0.881375
9000B   | 512MB | 1000000       | 0.884610
64KB    | 64MB  | 1000000       | 0.814658
64KB    | 128MB | 1000000       | 0.804124
64KB    | 256MB | 1000000       | 0.798143
64KB    | 512MB | 1000000       | 0.795377

10 cache lines:
len	| set	| iterations	| cycles/byte
========|=======|===============|=============
1500B   | 64MB  | 1000000       | 1.431512
1500B   | 128MB | 1000000       | 1.431805
1500B   | 256MB | 1000000       | 1.430388
1500B   | 512MB | 1000000       | 1.464370
9000B   | 64MB  | 1000000       | 0.893922
9000B   | 128MB | 1000000       | 0.887852
9000B   | 256MB | 1000000       | 0.882711
9000B   | 512MB | 1000000       | 0.890067
64KB    | 64MB  | 1000000       | 0.814890
64KB    | 128MB | 1000000       | 0.801470
64KB    | 256MB | 1000000       | 0.796658
64KB    | 512MB | 1000000       | 0.794266

20 cache lines:
len	| set	| iterations	| cycles/byte
========|=======|===============|=============
1500B   | 64MB  | 1000000       | 1.455539
1500B   | 128MB | 1000000       | 1.443117
1500B   | 256MB | 1000000       | 1.436739
1500B   | 512MB | 1000000       | 1.458973
9000B   | 64MB  | 1000000       | 0.898470
9000B   | 128MB | 1000000       | 0.886110
9000B   | 256MB | 1000000       | 0.889549
9000B   | 512MB | 1000000       | 0.886547
64KB    | 64MB  | 1000000       | 0.814665
64KB    | 128MB | 1000000       | 0.803252
64KB    | 256MB | 1000000       | 0.797268
64KB    | 512MB | 1000000       | 0.794830

