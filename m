Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3JNWSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:18:50 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35084 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3JNWSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:18:49 -0400
Message-ID: <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Mon, 14 Oct 2013 15:18:47 -0700
In-Reply-To: <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
	 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 14:19 -0700, Eric Dumazet wrote:
> On Mon, 2013-10-14 at 16:28 -0400, Neil Horman wrote:
> 
> > So, early testing results today.  I wrote a test module that, allocated a 4k
> > buffer, initalized it with random data, and called csum_partial on it 100000
> > times, recording the time at the start and end of that loop.  Results on a 2.4
> > GHz Intel Xeon processor:
> > 
> > Without patch: Average execute time for csum_partial was 808 ns
> > With patch: Average execute time for csum_partial was 438 ns
> 
> Impressive, but could you try again with data out of cache ?

So I tried your patch on a GRE tunnel and got following results on a
single TCP flow. (short result : no visible difference)


Using a prefetch 5*64([%src]) helps more (see at the end)

cpus : model name : Intel Xeon(R) CPU X5660 @ 2.80GHz


Before patch :

lpq83:~# ./netperf -H 7.7.8.84 -l 20 -Cc
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 7.7.8.84 () port 0 AF_INET
Recv   Send    Send                          Utilization       Service Demand
Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
Size   Size    Size     Time     Throughput  local    remote   local   remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB

 87380  16384  16384    20.00      7651.61   2.51     5.45     0.645   1.399  


After patch :

lpq83:~# ./netperf -H 7.7.8.84 -l 20 -Cc
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 7.7.8.84 () port 0 AF_INET
Recv   Send    Send                          Utilization       Service Demand
Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
Size   Size    Size     Time     Throughput  local    remote   local   remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB

 87380  16384  16384    20.00      7239.78   2.09     5.19     0.569   1.408  

Profile on receiver

   PerfTop:    1358 irqs/sec  kernel:98.5%  exact:  0.0% [1000Hz cycles],  (all, 24 CPUs)
------------------------------------------------------------------------------------------------------------------------------------------------------------

    19.99%  [kernel]     [k] csum_partial                
     7.04%  [kernel]     [k] copy_user_generic_string    
     4.92%  [bnx2x]      [k] bnx2x_rx_int                
     3.50%  [kernel]     [k] ipt_do_table                
     2.86%  [kernel]     [k] __netif_receive_skb_core    
     2.35%  [kernel]     [k] fib_table_lookup            
     2.19%  [kernel]     [k] netif_receive_skb           
     1.87%  [kernel]     [k] intel_idle                  
     1.65%  [kernel]     [k] kmem_cache_alloc            
     1.64%  [kernel]     [k] ip_rcv                      
     1.51%  [kernel]     [k] kmem_cache_free             


And attached patch brings much better results

lpq83:~# ./netperf -H 7.7.8.84 -l 10 -Cc
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 7.7.8.84 () port 0 AF_INET
Recv   Send    Send                          Utilization       Service Demand
Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
Size   Size    Size     Time     Throughput  local    remote   local   remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB

 87380  16384  16384    10.00      8043.82   2.32     5.34     0.566   1.304  

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index 9845371..f0e10fc 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -68,7 +68,8 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
 			zero = 0;
 			count64 = count >> 3;
 			while (count64) { 
-				asm("addq 0*8(%[src]),%[res]\n\t"
+				asm("prefetch 5*64(%[src])\n\t"
+				    "addq 0*8(%[src]),%[res]\n\t"
 				    "adcq 1*8(%[src]),%[res]\n\t"
 				    "adcq 2*8(%[src]),%[res]\n\t"
 				    "adcq 3*8(%[src]),%[res]\n\t"


