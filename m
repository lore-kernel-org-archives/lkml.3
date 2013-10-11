Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab3JKLOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:14:40 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:9310 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658Ab3JKLOj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:14:39 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peng, Arthur" <Arthur.Peng@sonymobile.com>,
        "Zhang, Bojie" <Bojie.Zhang@sonymobile.com>,
        "Gu, Youcai 1 (EXT)" <Youcai1.Gu@sonymobile.com>,
        "Alevoor, Raghavendra 2" <Raghavendra.Alevoor@sonymobile.com>
Date: Fri, 11 Oct 2013 19:14:35 +0800
Subject: RE: BUG report about ipt_do_table( )
Thread-Topic: BUG report about ipt_do_table( )
Thread-Index: Ac7GcW9mRd8DsXdCSOqBeMP8Vz3V8QAAQ+/A
Message-ID: <35FD53F367049845BC99AC72306C23D1014D1A0971BB@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971B1@CNBJMBX05.corpusers.net>
 <20131010094824.GF3817@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B4@CNBJMBX05.corpusers.net>
 <20131010110309.GA6199@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B5@CNBJMBX05.corpusers.net>
 <20131010141841.GF6199@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B6@CNBJMBX05.corpusers.net>
 <20131011110247.GF14732@mudshark.cambridge.arm.com>
In-Reply-To: <20131011110247.GF14732@mudshark.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Thanks for your clarification .

I have merged the patch,
And need wait some time to get
The test result ,
You know that this BUG is not easy to reproduce,
It's very infrequent.
Maybe we need run several times stability test to 
Make sure the patch works .

I will update to you the result as soon as possible !

Thanks 

-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Friday, October 11, 2013 7:03 PM
To: Wang, Yalin
Cc: 'linux-arm-msm-owner@vger.kernel.org'; linux-kernel@vger.kernel.org; Peng, Arthur; Zhang, Bojie; Gu, Youcai 1 (EXT); Alevoor, Raghavendra 2
Subject: Re: BUG report about ipt_do_table( )

On Fri, Oct 11, 2013 at 02:50:24AM +0100, Wang, Yalin wrote:
> Hi  Will,

Hello again,

> Maybe I know your meaning ,
> If it use spinlock to protected the shared data, The bug will not 
> happen, because spinlock will Use DSB( )  to sync .

Actually, the dsb is for something else (the sev). It is the smp_mb() call which guarantees the ordering of critical sections with respect to spinlock operations.

> Unluckily, here, it use a special seqcount_t( ) (see get_counters( ) 
> function)

Well, there is a comment about a write_lock being held, so you should be ok if that's true. The issue I saw was with the newinfo population, as I described in my earlier mail.

> To make sure there is no others using the old data, Before release the 
> old data, this is much like RCU Work, but RCU use rcu_assign_pointer( 
> ) --> Which use smp_wmb( ) , so it's safe,  am I right ?

RCU is safe. There are *many* weakly ordered architectures on which Linux runs, so I don't think you have to worry too much about the core data structures and locking/synchronisation/atomic primitives. The major scope for errors is in lockless code, where the barrier usage is explicit.

> In my patch, I use mb( ), because this macro Is DSB( ) , while 
> smp_wmb( ) is DMS( ), I just think DSB is much strict than DMS, mmm..  
> so , DSM( )  or DMS ( )  are both ok ?

I think you're getting confused with your barriers. We have two memory barriers on ARM: dmb and dsb. dmb is sufficient to enforce ordering of observability. dsb is used to enforce completion.

> The whitepaper I use is here:
> https://www.google.com/#q=cortex+a15+microarchitecture
> 
> the first: [PDF] Exploring the Design of the Cortex-A15 Processor - 
> ARM
> 
> I just search in Google, and you know that qcom don't release Much 
> document about its krait cpu's micro architecture details, I just use 
> cortex-a15 for a reference, I am not sure if their pipeline ( 
> load/store unit) are the same,

I think the lawyers would have a field day if the pipelines were the same!
You really can't use an A15 slide-deck to infer micro-architectural details about Krait.

Please can you test the patch I sent you yesterday?

Will
