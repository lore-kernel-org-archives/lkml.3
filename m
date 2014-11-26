Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaKZSlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:41:37 -0500
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:50274 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751183AbaKZSlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:41:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2110:2194:2198:2199:2200:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6119:6261:6742:7903:7904:7974:8531:8603:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12555:12679:12740:13146:13149:13230:13548:13972:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ball73_2a8c3f4522b04
X-Filterd-Recvd-Size: 3328
Message-ID: <1417027291.19695.12.camel@perches.com>
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
Date: Wed, 26 Nov 2014 10:41:31 -0800
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

498 overall.

> If I think dropping 'inline' and using -Os will give bigger savings...
> but I suspect 'tinification' folks will compile JIT out anyway...

Smaller is generally better/faster in any case.

> thanks for giving it a shot :)
> That's exactly what I had in mind.
> imo it's less readable, but we probably not going
> to mess much with this piece of code anyway.
> Though to be safe in the future, we'd need to
> add BUILD_BUG_ON that largest value (AUX_REG)
> fits in 32bit (or 64bit) and add a comment that
> verifier goes before the JIT and checks that
> insn->src_reg, insn->dst_reg are less than MAX_BPF_REG,
> so argument 'reg' also doesn't trigger too large shift.
> Perfectionists r us. :)
> ... or just leave it as-is ;)

16 registers max anyway as it's stored
in a :4

No worries, it was just playtime anyway.

cheers, Joe


