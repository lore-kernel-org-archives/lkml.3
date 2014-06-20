Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbaFTFpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:45:45 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:38891 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667AbaFTFpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:45:43 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 20 Jun 2014 14:50:09 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140620055009.GA8869@js1304-P5Q-DELUXE>
References: <20140620152715.24baa4ce@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620152715.24baa4ce@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 03:27:15PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (arm
> defconfig) failed like this:
> 
> In file included from /scratch/sfr/next/arch/arm/mm/dma-mapping.c:29:0:
> /scratch/sfr/next/include/linux/cma.h:8:28: error: 'CONFIG_CMA_AREAS' undeclared here (not in a function)
>  #define MAX_CMA_AREAS (1 + CONFIG_CMA_AREAS)
>                             ^
> /scratch/sfr/next/arch/arm/mm/dma-mapping.c:434:54: note: in expansion of macro 'MAX_CMA_AREAS'
>  static struct dma_contig_early_reserve dma_mmu_remap[MAX_CMA_AREAS] __initdata;
>                                                       ^
> 
> Caused by commit f495d267b2e0 ("CMA: generalize CMA reserved area
> management functionality").
> 
> I have reverted that commit and these commits that depend on it
> 
> 57d551e70a38 ("mm, CMA: clean-up log message")
> d75ab106aef5 ("mm, CMA: change cma_declare_contiguous() to obey coding convention")
> f693a5424631 ("mm, CMA: clean-up CMA allocation error path")
> e58e263e5254 ("PPC, KVM, CMA: use general CMA reserved area management framework")
> 

Hello,

If below patch fixes above problem, is it possible to retain above patches
in linux-next?

Thanks.

---------8<----------------
>From e5c519c4b74914067e43cb55e232f19de9967324 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Fri, 20 Jun 2014 13:30:56 +0900
Subject: [PATCH] CMA: fix ARM build failure related to MAX_CMA_AREAS
 definition

If CMA is disabled, CONFIG_CMA_AREAS isn't defined so compile error
happens. To fix it, define MAX_CMA_AREAS if CONFIG_CMA_AREAS
isn't defined.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 32cab7a..371b930 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -5,8 +5,14 @@
  * There is always at least global CMA area and a few optional
  * areas configured in kernel .config.
  */
+#ifdef CONFIG_CMA_AREAS
 #define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
 
+#else
+#define MAX_CMA_AREAS	(0)
+
+#endif
+
 struct cma;
 
 extern phys_addr_t cma_get_base(struct cma *cma);
-- 
1.7.9.5

