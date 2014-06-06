Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaFFO12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:27:28 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:36306 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaFFO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:27:27 -0400
Message-ID: <5391CFCC.6060507@gmail.com>
Date: Fri, 06 Jun 2014 10:27:24 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Pranith Kumar <pranith@gatech.edu>, dwmw2@infradead.org,
        joro@8bytes.org
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] use documented cmpxchg api
References: <5390ED07.2070009@gatech.edu> <53910C95.7000808@hurleysoftware.com> <5391136C.3010809@gmail.com> <53919E24.3010206@hurleysoftware.com>
In-Reply-To: <53919E24.3010206@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 06:55 AM, Peter Hurley wrote:
> 
> This won't work either, and should generate a compile or link error
> on CONFIG_X86_32.
> 
> The auto-sizing done by __cmpxchg() does not substitute the cmpxchg8b
> instruction for the cmpxchg instruction. __X86_CASE_Q is defined as -1 for
> CONFIG_X86_32 so the 8-byte size variant is dead-code, and calls
> __cmpxchg_wrong_size() instead.
> 
> 
Fixed with the following v3:

use the documented cmpxchg64 instead of __cmpxchg64. 

This kills the last user of said API in drivers code.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6bb3277..270113f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -293,7 +293,7 @@ static inline u64 dma_pte_addr(struct dma_pte *pte)
 	return pte->val & VTD_PAGE_MASK;
 #else
 	/* Must have a full atomic 64-bit read */
-	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
+	return  cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
 #endif
 }
 
-- 1.7.9.5 

