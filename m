Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaLGMaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 07:30:20 -0500
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:42672 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751975AbaLGMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 07:30:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2375:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3871:3872:3873:3874:4321:4605:5007:6117:6261:7901:7903:8660:9121:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12555:12740:13069:13148:13230:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bit32_3c62595789a55
X-Filterd-Recvd-Size: 2619
Message-ID: <1417955413.31745.25.camel@perches.com>
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by
 pr_warn() in mppe_rekey()
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Date: Sun, 07 Dec 2014 04:30:13 -0800
In-Reply-To: <alpine.DEB.2.02.1412071140290.2044@localhost6.localdomain6>
References: <1417731809.2721.17.camel@perches.com>
	 <alpine.DEB.2.02.1412050820290.2059@localhost6.localdomain6>
	 <1417765287.2721.39.camel@perches.com>
	 <alpine.DEB.2.02.1412071140290.2044@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-07 at 11:44 +0100, Julia Lawall wrote:
> > A negative to that approach is inlined functions would
> > take the function name of the parent not keep the
> > inlined function name.
> 
> I tried the following:
> 
> #include <stdio.h>
> 
> inline int foo() {
>   printf("%s %x\n",__func__,0x12345);
> }
> 
> int main () {
>   foo();
> }
> 
> The assembly code generated for main is:
> 
> 0000000000400470 <main>:
>   400470:       b9 45 23 01 00          mov    $0x12345,%ecx
>   400475:       ba 4b 06 40 00          mov    $0x40064b,%edx
>   40047a:       be 44 06 40 00          mov    $0x400644,%esi
>   40047f:       bf 01 00 00 00          mov    $0x1,%edi
>   400484:       31 c0                   xor    %eax,%eax
>   400486:       e9 d5 ff ff ff          jmpq   400460 <__printf_chk@plt>
> 
> That is, the call to foo seems tom be inlined.
> 
> But the output is:
> 
> foo 12345
> 
> So it seems that __func__ is determined before inlining.

True, and that's what I intended to describe.

If you did that with a kernel module and replaced
"%s, __func__" with "%pf, __builtin_return_address(0)"
when built with kallsyms you should get:

"modname 12345" when most would expect "foo 12345"

when built without kallsyms, that output should be
"<address> 12345"

but the object code should be smaller.


