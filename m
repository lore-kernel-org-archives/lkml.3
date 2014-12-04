Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbaLDXAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:00:54 -0500
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:55325 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754776AbaLDXAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:00:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:4321:4605:5007:6119:6261:6690:6742:7903:8603:10004:10400:10848:11026:11658:11914:12043:12296:12517:12519:12555:13069:13161:13229:13311:13357:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toy38_7364478c500f
X-Filterd-Recvd-Size: 2881
Message-ID: <1417734048.2721.22.camel@perches.com>
Subject: [PATCH] x86: bpf_jit_comp: Reduce is_ereg() code size
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
Date: Thu, 04 Dec 2014 15:00:48 -0800
In-Reply-To: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
References: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the (1 << reg) & mask trick to reduce code size.

x86-64 size difference -O2 without profiling for various
gcc versions:

$ size arch/x86/net/bpf_jit_comp.o*
   text    data     bss     dec     hex filename
   9266       4       0    9270    2436 arch/x86/net/bpf_jit_comp.o.4.4.new
  10042       4       0   10046    273e arch/x86/net/bpf_jit_comp.o.4.4.old
   9109       4       0    9113    2399 arch/x86/net/bpf_jit_comp.o.4.6.new
   9717       4       0    9721    25f9 arch/x86/net/bpf_jit_comp.o.4.6.old
   8789       4       0    8793    2259 arch/x86/net/bpf_jit_comp.o.4.7.new
  10245       4       0   10249    2809 arch/x86/net/bpf_jit_comp.o.4.7.old
   9671       4       0    9675    25cb arch/x86/net/bpf_jit_comp.o.4.9.new
  10679       4       0   10683    29bb arch/x86/net/bpf_jit_comp.o.4.9.old

Signed-off-by: Joe Perches <joe@perches.com>
---

compiled, untested by me, but per Alexei Starovoitov this passes
the test_bpf suite

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


