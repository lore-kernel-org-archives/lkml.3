Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaKZSCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:02:53 -0500
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:47023 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750828AbaKZSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:02:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3866:3867:3870:3871:3872:4321:5007:6119:6261:6742:7974:8603:10004:10400:10848:11026:11232:11658:11914:12517:12519:12555:12740:13069:13161:13229:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: way33_8cc430988cc4c
X-Filterd-Recvd-Size: 2760
Message-ID: <1417024965.19695.7.camel@perches.com>
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
Date: Wed, 26 Nov 2014 10:02:45 -0800
In-Reply-To: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
References: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 09:23 -0800, Alexei Starovoitov wrote:
> On Wed, Nov 26, 2014 at 8:58 AM, Joe Perches <joe@perches.com> wrote:

> > Is there any value in reordering these tests for frequency
> > or maybe using | instead of || to avoid multiple jumps?
> 
> probably not. It's not a critical path.
> compiler may fuse conditions depending on values anyway.
> If it was a critical path, we could have used
> (1 << reg) & mask trick.
> I picked explicit 'return true' else 'return false' here,
> because it felt easier to read. Just a matter of taste.

There is a size difference though: (allyesconfig)

$ size arch/x86/net/built-in.o*
   text	   data	    bss	    dec	    hex	filename
  12999	   1012	   4336	  18347	   47ab	arch/x86/net/built-in.o.new
  13177	   1076	   4592	  18845	   499d	arch/x86/net/built-in.o.old
---
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 3f62734..09e2cea 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -135,11 +135,11 @@ static const int reg2hex[] = {
  */
 static inline bool is_ereg(u32 reg)
 {
-	if (reg == BPF_REG_5 || reg == AUX_REG ||
-	    (reg >= BPF_REG_7 && reg <= BPF_REG_9))
-		return true;
-	else
-		return false;
+	return (1 << reg) & (BIT(BPF_REG_5) |
+			     BIT(AUX_REG) |
+			     BIT(BPF_REG_7) |
+			     BIT(BPF_REG_8) |
+			     BIT(BPF_REG_9));
 }
 
 /* add modifiers if 'reg' maps to x64 registers r8..r15 */


