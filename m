Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3DXLJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:09:06 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:25188
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504Ab3DXLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:09:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zcb8kzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Wed, 24 Apr 2013 19:08:17 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>
Subject: Re: [PATCH v2 01/15] powerpc/85xx: cache operations for Freescale
 SoCs based on BOOK3E
Message-ID: <20130424110817.GA3172@localhost.localdomain>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
 <1366760770.5825.17@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366760770.5825.17@snotra>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 06:46:10PM -0500, Scott Wood wrote:
> On 04/19/2013 05:47:34 AM, Zhao Chenhui wrote:
> >These cache operations support Freescale SoCs based on BOOK3E.
> >Move L1 cache operations to fsl_booke_cache.S in order to maintain
> >easily. And, add cache operations for backside L2 cache and
> >platform cache.
> >
> >The backside L2 cache appears on e500mc and e5500 core. The
> >platform cache
> >supported by this patch is L2 Look-Aside Cache, which appears on SoCs
> >with e500v1/e500v2 core, such as MPC8572, P1020, etc.
> >
> >Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> >Signed-off-by: Li Yang <leoli@freescale.com>
> >---
> > arch/powerpc/include/asm/cacheflush.h |    8 ++
> > arch/powerpc/kernel/Makefile          |    1 +
> > arch/powerpc/kernel/fsl_booke_cache.S |  210
> >+++++++++++++++++++++++++++++++++
> > arch/powerpc/kernel/head_fsl_booke.S  |   74 ------------
> > 4 files changed, 219 insertions(+), 74 deletions(-)
> > create mode 100644 arch/powerpc/kernel/fsl_booke_cache.S
> >
> >diff --git a/arch/powerpc/include/asm/cacheflush.h
> >b/arch/powerpc/include/asm/cacheflush.h
> >index b843e35..bc3f937 100644
> >--- a/arch/powerpc/include/asm/cacheflush.h
> >+++ b/arch/powerpc/include/asm/cacheflush.h
> >@@ -32,6 +32,14 @@ extern void flush_dcache_page(struct page *page);
> >
> > extern void __flush_disable_L1(void);
> >
> >+#ifdef CONFIG_FSL_SOC_BOOKE
> >+void flush_dcache_L1(void);
> >+void flush_backside_L2_cache(void);
> >+void disable_backside_L2_cache(void);
> >+void flush_disable_L2(void);
> >+void invalidate_enable_L2(void);
> >+#endif
> 
> Don't ifdef prototypes unless there's a good reason, such as
> providing an inline alternative.

I'll get rid of this "#ifdef".

> 
> Why do you have "flush_backside_L2_cache" and
> "disable_backside_L2_cache" as something different from
> "flush_disable_L2"?  The latter should flush whatever L2 is present.
> Don't treat pre-corenet as the default.
> 

These L2 caches are very different. The backside L2 is integrated in
the e500mc/e5500 core and controlled by SPR registers. But, the latter
L2 cache is on the SoC and controlled by registers mapped in CCSR.

> Why do we even need to distinguish L1 from L2 at all?  Shouldn't the
> function that gets exposed just be "flush and disable data caches
> that are specific to this cpu"?  What should happen on e6500?
> 
> -Scott

Yes. It is a good idea to use a set of uniform functions to operate the caches of
e500/e500mc/e5500/e6500 and SoCs. I'll think over your comments.

Thanks for you comments.

-Chenhui


