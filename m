Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3JNWiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:38:06 -0400
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:42293 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932218Ab3JNWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:38:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:2900:3138:3139:3140:3141:3142:3352:3622:3834:3865:3867:3868:3871:4321:4560:4605:5007:6119:7652:7809:7904:8603:9121:10004:10394:10400:10848:11232:11233:11658:11914:12043:12517:12519:12555:12740:13019:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wax12_28d1d5f506504
X-Filterd-Recvd-Size: 2509
Message-ID: <1381790278.16896.2.camel@joe-AO722>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date: Mon, 14 Oct 2013 15:37:58 -0700
In-Reply-To: <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
	 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 15:18 -0700, Eric Dumazet wrote:
> attached patch brings much better results
> 
> lpq83:~# ./netperf -H 7.7.8.84 -l 10 -Cc
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 7.7.8.84 () port 0 AF_INET
> Recv   Send    Send                          Utilization       Service Demand
> Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
> Size   Size    Size     Time     Throughput  local    remote   local   remote
> bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB
> 
>  87380  16384  16384    10.00      8043.82   2.32     5.34     0.566   1.304  
> 
> diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
[]
> @@ -68,7 +68,8 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
>  			zero = 0;
>  			count64 = count >> 3;
>  			while (count64) { 
> -				asm("addq 0*8(%[src]),%[res]\n\t"
> +				asm("prefetch 5*64(%[src])\n\t"

Might the prefetch size be too big here?

0x140 is pretty big and is always multiple cachelines no?

> +				    "addq 0*8(%[src]),%[res]\n\t"
>  				    "adcq 1*8(%[src]),%[res]\n\t"
>  				    "adcq 2*8(%[src]),%[res]\n\t"
>  				    "adcq 3*8(%[src]),%[res]\n\t"



