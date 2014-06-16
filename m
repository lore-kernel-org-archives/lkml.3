Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaFPFgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 01:36:53 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38450 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaFPFgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 01:36:42 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 -next 7/9] mm, CMA: clean-up CMA allocation error path
Date: Mon, 16 Jun 2014 14:40:49 +0900
Message-Id: <1402897251-23639-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402897251-23639-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1402897251-23639-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can remove one call sites for clear_cma_bitmap() if we first
call it before checking error number.

Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/cma.c b/mm/cma.c
index 0cf50da..b442a13 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -285,11 +285,12 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
 			break;
-		} else if (ret != -EBUSY) {
-			cma_clear_bitmap(cma, pfn, count);
-			break;
 		}
+
 		cma_clear_bitmap(cma, pfn, count);
+		if (ret != -EBUSY)
+			break;
+
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
 			 __func__, pfn_to_page(pfn));
 		/* try again with a bit different memory target */
-- 
1.7.9.5

