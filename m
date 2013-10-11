Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3JKBub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:50:31 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:17777 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab3JKBua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:50:30 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peng, Arthur" <Arthur.Peng@sonymobile.com>,
        "Zhang, Bojie" <Bojie.Zhang@sonymobile.com>,
        "Gu, Youcai 1 (EXT)" <Youcai1.Gu@sonymobile.com>,
        "Alevoor, Raghavendra 2" <Raghavendra.Alevoor@sonymobile.com>
Date: Fri, 11 Oct 2013 09:50:24 +0800
Subject: RE: BUG report about ipt_do_table( )
Thread-Topic: BUG report about ipt_do_table( )
Thread-Index: Ac7Fw6JG4oB13MIZTr2GR/Es2S3c5QAXlLqw
Message-ID: <35FD53F367049845BC99AC72306C23D1014D1A0971B6@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971B1@CNBJMBX05.corpusers.net>
 <20131010094824.GF3817@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B4@CNBJMBX05.corpusers.net>
 <20131010110309.GA6199@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1014D1A0971B5@CNBJMBX05.corpusers.net>
 <20131010141841.GF6199@mudshark.cambridge.arm.com>
In-Reply-To: <20131010141841.GF6199@mudshark.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9B1obJs025633

Hi  Will,

Maybe I know your meaning ,
If it use spinlock to protected the shared data,
The bug will not happen, because spinlock will 
Use DSB( )  to sync .
Unluckily, here, it use a special seqcount_t( ) (see get_counters( ) function)
To make sure there is no others using the old data,
Before release the old data, this is much like RCU
Work, but RCU use rcu_assign_pointer( ) -->
Which use smp_wmb( ) , so it's safe,  am I right ?

In my patch, I use mb( ), because this macro
Is DSB( ) , while smp_wmb( ) is DMS( ),
I just think DSB is much strict than DMS,
mmm..  so , DSM( )  or DMS ( )  are both ok ?



The whitepaper I use is here:
https://www.google.com/#q=cortex+a15+microarchitecture

the first: [PDF] Exploring the Design of the Cortex-A15 Processor - ARM

I just search in Google, and you know that qcom don't release
Much document about its krait cpu's micro architecture details,
I just use cortex-a15 for a reference, I am not sure if their 
pipeline ( load/store unit) are the same,
if you have cortex-a15 micro architecture details document,
I am very appreciated that you can share to  me . :)

Thanks 




-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Thursday, October 10, 2013 10:19 PM
To: Wang, Yalin
Cc: 'linux-arm-msm-owner@vger.kernel.org'; linux-kernel@vger.kernel.org; Peng, Arthur; Zhang, Bojie; Gu, Youcai 1 (EXT); Alevoor, Raghavendra 2
Subject: Re: BUG report about ipt_do_table( )

On Thu, Oct 10, 2013 at 12:26:38PM +0100, Wang, Yalin wrote:
> Hi  Will ,

Hello,

> Seems your patch is better than mine,
> It make sure newinfo->initial_entries  update is Seen by others .
> 
> I will test by your patches , and update to you ASAP .

Thanks.

> I have another questions about this  BUG, Since all shared data will 
> have this problem especially Shared between different CPUs,
> 
> This means all shared data need a smp_wmb() , after One CPU update it 
> ?

Only if the ordering of observability matters and isn't enforced by other mechanisms (e.g. locks).

> But I see not all shared data are updated by this way, And kernel 
> works well .  Why ??  a little curious .

Again, the barriers tend to be hidden inside things like locking primitives, atomics, I/O accessors etc.

> Another is that , I read cortex-a15 whitepaper , It says :
> 
> Load/Store cluster
> Â§ All Load/Store, data transfers and cache maintenance operations Â§ 
> Partially out-of-order, 1 Load and 1 Store executed per cycle Â§ Load 
> cannot bypass a Store, Store cannot bypass a Store

It's hard to interpret this out of context. Please can you point me at the whitepaper? Also, I was talking from the perspective of the architecture and you're not using an A15 afaik.

> !! Store can't   bypass  store !! , but in this BUG , it seems later store can
> Be wrote into cache even before  the earlier store completed !
> Am I right ?

The architecture requires stores to be observed in program order from the perspective of the CPU issuing them, but there aren't ordering guarantees for stores to different locations when observed by a different CPU.

Will
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
