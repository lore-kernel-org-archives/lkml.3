Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab3JRX11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:27:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab3JRX10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:27:26 -0400
Date: Fri, 18 Oct 2013 11:46:08 -0400
Message-Id: <201310181546.r9IFk8VO018241@ib.usersys.redhat.com>
From: Doug Ledford <dledford@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: 1381790982.16896.7.camel@joe-AO722
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 22:49 -0700, Joe Perches wrote:
> On Mon, 2013-10-14 at 15:44 -0700, Eric Dumazet wrote:
>> On Mon, 2013-10-14 at 15:37 -0700, Joe Perches wrote:
>> > On Mon, 2013-10-14 at 15:18 -0700, Eric Dumazet wrote:
>> > > attached patch brings much better results
>> > > 
>> > > lpq83:~# ./netperf -H 7.7.8.84 -l 10 -Cc
>> > > MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 7.7.8.84 () port 0 AF_INET
>> > > Recv   Send    Send                          Utilization       Service Demand
>> > > Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
>> > > Size   Size    Size     Time     Throughput  local    remote   local   remote
>> > > bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB
>> > > 
>> > >  87380  16384  16384    10.00      8043.82   2.32     5.34     0.566   1.304  
>> > > 
>> > > diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
>> > []
>> > > @@ -68,7 +68,8 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
>> > >  			zero = 0;
>> > >  			count64 = count >> 3;
>> > >  			while (count64) { 
>> > > -				asm("addq 0*8(%[src]),%[res]\n\t"
>> > > +				asm("prefetch 5*64(%[src])\n\t"
>> > 
>> > Might the prefetch size be too big here?
>> 
>> To be effective, you need to prefetch well ahead of time.
> 
> No doubt.
> 
>> 5*64 seems common practice (check arch/x86/lib/copy_page_64.S)
> 
> 5 cachelines for some processors seems like a lot.
> 
> Given you've got a test rig, maybe you could experiment
> with 2 and increase it until it doesn't get better.

You have a fundamental misunderstanding of the prefetch operation.  The 5*64
in the above asm statment does not mean a size, it is an index, with %[src]
as the base pointer.  So it is saying to go to address %[src] + 5*64 and
prefetch there.  The prefetch size itself is always a cache line.  Once the
address is known, whatever cacheline holds that address is the cacheline we
will prefetch.  Your size concerns have no meaning.

