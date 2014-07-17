Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbaGQWGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:06:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaGQWGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:06:17 -0400
Date: Thu, 17 Jul 2014 15:06:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH] CMA: generalize CMA reserved area management
 functionality (fixup)
Message-Id: <20140717150615.32c48786b6bdbc880bdc5ed4@linux-foundation.org>
In-Reply-To: <1405589767-17513-1-git-send-email-m.szyprowski@samsung.com>
References: <53C78ED7.7030002@samsung.com>
	<1405589767-17513-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014 11:36:07 +0200 Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> MAX_CMA_AREAS is used by other subsystems (i.e. arch/arm/mm/dma-mapping.c),
> so we need to provide correct definition even if CMA is disabled.
> This patch fixes this issue.
> 
> Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  include/linux/cma.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 9a18a2b1934c..c077635cad76 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -5,7 +5,11 @@
>   * There is always at least global CMA area and a few optional
>   * areas configured in kernel .config.
>   */
> +#ifdef CONFIG_CMA
>  #define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
> +#else
> +#define MAX_CMA_AREAS	(0)
> +#endif
>  
>  struct cma;

Joonsoo already fixed this up, a bit differently:
http://ozlabs.org/~akpm/mmots/broken-out/cma-generalize-cma-reserved-area-management-functionality-fix.patch

Which approach makes more sense?



From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: CMA: fix ARM build failure related to MAX_CMA_AREAS definition

If CMA is disabled, CONFIG_CMA_AREAS isn't defined so compile error
happens. To fix it, define MAX_CMA_AREAS if CONFIG_CMA_AREAS
isn't defined.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/cma.h~cma-generalize-cma-reserved-area-management-functionality-fix include/linux/cma.h
--- a/include/linux/cma.h~cma-generalize-cma-reserved-area-management-functionality-fix
+++ a/include/linux/cma.h
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
_


