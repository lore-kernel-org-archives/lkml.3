Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaKZUBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:01:06 -0500
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:56617 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750770AbaKZUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:01:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:6261:6742:7903:7974:8531:8603:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13146:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fact17_8da215424803
X-Filterd-Recvd-Size: 3015
Message-ID: <1417032059.16355.4.camel@perches.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
From: Joe Perches <joe@perches.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Nov 2014 12:00:59 -0800
In-Reply-To: <CAADnVQK3iui8cAmhi28=65p2CJbTu45fR98ri8Uh8xLRb=cwnA@mail.gmail.com>
References: <CAADnVQK3iui8cAmhi28=65p2CJbTu45fR98ri8Uh8xLRb=cwnA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 10:34 -0800, Alexei Starovoitov wrote:
> On Wed, Nov 26, 2014 at 10:02 AM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2014-11-26 at 09:23 -0800, Alexei Starovoitov wrote:
> >> On Wed, Nov 26, 2014 at 8:58 AM, Joe Perches <joe@perches.com> wrote:
> >
> >> > Is there any value in reordering these tests for frequency
> >> > or maybe using | instead of || to avoid multiple jumps?
> >>
> >> probably not. It's not a critical path.
> >> compiler may fuse conditions depending on values anyway.
> >> If it was a critical path, we could have used
> >> (1 << reg) & mask trick.
> >> I picked explicit 'return true' else 'return false' here,
> >> because it felt easier to read. Just a matter of taste.
> >
> > There is a size difference though: (allyesconfig)
> >
> > $ size arch/x86/net/built-in.o*
> >    text    data     bss     dec     hex filename
> >   12999    1012    4336   18347    47ab arch/x86/net/built-in.o.new
> >   13177    1076    4592   18845    499d arch/x86/net/built-in.o.old
> 
> interesting. Compiler obviously thinks that 178 byte increase
> with -O2 is the right trade off. Which I agree with :)
> 
> If I think dropping 'inline' and using -Os will give bigger savings...

This was allyesconfig which already uses -Os

Using -O2, there is no difference using inline
or not, but the size delta with the bitmask is
much larger

$ size arch/x86/net/built-in.o* (allyesconfig, but not -Os)
   text	   data	    bss	    dec	    hex	filename
  13410	    820	   3624	  17854	   45be	arch/x86/net/built-in.o.new
  16130	    884	   4200	  21214	   52de	arch/x86/net/built-in.o.old
  16130	    884	   4200	  21214	   52de	arch/x86/net/built-in.o.static


