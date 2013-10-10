Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3JJOSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:18:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59009 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272Ab3JJOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:18:46 -0400
Date: Thu, 10 Oct 2013 15:18:41 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peng, Arthur" <Arthur.Peng@sonymobile.com>,
        "Zhang, Bojie" <Bojie.Zhang@sonymobile.com>,
        "Gu, Youcai 1 (EXT)" <Youcai1.Gu@sonymobile.com>,
        "Alevoor, Raghavendra 2" <Raghavendra.Alevoor@sonymobile.com>
Subject: Re: BUG report about ipt_do_table( )
Message-ID: <20131010141841.GF6199@mudshark.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971B1@CNBJMBX05.corpusers.net>
 <20131010094824.GF3817@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B4@CNBJMBX05.corpusers.net>
 <20131010110309.GA6199@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B5@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35FD53F367049845BC99AC72306C23D1014D1A0971B5@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 12:26:38PM +0100, Wang, Yalin wrote:
> Hi  Will ,

Hello,

> Seems your patch is better than mine,
> It make sure newinfo->initial_entries  update is 
> Seen by others . 
> 
> I will test by your patches , and update to you ASAP .

Thanks.

> I have another questions about this  BUG,
> Since all shared data will have this problem especially 
> Shared between different CPUs,
> 
> This means all shared data need a smp_wmb() , after 
> One CPU update it ? 

Only if the ordering of observability matters and isn't enforced by other
mechanisms (e.g. locks).

> But I see not all shared data are updated by this way,
> And kernel works well .  Why ??  a little curious .

Again, the barriers tend to be hidden inside things like locking primitives,
atomics, I/O accessors etc.

> Another is that , I read cortex-a15 whitepaper ,
> It says :
> 
> Load/Store cluster
>  All Load/Store, data transfers and cache maintenance operations
>  Partially out-of-order, 1 Load and 1 Store executed per cycle
>  Load cannot bypass a Store, Store cannot bypass a Store

It's hard to interpret this out of context. Please can you point me at the
whitepaper? Also, I was talking from the perspective of the architecture and
you're not using an A15 afaik.

> !! Store can't   bypass  store !! , but in this BUG , it seems later store can
> Be wrote into cache even before  the earlier store completed !
> Am I right ?

The architecture requires stores to be observed in program order from the
perspective of the CPU issuing them, but there aren't ordering guarantees
for stores to different locations when observed by a different CPU.

Will
