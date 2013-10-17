Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761834Ab3JQBmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:42:17 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58351 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760887Ab3JQBmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:42:16 -0400
Message-ID: <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Wed, 16 Oct 2013 18:42:08 -0700
In-Reply-To: <20131017003421.GA31470@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
	 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131017003421.GA31470@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 20:34 -0400, Neil Horman wrote:

> > 
> 
> So I went to reproduce these results, but was unable to (due to the fact that I
> only have a pretty jittery network to do testing accross at the moment with
> these devices).  So instead I figured that I would go back to just doing
> measurements with the module that I cobbled together (operating under the
> assumption that it would give me accurate, relatively jitter free results (I've
> attached the module code for reference below).  My results show slightly
> different behavior:
> 
> Base results runs:
> 89417240
> 85170397
> 85208407
> 89422794
> 91645494
> 103655144
> 86063791
> 75647774
> 83502921
> 85847372
> AVG = 875 ns
> 
> Prefetch only runs:
> 70962849
> 77555099
> 81898170
> 68249290
> 72636538
> 83039294
> 78561494
> 83393369
> 85317556
> 79570951
> AVG = 781 ns
> 
> Parallel addition only runs:
> 42024233
> 44313064
> 48304416
> 64762297
> 42994259
> 41811628
> 55654282
> 64892958
> 55125582
> 42456403
> AVG = 510 ns
> 
> 
> Both prefetch and parallel addition:
> 41329930
> 40689195
> 61106622
> 46332422
> 49398117
> 52525171
> 49517101
> 61311153
> 43691814
> 49043084
> AVG = 494 ns
> 
> 
> For reference, each of the above large numbers is the number of nanoseconds
> taken to compute the checksum of a 4kb buffer 100000 times.  To get my average
> results, I ran the test in a loop 10 times, averaged them, and divided by
> 100000.
> 
> 
> Based on these, prefetching is obviously a a good improvement, but not as good
> as parallel execution, and the winner by far is doing both.
> 
> Thoughts?
> 
> Neil
> 


Your benchmark uses a single 4K page, so data is _super_ hot in cpu
caches.
( prefetch should give no speedups, I am surprised it makes any
difference)

Try now with 32 huges pages, to get 64 MBytes of working set.

Because in reality we never csum_partial() data in cpu cache.
(Unless the NIC preloaded the data into cpu cache before sending the
interrupt)

Really, if Sebastien got a speed up, it means that something fishy was
going on, like :

- A copy of data into some area of memory, prefilling cpu caches
- csum_partial() done while data is hot in cache.

This is exactly a "should not happen" scenario, because the csum in this
case should happen _while_ doing the copy, for 0 ns.



